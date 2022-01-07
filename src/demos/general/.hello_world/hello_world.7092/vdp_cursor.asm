* FILE......: vdp_cursor.asm
* Purpose...: VDP cursor handling 

*//////////////////////////////////////////////////////////////
*               VDP cursor movement functions
*//////////////////////////////////////////////////////////////


***************************************************************
* AT - Set cursor YX position
***************************************************************
*  bl   @yx
*  data p0
*--------------------------------------------------------------
*  INPUT
*  P0 = New Cursor YX position
********|*****|*********************|**************************
at      mov   *r11+,@wyx   
        b     *r11            


***************************************************************
* down - Increase cursor Y position
***************************************************************
*  bl   @down
********|*****|*********************|**************************
down    ab    @hb$01,@wyx
        b     *r11            


***************************************************************
* up - Decrease cursor Y position
***************************************************************
*  bl   @up
********|*****|*********************|**************************
up      sb    @hb$01,@wyx
        b     *r11            


***************************************************************
* setx - Set cursor X position
***************************************************************
*  bl   @setx
*  data p0
*--------------------------------------------------------------
*  Register usage
*  TMP0
********|*****|*********************|**************************
setx    mov   *r11+,tmp0            ; Set cursor X position
xsetx   movb  @wyx,tmp0             ; Overwrite Y position
        mov   tmp0,@wyx             ; Save as new YX position
        b     *r11
