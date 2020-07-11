* FILE......: cpu_strings.asm
* Purpose...: CPU string manipulation library


***************************************************************
* string.ltrim - Left justify string
***************************************************************
*  bl   @string.ltrim
*       data p0,p1,p2
*--------------------------------------------------------------
*  P0 = Pointer to length-prefix string
*  P1 = Pointer to RAM work buffer
*  P2 = Fill character
*--------------------------------------------------------------
*  BL   @xstring.ltrim
*
*  TMP0 = Pointer to length-prefix string
*  TMP1 = Pointer to RAM work buffer
*  TMP2 = Fill character
********|*****|*********************|**************************
string.ltrim:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;-----------------------------------------------------------------------
        ; Get parameter values
        ;-----------------------------------------------------------------------
        mov   *r11+,tmp0            ; Pointer to length-prefixed string
        mov   *r11+,tmp1            ; RAM work buffer
        mov   *r11+,tmp2            ; Fill character
        jmp   !
        ;-----------------------------------------------------------------------
        ; Register version
        ;-----------------------------------------------------------------------
xstring.ltrim:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;-----------------------------------------------------------------------
        ; Start
        ;-----------------------------------------------------------------------
!       mov   *tmp0,tmp3 
        swpb  tmp3                  ; LO <-> HI
        andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
        sla   tmp2,8                ; LO -> HI fill character
        ;-----------------------------------------------------------------------
        ; Scan string from left to right and compare with fill character
        ;-----------------------------------------------------------------------
string.ltrim.scan:        
        cb    *tmp0,tmp2            ; Do we have a fill character?
        jne   string.ltrim.move     ; No, now move string left
        inc   tmp0                  ; Next byte
        dec   tmp3                  ; Shorten string length
        jeq   string.ltrim.move     ; Exit if all characters processed
        jmp   string.ltrim.scan     ; Scan next characer
        ;-----------------------------------------------------------------------
        ; Copy part of string to RAM work buffer (This is the left-justify)
        ;-----------------------------------------------------------------------
string.ltrim.move:        
        cb    *tmp0,tmp2            ; Do we have a fill character?
        mov   tmp3,tmp3             ; String length = 0 ?
        jeq   string.ltrim.panic    ; File length assert
        mov   tmp3,tmp2       
        swpb  tmp3                  ; HI <-> LO
        movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf

        bl    @xpym2m               ; tmp0 = Memory source address
                                    ; tmp1 = Memory target address
                                    ; tmp2 = Number of bytes to copy
        jmp   string.ltrim.exit                                    
        ;-----------------------------------------------------------------------
        ; CPU crash
        ;-----------------------------------------------------------------------
string.ltrim.panic:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system                                    
        ;----------------------------------------------------------------------
        ; Exit
        ;----------------------------------------------------------------------                                    
string.ltrim.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
         



***************************************************************
* string.getlen0 - Get length of C-style string
***************************************************************
*  bl   @string.getlen0
*       data p0,p1
*--------------------------------------------------------------
*  P0 = Pointer to C-style string
*  P1 = String termination character
*--------------------------------------------------------------
*  bl   @xstring.getlen0
*
*  TMP0 = Pointer to C-style string
*  TMP1 = Termination character
*--------------------------------------------------------------
*  OUTPUT:
*  @waux1 = Length of string
********|*****|*********************|**************************
string.getlen0:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-----------------------------------------------------------------------
        ; Get parameter values
        ;-----------------------------------------------------------------------
        mov   *r11+,tmp0            ; Pointer to length-prefixed string
        mov   *r11+,tmp1            ; RAM work buffer
        jmp   !
        ;-----------------------------------------------------------------------
        ; Register version
        ;-----------------------------------------------------------------------
xstring.getlen0:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-----------------------------------------------------------------------
        ; Start
        ;-----------------------------------------------------------------------
!       sla   tmp1,8                ; LSB to MSB
        clr   tmp2                  ; Loop counter
        ;-----------------------------------------------------------------------
        ; Scan string for termination character
        ;-----------------------------------------------------------------------
string.getlen0.loop:
        inc   tmp2
        cb    *tmp0+,tmp1           ; Compare character
        jeq   string.getlen0.putlength
        ;-----------------------------------------------------------------------
        ; Sanity check on string length
        ;-----------------------------------------------------------------------
        ci    tmp2,255              
        jgt   string.getlen0.panic
        jmp   string.getlen0.loop
        ;-----------------------------------------------------------------------
        ; Return length
        ;-----------------------------------------------------------------------
string.getlen0.putlength:
        dec   tmp2                  ; One time adjustment        
        mov   tmp2,@waux1           ; Store length
        jmp   string.getlen0.exit   ; Exit
        ;-----------------------------------------------------------------------
        ; CPU crash
        ;-----------------------------------------------------------------------
string.getlen0.panic:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system                                    
        ;----------------------------------------------------------------------
        ; Exit
        ;----------------------------------------------------------------------                                    
string.getlen0.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller