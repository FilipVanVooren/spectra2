* FILE......: cpu_numsupport.asm
* Purpose...: CPU create, display numbers module

***************************************************************
* MKNUM - Convert unsigned number to string
***************************************************************
*  BL   @MKNUM
*  DATA P0,P1,P2
*
*  P0   = Pointer to 16 bit unsigned number
*  P1   = Pointer to 5 byte string buffer
*  P2HB = Offset for ASCII digit
*  P2LB = Character for replacing leading 0's
*
*  (CONFIG:0 = 1) = Display number at cursor YX
*-------------------------------------------------------------
*  Destroys registers tmp0-tmp4
********|*****|*********************|**************************
mknum   li    tmp3,5                ; Digit counter
        mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
        mov   *tmp1,tmp1            ; /
        mov   *r11+,tmp4            ; Pointer to string buffer
        ai    tmp4,4                ; Get end of buffer
        li    tmp2,10               ; Divide by 10 to isolate last digit
*--------------------------------------------------------------
*  Do string conversion
*--------------------------------------------------------------
mknum1  clr   tmp0                  ; Clear the high word of the dividend
        div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
        swpb  tmp1                  ; Move to high-byte for writing to buffer
        ab    *r11,tmp1             ; Add offset for ASCII digit
        movb  tmp1,*tmp4            ; Write remainder to string buffer
        mov   tmp0,tmp1             ; Move integer result into R4 for next digit
        dec   tmp4                  ; Adjust string pointer for next digit
        dec   tmp3                  ; Decrease counter
        jne   mknum1                ; Do next digit
*--------------------------------------------------------------
*  Replace leading 0's with fill character
*--------------------------------------------------------------
        li    tmp3,4                ; Check first 4 digits
        inc   tmp4                  ; Too far, back to buffer start
        mov   *r11,tmp0
        sla   tmp0,8                ; Only keep fill character in HB
mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
        jeq   mknum4                ; Yes, replace with fill character
mknum3  inct  r11
        coc   @wbit0,config         ; Check if 'display' bit is set
        jeq   mknum5                ; Yes, so show at current YX position
        b     *r11                  ; Exit
mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
        dec   tmp3                  ; 4th digit processed ?
        jeq   mknum3                ; Yes, exit
        jmp   mknum2                ; No, next one
*--------------------------------------------------------------
*  Display integer on screen at current YX position
*--------------------------------------------------------------
mknum5  andi  config,>7fff          ; Reset bit 0
        mov   r11,tmp0
        ai    tmp0,-4
        mov   *tmp0,tmp1            ; Get buffer address
        li    tmp2,>0500            ; String length = 5
        b     @xutstr               ; Display string




***************************************************************
* trimnum - Trim unsigned number string
***************************************************************
*  bl   @trimnum
*  data p0,p1,p2
*--------------------------------------------------------------
*  p0   = Pointer to 5 byte string buffer (no length byte!)
*  p1   = Pointer to output variable
*  p2   = Padding character to match against
*--------------------------------------------------------------
*  Copy unsigned number string into a length-padded, left
*  justified string for display with putstr, putat, ...
*
*  The new string starts at index 5 in buffer, overwriting
*  anything that is located there !
*
*               01234|56789A
*  Before...:   XXXXX          length
*  After....:   XXXXY|zY       z=1
*               XXXYY|zYY      z=2
*               XXYYY|zYYY     z=3
*               XYYYY|zYYYY    z=4
*               YYYYY|zYYYYY   z=5
*--------------------------------------------------------------
*  Destroys registers tmp0-tmp3
********|*****|*********************|**************************
trimnum:
        mov   *r11+,tmp0            ; Get pointer to input string
        mov   *r11+,tmp1            ; Get pointer to output string
        mov   *r11+,tmp2            ; Get padding character
        swpb  tmp2                  ; LO <-> HI
        li    tmp3,5                ; Set counter
        ;------------------------------------------------------
        ; Scan for padding character from left to right
        ;------------------------------------------------------:
trimnum_scan:
        cb    *tmp0,tmp2            ; Matches padding character ?
        jne   trimnum_setlen        ; No, exit loop
        inc   tmp0                  ; Next character
        dec   tmp3                  ; Last digit reached ?
        jeq   trimnum_setlen        ; yes, exit loop
        jmp   trimnum_scan
        ;------------------------------------------------------
        ; Scan completed, set length byte new string
        ;------------------------------------------------------
trimnum_setlen:
        swpb  tmp3                  ; LO <-> HI
        movb  tmp3,*tmp1+           ; Update string-length in work buffer
        swpb  tmp3                  ; LO <-> HI
        ;------------------------------------------------------
        ; Start filling new string
        ;------------------------------------------------------
trimnum_fill:
        movb  *tmp0+,*tmp1+         ; Copy character
        dec   tmp3                  ; Last character ?
        jne   trimnum_fill          ; Not yet, repeat
        b     *r11                  ; Return




***************************************************************
* PUTNUM - Put unsigned number on screen
***************************************************************
*  BL   @PUTNUM
*  DATA P0,P1,P2,P3
*--------------------------------------------------------------
*  P0   = YX position
*  P1   = Pointer to 16 bit unsigned number
*  P2   = Pointer to 5 byte string buffer
*  P3HB = Offset for ASCII digit
*  P3LB = Character for replacing leading 0's
********|*****|*********************|**************************
putnum  mov   *r11+,@wyx            ; Set cursor
        ori   config,>8000          ; CONFIG register bit 0=1
        jmp   mknum                 ; Convert number and display
