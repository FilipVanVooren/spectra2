* FILE......: registers.asm
* Purpose...: Equates for registers

***************************************************************
* Register usage
* R0      **free not used**
* R1      **free not used**
* R2      Config register
* R3      Extended config register
* R4-R8   Temporary registers/variables (tmp0-tmp4)
* R9      Stack pointer
* R10     Highest slot in use + Timer counter
* R11     Subroutine return address
* R12     CRU
* R13     Copy of VDP status byte and counter for sound player
* R14     Copy of VDP register #0 and VDP register #1 bytes
* R15     VDP read/write address
*--------------------------------------------------------------
* Special purpose registers
* R0      shift count
* R12     CRU
* R13     WS     - when using LWPI, BLWP, RTWP
* R14     PC     - when using LWPI, BLWP, RTWP
* R15     STATUS - when using LWPI, BLWP, RTWP
***************************************************************
* Define registers
********@*****@*********************@**************************
r0      equ   0
r1      equ   1
r2      equ   2
r3      equ   3
r4      equ   4
r5      equ   5
r6      equ   6
r7      equ   7
r8      equ   8
r9      equ   9
r10     equ   10
r11     equ   11
r12     equ   12
r13     equ   13
r14     equ   14
r15     equ   15
***************************************************************
* Define register equates
********@*****@*********************@**************************
config  equ   r2                    ; Config register
xconfig equ   r3                    ; Extended config register 
tmp0    equ   r4                    ; Temp register 0
tmp1    equ   r5                    ; Temp register 1
tmp2    equ   r6                    ; Temp register 2
tmp3    equ   r7                    ; Temp register 3
tmp4    equ   r8                    ; Temp register 4
stack   equ   r9                    ; Stack pointer
vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
vdprw   equ   r15                   ; Contains VDP read/write address
***************************************************************
* Define MSB/LSB equates for registers
********@*****@*********************@**************************
r0hb    equ   ws1                   ; HI byte R0
r0lb    equ   ws1+1                 ; LO byte R0
r1hb    equ   ws1+2                 ; HI byte R1
r1lb    equ   ws1+3                 ; LO byte R1
r2hb    equ   ws1+4                 ; HI byte R2
r2lb    equ   ws1+5                 ; LO byte R2
r3hb    equ   ws1+6                 ; HI byte R3
r3lb    equ   ws1+7                 ; LO byte R3
r4hb    equ   ws1+8                 ; HI byte R4
r4lb    equ   ws1+9                 ; LO byte R4
r5hb    equ   ws1+10                ; HI byte R5
r5lb    equ   ws1+11                ; LO byte R5
r6hb    equ   ws1+12                ; HI byte R6
r6lb    equ   ws1+13                ; LO byte R6
r7hb    equ   ws1+14                ; HI byte R7
r7lb    equ   ws1+15                ; LO byte R7
r8hb    equ   ws1+16                ; HI byte R8
r8lb    equ   ws1+17                ; LO byte R8
r9hb    equ   ws1+18                ; HI byte R9
r9lb    equ   ws1+19                ; LO byte R9
r10hb   equ   ws1+20                ; HI byte R10
r10lb   equ   ws1+21                ; LO byte R10
r11hb   equ   ws1+22                ; HI byte R11
r11lb   equ   ws1+23                ; LO byte R11
r12hb   equ   ws1+24                ; HI byte R12
r12lb   equ   ws1+25                ; LO byte R12
r13hb   equ   ws1+26                ; HI byte R13
r13lb   equ   ws1+27                ; LO byte R13
r14hb   equ   ws1+28                ; HI byte R14
r14lb   equ   ws1+29                ; LO byte R14
r15hb   equ   ws1+30                ; HI byte R15
r15lb   equ   ws1+31                ; LO byte R15
********@*****@*********************@**************************
tmp0hb  equ   ws1+8                 ; HI byte R4
tmp0lb  equ   ws1+9                 ; LO byte R4
tmp1hb  equ   ws1+10                ; HI byte R5
tmp1lb  equ   ws1+11                ; LO byte R5
tmp2hb  equ   ws1+12                ; HI byte R6
tmp2lb  equ   ws1+13                ; LO byte R6
tmp3hb  equ   ws1+14                ; HI byte R7
tmp3lb  equ   ws1+15                ; LO byte R7
tmp4hb  equ   ws1+16                ; HI byte R8
tmp4lb  equ   ws1+17                ; LO byte R8
********@*****@*********************@**************************
btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
***************************************************************
