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
startup_keep_vdpdiskbuf   equ  1    ; Keep VDP memory reserved for 3 VDP disk buffers
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
skip_tms52xx_detection    equ  1    ; Skip speech synthesizer detection
skip_tms52xx_player       equ  1    ; Skip inclusion of speech player code
skip_random_generator     equ  1    ; Skip random functions 
skip_timer_alloc          equ  1    ; Skip support for timers allocation

*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
grmhdr  byte  >aa,1,1,0,0,0
        data  prog0
        byte  0,0,0,0,0,0,0,0
prog0   data  0                     ; No more items following
        data  runlib
 .ifdef debug
        #string 'FIO TEST %%build_date%%'
 .else
        #string 'FIO TEST'
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
pabadr1 equ   >01f0                 ; VDP PAB1
pabadr2 equ   >0200                 ; VDP PAB2
vrecbuf equ   >0300                 ; VDP Buffer

***************************************************************
* Main
********@*****@*********************@**************************
main    bl    @putat
        data  >0000,msg

        bl    @putat
        data  >0100,fname

        ;------------------------------------------------------
        ; Prepare VDP for PAB and page out scratchpad
        ;------------------------------------------------------
        bl    @cpym2v
        data  pabadr1,dsrsub,2      ; Copy PAB for DSR call files subprogram

        bl    @cpym2v
        data  pabadr2,pab,25        ; Copy PAB to VDP

        bl    @cpym2v
        data  >37d7,schrott,6 


        bl    @mem.scrpad.pgout     ; Page out scratchpad memory
              data  >a000           ; Memory destination @>a000

        ;------------------------------------------------------
        ; Set up file buffer - call files(1)
        ;------------------------------------------------------
        li    r0,>0100 
        movb  r0,@>834c             ; Set number of disk files to 1
        li    r0,pabadr1
        mov   r0,@>8356             ; Pass PAB to DSRLNK
        blwp  @dsrlnk               ; Call subprogram for "call files(1)"
        data  >a
        jeq   done1                 ; Exit on error
        

        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
        bl    @file.open
        data  pabadr2                ; Pass file descriptor to DSRLNK

;        li    r0,pabadr2+9
;        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
;        blwp  @dsrlnk
;        data  8

        ;------------------------------------------------------
        ; Read record
        ;------------------------------------------------------
readfile        
        li    r0,pabadr2+9
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK

        bl    @vputb
        data  pabadr2,io.op.read

        blwp  @dsrlnk
        data  8

        jeq   file_error
        jmp   readfile

        ;------------------------------------------------------
        ; Close file
        ;------------------------------------------------------
close_file        
        li    r0,pabadr2+9
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK

        bl    @vputb
        data  pabadr2,io.op.close

        blwp  @dsrlnk
        data  8

done0   jmp   $
done1   jmp   $
done2   jmp   $

file_error 
        jmp   close_file





        



***************************************************************
* DSR subprogram for call files
***************************************************************
        even
dsrsub  byte  >01,>16               ; DSR program/subprogram - set file buffers


***************************************************************
* PAB for accessing file
********@*****@*********************@**************************
pab     byte  io.op.open            ;  0    - OPEN
        byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
        data  vrecbuf               ;  2-3  - Record buffer in VDP memory
        byte  80                    ;  4    - Record length (80 characters maximum)
        byte  80                    ;  5    - Character count
        data  >0000                 ;  6-7  - Seek record (only for fixed records)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)
fname   byte  15                    ;  9    - File descriptor length
        text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
        even


msg     #string '* File reading test *'
schrott data  >00aa, >3fff, >1103
