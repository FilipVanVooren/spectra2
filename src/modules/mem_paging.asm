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
*--------------------------------------------------------------
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
        mov   tmp1,tmp3             ; tmp3 = copy of tmp1
        ;------------------------------------------------------
        ; Copy scratchpad memory to destination
        ;------------------------------------------------------
xmem.scrpad.pgout:
        li    tmp0,>8300            ; tmp0 = Memory source address
        li    tmp2,128              ; tmp2 = Bytes to copy
        mov   tmp1,tmp3             ; tmp3 = copy of tmp1
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
        ; If we get here, WS will be moved to specified 
        ; destination.  Also contents of r13,r14,r15 
        ; are about to be overwritten by rtwp instruction.
        ;------------------------------------------------------
        rtwp                        ; Activate new workspace
        ;------------------------------------------------------
        ; Setup scratchpad memory for DSRLNK/GPLLNK
        ;------------------------------------------------------
mem.scrpad.pgout.after.rtwp:
        li    tmp1,>8300
        li    tmp2,128              ; Clear 128 words of memory
        ;------------------------------------------------------
        ; Clear scratchpad memory >8300 - >83ff
        ;------------------------------------------------------
!       clr   *tmp1+
        dec   tmp2
        jne   -!                    ; Loop until done
        ;------------------------------------------------------
        ; Poke values in GPL workspace >83e0 - >83ff
        ;------------------------------------------------------
        li    tmp0,>9800
        mov   tmp0,@>83fa           ; R13 = >9800

        li    tmp0,>0108
        mov   tmp0,@>83fc           ; R14 = >0001 

        li    tmp0,>8c02
        mov   tmp0,@>83fe           ; R15 = >8c02
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.scrpad.pgout.$$:
        b     *r11                  ; Return to caller
