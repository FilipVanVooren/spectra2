* FILE......: basic_cpu_vdp.asm
* Purpose...: Basic CPU & VDP functions used by other modules

*//////////////////////////////////////////////////////////////
*       Support Machine Code for copy & fill functions
*//////////////////////////////////////////////////////////////

*--------------------------------------------------------------
* ; Machine code for tight loop.
* ; The MOV operation at MCLOOP must be injected by the calling routine.
*--------------------------------------------------------------
*       DATA  >????                 ; \ mcloop  mov   ...
mccode  data  >0606                 ; |         dec   r6 (tmp2)
        data  >16fd                 ; |         jne   mcloop
        data  >045b                 ; /         b     *r11
*--------------------------------------------------------------
* ; Machine code for reading from the speech synthesizer
* ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
* ; Is required for the 12 uS delay. It destroys R5.
*--------------------------------------------------------------
spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
        data  >0bc5                 ; /         src   r5,12  (tmp1)
        even 


***************************************************************
* loadmc - Load machine code into scratchpad  >8322 - >8328
***************************************************************
*  bl  @loadmc
*--------------------------------------------------------------
*  REMARKS
*  Machine instruction in location @>8320 will be set by 
*  SP2 copy/fill routine that is called later on.
********|*****|*********************|**************************
loadmc:  
        li    r1,mccode             ; Machinecode to patch
        li    r2,mcloop+2           ; Scratch-pad reserved for machine code
        mov   *r1+,*r2+             ; Copy 1st instruction 
        mov   *r1+,*r2+             ; Copy 2nd instruction
        mov   *r1+,*r2+             ; Copy 3rd instruction
        b     *r11                  ; Return to caller


*//////////////////////////////////////////////////////////////
*                    STACK SUPPORT FUNCTIONS
*//////////////////////////////////////////////////////////////

***************************************************************
* POPR. - Pop registers & return to caller
***************************************************************
*  B  @POPRG.
*--------------------------------------------------------------
*  REMARKS
*  R11 must be at stack bottom
********|*****|*********************|**************************
popr3   mov   *stack+,r3
popr2   mov   *stack+,r2
popr1   mov   *stack+,r1
popr0   mov   *stack+,r0
poprt   mov   *stack+,r11
        b     *r11



*//////////////////////////////////////////////////////////////
*                   MEMORY FILL FUNCTIONS
*//////////////////////////////////////////////////////////////

***************************************************************
* FILM - Fill CPU memory with byte
***************************************************************
*  bl   @film
*  data P0,P1,P2
*--------------------------------------------------------------
*  P0 = Memory start address
*  P1 = Byte to fill
*  P2 = Number of bytes to fill
*--------------------------------------------------------------
*  bl   @xfilm
*
*  TMP0 = Memory start address
*  TMP1 = Byte to fill
*  TMP2 = Number of bytes to fill
********|*****|*********************|**************************
film    mov   *r11+,tmp0            ; Memory start
        mov   *r11+,tmp1            ; Byte to fill
        mov   *r11+,tmp2            ; Repeat count
*--------------------------------------------------------------
* Do some checks first
*--------------------------------------------------------------
xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
        jne   filchk                ; No, continue checking

        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system
*--------------------------------------------------------------
*       Check: 1 byte fill
*--------------------------------------------------------------
filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value

        ci    tmp2,1                ; Bytes to fill = 1 ?
        jne   filchk2
        movb  tmp1,*tmp0+
        b     *r11                  ; Exit
*--------------------------------------------------------------
*       Check: 2 byte fill
*--------------------------------------------------------------
filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
        jne   filchk3
        movb  tmp1,*tmp0+           ; Deal with possible uneven start address
        movb  tmp1,*tmp0+        
        b     *r11                  ; Exit
*--------------------------------------------------------------
*       Check: Handle uneven start address
*--------------------------------------------------------------
filchk3 mov   tmp0,tmp3
        andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
        jne   fil16b
        movb  tmp1,*tmp0+           ; Copy 1st byte
        dec   tmp2
        ci    tmp2,2                ; Do we only have 1 word left?
        jeq   filchk2               ; Yes, copy word and exit
*--------------------------------------------------------------
*       Fill memory with 16 bit words
*--------------------------------------------------------------
fil16b  mov   tmp2,tmp3
        andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
        jeq   dofill
        dec   tmp2                  ; Make TMP2 even
