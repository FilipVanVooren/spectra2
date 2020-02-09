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
* >ffe0  r0               >fff0  r8  (tmp4)
* >ffe2  r1               >fff2  r9  (stack)
* >ffe4  r2 (config)      >fff4  r10
* >ffe6  r3               >fff6  r11
* >ffe8  r4 (tmp0)        >fff8  r12
* >ffea  r5 (tmp1)        >fffa  r13
* >ffec  r6 (tmp2)        >fffc  r14
* >ffee  r7 (tmp3)        >fffe  r15
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
        ; Show crashed message
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
        ; Show caller details
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
        ; Show registers R0 - R15
        ;------------------------------------------------------
        bl    @at                   ; Put cursor at YX
              byte 3,4              ; \ i p0 = YX position         
                                    ; /

        li    tmp0,>ffe0            ; Crash registers >ffe0 - >ffff
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
        mov   tmp2,r1               ; Save register number

        bl    @mknum
              data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
              data rambuf           ; | i  p1 = Pointer to ram buffer
              byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9

        bl    @setx                 ; Set cursor X position
              data 0                ; \ i  p0 =  Cursor Y position
                                    ; /

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
        bl    @mkhex                ; Convert hex word to string
              data r0hb             ; \ i  p0 = Pointer to 16 bit word  
              data rambuf           ; | i  p1 = Pointer to ram buffer
              byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9


        bl    @setx                 ; Set cursor X position
              data 6                ; \ i  p0 =  Cursor Y position
                                    ; /

        bl    @putstr
              data cpu.crash.msg.marker

        bl    @setx                 ; Set cursor X position
              data 7                ; \ i  p0 =  Cursor Y position
                                    ; /

        bl    @putstr               ; Put length-byte prefixed string at current YX
              data rambuf           ; \ i  p0 = Pointer to ram buffer
                                    ; /

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0

        bl    @down                 ; y=y+1

        inc   tmp2
        ci    tmp2,15
        jle   cpu.crash.showreg     ; Show next register
        ;------------------------------------------------------
        ; Display temp variable markers
        ;------------------------------------------------------
        bl    @putat
              byte 5,15
              data cpu.crash.msg.config
        bl    @putat
              byte 7,15
              data cpu.crash.msg.tmp0 
        bl    @putat
              byte 8,15
              data cpu.crash.msg.tmp1
        bl    @putat
              byte 9,15
              data cpu.crash.msg.tmp2 
        bl    @putat
              byte 10,15
              data cpu.crash.msg.tmp3 
        bl    @putat
              byte 11,15
              data cpu.crash.msg.tmp4 
        bl    @putat
              byte 12,15
              data cpu.crash.msg.stack
        ;------------------------------------------------------
        ; Kernel takes over
        ;------------------------------------------------------
        b     @tmgr                 ; Start kernel again for polling keyboard
        

cpu.crash.msg.crashed      byte 21
                           text 'System crashed near >'

cpu.crash.msg.caller       byte 21        
                           text 'Caller address near >'

cpu.crash.msg.r            byte 1
                           text 'R'

cpu.crash.msg.marker       byte 1      
                           text '>'

cpu.crash.msg.config       byte 6
                           text 'config'
                           even

cpu.crash.msg.stack        byte 5
                           text 'stack'
                           even

cpu.crash.msg.tmp0         byte 4
                           text 'tmp0'
                           even

cpu.crash.msg.tmp1         byte 4
                           text 'tmp1'
                           even

cpu.crash.msg.tmp2         byte 4
                           text 'tmp2'
                           even

cpu.crash.msg.tmp3         byte 4
                           text 'tmp3'
                           even

cpu.crash.msg.tmp4         byte 4
                           text 'tmp4'
                           even
