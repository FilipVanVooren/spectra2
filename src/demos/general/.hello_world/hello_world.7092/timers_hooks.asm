* FILE......: timers_kthread.asm
* Purpose...: Timers / User hooks


***************************************************************
* MKHOOK - Allocate user hook
***************************************************************
*  BL    @MKHOOK
*  DATA  P0
*--------------------------------------------------------------
*  P0 = Address of user hook
*--------------------------------------------------------------
*  REMARKS
*  The user hook gets executed after the kernel thread.
*  The user hook must always exit with "B @HOOKOK"
********|*****|*********************|**************************
mkhook  mov   *r11+,@wtiusr         ; Set user hook address
        soc   @wbit7,config         ; Enable user hook
mkhoo1  b     *r11                  ; Return
hookok  equ   tmgr1                 ; Exit point for user hook


***************************************************************
* CLHOOK - Clear user hook
***************************************************************
*  BL    @CLHOOK
********|*****|*********************|**************************
clhook  clr   @wtiusr               ; Unset user hook address
        andi  config,>feff          ; Disable user hook (bit 7=0)
        b     *r11                  ; Return