dofill  mov   tmp1,*tmp0+
        dect  tmp2
        jne   dofill
*--------------------------------------------------------------
* Fill last byte if ODD
*--------------------------------------------------------------
        mov   tmp3,tmp3
        jeq   fil.exit
        movb  tmp1,*tmp0+
fil.exit:
        b     *r11


***************************************************************
* FILV - Fill VRAM with byte
***************************************************************
*  BL   @FILV
*  DATA P0,P1,P2
*--------------------------------------------------------------
*  P0 = VDP start address
*  P1 = Byte to fill
*  P2 = Number of bytes to fill
*--------------------------------------------------------------
*  BL   @XFILV
*
*  TMP0 = VDP start address
*  TMP1 = Byte to fill
*  TMP2 = Number of bytes to fill
********|*****|*********************|**************************
filv    mov   *r11+,tmp0            ; Memory start
        mov   *r11+,tmp1            ; Byte to fill
        mov   *r11+,tmp2            ; Repeat count
*--------------------------------------------------------------
*    Setup VDP write address
*--------------------------------------------------------------
xfilv   ori   tmp0,>4000
        swpb  tmp0
        movb  tmp0,@vdpa
        swpb  tmp0
        movb  tmp0,@vdpa
*--------------------------------------------------------------
*    Fill bytes in VDP memory
*--------------------------------------------------------------
        li    r15,vdpw              ; Set VDP write address
        swpb  tmp1
        mov   @filzz,@mcloop        ; Setup move command
        b     @mcloop               ; Write data to VDP
*--------------------------------------------------------------
    .ifdef use_osrom_constants
filzz   equ   >1624                 ; data >d7c5 (MOVB TMP1,*R15)
    .else
filzz   data  >d7c5                 ; MOVB TMP1,*R15
    .endif 



*//////////////////////////////////////////////////////////////
*                  VDP LOW LEVEL FUNCTIONS
*//////////////////////////////////////////////////////////////

***************************************************************
* VDWA / VDRA - Setup VDP write or read address
***************************************************************
*  BL   @VDWA
*
*  TMP0 = VDP destination address for write
*--------------------------------------------------------------
*  BL   @VDRA
*
*  TMP0 = VDP source address for read
********|*****|*********************|**************************
vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
vdra    swpb  tmp0
        movb  tmp0,@vdpa
        swpb  tmp0
        movb  tmp0,@vdpa            ; Set VDP address
        b     *r11                  ; Exit

***************************************************************
* VPUTB - VDP put single byte
***************************************************************
*  BL @VPUTB
*  DATA P0,P1
*--------------------------------------------------------------
*  P0 = VDP target address
*  P1 = Byte to write
********|*****|*********************|**************************
vputb   mov   *r11+,tmp0            ; Get VDP target address
        mov   *r11+,tmp1            ; Get byte to write
*--------------------------------------------------------------
* Set VDP write address 
*--------------------------------------------------------------
xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
        swpb  tmp0                  ; \
        movb  tmp0,@vdpa            ; | Set VDP write address
        swpb  tmp0                  ; | inlined @vdwa call
        movb  tmp0,@vdpa            ; / 
*--------------------------------------------------------------
* Write byte
*--------------------------------------------------------------
        swpb  tmp1                  ; LSB to MSB
        movb  tmp1,*r15             ; Write byte
        b     *r11                  ; Exit


***************************************************************
* VGETB - VDP get single byte
***************************************************************
*  bl   @vgetb
*  data p0
*--------------------------------------------------------------
*  P0 = VDP source address
*--------------------------------------------------------------
*  bl   @xvgetb
*
*  tmp0 = VDP source address
*--------------------------------------------------------------
*  Output:
*  tmp0 MSB = >00
*  tmp0 LSB = VDP byte read
********|*****|*********************|**************************
vgetb   mov   *r11+,tmp0            ; Get VDP source address  
*--------------------------------------------------------------
* Set VDP read address 
*--------------------------------------------------------------
xvgetb  swpb  tmp0                  ; \
        movb  tmp0,@vdpa            ; | Set VDP read address
        swpb  tmp0                  ; | inlined @vdra call
        movb  tmp0,@vdpa            ; / 
