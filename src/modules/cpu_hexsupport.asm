* FILE......: cpu_hexsupport.asm
* Purpose...: CPU create, display hex numbers module

***************************************************************
* mkhex - Convert hex word to string
***************************************************************
*  bl   @mkhex
*       data P0,P1,P2
*--------------------------------------------------------------
*  P0 = Pointer to 16 bit word
*  P1 = Pointer to string buffer
*  P2 = Offset for ASCII digit
*       MSB determines offset for chars A-F
*       LSB determines offset for chars 0-9
*  (CONFIG#0 = 1) = Display number at cursor YX
*--------------------------------------------------------------
*  Memory usage:
*  tmp0, tmp1, tmp2, tmp3, tmp4
*  waux1, waux2, waux3
*--------------------------------------------------------------
*  Memory variables waux1-waux3 are used as temporary variables
********@*****@*********************@**************************
mkhex   mov   *r11+,tmp0            ; P0: Address of word
        mov   *r11+,@waux3          ; P1: Pointer to string buffer
        clr   @waux1
        clr   @waux2
        li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
        mov   *tmp0,tmp0            ; Get word
*--------------------------------------------------------------
*    Convert nibbles to bytes (is in wrong order)
*--------------------------------------------------------------
        li    tmp1,4                ; 4 nibbles
mkhex1  mov   tmp0,tmp2             ; Make work copy
        andi  tmp2,>000f            ; Only keep LSN
        ;------------------------------------------------------
        ; Determine offset for ASCII char
        ;------------------------------------------------------
        ci    tmp2,>000a            
        jlt   mkhex1.digit09
        ;------------------------------------------------------
        ; Add ASCII offset for digits A-F
        ;------------------------------------------------------        
mkhex1.digitaf:        
        mov   *r11,tmp4
        srl   tmp4,8                ; Right justify
        ai    tmp4,-10              ; Adjust offset for 'A-F'        
        jmp   mkhex2

mkhex1.digit09:
        ;------------------------------------------------------
        ; Add ASCII offset for digits 0-9
        ;------------------------------------------------------
        mov   *r11,tmp4
        andi  tmp4,>00ff            ; Only keep LSB        

mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
        swpb  tmp2
        movb  tmp2,*tmp3+           ; Save byte
        srl   tmp0,4                ; Next nibble
        dec   tmp1
        jne   mkhex1                ; Repeat until all nibbles processed
        andi  config,>bfff          ; Reset bit 1 in config register
*--------------------------------------------------------------
*    Build first 2 bytes in correct order
*--------------------------------------------------------------
        mov   @waux3,tmp1           ; Get pointer
        clr   *tmp1                 ; Set length byte to 0
        inc   tmp1                  ; Next byte, not word!
        mov   @waux2,tmp0
        swpb  tmp0
        movb  tmp0,*tmp1+
        swpb  tmp0
        movb  tmp0,*tmp1+
*--------------------------------------------------------------
*    Set length byte
*--------------------------------------------------------------
        mov   @waux3,tmp0           ; Get start of string buffer
        movb  @hb$04,*tmp0          ; Set lengh byte to 4
        inct  r11                   ; Skip Parameter P2
*--------------------------------------------------------------
*    Build last 2 bytes in correct order
*--------------------------------------------------------------
        mov   @waux1,tmp0
        swpb  tmp0
        movb  tmp0,*tmp1+
        swpb  tmp0
        movb  tmp0,*tmp1+
*--------------------------------------------------------------
*    Display hex number ?
*--------------------------------------------------------------
        coc   @wbit0,config         ; Check if 'display' bit is set
        jeq   mkhex3                ; Yes, so show at current YX position
        b     *r11                  ; Exit
*--------------------------------------------------------------
*  Display hex number on screen at current YX position
*--------------------------------------------------------------
mkhex3  andi  config,>7fff          ; Reset bit 0
        mov   @waux3,tmp1           ; Get Pointer to string
        b     @xutst0               ; Display string
prefix  data  >0610                 ; Length byte + blank



***************************************************************
* puthex - Put 16 bit word on screen
***************************************************************
*  bl   @mkhex
*       data P0,P1,P2,P3
*--------------------------------------------------------------
*  P0 = YX position
*  P1 = Pointer to 16 bit word
*  P2 = Pointer to string buffer
*  P3 = Offset for ASCII digit
*       MSB determines offset for chars A-F
*       LSB determines offset for chars 0-9
*--------------------------------------------------------------
*  Memory usage:
*  tmp0, tmp1, tmp2, tmp3
*  waux1, waux2, waux3
********@*****@*********************@**************************
puthex  mov   *r11+,@wyx            ; Set cursor
        ori   config,>8000          ; CONFIG register bit 0=1
        jmp   mkhex                 ; Convert number and display

