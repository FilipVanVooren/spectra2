* FILE......: cpu_sams_support.asm
* Purpose...: Low level support for SAMS memory expansion card

*//////////////////////////////////////////////////////////////
*                SAMS Memory Expansion support
*//////////////////////////////////////////////////////////////

***************************************************************
* sams.bank - Switch SAMS memory bank
***************************************************************
*  bl   @sams.bank
*       data P0,P1
*--------------------------------------------------------------
*  P0 = SAMS bank number
*  P1 = Memory address
*--------------------------------------------------------------
*  bl   @xsams.bank
*
*  tmp0 = SAMS bank number
*  tmp1 = Memory address
*--------------------------------------------------------------
*  Register usage
*  r0, tmp0, tmp1, r12
*--------------------------------------------------------------
*  Address      p1/tmp1        Paged area
*  =======      =======        ==========
*  >4004        >04            >2000-2fff
*  >4006        >06            >3000-4fff
*  >4014        >14            >a000-afff
*  >4016        >16            >b000-bfff
*  >4018        >18            >c000-cfff
*  >401a        >1a            >d000-dfff
*  >401c        >1c            >e000-efff
*  >401e        >1e            >f000-ffff
*  Others       Others         Inactive
********|*****|*********************|**************************
sams.bank:
        mov   *r11+,tmp0            ; Get p0
        mov   *r11+,tmp1            ; Get p1
xsams.bank:
*--------------------------------------------------------------
* Determine SAMS bank
*--------------------------------------------------------------
        srl   tmp1,12               ; Reduce address to 4K chunks 
        sla   tmp1,1                ; Registers are 2 bytes appart
*--------------------------------------------------------------
* Switch to specified SAMS bank
*--------------------------------------------------------------
sams.bank.switch:
        li    r12,>1e00             ; SAMS CRU address
        mov   tmp0,r0               ; Must be in r0 for CRU use
        swpb  r0                    ; LSB to MSB      
        sbo   0                     ; Enable access to SAMS registers 
        movb  r0,@>4000(tmp1)       ; Set SAMS bank number
        sbz   0                     ; Disable access to SAMS registers
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.bank.exit:
        b     *r11                  ; Return to caller       




*--------------------------------------------------------------
* Enable SAMS mapping mode
*--------------------------------------------------------------
sams.mapping.on:
        li    r12,>1e00             ; SAMS CRU address
        sbo   1                     ; Enable SAMS mapper
        jmp   sams.mapping.exit
*--------------------------------------------------------------
* Disable SAMS mapping mode
*--------------------------------------------------------------
sams.mapping.off:
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.mapping.exit:
        b     *r11                  ; Return to caller       