*--------------------------------------------------------------
* Read byte
*--------------------------------------------------------------
        movb  @vdpr,tmp0            ; Read byte
        srl   tmp0,8                ; Right align
        b     *r11                  ; Exit


***************************************************************
* VIDTAB - Dump videomode table
***************************************************************
*  BL   @VIDTAB
*  DATA P0
*--------------------------------------------------------------
*  P0 = Address of video mode table
*--------------------------------------------------------------
*  BL   @XIDTAB
*
*  TMP0 = Address of video mode table
*--------------------------------------------------------------
*  Remarks
*  TMP1 = MSB is the VDP target register
*         LSB is the value to write
********|*****|*********************|**************************
vidtab  mov   *r11+,tmp0            ; Get video mode table
xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
*--------------------------------------------------------------
* Calculate PNT base address
*--------------------------------------------------------------
        mov   tmp0,tmp1
        inct  tmp1
        movb  *tmp1,tmp1            ; Get value for VDP#2
        andi  tmp1,>ff00            ; Only keep MSB
        sla   tmp1,2                ; TMP1 *= 400
        mov   tmp1,@wbase           ; Store calculated base
*--------------------------------------------------------------
* Dump VDP shadow registers
*--------------------------------------------------------------
        li    tmp1,>8000            ; Start with VDP register 0
        li    tmp2,8
vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
        swpb  tmp1
        movb  tmp1,@vdpa
        swpb  tmp1
        movb  tmp1,@vdpa
        ai    tmp1,>0100
        dec   tmp2
        jne   vidta1                ; Next register
        mov   *tmp0,@wcolmn         ; Store # of columns per row
        b     *r11


***************************************************************
* PUTVR  - Put single VDP register
***************************************************************
*  BL   @PUTVR
*  DATA P0
*--------------------------------------------------------------
*  P0 = MSB is the VDP target register
*       LSB is the value to write
*--------------------------------------------------------------
*  BL   @PUTVRX
*
*  TMP0 = MSB is the VDP target register
*         LSB is the value to write
********|*****|*********************|**************************
putvr   mov   *r11+,tmp0
putvrx  ori   tmp0,>8000
        swpb  tmp0
        movb  tmp0,@vdpa
        swpb  tmp0
        movb  tmp0,@vdpa
        b     *r11


***************************************************************
* PUTV01  - Put VDP registers #0 and #1
***************************************************************
*  BL   @PUTV01
********|*****|*********************|**************************
putv01  mov   r11,tmp4              ; Save R11
        mov   r14,tmp0
        srl   tmp0,8
        bl    @putvrx               ; Write VR#0
        li    tmp0,>0100
        movb  @r14lb,@tmp0lb
        bl    @putvrx               ; Write VR#1
        b     *tmp4                 ; Exit


***************************************************************
* LDFNT - Load TI-99/4A font from GROM into VDP
***************************************************************
*  BL   @LDFNT
*  DATA P0,P1
*--------------------------------------------------------------
*  P0 = VDP Target address
*  P1 = Font options
*--------------------------------------------------------------
* Uses registers tmp0-tmp4
********|*****|*********************|**************************
ldfnt   mov   r11,tmp4              ; Save R11
        inct  r11                   ; Get 2nd parameter (font options)
        mov   *r11,tmp0             ; Get P0
        andi  config,>7fff          ; CONFIG register bit 0=0
        coc   @wbit0,tmp0
        jne   ldfnt1
        ori   config,>8000          ; CONFIG register bit 0=1
        andi  tmp0,>7fff            ; Parameter value bit 0=0
*--------------------------------------------------------------
* Read font table address from GROM into tmp1
*--------------------------------------------------------------
ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
        movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
        swpb  tmp0
        movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
        movb  @grmrd,tmp1           ; Read font table address byte 1
        swpb  tmp1 
        movb  @grmrd,tmp1           ; Read font table address byte 2
        swpb  tmp1 
*--------------------------------------------------------------
* Setup GROM source address from tmp1
*--------------------------------------------------------------
        movb  tmp1,@grmwa
        swpb  tmp1
        movb  tmp1,@grmwa           ; Setup GROM address for reading
