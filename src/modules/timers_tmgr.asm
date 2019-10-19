* FILE......: timers_tmgr.asm
* Purpose...: Timers / Thread scheduler

***************************************************************
* TMGR - X - Start Timers/Thread scheduler
***************************************************************
*  B @TMGR
*--------------------------------------------------------------
*  REMARKS
*  Timer/Thread scheduler. Normally called from MAIN.
*  This is basically the kernel keeping everything togehter.
*  Do not forget to set BTIHI to highest slot in use.
*
*  Register usage in TMGR8 - TMGR11
*  TMP0  = Pointer to timer table
*  R10LB = Use as slot counter
*  TMP2  = 2nd word of slot data
*  TMP3  = Address of routine to call
********@*****@*********************@**************************
tmgr    limi  0                     ; No interrupt processing
*--------------------------------------------------------------
* Read VDP status register
*--------------------------------------------------------------
tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
*--------------------------------------------------------------
* Latch sprite collision flag
*--------------------------------------------------------------
        coc   @wbit2,r13            ; C flag on ?
        jne   tmgr1a                ; No, so move on
        soc   @wbit12,config        ; Latch bit 12 in config register
*--------------------------------------------------------------
* Interrupt flag
*--------------------------------------------------------------
tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
        jeq   tmgr4                 ; Yes, process slots 0..n
*--------------------------------------------------------------
* Run speech player
*--------------------------------------------------------------
    .ifndef skip_tms52xx_player
        coc   @wbit3,config         ; Speech player on ?
        jne   tmgr2
        bl    @sppla1               ; Run speech player
    .endif
*--------------------------------------------------------------
* Run kernel thread
*--------------------------------------------------------------
tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
        jeq   tmgr3                 ; Yes, skip to user hook
        coc   @wbit9,config         ; Kernel thread enabled ?
        jne   tmgr3                 ; No, skip to user hook
        b     @kthread              ; Run kernel thread
*--------------------------------------------------------------
* Run user hook
*--------------------------------------------------------------
tmgr3   coc   @wbit6,config         ; User hook blocked ?
        jeq   tmgr1
        coc   @wbit7,config         ; User hook enabled ?
        jne   tmgr1
        mov   @wtiusr,tmp0
        b     *tmp0                 ; Run user hook
*--------------------------------------------------------------
* Do internal housekeeping
*--------------------------------------------------------------
tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
        mov   r10,tmp0
        andi  tmp0,>00ff            ; Clear HI byte
        coc   @wbit2,config         ; PAL flag set ?
        jeq   tmgr5
        ci    tmp0,60               ; 1 second reached ?
        jmp   tmgr6
tmgr5   ci    tmp0,50
tmgr6   jlt   tmgr7                 ; No, continue
        jmp   tmgr8
tmgr7   inc   r10                   ; Increase tick counter
*--------------------------------------------------------------
* Loop over slots
*--------------------------------------------------------------
tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
        andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
        jeq   tmgr11                ; Yes, get next slot
*--------------------------------------------------------------
*  Check if slot should be executed
*--------------------------------------------------------------
        inct  tmp0                  ; Second word of slot data
        inc   *tmp0                 ; Update tick count in slot
        mov   *tmp0,tmp2            ; Get second word of slot data
        cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
        jne   tmgr10                ; No, get next slot
        andi  tmp2,>ff00            ; Clear internal counter
        mov   tmp2,*tmp0            ; Update timer table
*--------------------------------------------------------------
*  Run slot, we only need TMP0 to survive
*--------------------------------------------------------------
        mov   tmp0,@wtitmp          ; Save TMP0
        bl    *tmp3                 ; Call routine in slot
slotok  mov   @wtitmp,tmp0          ; Restore TMP0
*--------------------------------------------------------------
*  Prepare for next slot
*--------------------------------------------------------------
tmgr10  inc   r10                   ; Next slot
        cb    @r10lb,@btihi         ; Last slot done ?
        jgt   tmgr12                ; yes, Wait for next VDP interrupt
        inct  tmp0                  ; Offset for next slot
        jmp   tmgr9                 ; Process next slot
tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
        jmp   tmgr10                ; Process next slot
tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
        jmp   tmgr1
tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)

