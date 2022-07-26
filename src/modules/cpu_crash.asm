* FILE......: cpu_crash.asm
* Purpose...: Custom crash handler module


***************************************************************
* cpu.crash - CPU program crashed handler
***************************************************************
*  bl   @cpu.crash
*--------------------------------------------------------------
* Crash and halt system. Upon crash entry register contents are
* copied to the memory region >ffe0 - >fffe and displayed after
* resetting the spectra2 runtime library, video modes, etc.
*
* Diagnostics
* >ffce  caller address
*
* Register contents
* >ffdc  wp
* >ffde  st
* >ffe0  r0
* >ffe2  r1
* >ffe4  r2  (config)
* >ffe6  r3
* >ffe8  r4  (tmp0)
* >ffea  r5  (tmp1)
* >ffec  r6  (tmp2)
* >ffee  r7  (tmp3)
* >fff0  r8  (tmp4)
* >fff2  r9  (stack)
* >fff4  r10
* >fff6  r11
* >fff8  r12
* >fffa  r13
* >fffc  r14
* >fffe  r15
********|*****|*********************|**************************
cpu.crash:
        ai    r11,-4                ; Remove opcode offset
*--------------------------------------------------------------
*    Save registers to high memory
*--------------------------------------------------------------
        mov   r0,@>ffe0
        mov   r1,@>ffe2
        mov   r2,@>ffe4
        mov   r3,@>ffe6
        mov   r4,@>ffe8
        mov   r5,@>ffea
        mov   r6,@>ffec
        mov   r7,@>ffee
        mov   r8,@>fff0
        mov   r9,@>fff2
        mov   r10,@>fff4
        mov   r11,@>fff6
        mov   r12,@>fff8
        mov   r13,@>fffa
        mov   r14,@>fffc
        mov   r15,@>ffff
        stwp  r0
        mov   r0,@>ffdc
        stst  r0
        mov   r0,@>ffde
*--------------------------------------------------------------
*    Reset system
*--------------------------------------------------------------
cpu.crash.reset:
        lwpi  ws1                   ; Activate workspace 1
        clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
        li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
        b     @runli1               ; Initialize system again (VDP, Memory, etc.)
*--------------------------------------------------------------
*    Show diagnostics after system reset
*--------------------------------------------------------------
cpu.crash.main:
        ;------------------------------------------------------
        ; Load "32x24" video mode & font
        ;------------------------------------------------------
        bl    @vidtab               ; Load video mode table into VDP
              data graph1           ; \ i  p0 = pointer to video mode table
                                    ; /

        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)

        bl    @filv
              data >0000,32,32*24   ; Clear screen

        bl    @filv
              data >0380,>f0,32*24  ; Load color table
        ;------------------------------------------------------
        ; Show crash address
        ;------------------------------------------------------
        bl    @putat                ; Show crash message
              data >0000,cpu.crash.msg.crashed

        bl    @puthex               ; Put hex value on screen
              byte 0,21             ; \ i  p0 = YX position
              data >fff6            ; | i  p1 = Pointer to 16 bit word
              data rambuf           ; | i  p2 = Pointer to ram buffer
              byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9
        ;------------------------------------------------------
        ; Show caller address
        ;------------------------------------------------------
        bl    @putat                ; Show caller message
              data >0100,cpu.crash.msg.caller

        bl    @puthex               ; Put hex value on screen
              byte 1,21             ; \ i  p0 = YX position
              data >ffce            ; | i  p1 = Pointer to 16 bit word
              data rambuf           ; | i  p2 = Pointer to ram buffer
              byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9
        ;------------------------------------------------------
        ; Display labels
        ;------------------------------------------------------
        bl    @putat
              byte 3,0
              data cpu.crash.msg.wp
        bl    @putat
              byte 4,0
              data cpu.crash.msg.st
        ;------------------------------------------------------
        ; Show crash registers WP, ST, R0 - R15
        ;------------------------------------------------------
        bl    @at                   ; Put cursor at YX
              byte 3,4              ; \ i p0 = YX position
                                    ; /

        li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
        clr   tmp2                  ; Loop counter

cpu.crash.showreg:
        mov   *tmp0+,r0             ; Move crash register content to r0

        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Display crash register number
        ;------------------------------------------------------
cpu.crash.showreg.label:
        mov   tmp2,r1               ; Save register number
        ci    tmp2,1                ; Skip labels WP/ST?
        jle   cpu.crash.showreg.content
                                    ; Yes, skip

        dect  r1                    ; Adjust because of "dummy" WP/ST registers
        bl    @mknum
              data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
              data rambuf           ; | i  p1 = Pointer to ram buffer
              byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9

        bl    @setx                 ; Set cursor X position
              data 0                ; \ i  p0 =  Cursor Y position
                                    ; /

        li    tmp0,>0400            ; Set string length-prefix byte
        movb  tmp0,@rambuf          ;

        bl    @putstr               ; Put length-byte prefixed string at current YX
              data rambuf           ; \ i  p0 = Pointer to ram buffer
                                    ; /

        bl    @setx                 ; Set cursor X position
              data 2                ; \ i  p0 =  Cursor Y position
                                    ; /

        ci    r1,10
        jlt   !
        dec   @wyx                  ; x=x-1

!       bl    @putstr
              data cpu.crash.msg.r

        bl    @mknum
              data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
              data rambuf           ; | i  p1 = Pointer to ram buffer
              byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9
        ;------------------------------------------------------
        ; Display crash register content
        ;------------------------------------------------------
cpu.crash.showreg.content:
        bl    @mkhex                ; Convert hex word to string
              data r0hb             ; \ i  p0 = Pointer to 16 bit word
              data rambuf           ; | i  p1 = Pointer to ram buffer
              byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9

        bl    @setx                 ; Set cursor X position
              data 4                ; \ i  p0 =  Cursor Y position
                                    ; /

        bl    @putstr               ; Put '  >'
              data cpu.crash.msg.marker

        bl    @setx                 ; Set cursor X position
              data 7                ; \ i  p0 =  Cursor Y position
                                    ; /

        li    tmp0,>0400            ; Set string length-prefix byte
        movb  tmp0,@rambuf          ;

        bl    @putstr               ; Put length-byte prefixed string at current YX
              data rambuf           ; \ i  p0 = Pointer to ram buffer
                                    ; /

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0

        bl    @down                 ; y=y+1

        inc   tmp2
        ci    tmp2,17
        jle   cpu.crash.showreg     ; Show next register
        ;------------------------------------------------------
        ; Kernel takes over
        ;------------------------------------------------------
        b     @cpu.crash.showbank   ; Expected to be included in


cpu.crash.msg.crashed      stri 'System crashed near >'
                           even
cpu.crash.msg.caller       stri 'Caller address near >'
                           even
cpu.crash.msg.r            stri 'R'
                           even
cpu.crash.msg.marker       stri '  >'
                           even
cpu.crash.msg.wp           stri '**WP'
                           even
cpu.crash.msg.st           stri '**ST'
                           even
cpu.crash.msg.source       stri 'Source    %%build_src%%'
                           even
cpu.crash.msg.id           stri 'Build-ID  %%build_date%%'
                           even