*--------------------------------------------------------------
* Setup VDP target address
*--------------------------------------------------------------
        mov   *tmp4,tmp0            ; Get P1 (VDP destination)
        bl    @vdwa                 ; Setup VDP destination address
        inct  tmp4                  ; R11=R11+2
        mov   *tmp4,tmp1            ; Get font options into TMP1
        andi  tmp1,>7fff            ; Parameter value bit 0=0
        mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
        mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
*--------------------------------------------------------------
* Copy from GROM to VRAM
*--------------------------------------------------------------
ldfnt2  src   tmp1,1                ; Carry set ?
        joc   ldfnt4                ; Yes, go insert a >00
        movb  @grmrd,tmp0
*--------------------------------------------------------------
*   Make font fat
*--------------------------------------------------------------
        coc   @wbit0,config         ; Fat flag set ?
        jne   ldfnt3                ; No, so skip
        movb  tmp0,tmp3
        srl   tmp3,1
        soc   tmp3,tmp0
*--------------------------------------------------------------
*   Dump byte to VDP and do housekeeping
*--------------------------------------------------------------
ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
        dec   tmp2
        jne   ldfnt2
        inct  tmp4                  ; R11=R11+2
        li    r15,vdpw              ; Set VDP write address
        andi  config,>7fff          ; CONFIG register bit 0=0
        b     *tmp4                 ; Exit
ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
        jmp   ldfnt2
*--------------------------------------------------------------
* Fonts pointer table
*--------------------------------------------------------------
tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
        data  >004e,64*7,>0101      ; Pointer to upper case font
        data  >004e,96*7,>0101      ; Pointer to upper & lower case font
        data  >0050,32*7,>0101      ; Pointer to lower case font



***************************************************************
* YX2PNT - Get VDP PNT address for current YX cursor position
***************************************************************
*  BL   @YX2PNT
*--------------------------------------------------------------
*  INPUT
*  @WYX = Cursor YX position
*--------------------------------------------------------------
*  OUTPUT
*  TMP0 = VDP address for entry in Pattern Name Table
*--------------------------------------------------------------
*  Register usage
*  TMP0, R14, R15
********|*****|*********************|**************************
yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
        mov   @wyx,r14              ; Get YX
        srl   r14,8                 ; Right justify (remove X)
        mpy   @wcolmn,r14           ; pos = Y * (columns per row)
*--------------------------------------------------------------
* Do rest of calculation with R15 (16 bit part is there)
* Re-use R14
*--------------------------------------------------------------
        mov   @wyx,r14              ; Get YX
        andi  r14,>00ff             ; Remove Y
        a     r14,r15               ; pos = pos + X
        a     @wbase,r15            ; pos = pos + (PNT base address)
*--------------------------------------------------------------
* Clean up before exit
*--------------------------------------------------------------
        mov   tmp0,r14              ; Restore VDP#0 & VDP#1
        mov   r15,tmp0              ; Return pos in TMP0
        li    r15,vdpw              ; VDP write address
        b     *r11



***************************************************************
* Put length-byte prefixed string at current YX
***************************************************************
*  BL   @PUTSTR
*  DATA P0
*
*  P0 = Pointer to string
*--------------------------------------------------------------
*  REMARKS
*  First byte of string must contain length
********|*****|*********************|**************************
putstr  mov   *r11+,tmp1
xutst0  movb  *tmp1+,tmp2           ; Get length byte
xutstr  mov   r11,tmp3
        bl    @yx2pnt               ; Get VDP destination address
        mov   tmp3,r11
        srl   tmp2,8                ; Right justify length byte
*--------------------------------------------------------------
* Put string
*--------------------------------------------------------------
        mov   tmp2,tmp2             ; Length = 0 ?
        jeq   !                     ; Yes, crash and burn

        ci    tmp2,255              ; Length > 255 ?
        jgt   !                     ; Yes, crash and burn

        b     @xpym2v               ; Display string
*--------------------------------------------------------------
* Crash handler
*--------------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system



***************************************************************
* Put length-byte prefixed string at YX
***************************************************************
*  BL   @PUTAT
*  DATA P0,P1
*
*  P0 = YX position
*  P1 = Pointer to string
*--------------------------------------------------------------
*  REMARKS
*  First byte of string must contain length
********|*****|*********************|**************************
putat   mov   *r11+,@wyx            ; Set YX position
        b     @putstr
