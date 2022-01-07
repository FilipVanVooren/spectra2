* FILE......: speech_detect.asm
* Purpose...: Check if speech synthesizer is connected


***************************************************************
* SPSTAT - Read status register byte from speech synthesizer
***************************************************************
*  LI  TMP2,@>....
*  B   @SPSTAT
*--------------------------------------------------------------
* REMARKS
* Destroys R11 !
*
* Register usage
* TMP0HB = Status byte read from speech synth
* TMP1   = Temporary use  (scratchpad machine code)
* TMP2   = Return address for this subroutine
* R11    = Return address (scratchpad machine code)
********|*****|*********************|**************************
spstat  li    tmp0,spchrd           ; (R4) = >9000
        mov   @spcode,@mcsprd       ; \
        mov   @spcode+2,@mcsprd+2   ; / Load speech read code
        li    r11,spsta1            ; Return to SPSTA1
        b     @mcsprd               ; Run scratchpad code
spsta1  mov   @mccode,@mcsprd       ; \
        mov   @mccode+2,@mcsprd+2   ; / Restore tight loop code
        b     *tmp2                 ; Exit


***************************************************************
* SPCONN - Check if speech synthesizer connected
***************************************************************
* BL  @SPCONN
*--------------------------------------------------------------
* OUTPUT
* TMP0HB = Byte read from speech synth
*--------------------------------------------------------------
* REMARKS
* See Editor/Assembler manual, section 22.1.6 page 354.
* Calls SPSTAT.
*
* Register usage
* TMP0HB = Byte read from speech synth
* TMP3   = Copy of R11
* R12    = CONFIG register
********|*****|*********************|**************************
spconn  mov   r11,tmp3              ; Save R11
*--------------------------------------------------------------
* Setup speech synthesizer memory address >0000
*--------------------------------------------------------------
        li    tmp0,>4000            ; Load >40 (speech memory address command)
        li    tmp1,5                ; Process 5 nibbles in total
spcon1  movb  tmp0,@spchwt          ; Write nibble >40 (5x)
        dec   tmp1
        jne   spcon1
*--------------------------------------------------------------
* Read first byte from speech synthesizer memory address >0000
*--------------------------------------------------------------
        li    tmp0,>1000
        movb  tmp0,@spchwt          ; Load >10 (speech memory read command)
        nop                         ; \
        nop                         ; / 12 Microseconds delay
        li    tmp2,spcon2
        b     @spstat               ; Read status byte
*--------------------------------------------------------------
* Update status bit 5 in CONFIG register
*--------------------------------------------------------------
spcon2  srl   tmp0,8                ; MSB to LSB
        ci    tmp0,>00aa            ; >aa means speech found
        jne   spcon3
        soc   @wbit5,config         ; Set config bit5=1
        jmp   spcon4
spcon3  szc   @wbit5,config         ; Set config bit5=0
spcon4  b     *tmp3                 ; Exit
