* FILE......: rle_compress.asm
* Purpose...: RLE compression support

***************************************************************
* cpu2rle - RLE compress CPU memory
***************************************************************
*  bl   @cpu2rle
*       data P0,P1,P2
*--------------------------------------------------------------
*  P0 = ROM/RAM source address
*  P1 = RAM target address
*  P2 = Length of uncompressed data
*
*  Output:
*  waux1 = Length of RLE encoded string
*--------------------------------------------------------------
*  bl   @xcpu2rle
*
*  TMP0  = ROM/RAM source address
*  TMP1  = ROM/RAM source address
*  TMP2  = Length of uncompressed data
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
*  Implementation workflow:
*  (1) Scan string from left to right:
*      (1.1) Compare lookahead char with current char
*      (1.2) If it's not a repeated character:
*            (1.2.1) Check if any pending repeated character
*            (1.2.2) If yes, flush pending to output buffer (=RLE encode)
*            (1.2.3) Track address of future encoding byte
*            (1.2.4) Append data byte to output buffer and jump to (2)
*
*      (1.3) If it's a repeated character:
*            (1.3.1) Check if any pending non-repeated character
*            (1.3.2) If yes, set encoding byte before first data byte
*            (1.3.3) Increase repetition counter and jump to (2)
* 
*  (2) Process next character 
*      (2.1) Jump back to (1.1) unless end of string reached
*             
*  (3) End of string reached:
*      (3.1) Check if pending repeated character
*      (3.2) If yes, flush to output buffer (=RLE encode) and exit
*      (3.3) Check if pending non-repeated character
*      (3.4) If yes, set encoding byte before first data byte
*
*  (4) Exit
*--------------------------------------------------------------


********@*****@*********************@**************************
cpu2rle:
        mov   *r11+,tmp0            ; ROM/RAM source address
        mov   *r11+,tmp1            ; RAM target address
        mov   *r11+,tmp2            ; Length of data to encode
xcpu2rle:        
        mov   r11,@waux3            ; Save return address        
*--------------------------------------------------------------
*   Initialisation
*--------------------------------------------------------------
cup2rle.init:
        clr   tmp3                  ; Character buffer (2 chars)
        clr   tmp4                  ; Repetition counter
        clr   @waux1                ; Length of RLE string        
        clr   @waux2                ; Address of encoding byte
*--------------------------------------------------------------
*   (1.1) Scan string 
*--------------------------------------------------------------
cpu2rle.scan:
        srl   tmp3,8                ; Save old character in LSB
        movb  *tmp0+,tmp3           ; Move current character to MSB
        cb    *tmp0,tmp3            ; Compare lookahead with current
        jeq   cpu2rle.scan.dup      ; Duplicate found
*--------------------------------------------------------------
*   (1.2) No duplicate
*--------------------------------------------------------------
cpu2rle.scan.nodup:
        ;------------------------------------------------------
        ; (1.2.1) First check if any pending duplicates
        ;------------------------------------------------------
        mov   tmp4,tmp4
        jne   cpu2rle.scan.flush_dup 
                                    ; Yes, flush pending duplicates
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
        ; (1.3.1) First check if any pending non-duplicates
        ;------------------------------------------------------
        mov   @waux2,@waux2
        jne   cpu2rle.scan.flush_nodup 
                                    ; Set encoding byte before 1st data byte
        ;------------------------------------------------------
        ; (1.3.3) Now process duplicate character
        ;------------------------------------------------------
cpu2rle.scan.dup.rest:
        inc   tmp4                  ; Increase repetition counter
        jmp   cpu2rle.scan.next     ; Scan next character


*--------------------------------------------------------------
*   (1.2.2) Flush duplicate to output buffer (=RLE encode)
*--------------------------------------------------------------
cpu2rle.scan.flush_dup:
        movb  tmp3,tmp4             ; Move character to MSB 
        swpb  tmp4                  ; Move counter to MSB, character to LSB
        ori   tmp4,8000             ; Set high bit in MSB
        mov   tmp4,*tmp1+           ; RLE word to output buffer        
        clr   tmp4                  ; Reset repetition counter
        inct  @waux1                ; RLE string length += 2
        jmp   cpu2rle.scan.nodup.rest
*--------------------------------------------------------------
*   (1.3.2) Set encoding byte before first data byte
*--------------------------------------------------------------
cpu2rle.scan.flush_nodup:
        mov   tmp1,tmp4             ; \ Calculate length of non-repeated  
        s     @waux2,tmp4           ; | characters. Short on registers
        dec   tmp4                  ; / so abusing tmp4

        sla   tmp4,8                ; \
        movb  tmp4,@waux2           ; / Set encoding byte 

        clr   @waux2                ; Reset address of encoding byte   
        clr   tmp4                  ; Clear before using again
        jmp   cpu2rle.scan.dup.rest

*--------------------------------------------------------------
*   (2) Next character
*--------------------------------------------------------------
cpu2rle.scan.next:
        dec   tmp2
        jgt   cpu2rle.scan          ; (2.1) Next compare
*--------------------------------------------------------------
*   (3) End of string reached
*--------------------------------------------------------------
cpu2rle.eos.pending_dup:
        ;------------------------------------------------------
        ; (3.1) End of string. Pending duplicates left?
        ;------------------------------------------------------       
        mov   tmp4,tmp4             ; Duplicates left?
        jeq   cpu2rle.eos.pending_nodup
                                    ; No, check no-duplicates
        ;------------------------------------------------------
        ; (3.2) Yes, flush pending duplicates to output buffer
        ;------------------------------------------------------
cpu2rle.eos.flush_dup:
        movb  tmp3,tmp4             ; Move character to MSB 
        swpb  tmp4                  ; Move counter to MSB, character to LSB
        ori   tmp4,8000             ; Set high bit in MSB
        mov   tmp4,*tmp1+           ; RLE encoded to output buffer
        inct  @waux1                ; RLE string length += 2        
        jmp   cpu2rle.$$            ; Exit
        ;------------------------------------------------------
        ; (3.3) End of string. Pending non-duplicates left?
        ;------------------------------------------------------
cpu2rle.eos.pending_nodup:
        mov   @waux2,@waux2
        jeq   cpu2rle.$$            ; No, so exit
        ;------------------------------------------------------
        ; (3.4) Yes, Set encoding byte before first data byte
        ;------------------------------------------------------
        mov   tmp1,tmp4             ; \ Calculate length of non-repeated  
        s     @waux2,tmp4           ; | characters. Short on registers
        dec   tmp4                  ; / so abusing tmp4

        sla   tmp4,8                ; \
        movb  tmp4,@waux2           ; / Set encoding byte         
*--------------------------------------------------------------
*   (4) Exit
*--------------------------------------------------------------
cpu2rle.$$:
        mov   @waux3,r11            ; Get return address
        b     *r11                  ; Return