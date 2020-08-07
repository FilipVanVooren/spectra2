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
*--------------------------------------------------------------
*  Remarks
*  Copies 256 bytes from scratchpad to CPU memory destination
*  specified in P0 (TMP1).
*  Then copies 256 bytes from @cpu.scrpad.tgt 
*  to scratchpad >8300 and activates workspace in >8300
********|*****|*********************|**************************
cpu.scrpad.pgout:
        mov   *r11+,tmp1            ; tmp1 = Memory target address
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xcpu.scrpad.pgout:
        li    tmp0,>8300            ; tmp0 = Memory source address
        mov   tmp1,tmp3             ; tmp3 = copy of tmp1
        li    tmp2,16               ; tmp2 = 256/16        
        ;------------------------------------------------------
        ; Copy memory
        ;------------------------------------------------------
!       mov   *tmp0+,*tmp1+         ; Copy word 1
        mov   *tmp0+,*tmp1+         ; Copy word 2
        mov   *tmp0+,*tmp1+         ; Copy word 3
        mov   *tmp0+,*tmp1+         ; Copy word 4
        mov   *tmp0+,*tmp1+         ; Copy word 5
        mov   *tmp0+,*tmp1+         ; Copy word 6
        mov   *tmp0+,*tmp1+         ; Copy word 7
        mov   *tmp0+,*tmp1+         ; Copy word 8                         
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
        b     @cpu.scrpad.restore   ; Restore scratchpad memory 
                                    ; from @cpu.scrpad.tgt to @>8300
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.pgout.exit:
        b     *r11                  ; Return to caller


***************************************************************
* cpu.scrpad.pgin - Page in scratchpad memory
***************************************************************
*  bl   @cpu.scrpad.pgin
*  DATA p0
*  P0 = CPU memory source
*--------------------------------------------------------------
*  bl   @memx.scrpad.pgin
*  TMP0 = CPU memory source
*--------------------------------------------------------------
*  Register usage
*  tmp0-tmp2 = Used as temporary registers
*--------------------------------------------------------------
*  Remarks
*  Copies 256 bytes from CPU memory source to scratchpad >8300 
*  and activates workspace in scratchpad >8300
********|*****|*********************|**************************
cpu.scrpad.pgin:
        mov   *r11+,tmp0            ; tmp0 = Memory source address
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xcpu.scrpad.pgin:
        li    tmp1,>8300            ; tmp1 = Memory destination address
        li    tmp2,16               ; tmp2 = 256/16
        ;------------------------------------------------------
        ; Copy memory
        ;------------------------------------------------------
!       mov   *tmp0+,*tmp1+         ; Copy word 1
        mov   *tmp0+,*tmp1+         ; Copy word 2
        mov   *tmp0+,*tmp1+         ; Copy word 3
        mov   *tmp0+,*tmp1+         ; Copy word 4
        mov   *tmp0+,*tmp1+         ; Copy word 5
        mov   *tmp0+,*tmp1+         ; Copy word 6
        mov   *tmp0+,*tmp1+         ; Copy word 7
        mov   *tmp0+,*tmp1+         ; Copy word 8
        dec   tmp2
        jne   -!                    ; Loop until done
        ;------------------------------------------------------
        ; Switch workspace to scratchpad memory
        ;------------------------------------------------------
        lwpi  >8300                 ; Activate copied workspace
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.pgin.exit:
        b     *r11                  ; Return to caller 