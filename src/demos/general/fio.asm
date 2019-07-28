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
debug                   equ  1      ; Turn on debugging
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
skip_vdp_hchar          equ  1      ; Skip hchar, xchar
skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
skip_vdp_boxes          equ  1      ; Skip filbox, putbox
skip_vdp_bitmap         equ  1      ; Skip bitmap functions
skip_vdp_viewport       equ  1      ; Skip viewport functions
skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
skip_vdp_yx2px_calc     equ  1      ; Skip YX to pixel calculation
skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
skip_vdp_sprites        equ  1      ; Skip sprites support
skip_sound_player       equ  1      ; Skip inclusion of sound player code
skip_tms52xx_detection  equ  1      ; Skip speech synthesizer detection
skip_tms52xx_player     equ  1      ; Skip inclusion of speech player code
skip_random_generator   equ  1      ; Skip random functions 
skip_timer_alloc        equ  1      ; Skip support for timers allocation


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
recbuf  equ   >0300                 ; VDP Buffer



***************************************************************
* Main
********@*****@*********************@**************************
main    bl    @putat
        data  >0815,msg

        bl    @cpym2v
        data  pabadr1,dsrsub,2      ; Copy PAB for DSR call files subprogram

        bl    @cpym2v
        data  pabadr2,pab,21        ; Copy PAB to VDP

        bl    @mem.scrpad.pgout     ; Page out scratchpad memory
        data  >a000                 ; Memory destination @>a000

        ;------------------------------------------------------
        ; Set up file buffer - call files(1)
        ;------------------------------------------------------
        li    r0,>0100 
        movb  r0,@>834c             ; Set number of disk files to 1

        li    r0,pabadr1
        mov   r0,@>8356             ; Pass PAB to DSRLNK
        blwp  @dsrlnk               ; Call subprogram for "call files(1)"
        data  10 
 
        ;------------------------------------------------------
        ; Open file
        ;------------------------------------------------------
        li    r0,pabadr2+9
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
        blwp  @dsrlnk
        data  8


        ;------------------------------------------------------
        ; Read record
        ;------------------------------------------------------
        li    r0,pabadr2+9
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK

        bl    @vputb
        data  pabadr2,io.op.read

        blwp  @dsrlnk
        data  8

        jmp   $



***************************************************************
* File IO operations
************************************@**************************
io.op.open       equ >00            ; OPEN
io.op.close      equ >01            ; CLOSE
io.op.read       equ >02            ; READ
io.op.write      equ >03            ; WRITE
io.op.rewind     equ >04            ; RESTORE/REWIND
io.op.load       equ >05            ; LOAD
io.op.save       equ >06            ; SAVE
io.op.delfile    equ >07            ; DELETE FILE
io.op.status     equ >09            ; STATUS
***************************************************************
* File types - All relative files are fixed length
************************************@**************************
io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
***************************************************************
* File types - Sequential files
************************************@**************************
io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL



***************************************************************
* DSR subprogram for call files
***************************************************************
dsrsub  byte  >01,>16               ; DSR program/subprogram - set file buffers
***************************************************************
* PAB for accessing file
********@*****@*********************@**************************
pab     byte  io.op.open            ;  0    - OPEN
        byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
        data  recbuf                ;  2-3  - Record buffer in VDP memory
        byte  >50                   ;  4    - 80 characters maximum
        byte  >00                   ;  5    - Filled with bytes read during read
        data  >0000                 ;  6-7  - Seek record (only for fixed records)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)
        byte  11
        text  'DSK1.MYFILE'         ;  9    - Length of string
                                    ; 10-.. - Device+String name


msg     #string '* File reading test *'
