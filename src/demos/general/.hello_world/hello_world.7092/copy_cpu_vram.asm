* FILE......: copy_cpu_vram.asm
* Purpose...: CPU memory to VRAM copy support module

***************************************************************
* CPYM2V - Copy CPU memory to VRAM
***************************************************************
*  BL   @CPYM2V
*  DATA P0,P1,P2
*--------------------------------------------------------------
*  P0 = VDP start address
*  P1 = RAM/ROM start address
*  P2 = Number of bytes to copy
*--------------------------------------------------------------
*  BL @XPYM2V
*
*  TMP0 = VDP start address
*  TMP1 = RAM/ROM start address
*  TMP2 = Number of bytes to copy
********|*****|*********************|**************************
cpym2v  mov   *r11+,tmp0            ; VDP Start address
        mov   *r11+,tmp1            ; RAM/ROM start address
        mov   *r11+,tmp2            ; Bytes to copy
*--------------------------------------------------------------
*    Assert
*--------------------------------------------------------------
xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
        jne   !                     ; No, continue
         
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
*--------------------------------------------------------------
*    Setup VDP write address
*--------------------------------------------------------------
!       ori   tmp0,>4000
        swpb  tmp0
        movb  tmp0,@vdpa
        swpb  tmp0
        movb  tmp0,@vdpa
*--------------------------------------------------------------
*    Copy bytes from CPU memory to VRAM
*--------------------------------------------------------------
        li    r15,vdpw              ; Set VDP write address
        mov   @tmp008,@mcloop       ; Setup copy command
        b     @mcloop               ; Write data to VDP and return
*--------------------------------------------------------------
* Data
*--------------------------------------------------------------
tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
