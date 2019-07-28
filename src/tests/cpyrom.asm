***************************************************************
* This file: cpyrom.asm             ; Version %%build_date%%
********@*****@*********************@**************************
        save  >6000,>7fff
        aorg  >6000
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reducing code size
*--------------------------------------------------------------
debug                  equ  1       ; 0|1  1=Debug
skip_rom_bankswitch    equ  1       ; Skip ROM bankswitching support
*skip_grom_support      equ  1       ; Skip GROM support functions
skip_f18a_support      equ  1       ; Skip f18a support
skip_vdp_hchar         equ  1       : Skip hchar, xchar
skip_vdp_vchar         equ  1       ; Skip vchar, xvchar
skip_vdp_boxes         equ  1       ; Skip filbox, putbox
skip_vdp_hexsupport    equ  1       ; Skip mkhex, puthex
skip_vdp_bitmap        equ  1       ; Skip bitmap functions
skip_vdp_viewport      equ  1       ; Skip viewport functions
skip_keyboard_real     equ  1       ; Skip real keyboard support
skip_random_generator  equ  1       ; Skip random functions 
*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
grmhdr  byte  >aa,1,1,0,0,0
        data  prog0
        byte  0,0,0,0,0,0,0,0
prog0   data  0                     ; No more items following
        data  runlib
*--------------------------------------------------------------
    .ifdef debug
        byte  8+%%build_date.length%%
        text  'COPY ROM %%build_date%%'
    .else
        byte  16
        text  'COPY ROM'
    .endif
*--------------------------------------------------------------
* Include required files
*--------------------------------------------------------------
        copy  "%%spectra2%%/runlib.asm"
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
spfclr  equ   >1C                   ; Foreground/Background color for font.
spfbck  equ   >0C                   ; Screen background color.
*--------------------------------------------------------------
* Variables
*--------------------------------------------------------------
timers  equ   >83e0                 ; Timer table (16 bytes/4 slots)
;--------------------------------------------------------------
; graphics mode 1 configuration (32x24)
;--------------------------------------------------------------
spvmod  equ   graph1                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
***************************************************************
* Main
********@*****@*********************@**************************
main
        bl    @cpym2m
        data  >0000,>a000,>2000     ; Copy >2000 bytes from >0000 to >a0000.

        bl    @putat
        data  >0000,message       

        b     @kernel

message byte  22 
        text  'OS ROM copied to >A000'
