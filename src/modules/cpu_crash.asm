* FILE......: cpu_crash.asm
* Purpose...: Custom crash handler module


***************************************************************
* crash - CPU program crashed handler 
***************************************************************
*  bl   @crash
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
********@*****@*********************@**************************
crash:  ai    r11,-4                ; Remove opcode offset         
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
crash.reset:
        lwpi  ws1                   ; Activate workspace 1
        clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
        li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
        b     @runli1               ; Initialize system again (VDP, Memory, etc.)
*--------------------------------------------------------------
*    Show diagnostics after system reset
*--------------------------------------------------------------
crash.main:
        ;------------------------------------------------------
        ; Show crashed message
        ;------------------------------------------------------
        bl    @putat                ; Show crash message
              data >0000,crash.msg.crashed
                
        bl    @puthex               ; Put hex value on screen
              byte 0,19             ; \ .  p0 = YX position              
              data >fff6            ; | .  p1 = Pointer to 16 bit word
              data rambuf           ; | .  p2 = Pointer to ram buffer
              byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9
        ;------------------------------------------------------
        ; Show caller details
        ;------------------------------------------------------
        bl    @putat                ; Show caller message
              data >0100,crash.msg.caller

        bl    @puthex               ; Put hex value on screen
              byte 1,19             ; \ .  p0 = YX position              
              data >ffce            ; | .  p1 = Pointer to 16 bit word
              data rambuf           ; | .  p2 = Pointer to ram buffer
              byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
                                    ; /         LSB offset for ASCII digit 0-9
        ;------------------------------------------------------
        ; Kernel takes over
        ;------------------------------------------------------
        b     @tmgr                 ; Start kernel again for polling keyboard
        
crash.msg.crashed      byte 19
                       text 'System crashed at >'

crash.msg.caller       byte 19        
                       text 'Caller address is >'
