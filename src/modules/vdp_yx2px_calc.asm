* FILE......: vdp_yx2px_calc.asm
* Purpose...: Calculate pixel position for YX coordinate

***************************************************************
* YX2PX - Get pixel position for cursor YX position
***************************************************************
*  BL   @YX2PX
*
*  (CONFIG:0 = 1) = Skip sprite adjustment
*--------------------------------------------------------------
*  INPUT
*  @WYX   = Cursor YX position
*--------------------------------------------------------------
*  OUTPUT
*  TMP0HB = Y pixel position
*  TMP0LB = X pixel position
*--------------------------------------------------------------
*  Remarks
*  This subroutine does not support multicolor mode
********@*****@*********************@**************************
yx2px   mov   @wyx,tmp0
yx2pxx  mov   r11,tmp2              ; Save return address
        swpb  tmp0                  ; Y<->X
        clr   tmp1                  ; Clear before copy
        movb  tmp0,tmp1             ; Copy X to TMP1
*--------------------------------------------------------------
* X pixel - Special F18a 80 colums treatment
*--------------------------------------------------------------
        coc   @wbit1,config         ; f18a present ?
        jne   yx2pxx_normal         ; No, skip 80 cols handling
        c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
        jne   yx2pxx_normal         ; No, skip 80 cols handling

        sla   tmp1,1                ; X = X * 2
        ab    tmp0,tmp1             ; X = X + (original X)
        ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
        jmp   yx2pxx_y_calc
*--------------------------------------------------------------
* X pixel - Normal VDP treatment 
*--------------------------------------------------------------
yx2pxx_normal:
        movb  tmp0,tmp1             ; Copy X to TMP1
*--------------------------------------------------------------
        sla   tmp1,3                ; X=X*8
*--------------------------------------------------------------
* Calculate Y pixel position
*--------------------------------------------------------------
yx2pxx_y_calc:
        sla   tmp0,3                ; Y=Y*8
        movb  tmp1,tmp0
        swpb  tmp0                  ; X<->Y
yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
        jeq   yx2pi3                ; Yes, exit
*--------------------------------------------------------------
* Adjust for Y sprite location
* See VDP Programmers Guide, Section 9.2.1
*--------------------------------------------------------------
yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
        cb    @hb$d0,tmp0           ; Y position = >D0 ?
        jeq   yx2pi2                ; Yes, but that's not allowed, adjust
yx2pi3  b     *tmp2                 ; Exit
*--------------------------------------------------------------
* Local constants
*--------------------------------------------------------------
yx2pxx_c80:
       data   80


