***************************************************************
* Hardware detection 
***************************************************************
* This file: hwdetect.a99
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
title0  byte  18
        text  'HARDWARE DETECTION'
*--------------------------------------------------------------
* Include required files
*--------------------------------------------------------------
        copy  "%%spectra2%%/runlib.asm"
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
spfclr  equ   >a0                   ; Foreground/Background color for font.
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
main    bl    @putat
        data  >0000,hello
*--------------------------------------------------------------
* Check F18A VDP
*--------------------------------------------------------------
        coc   @wbit1,config         ; CONFIG bit 1 set ?
        jeq   main1
        bl    @putat
        data  >0502,f18nok
        jmp   main2

main1   bl    @putat
        data  >0502,f18ok

        bl    @cpym2m
        data  f18fir,rambuf,28      ; Copy message string to ram
        
        bl    @f18unl
        bl    @f18fwv               ; Get F18A firmware version
        mov   tmp0,@fwvers          ; Take backup

        mov   tmp0,tmp1
        sla   tmp1,4                ; Move high nibble LSB to MSB
        ai    tmp1,>3000            ; ASCII offset 48
        movb  tmp1,@rambuf+18       ; Inject into string

        mov   tmp0,tmp1
        andi  tmp1,>000f            ; Only keep low nibble
        ai    tmp1,>0030            ; ASCII offset 48 
        sla   tmp1,8                ; Move LSB to MSB
        movb  tmp1,@rambuf+20       ; Inject into string

        bl    @putat
        data  >0902,rambuf          ; Display string

        mov   tmp0,@rambuf
        bl    @puthex
        data  >0918,fwvers,rambuf,48
*--------------------------------------------------------------
* Check speech synthesizer
*--------------------------------------------------------------
main2   coc   @wbit5,config         ; CONFIG bit 5 set ? 
        jeq   main3
        bl    @putat
        data  >0302,spenok
        jmp   main4
main3   bl    @putat
        data  >0302,speok
*--------------------------------------------------------------
* Show VDP refresh rate (50Hz/60Hz)
*--------------------------------------------------------------
main4   coc   @wbit2,config         ; CONFIG bit 2 set ?
        jeq   main5
        bl    @putat
        data  >0702,vdp60hz
        jmp   main6
main5   bl    @putat
        data  >0702,vdp50hz
*--------------------------------------------------------------
* Check keyboard (alpha lock down)
*--------------------------------------------------------------
main6   coc   @wbit10,config        ; CONFIG bit 10 set ?
        jeq   main7
        bl    @putat
        data  >0b02,alphaup
        jmp   main8 
main7   bl    @putat
        data  >0b02,alphadn
        jmp   main8 
main8   b     @kernel               ; Start kernel
*--------------------------------------------------------------
* Data
*--------------------------------------------------------------
hello   byte 18
        text 'Hardware detection'
f18ok   byte 19
        text '+ F18A VDP detected'
        even
f18nok  byte 20
        text '- TMS9918 or similar'
        even
f18fir  byte 28 
        text '* F18A Firmware V .  (1234)'
speok   byte 29
        text '+ Speech synthesizer detected'
        even
spenok  byte 29
        text '- No speech synthesizer found' 
        even
vdp50hz byte 23
        text '* VDP refresh rate 50hz'
        even
vdp60hz byte 23
        text '* VDP refresh rate 60hz'
alphaup byte 19
        text '* Alpha lock key up'
        even
alphadn byte 21
        text '* Alpha lock key down'

