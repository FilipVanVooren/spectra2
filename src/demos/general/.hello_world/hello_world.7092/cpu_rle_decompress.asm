* FILE......: cpu_rle_decompress.asm
* Purpose...: RLE decompression support


***************************************************************
* rl2cpu - RLE decompress to CPU memory
***************************************************************
*  bl   @rle2cpu
*       data P0,P1,P2
*--------------------------------------------------------------
*  P0 = ROM/RAM source address
*  P1 = RAM target address
*  P2 = Length of RLE encoded data
*--------------------------------------------------------------
*  bl   @xrle2cpu
*
*  TMP0 = ROM/RAM source address
*  TMP1 = RAM target address
*  TMP2 = Length of RLE encoded data
*--------------------------------------------------------------
*  Detail on RLE compression format:
*  - If high bit is set, remaining 7 bits indicate to copy
*    the next byte that many times.
*  - If high bit is clear, remaining 7 bits indicate how many
*    data bytes (non-repeated) follow.
*--------------------------------------------------------------


********|*****|*********************|**************************
rle2cpu:
        mov   *r11+,tmp0            ; ROM/RAM source address
        mov   *r11+,tmp1            ; RAM target address
        mov   *r11+,tmp2            ; Length of RLE encoded data
xrle2cpu:
        dect  stack        
        mov   r11,*stack            ; Save return address        
*--------------------------------------------------------------
*   Scan RLE control byte
*--------------------------------------------------------------
rle2cpu.scan:
        movb  *tmp0+,tmp3           ; Get control byte into tmp3
        dec   tmp2                  ; Update length
        jeq   rle2cpu.exit          ; End of list
        sla   tmp3,1                ; Check bit 0 of control byte
        joc   rle2cpu.dump_compressed
                                    ; Yes, next byte is compressed
*--------------------------------------------------------------
*    Dump uncompressed bytes
*--------------------------------------------------------------
rle2cpu.dump_uncompressed:
        srl   tmp3,9                ; Use control byte as loop counter
        s     tmp3,tmp2             ; Update RLE string length     

        dect  stack        
        mov   tmp2,*stack           ; Push tmp2
        mov   tmp3,tmp2             ; Set length for block copy

        bl    @xpym2m               ; Block copy to destination
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Target address 
                                    ; / i  tmp2 = Bytes to copy

        mov   *stack+,tmp2          ; Pop tmp2
        jmp   rle2cpu.check_if_more ; Check if more data to decompress
*--------------------------------------------------------------
*    Dump compressed bytes
*--------------------------------------------------------------
rle2cpu.dump_compressed:
        srl   tmp3,9                ; Use control byte as counter
        dec   tmp2                  ; Update RLE string length

        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack        
        mov   tmp2,*stack           ; Push tmp2
        dect  stack        
        mov   tmp3,*stack           ; Push tmp3

        mov   tmp3,tmp2             ; Set length for block fill
        movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")       
        srl   tmp1,8                ; Right align                                                                                                                           

        bl    @xfilm                ; Block fill to destination
                                    ; \ i  tmp0 = Target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Repeat count

        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1

        a     tmp3,tmp1             ; Adjust memory target after fill
*--------------------------------------------------------------
*    Check if more data to decompress
*--------------------------------------------------------------
rle2cpu.check_if_more:
        mov   tmp2,tmp2             ; Length counter = 0 ?
        jne   rle2cpu.scan          ; Not yet, process next control byte
*--------------------------------------------------------------
*    Exit
*--------------------------------------------------------------
rle2cpu.exit:
        b     @poprt                ; Return
