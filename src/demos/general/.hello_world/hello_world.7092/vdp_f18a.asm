* FILE......: vdp_f18a.asm
* Purpose...: VDP F18A Support module

*//////////////////////////////////////////////////////////////
*                 VDP F18A LOW-LEVEL FUNCTIONS
*//////////////////////////////////////////////////////////////

***************************************************************
* f18unl - Unlock F18A VDP
***************************************************************
*  bl   @f18unl
********|*****|*********************|**************************
f18unl  mov   r11,tmp4              ; Save R11
        bl    @putvr                ; Write once
        data  >391c                 ; VR1/57, value 00011100
        bl    @putvr                ; Write twice
        data  >391c                 ; VR1/57, value 00011100
        bl    @putvr
        data  >01e0                 ; VR1, value 11100000, a sane setting
        b     *tmp4                 ; Exit


***************************************************************
* f18lck - Lock F18A VDP
***************************************************************
*  bl   @f18lck
********|*****|*********************|**************************
f18lck  mov   r11,tmp4              ; Save R11 
        bl    @putvr                ; VR1/57, value 00000000
        data  >3900
        b     *tmp4                 ; Exit


***************************************************************
* f18idl - Put GPU in F18A VDP in idle mode (stop GPU program)
***************************************************************
*  bl   @f18idl
*--------------------------------------------------------------
*  REMARKS
*  Expects that the f18a is unlocked when calling this function.
********|*****|*********************|**************************
f18idl  mov   r11,tmp4              ; Save R11 
        bl    @putvr                ; VR56 >38, value 00000000
        data  >3800                 ; Reset and load PC (GPU idle!)
        b     *tmp4                 ; Exit



***************************************************************
* f18chk - Check if F18A VDP present
***************************************************************
*  bl   @f18chk
*--------------------------------------------------------------
*  REMARKS
*  Expects that the f18a is unlocked when calling this function.
*  Runs GPU code at VDP >3f00
********|*****|*********************|**************************
f18chk  mov   r11,tmp4              ; Save R11
        bl    @cpym2v
        data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
        bl    @putvr
        data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
        bl    @putvr
        data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
                                    ; GPU code should run now

        bl    @putvr                ; VR56 >38, value 00000000
        data  >3800                 ; Reset and load PC (GPU idle!)        
***************************************************************
* VDP @>3f00 == 0 ? F18A present : F18a not present
***************************************************************
        li    tmp0,>3f00
        bl    @vdra                 ; Set VDP read address to >3f00
        movb  @vdpr,tmp0            ; Read MSB byte
        srl   tmp0,8
        movb  @vdpr,tmp0            ; Read LSB byte
        mov   tmp0,tmp0             ; For comparing with 0
        jeq   f18chk_yes
f18chk_no:
        andi  config,>bfff          ; CONFIG Register bit 1=0 
        jmp   f18chk_exit 
f18chk_yes:
        ori   config,>4000          ; CONFIG Register bit 1=1

f18chk_exit:
        bl    @filv                 ; Clear VDP mem >3f00->3f05
        data  >3f00,>00,6 
        b     *tmp4                 ; Exit
***************************************************************
* GPU code
********|*****|*********************|**************************
f18chk_gpu
        data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
        data  >3f00                 ; 3f02 / 3f00
        data  >0340                 ; 3f04   0340  idle
        data  >10ff                 ; 3f06   10ff  \ jmp $  
                                    ;              | Make classic99 debugger
                                    ;              | happy if break on illegal
                                    ;              / opcode is on.

***************************************************************
* f18rst - Reset f18a into standard settings
***************************************************************
*  bl   @f18rst
*--------------------------------------------------------------
*  REMARKS
*  This is used to leave the F18A mode and revert all settings
*  that could lead to corruption when doing BLWP @0
*
*  Is expected to run while the f18a is unlocked. 
* 
*  There are some F18a settings that stay on when doing blwp @0
*  and the TI title screen cannot recover from that.
* 
*  It is your responsibility to set video mode tables should
*  you want to continue instead of doing blwp @0 after your
*  program cleanup
********|*****|*********************|**************************
f18rst  mov   r11,tmp4              ; Save R11 
        ;------------------------------------------------------
        ; Reset all F18a VDP registers to power-on defaults
        ;------------------------------------------------------
        bl    @putvr 
        data  >3280                 ; F18a VR50 (>32), MSB 8=1

        bl    @putvr                ; VR1/57, value 00000000
        data  >3900                 ; Lock the F18a
        b     *tmp4                 ; Exit



***************************************************************
* f18fwv - Get F18A Firmware Version
***************************************************************
*  bl   @f18fwv
*--------------------------------------------------------------
*  REMARKS
*  Successfully tested with F18A v1.8, note that this does not
*  work with F18 v1.3 but you shouldn't be using such old F18A
*  firmware to begin with. 
*--------------------------------------------------------------
*  TMP0 High nibble = major version
*  TMP0 Low nibble  = minor version
*
*  Example: >0018     F18a Firmware v1.8
********|*****|*********************|**************************
f18fwv  mov   r11,tmp4              ; Save R11
        coc   @wbit1,config         ; CONFIG bit 1 set ?
        jne   f18fw1
***************************************************************
* Read F18A major/minor version
***************************************************************
        mov   @vdps,tmp0            ; Clear VDP status register
        bl    @putvr                ; Write to VR#15 for setting F18A status
        data  >0f0e                 ; register to read (0e=VR#14)
        clr   tmp0
        movb  @vdps,tmp0
        srl   tmp0,8
f18fw1  b     *tmp4                 ; Exit
