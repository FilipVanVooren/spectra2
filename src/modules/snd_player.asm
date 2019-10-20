* FILE......: snd_player.asm
* Purpose...: Sound player support code


***************************************************************
* MUTE - Mute all sound generators
***************************************************************
*  BL  @MUTE
*  Mute sound generators and clear sound pointer
*
*  BL  @MUTE2
*  Mute sound generators without clearing sound pointer
********@*****@*********************@**************************
mute    clr   @wsdlst               ; Clear sound pointer
mute2   szc   @wbit13,config        ; Turn off/pause sound player
        li    tmp0,muttab
        li    tmp1,sound            ; Sound generator port >8400
        movb  *tmp0+,*tmp1          ; Generator 0
        movb  *tmp0+,*tmp1          ; Generator 1
        movb  *tmp0+,*tmp1          ; Generator 2
        movb  *tmp0,*tmp1           ; Generator 3
        b     *r11
muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators


***************************************************************
* SDPREP - Prepare for playing sound
***************************************************************
*  BL   @SDPREP
*  DATA P0,P1
*
*  P0 = Address where tune is stored
*  P1 = Option flags for sound player
*--------------------------------------------------------------
*  REMARKS
*  Use the below equates for P1:
*
*  SDOPT1 => Tune is in CPU memory + loop
*  SDOPT2 => Tune is in CPU memory
*  SDOPT3 => Tune is in VRAM + loop
*  SDOPT4 => Tune is in VRAM
********@*****@*********************@**************************
sdprep  mov   *r11,@wsdlst          ; Set tune address
        mov   *r11+,@wsdtmp         ; Set tune address in temp
        andi  config,>fff8          ; Clear bits 13-14-15
        soc   *r11+,config          ; Set options
        movb  @hb$01,@r13lb         ; Set initial duration
        b     *r11

***************************************************************
* SDPLAY - Sound player for tune in VRAM or CPU memory
***************************************************************
*  BL  @SDPLAY
*--------------------------------------------------------------
*  REMARKS
*  Set config register bit13=0 to pause player.
*  Set config register bit14=1 to repeat (or play next tune).
********@*****@*********************@**************************
sdplay  coc   @wbit13,config        ; Play tune ?
        jeq   sdpla1                ; Yes, play
        b     *r11
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
sdpla1  dec   r13                   ; duration = duration - 1
        cb    @r13lb,@hb$00         ; R13LB == 0 ?
        jeq   sdpla3                ; Play next note
sdpla2  b     *r11                  ; Note still busy, exit
sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
        jeq   mmplay
*--------------------------------------------------------------
* Play tune from VDP memory
*--------------------------------------------------------------
vdplay  mov   @wsdtmp,tmp0          ; Get tune address
        swpb  tmp0
        movb  tmp0,@vdpa
        swpb  tmp0
        movb  tmp0,@vdpa
        clr   tmp0
        movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
        jeq   sdexit                ; Yes. exit
vdpla1  srl   tmp0,8                ; Right justify length byte
        a     tmp0,@wsdtmp          ; Adjust for next table entry
vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
        dec   tmp0
        jne   vdpla2
        movb  @vdpr,@r13lb          ; Set duration counter
vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
        b     *r11
*--------------------------------------------------------------
* Play tune from CPU memory
*--------------------------------------------------------------
mmplay  mov   @wsdtmp,tmp0
        movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
        jeq   sdexit                ; Yes, exit
mmpla1  srl   tmp1,8                ; Right justify length byte
        a     tmp1,@wsdtmp          ; Adjust for next table entry
mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
        dec   tmp1
        jne   mmpla2
        movb  *tmp0,@r13lb          ; Set duration counter
        inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
        b     *r11
*--------------------------------------------------------------
* Exit. Check if tune must be looped
*--------------------------------------------------------------
sdexit  coc   @wbit14,config        ; Loop flag set ?
        jne   sdexi2                ; No, exit
        mov   @wsdlst,@wsdtmp
        movb  @hb$01,@r13lb          ; Set initial duration
sdexi1  b     *r11                  ; Exit
sdexi2  andi  config,>fff8          ; Reset music player
        b     *r11                  ; Exit

