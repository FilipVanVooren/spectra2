* FILE......: cpu_rle_compress.asm
* Purpose...: RLE compression support

***************************************************************
* cpu2rle - RLE compress CPU memory
***************************************************************
*  bl   @cpu2rle
*       data P0,P1,P2
*--------------------------------------------------------------
*  P0 = ROM/RAM source address
*  P1 = RAM target address
*  P2 = Length uncompressed data
*
*  Output:
*  waux1 = Length of RLE encoded string
*--------------------------------------------------------------
*  bl   @xcpu2rle
*
*  TMP0  = ROM/RAM source address
*  TMP1  = RAM target address
*  TMP2  = Length uncompressed data
*
*  Output:
*  waux1 = Length of RLE encoded string
*--------------------------------------------------------------
*  Memory usage:
*  tmp0, tmp1, tmp2, tmp3, tmp4
*  waux1, waux2, waux3
*--------------------------------------------------------------
*  Detail on RLE compression format:
*  - If high bit is set, remaining 7 bits indicate to copy
*    the next byte that many times.
*  - If high bit is clear, remaining 7 bits indicate how many
*    data bytes (non-repeated) follow.
*
*  Part of string is considered for RLE compression as soon as
*  the same char is repeated 3 times.
* 
*  Implementation workflow:
*  (1) Scan string from left to right:
*      (1.1) Compare lookahead char with current char.
*            - Jump to (1.2) if it's not a repeated character.
*            - If repeated char count = 0 then check 2nd lookahead
*              char. If it's a repeated char again then jump to (1.3)
*              else handle as non-repeated char (1.2)
*            - If repeated char count > 0 then handle as repeated char (1.3)
*
*      (1.2) It's not a repeated character:
*            (1.2.1) Check if any pending repeated character
*            (1.2.2) If yes, flush pending to output buffer (=RLE encode)
*            (1.2.3) Track address of future encoding byte
*            (1.2.4) Append data byte to output buffer and jump to (2)
*
*      (1.3) It's a repeated character:
*            (1.3.1) Check if any pending non-repeated character
*            (1.3.2) If yes, set encoding byte before first data byte
*            (1.3.3) Increase repetition counter and jump to (2)
* 
*  (2) Process next character 
*      (2.1) Jump back to (1.1) unless end of string reached
*             
*  (3) End of string reached:
*      (3.1) Check if pending repeated character
*      (3.2) If yes, flush pending to output buffer (=RLE encode)
*      (3.3) Check if pending non-repeated character
*      (3.4) If yes, set encoding byte before first data byte
*
*  (4) Exit
*--------------------------------------------------------------


********|*****|*********************|**************************
cpu2rle:
        mov   *r11+,tmp0            ; ROM/RAM source address
        mov   *r11+,tmp1            ; RAM target address
        mov   *r11+,tmp2            ; Length of data to encode
xcpu2rle:
        dect  stack        
        mov   r11,*stack            ; Save return address        
*--------------------------------------------------------------
*   Initialisation
*--------------------------------------------------------------
cup2rle.init:
        clr   tmp3                  ; Character buffer (2 chars)
        clr   tmp4                  ; Repeat counter
        clr   @waux1                ; Length of RLE string        
        clr   @waux2                ; Address of encoding byte
*--------------------------------------------------------------
*   (1.1) Scan string 
*--------------------------------------------------------------
cpu2rle.scan:
        srl   tmp3,8                ; Save old character in LSB
        movb  *tmp0+,tmp3           ; Move current character to MSB
        cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
        jne   cpu2rle.scan.nodup    ; No duplicate, move along
        ;------------------------------------------------------
        ; Only check 2nd lookahead if new string fragment
        ;------------------------------------------------------             
        mov   tmp4,tmp4             ; Repeat counter > 0 ?
        jgt   cpu2rle.scan.dup      ; Duplicate found
        ;------------------------------------------------------
        ; Special handling for new string fragment
        ;------------------------------------------------------        
        cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
        jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is 
                                    ; not worth it, so move along

        jeq   cpu2rle.scan.dup      ; Duplicate found
*--------------------------------------------------------------
*   (1.2) No duplicate
*--------------------------------------------------------------
cpu2rle.scan.nodup:
        ;------------------------------------------------------
        ; (1.2.1) First flush any pending duplicates
        ;------------------------------------------------------
        mov   tmp4,tmp4             ; Repeat counter = 0 ?
        jeq   cpu2rle.scan.nodup.rest

        bl    @cpu2rle.flush.duplicates
                                    ; Flush pending duplicates
        ;------------------------------------------------------
        ; (1.2.3) Track address of encoding byte
        ;------------------------------------------------------
