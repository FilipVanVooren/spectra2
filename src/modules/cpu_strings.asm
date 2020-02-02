* FILE......: cpu_strings.asm
* Purpose...: CPU string manipulation library (left justify, ...)

*----------------------------------
* Left justify length-padded string
*----------------------------------
trim_left:
        mov   *r11+,tmp0            ; Pointer to length-prefixed string
        mov   *r11+,tmp1            ; RAM work buffer
        mov   *r11+,tmp2            ; Fill character
        mov   *tmp0,tmp3 
        swpb  tmp3                  ; LO <-> HI
        andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep string length)
        sla   tmp2,8                ; LO -> HI fill character

trim_left_scan:
        ;----------------------------------------------------------------------
        ; Scan string from left to right and compare with fill character
        ;----------------------------------------------------------------------
        cb    *tmp0,tmp2            ; Do we have a fill character?
        jne   trim_left_move        ; No, now move string left
        inc   tmp0                  ; Next byte
        dec   tmp3                  ; Shorten string length
        jeq   trim_left_move        ; Exit if all characters processed
        jmp   trim_left_scan        ; Scan next characer

trim_left_move:
        ;----------------------------------------------------------------------
        ; Copy part of string to RAM work buffer (This is the left-justify)
        ;----------------------------------------------------------------------
        cb    *tmp0,tmp2            ; Do we have a fill character?
        mov   tmp3,tmp3             ; String length = 0 ?
        jeq   trim_left_panic       ; File length assert
   
        mov   tmp3,tmp2       
        swpb  tmp3                  ; HI <-> LO
        movb  tmp3,*tmp1+           ; Set new string length byte in RAM work buffer

        bl    @xpym2m               ; tmp0 = Memory source address
                                    ; tmp1 = Memory target address
                                    ; tmp2 = Number of bytes to copy

trim_left_exit:
        b     *r11                  ; Return 
         
trim_left_panic:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system