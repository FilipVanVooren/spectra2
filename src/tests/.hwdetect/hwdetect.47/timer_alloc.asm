* FILE......: timer_alloc.asm
* Purpose...: Support code for timer allocation


***************************************************************
* MKSLOT - Allocate timer slot(s)
***************************************************************
*  BL    @MKSLOT
*  BYTE  P0HB,P0LB
*  DATA  P1
*  ....
*  DATA  EOL                        ; End-of-list
*--------------------------------------------------------------
*  P0 = Slot number, target count
*  P1 = Subroutine to call via BL @xxxx if slot is fired
********@*****@*********************@**************************
mkslot  mov   *r11+,tmp0
        mov   *r11+,tmp1
*--------------------------------------------------------------
*  Calculate address of slot
*--------------------------------------------------------------
        mov   tmp0,tmp2
        srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
        a     @wtitab,tmp2          ; Add table base
*--------------------------------------------------------------
*  Add slot to table
*--------------------------------------------------------------
        mov   tmp1,*tmp2+           ; Store address of subroutine
        sla   tmp0,8                ; Get rid of slot number
        mov   tmp0,*tmp2            ; Store target count and reset tick count
*--------------------------------------------------------------
*  Check for end of list
*--------------------------------------------------------------
        c     *r11,@whffff          ; End of list ?
        jeq   mkslo1                ; Yes, exit
        jmp   mkslot                ; Process next entry
*--------------------------------------------------------------
*  Exit
*--------------------------------------------------------------
mkslo1  inct  r11
        b     *r11                  ; Exit


***************************************************************
* CLSLOT - Clear single timer slot
***************************************************************
*  BL    @CLSLOT
*  DATA  P0
*--------------------------------------------------------------
*  P0 = Slot number
********@*****@*********************@**************************
clslot  mov   *r11+,tmp0
xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
        a     @wtitab,tmp0          ; Add table base
        clr   *tmp0+                ; Clear 1st word of slot
        clr   *tmp0                 ; Clear 2nd word of slot
        b     *r11                  ; Exit
