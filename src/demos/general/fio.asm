***************************************************************
* 
*                          File I/O test
*
*                (c)2018-2019 // Filip van Vooren
*
***************************************************************
* File: fio.asm                     ; Version %%build_date%%
*--------------------------------------------------------------
* 2018-04-01   Development started
********@*****@*********************@**************************
        save  >6000,>7fff
        aorg  >6000
*--------------------------------------------------------------
debug                     equ  1    ; Turn on debugging
;--------------------------------------------------------------
; Equates for spectra2 DSRLNK 
;--------------------------------------------------------------
dsrlnk.dsrlws             equ >b000 ; Address of dsrlnk workspace                                              
dsrlnk.namsto             equ >2100 ; 8-byte RAM buffer for storing device name
startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup

*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
skip_vdp_hchar            equ  1    ; Skip hchar, xchar
skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
skip_vdp_boxes            equ  1    ; Skip filbox, putbox
skip_vdp_bitmap           equ  1    ; Skip bitmap functions
skip_vdp_viewport         equ  1    ; Skip viewport functions
skip_vdp_rle_decompress   equ  1    ; Skip RLE decompress to VRAM
skip_vdp_yx2px_calc       equ  1    ; Skip YX to pixel calculation
skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
skip_vdp_sprites          equ  1    ; Skip sprites support
skip_sound_player         equ  1    ; Skip inclusion of sound player code
skip_speech_detection     equ  1    ; Skip speech synthesizer detection
skip_speech_player        equ  1    ; Skip inclusion of speech player code
skip_random_generator     equ  1    ; Skip random functions 
skip_timer_alloc          equ  1    ; Skip support for timers allocation
skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation

*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
grmhdr  byte  >aa,1,1,0,0,0
        data  prog0
        byte  0,0,0,0,0,0,0,0
prog0   data  0                     ; No more items following
        data  runlib
 .ifdef debug
        #string 'FIOT %%build_date%%'
 .else
        #string 'FIOT'
 .endif
*--------------------------------------------------------------
* Include required files
*--------------------------------------------------------------
        copy  "%%spectra2%%/runlib.asm"
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
spfclr  equ   >c1                   ; Foreground/Background color for font.
spfbck  equ   >01                   ; Screen background color.
;--------------------------------------------------------------
; Video mode configuration
;--------------------------------------------------------------
spvmod  equ   tx8024                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
;--------------------------------------------------------------
; VDP space for PAB and file buffer
;--------------------------------------------------------------
vpab    equ   >0200                 ; VDP PAB    @>0200
vrecbuf equ   >0300                 ; VDP Buffer @>0300


;--------------------------------------------------------------
; Variables
;--------------------------------------------------------------
cpupab  equ   >c000                 ; Pointer to VDP PAB, required by level 2 FIO
records equ   >c000                 ; Records processed so far
reclen  equ   >c002                 ; Current record length
rambuf  equ   >c004                 ; 5 byte RAM-buffer


***************************************************************
* Main
********@*****@*********************@**************************
main    bl    @putat
        data  >0000,msg

        bl    @putat
        data  >0100,fname

        bl    @putat
        data  >0300,rec1

        bl    @putat
        data  >0400,rec2

        ;------------------------------------------------------
        ; Initialization
        ;------------------------------------------------------
main.init:        
        clr   @records              ; Reset record counter
        li    tmp4,>b000            ; CPU destination for memory copy

        bl    @cpym2v
              data vpab,pab,25      ; Copy PAB to VDP
        ;------------------------------------------------------
        ; Load GPL scratchpad layout
        ;------------------------------------------------------
        bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data >a000            ; / 8300->a000, 2000->8300
        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
        bl    @file.open
              data vpab             ; Pass file descriptor to DSRLNK
        coc   @wbit2,tmp2           ; Equal bit set?
        jeq   file.error            ; Yes, IO error occured
        ;------------------------------------------------------
        ; Read file records
        ;------------------------------------------------------
main.readfile:        
        inc   @records              ; Update counter        
        clr   @reclen               ; Reset record length

        bl    @file.record.read     ; Read record
              data vpab             ; tmp0=Status byte, tmp1=Bytes read
                                    ; tmp2=Status register contents upon DSRLNK return

        mov   tmp1,@reclen          ; Save bytes read

        coc   @wbit2,tmp2           ; IO error occured?
        jeq   file.error            ; Yes, so handle file error
        ;------------------------------------------------------
        ; Load spectra scratchpad layout
        ;------------------------------------------------------
        bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
        bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data >a000            ; / >a000->8300
        ;------------------------------------------------------
        ; Display results
        ;------------------------------------------------------
        bl    @putnum
              byte 03,20
              data records,rambuf,>3020

        bl    @putnum
              byte 04,20
              data reclen,rambuf,>3020

        ;------------------------------------------------------
        ; Copy record to CPU memory
        ;------------------------------------------------------
        li    tmp0,vrecbuf          ; VDP source address
        mov   tmp4,tmp1             ; RAM target address 
        li    tmp2,80
        a     tmp2,tmp4
        bl    @xpyv2m               ; Copy memory
        ;------------------------------------------------------
        ; Load GPL scratchpad layout again
        ;------------------------------------------------------
        bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
              data >a000            ; / 8300->a000, 2000->8300

        jmp   main.readfile         ; Next record
        ;------------------------------------------------------
        ; Close file
        ;------------------------------------------------------
close_file                
        bl    @file.close           ; Close file
              data vpab 


        ;------------------------------------------------------
        ; Error handler
        ;------------------------------------------------------     
file.error        
        srl   tmp0,8                ; Right align VDP PAB 1 status byte
        ci    tmp0,io.err.eof       ; EOF reached ?
        jeq   eof_reached           ; All good. File closed by DSRLNK 
        b     @crash_handler        ; A File error occured. System crashed


eof_reached:
        bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
              data >a000            ; / >a000->8300

        bl    @putat
        data  >0600,eof

        b     @tmgr




***************************************************************
* PAB for accessing file
********@*****@*********************@**************************
pab     byte  io.op.open            ;  0    - OPEN
        byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
        data  vrecbuf               ;  2-3  - Record buffer in VDP memory
        byte  80                    ;  4    - Record length (80 characters maximum)
        byte  00                    ;  5    - Character count
        data  >0000                 ;  6-7  - Seek record (only for fixed records)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)

; fname  byte  12                    ;  9    - File descriptor length
;        text 'DSK1.XBEADOC'         ; 10-.. - File descriptor (Device + '.' + File name) 

fname   byte  15                    ;  9    - File descriptor length
        text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)


        even


msg     #string '* File reading test *'
rec1    #string 'Records read......:'
rec2    #string 'Characters read...:'
eof     #string 'EOF reached. FCTN+Q to quit'

