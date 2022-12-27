* FILE......: fg99.asm
* Purpose...: FinalGROM 99 reload code

*//////////////////////////////////////////////////////////////
*               FinalGROM 99 reload cartridge code
*//////////////////////////////////////////////////////////////

***************************************************************
* fg99 - Load cartridge from flash card into FinalGROM99
***************************************************************
*  bl   @fg99
*       data p0
*       data p1
*       text 'filename'
*
*  p0 = Cartridge type (>0000 for GROM/mixed, >FFFF for ROM)
*  p1 = Start address
*  p2 = Filename letters 1-2
*  p3 = Filename letters 3-4
*  p4 = Filename letters 5-6
*  p5 = Filename letters 7-8 
*--------------------------------------------------------------
*  bl   @xfg99
*
*  tmp0   = Filename letters 1-2
*  tmp1   = Filename letters 3-4
*  tmp2   = Filename letters 5-6
*  tmp3   = Filename letters 7-8
*  tmp4   = Cartridge type (>0000 for GROM/mixed, >FFFF for ROM)
*  @waux1 = Start address in cartridge
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
*       Code is expected to run from RAM, not from the cartridge space
*       and will not return to caller!
********|*****|*********************|**************************
fg99    mov   *r11+,tmp4            ; Get p0 (cartridge type)
        mov   *r11+,@waux1          ; Get p1 (start address in cartridge)
        mov   *r11+,tmp0            ; Get p2  (filename 1-2)
        mov   *r11+,tmp1            ; Get p3  (filename 3-4)
        mov   *r11+,tmp2            ; Get p4  (filename 5-6)
        mov   *r11+,tmp3            ; Get p5  (filename 7-8)
*--------------------------------------------------------------
* (1) Send prefix to FinalGROM
*--------------------------------------------------------------        
fg99.send:
        li    r0,fg99.data.prefix   ; Get prefix
        li    r2,8                  ; Sequence length: prefix (8)
fg99.send.prefix.loop:
        clr   @>6000                ; Signal new byte
        li    r1,>0038              ; >7000 >> 9
        movb  *r0+,r1
        src   r1,7                  ; >7000 + (byte << 1)

        clr   *r1                   ; Send byte
        dec   r2                    ; Prepare for next iteration
        jne   fg99.send.prefix.loop ; Next byte
*--------------------------------------------------------------
* (2) Send filename to FinalGROM
*-------------------------------------------------------------- 
        li    r0,tmp0               ; Filename
        li    r2,10                 ; Sequence length: fname (8) + carttype (2)
fg99.send.fname.loop:
        clr   @>6000                ; Signal new byte
        li    r1,>0038              ; >7000 >> 9
        movb  *r0+,r1
        src   r1,7                  ; >7000 + (byte << 1)

        clr   *r1                   ; Send byte
        dec   r2                    ; Prepare for next iteration
        jne   fg99.send.fname.loop  ; Next byte

        clr   @>6000                ; done sending filename
        src   r0, 8                 ; burn at least 21 cycles        
*--------------------------------------------------------------
* (3) Wait for image to be loaded by FinalGROM
*-------------------------------------------------------------- 
fg99.wait:
        li    r0,>6000              ; check >6000->6200
        li    r2,>100
!       mov   *r0+, r1
        jne   fg99.done
        dec   r2
        jne   -!
        jmp   fg99.wait
*--------------------------------------------------------------
* (4) Image finished loading. Start cartridge.
*--------------------------------------------------------------
        mov   @waux1,r0             ; Get start address
        b     *r0                   ; Jump into cartridge
*--------------------------------------------------------------
* Reload sequence
*--------------------------------------------------------------
fg99.data.prefix:
       text >99, 'OKFG99', >99      ; send this to reload
