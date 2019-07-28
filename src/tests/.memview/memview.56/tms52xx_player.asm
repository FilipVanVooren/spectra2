***************************************************************
* FILE......: tms52xx_player.asm
* Purpose...: Speech Synthesizer player 

*//////////////////////////////////////////////////////////////
*                 Speech Synthesizer player
*//////////////////////////////////////////////////////////////

***************************************************************
* SPPREP - Prepare for playing speech
***************************************************************
*  BL   @SPPREP
*  DATA P0
*
*  P0 = Address of LPC data for external voice.
********@*****@*********************@**************************
spprep  mov   *r11+,@wspeak         ; Set speech address
        soc   @wbit3,config         ; Clear bit 3
        b     *r11

***************************************************************
* SPPLAY - Speech player
***************************************************************
* BL  @SPPLAY
*--------------------------------------------------------------
* Register usage
* TMP3   = Copy of R11
* R12    = CONFIG register
********@*****@*********************@**************************
spplay  czc   @wbit3,config         ; Player off ?
        jeq   spplaz                ; Yes, exit
sppla1  mov   r11,tmp3              ; Save R11
        coc   @tmp010,config        ; Speech player enabled+busy ?
        jeq   spkex3                ; Check FIFO buffer level
*--------------------------------------------------------------
* Speak external: Push LPC data to speech synthesizer
*--------------------------------------------------------------
spkext  mov   @wspeak,tmp0
        movb  *tmp0+,@spchwt        ; Send byte to speech synth
        jmp   $+2                   ; Delay
        li    tmp2,16
spkex1  movb  *tmp0+,@spchwt        ; Send byte to speech synth
        dec   tmp2
        jne   spkex1
        ori   config,>0800          ; bit 4=1 (busy)
        mov   tmp0,@wspeak          ; Update LPC pointer
        jmp   spplaz                ; Exit
*--------------------------------------------------------------
* Speak external: Check synth FIFO buffer level
*--------------------------------------------------------------
spkex3  li    tmp2,spkex4           ; Set return address for SPSTAT
        b     @spstat               ; Get speech FIFO buffer status
spkex4  coc   @w$4000,tmp0          ; FIFO BL (buffer low) bit set?
        jeq   spkex5                ; Yes, refill
        jmp   spplaz                ; No, exit
*--------------------------------------------------------------
* Speak external: Refill synth with LPC data if FIFO buffer low
*--------------------------------------------------------------
spkex5  mov   @wspeak,tmp0
        li    tmp2,8                ; Bytes to send to speech synth
spkex6  movb  *tmp0+,tmp1
        movb  tmp1,@spchwt          ; Send byte to speech synth
        ci    tmp1,spkoff           ; Speak off marker found ?
        jeq   spkex8
        dec   tmp2
        jne   spkex6                ; Send next byte
        mov   tmp0,@wspeak          ; Update LPC pointer
spkex7  jmp   spplaz                ; Exit
*--------------------------------------------------------------
* Speak external: Done with speaking
*--------------------------------------------------------------
spkex8  szc   @tmp010,config        ; bit 3,4,5=0
        clr   @wspeak               ; Reset pointer
spplaz  b     *tmp3                 ; Exit
tmp010  data  >1800                 ; Binary 0001100000000000
                                    ; Bit    0123456789ABCDEF
