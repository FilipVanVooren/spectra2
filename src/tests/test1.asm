***************************************************************
* Hardware detection 
***************************************************************
* This file: test1.asm
********|*****|*********************|**************************
        save  >6000,>7fff
        aorg  >6000

*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
grmhdr  byte  >aa,1,1,0,0,0
        data  prog0
        byte  0,0,0,0,0,0,0,0
prog0   data  0                     ; No more items following
        data  runlib
title0  byte  9
        text  'F18A DEMO'
*--------------------------------------------------------------
* Include required files
*--------------------------------------------------------------
        copy  "../runlib.a99"
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
spfclr  equ   >F5                   ; Foreground/Background color for font.
spfbck  equ   >01                   ; Screen background color.
*--------------------------------------------------------------
* Variables
*--------------------------------------------------------------
timers  equ   >8342                 ; Address of timer table (8 bytes)
fwvers  equ   >8350                 ; F18A Firmware version
rambuf  equ   >8352                 ; Work buffer
;--------------------------------------------------------------
; graphics mode 1 configuration (32x24)
;--------------------------------------------------------------
spvmod  equ   graph1                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
***************************************************************
* Main
********|*****|*********************|**************************
main    coc   @wbit1,config         ; CONFIG bit 1 set ?
        jeq   main1                 ; Yes, we have a F18A
        blwp  @0                    ; No, return to title screen
*--------------------------------------------------------------
* Here we go
*--------------------------------------------------------------
*
main1   bl    @f18unl               ; Unlock the beast
        bl    @vidtab
        data  tx8024                ; 80x24 Video mode
        bl    @putat
        data  >0A10,hw
        b     @kernel               ; FCTN-QUIT Handler
*--------------------------------------------------------------
* Data
*--------------------------------------------------------------
hw      byte  12
        text  'Hello World!'
        even
