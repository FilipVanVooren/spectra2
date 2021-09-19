* FILE......: cpu_scrpad_paging.asm
* Purpose...: CPU memory paging functions

*//////////////////////////////////////////////////////////////
*                     CPU memory paging 
*//////////////////////////////////////////////////////////////


***************************************************************
* cpu.scrpad.pgout - Page out 256 bytes of scratchpad at >8300
*                    to CPU memory destination P0 (tmp1)
*                    and replace with 256 bytes of memory from
*                    predefined destination @cpu.scrpad.target 
***************************************************************
*  bl   @cpu.scrpad.pgout
*       DATA p0
*
*  P0 = CPU memory destination
*--------------------------------------------------------------
*  bl   @xcpu.scrpad.pgout
*  tmp1 = CPU memory destination
*--------------------------------------------------------------
*  Register usage
*  tmp3      = Copy of CPU memory destination
*  tmp0-tmp2 = Used as temporary registers
*  @waux1    = Copy of r5 (tmp1)
*--------------------------------------------------------------
*  Remarks
*  Copies 256 bytes from scratchpad to CPU memory destination
*  specified in P0 (TMP1).
*
*  Then copies 256 bytes from @cpu.scrpad.tgt to scratchpad 
*  >8300 and activates workspace in >8300
********|*****|*********************|**************************
cpu.scrpad.pgout:
        mov   tmp1,@waux1           ; Backup tmp1
        mov   *r11+,tmp1            ; tmp1 = Memory target address
        ;------------------------------------------------------
        ; Copy registers r0-r7
        ;------------------------------------------------------
        mov   r0,*tmp1+             ; Backup r0
        mov   r1,*tmp1+             ; Backup r1
        mov   r2,*tmp1+             ; Backup r2
        mov   r3,*tmp1+             ; Backup r3
        mov   r4,*tmp1+             ; Backup r4
        mov   @waux1,*tmp1+         ; Backup r5 (old value tmp1)
        mov   r6,*tmp1+             ; Backup r6
        mov   r7,*tmp1+             ; Backup r7
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xcpu.scrpad.pgout:
        li    tmp0,>8310            ; tmp0 = Memory source address
                                    ;        as of register r8
        li    tmp2,15               ; tmp2 = 15 iterations
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
        mov   @waux1,r13            ; R13=WP   (pop tmp1 from stack)
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
* cpu.scrpad.pgin - Page in 256 bytes of scratchpad memory 
*                   at >8300 from CPU memory specified in 
*                   p0 (tmp0)
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