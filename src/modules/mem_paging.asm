* FILE......: mem_paging.asm
* Purpose...: CPU memory paging functions

*//////////////////////////////////////////////////////////////
*                     CPU memory paging 
*//////////////////////////////////////////////////////////////

***************************************************************
* mem.scrpad.pgout - Page out scratchpad memory
***************************************************************
*  bl   @mem.scrpad.pgout
*  DATA p0
*  P0 = CPU memory destination
*--------------------------------------------------------------
*  bl   @memx.scrpad.pgout
*  TMP1 = CPU memory destination
*--------------------------------------------------------------
*  Register usage
*  tmp0-tmp2 = Used as temporary registers
*  tmp3      = Copy of CPU memory destination
********@*****@*********************@**************************
mem.scrpad.pgout:
        mov   *r11+,tmp1            ; tmp1 = Memory target address
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xmem.scrpad.pgout:
        li    tmp0,>8300            ; tmp0 = Memory source address
        mov   tmp1,tmp3             ; tmp3 = copy of tmp1
        li    tmp2,128              ; tmp2 = Bytes to copy
        ;------------------------------------------------------
        ; Copy memory
        ;------------------------------------------------------
!       mov   *tmp0+,*tmp1+         ; Copy word
        dec   tmp2
        jne   -!                    ; Loop until done
        ;------------------------------------------------------
        ; Switch to new workspace
        ;------------------------------------------------------
        mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
        li    r14,mem.scrpad.pgout.after.rtwp
                                    ; R14=PC
        clr   r15                   ; R15=STATUS
        ;------------------------------------------------------
        ; If we get here, WS was copied to specified 
        ; destination.  Also contents of r13,r14,r15 
        ; are about to be overwritten by rtwp instruction.
        ;------------------------------------------------------
        rtwp                        ; Activate copied workspace
                                    ; in non-scratchpad memory!

mem.scrpad.pgout.after.rtwp:
        ;------------------------------------------------------
        ; Clear scratchpad memory >8300 - >836f
        ;------------------------------------------------------
        li    tmp1,>8300
        li    tmp2,92              ; Clear 92 words of memory
!       clr   *tmp1+
        dec   tmp2
        jne   -!                    ; Loop until done
        ;------------------------------------------------------
        ; Poke values in scratchpad memory >8370 - >83ff for
        ; simulating Editor/Assembler environment
        ;------------------------------------------------------
        li    tmp0,data00008370
        li    tmp1,>8370
        li    tmp2,72
!       mov   *tmp0+,*tmp1+
        dec   tmp2
        jne   -!                    ; Loop until done
        ;------------------------------------------------------
        ; WARNING
        ; For the TI disk controller to work it is required
        ; that VDP memory range >37D7 up to >37DC contains the
        ; words:  >00AA, >3FFF, >1100
        ;------------------------------------------------------

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.scrpad.pgout.$$:
        b     *r11                  ; Return to caller



data00008370  data >37D7,>9E80,>00FF,>0000,>0075,>0080,>0000,>151B  
data00008380  data >6117,>6FE1,>0000,>0000,>0000,>0000,>0000,>0000
data00008390  data >0000,>0000,>0000,>0000,>0000,>0000,>0000,>0000        
data000083a0  data >0000,>0000,>0000,>0000,>0000,>0000,>0000,>0000
data000083b0  data >0000,>0000,>0000,>0000,>0000,>0000,>0000,>0000
data000083c0  data >5C2D,>0000,>0000,>0200,>FFFF,>FF00,>0484,>0000
data000083d0  data >0874,>0000,>E000,>05D6,>0070,>83E0,>0074,>2002
data000083e0  data >0000,>0002,>0000,>0000,>0000,>0000,>0000,>0000
data000083f0  data >0000,>0006,>4000,>02BA,>0006,>9800,>0108,>8C02