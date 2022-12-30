* FILE......: rom_fg99.asm
* Purpose...: FinalGROM 99 reload code

*//////////////////////////////////////////////////////////////
*               FinalGROM 99 reload cartridge code
*//////////////////////////////////////////////////////////////

***************************************************************
* fg99 - Load cartridge from flash card into FinalGROM99
***************************************************************
*  bl   @fg99
*       data p0
*
*  p0 = Pointer to FG99 cartridge table entry
*--------------------------------------------------------------
*  bl   @xfg99
*
*  tmp0 = Pointer to FG99 cartridge table entry
*--------------------------------------------------------------
* Remark
* https://github.com/endlos99/finalgrom99/blob/master/lib/reload_example.a99
*
* NOTE: You must use shortened 8.3 upper-case filenames here.
*       For example, to reload "mylongfile.bin", use "MYLONG~1.BIN".
*       If there are multiple files with prefix "MYLONG" in the
*       folder, you may have to replace the suffix "~1" by "~2",
*       "~3", ... to select the correct file.
*
*       PAD filename with >00 bytes so that it's always 8 bytes.
*       Code is expected to run from RAM, not from the cartridge space.
********|*****|*********************|**************************
fg99    mov   *r11+,tmp0            ; Get p0
*--------------------------------------------------------------
* Register version
*--------------------------------------------------------------   
xfg99:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
*--------------------------------------------------------------
* (1) Send prefix and filename to FinalGROM
*--------------------------------------------------------------     
        mov   tmp0,r0               ; Get Pointer
        li    r2,20                 ; Len = prefix (8) + fname (8) + suffix (4)
fg99.send.loop:
        clr   @>6000                ; Signal new byte
        li    r1,>0038              ; >7000 >> 9
        movb  *r0+,r1
        src   r1,7                  ; >7000 + (byte << 1)

        clr   *r1                   ; Send byte
        dec   r2                    ; Prepare for next iteration
        jne   fg99.send.loop        ; Next byte

        clr   @>6000                ; Done sending filename
        src   r0,8                  ; Burn at least 21 cycles        
*--------------------------------------------------------------
* (3) Wait for image to be loaded by FinalGROM
*-------------------------------------------------------------- 
fg99.wait:
        li    r0,>6000              ; check >6000->6200
        li    r2,>100
!       mov   *r0+, r1
        jne   fg99.exit             ; Done loading, run cartridge
        dec   r2
        jne   -!
        jmp   fg99.wait
*--------------------------------------------------------------
* (4) Image finished loading
*--------------------------------------------------------------
fg99.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
