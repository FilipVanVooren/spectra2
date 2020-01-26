* FILE......: cpu_sams_support.asm
* Purpose...: Low level support for SAMS memory expansion card

*//////////////////////////////////////////////////////////////
*                SAMS Memory Expansion support
*//////////////////////////////////////////////////////////////

***************************************************************
* sams.swbank. - Switch SAMS memory bank
***************************************************************
*  bl   @sams.swbank
*--------------------------------------------------------------
*  Address	 Paged area
*  =======   ==========
*  >4004     >2000-2FFF
*  >4006     >3000-4FFF
*  >4014     >A000-AFFF
*  >4016     >B000-BFFF
*  >4018     >C000-CFFF
*  >401A     >D000-DFFF
*  >401C     >E000-EFFF
*  >401E     >F000-FFFF
*  Others	 Inactive
*--------------------------------------------------------------
*  
********|*****|*********************|**************************
sams.swbank:
        li    r12,>1E00             ; SAMS CRU address 
        srl   tmp1,12               ; Reduce address to 4K chunks 
        sla   tmp1,1                ; Registers are 2 bytes appart
        sb0   0                     ; Access the mapper

        movb  R0,@>4000(tmp1)       ; Set the page number
        sbz   0                     ; Back to mapping mode
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.swbank.exit:
        b     *r11                  ; Return to caller       