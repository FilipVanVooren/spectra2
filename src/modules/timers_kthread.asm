* FILE......: timers_kthread.asm
* Purpose...: Timers / The kernel thread


***************************************************************
* KTHREAD - The kernel thread
*--------------------------------------------------------------
*  REMARKS
*  You should not call the kernel thread manually.
*  Instead control it via the CONFIG register.
*
*  The kernel thread is responsible for running the sound
*  player and doing keyboard scan.
********@*****@*********************@**************************
kthread soc   @wbit8,config         ; Block kernel thread
*--------------------------------------------------------------
* Run sound player
*--------------------------------------------------------------
    .ifdef skip_sound_player  
*       <<skipped>>
    .else
        coc   @wbit13,config        ; Sound player on ?
        jne   kthread_kb
        bl    @sdpla1               ; Run sound player
    .endif
*--------------------------------------------------------------
* Scan virtual keyboard
*--------------------------------------------------------------
kthread_kb
    .ifdef skip_virtual_keyboard
*       <<skipped>>
    .else
        bl    @virtkb               ; Scan virtual keyboard
    .endif
*--------------------------------------------------------------
* Scan real keyboard
*--------------------------------------------------------------
    .ifdef skip_real_keyboard
*       <<skipped>>
    .else
        bl    @realkb               ; Scan full keyboard
    .endif
*--------------------------------------------------------------
kthread_exit
        b     @tmgr3                ; Exit
