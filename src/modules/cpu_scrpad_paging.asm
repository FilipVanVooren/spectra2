* FILE......: cpu_scrpad_paging.asm
* Purpose...: CPU memory paging functions

*//////////////////////////////////////////////////////////////
*                     CPU memory paging 
*//////////////////////////////////////////////////////////////


***************************************************************
* cpu.scrpad.pgout - Page out scratchpad memory
***************************************************************
*  bl   @cpu.scrpad.pgout
*       DATA p0
*
*  P0 = CPU memory destination
*--------------------------------------------------------------
*  bl   @xcpu.scrpad.pgout
*  TMP1 = CPU memory destination
*--------------------------------------------------------------
*  Register usage
*  tmp0-tmp2 = Used as temporary registers
*  tmp3      = Copy of CPU memory destination
********|*****|*********************|**************************
cpu.scrpad.pgout:
        mov   *r11+,tmp1            ; tmp1 = Memory target address
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xcpu.scrpad.pgout:
        li    tmp0,>8300            ; tmp0 = Memory source address
        mov   tmp1,tmp3             ; tmp3 = copy of tmp1
        li    tmp2,128              ; tmp2 = Words to copy
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
        li    r14,cpu.scrpad.pgout.after.rtwp
                                    ; R14=PC
        clr   r15                   ; R15=STATUS
        ;------------------------------------------------------
        ; If we get here, WS was copied to specified 
        ; destination.  Also contents of r13,r14,r15 
        ; are about to be overwritten by rtwp instruction.
        ;------------------------------------------------------
        rtwp                        ; Activate copied workspace
                                    ; in non-scratchpad memory!

cpu.scrpad.pgout.after.rtwp:
        b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.pgout.$$:
        b     *r11                  ; Return to caller


***************************************************************
* cpu.scrpad.pgin - Page in scratchpad memory
***************************************************************
*  bl   @cpu.scrpad.pgin
*  DATA p0
*  P0 = CPU memory source
*--------------------------------------------------------------
*  bl   @memx.scrpad.pgin
*  TMP1 = CPU memory source
*--------------------------------------------------------------
*  Register usage
*  tmp0-tmp2 = Used as temporary registers
********|*****|*********************|**************************
cpu.scrpad.pgin:
        mov   *r11+,tmp0            ; tmp0 = Memory source address
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xcpu.scrpad.pgin:
        li    tmp1,>8300            ; tmp1 = Memory destination address
        li    tmp2,128              ; tmp2 = Words to copy
        ;------------------------------------------------------
        ; Copy memory
        ;------------------------------------------------------
!       mov   *tmp0+,*tmp1+         ; Copy word
        dec   tmp2
        jne   -!                    ; Loop until done
        ;------------------------------------------------------
        ; Switch workspace to scratchpad memory
        ;------------------------------------------------------
        lwpi  >8300                 ; Activate copied workspace
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.pgin.$$:
        b     *r11                  ; Return to caller 