cpu2rle.scan.nodup.rest:
        mov   @waux2,@waux2         ; \ Address encoding byte already fetched? 
        jne   !                     ; / Yes, so don't fetch again!

        mov   tmp1,@waux2           ; Fetch address of future encoding byte
        inc   tmp1                  ; Skip encoding byte
        inc   @waux1                ; RLE string length += 1 for encoding byte
        ;------------------------------------------------------
        ; (1.2.4) Write data byte to output buffer
        ;------------------------------------------------------
!       movb  tmp3,*tmp1+           ; Copy data byte character
        inc   @waux1                ; RLE string length += 1
        jmp   cpu2rle.scan.next     ; Next character
*--------------------------------------------------------------
*   (1.3) Duplicate
*--------------------------------------------------------------
cpu2rle.scan.dup:
        ;------------------------------------------------------
        ; (1.3.1) First flush any pending non-duplicates
        ;------------------------------------------------------
        mov   @waux2,@waux2         ; Pending encoding byte address present?
        jeq   cpu2rle.scan.dup.rest

        bl    @cpu2rle.flush.encoding_byte
                                    ; Set encoding byte before 
                                    ; 1st data byte of unique string
        ;------------------------------------------------------
        ; (1.3.3) Now process duplicate character
        ;------------------------------------------------------
cpu2rle.scan.dup.rest:
        inc   tmp4                  ; Increase repeat counter
        jmp   cpu2rle.scan.next     ; Scan next character

*--------------------------------------------------------------
*   (2) Next character
*--------------------------------------------------------------
cpu2rle.scan.next:
        dec   tmp2
        jgt   cpu2rle.scan          ; (2.1) Next compare

*--------------------------------------------------------------
*   (3) End of string reached
*--------------------------------------------------------------
        ;------------------------------------------------------
        ; (3.1) Flush any pending duplicates
        ;------------------------------------------------------       
cpu2rle.eos.check1:
        mov   tmp4,tmp4             ; Repeat counter = 0 ?
        jeq   cpu2rle.eos.check2

        bl    @cpu2rle.flush.duplicates
                                    ; (3.2) Flush pending ...
        jmp   cpu2rle.exit          ;       duplicates & exit
        ;------------------------------------------------------
        ; (3.3) Flush any pending encoding byte
        ;------------------------------------------------------
cpu2rle.eos.check2:        
        mov   @waux2,@waux2
        jeq   cpu2rle.exit          ; No, so exit

        bl    @cpu2rle.flush.encoding_byte
                                    ; (3.4) Set encoding byte before 
                                    ; 1st data byte of unique string
*--------------------------------------------------------------
*   (4) Exit
*--------------------------------------------------------------
cpu2rle.exit:
        b     @poprt                ; Return




*****************************************************************
* Helper routines called internally
*****************************************************************

*--------------------------------------------------------------
* Flush duplicate to output buffer (=RLE encode)
*--------------------------------------------------------------
cpu2rle.flush.duplicates:
        swpb  tmp3                  ; Need the "old" character in buffer 

        movb  tmp3,tmp4             ; Move character to MSB 
        swpb  tmp4                  ; Move counter to MSB, character to LSB

        ori   tmp4,>8000            ; Set high bit in MSB
        movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
        swpb  tmp4                  ; | Could be on uneven address so using
        movb  tmp4,*tmp1+           ; / movb instruction instead of mov
        inct  @waux1                ; RLE string length += 2                
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu2rle.flush.duplicates.exit:
        swpb  tmp3                  ; Back to "current" character in buffer
        clr   tmp4                  ; Clear repeat count
        b     *r11                  ; Return


*--------------------------------------------------------------
*   (1.3.2) Set encoding byte before first data byte
*--------------------------------------------------------------
cpu2rle.flush.encoding_byte:
        dect  stack                 ; Short on registers, save tmp3 on stack
        mov   tmp3,*stack           ; No need to save tmp4, but reset before exit

        mov   tmp1,tmp3             ; \ Calculate length of non-repeated  
        s     @waux2,tmp3           ; | characters
        dec   tmp3                  ; /

        sla   tmp3,8                ; Left align to MSB
        mov   @waux2,tmp4           ; Destination address of encoding byte
        movb  tmp3,*tmp4            ; Set encoding byte

        mov   *stack+,tmp3          ; Pop tmp3 from stack
        clr   @waux2                ; Reset address of encoding byte   
        clr   tmp4                  ; Clear before exit
        b     *r11                  ; Return