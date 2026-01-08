* FILE......: fio_memprep.asm
* Purpose...: File I/O VDP memory setup

***************************************************************
* file.vmem - Prepare VDP memory for file access
***************************************************************
*  bl   @file.vmem
*--------------------------------------------------------------
*  Output:
*  none
********|*****|*********************|**************************
file.vmem:
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
        dect  stack
        mov   r11,*stack            ; Save return address
*--------------------------------------------------------------
* Clear VDP memory >37E0 - >3FFF and poke
*--------------------------------------------------------------
        bl    @filv                 ; \ Fill VDP memory
              data >37e0            ; | p0  = Start address
              data 00               ; | p1  = Byte to fill
              data 2080             ; / p2  = Number of bytes to fill

        bl    @cpym2v               ; \ Copy CPU memory to VDP memory
              data >37d8            ; | p0 = VDP target address
              data file.vmem.37d8   ; | p1 = CPU source address
              data 6                ; / p2 = Number of bytes to copy

        bl    @cpym2v               ; \ Copy CPU memory to VDP memory
              data >3ee6            ; | p0 = VDP target address
              data file.vmem.part1  ; | p1 = CPU source address
              data 6                ; / p2 = Number of bytes to copy

        bl    @cpym2v               ; \ Copy CPU memory to VDP memory
              data >3f06            ; | p0 = VDP target address
              data file.vmem.part2  ; | p1 = CPU source address
              data 2                ; / p2 = Number of bytes to copy
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
file.vmem.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
*--------------------------------------------------------------
* Data
*--------------------------------------------------------------
file.vmem.37d8:
        data  >aa3f,>ff11,>0300,>0000

file.vmem.part1:
       data  >00C6,>4014,>0B00
file.vmem.part2:
       data  >10FF
