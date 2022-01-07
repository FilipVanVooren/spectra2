* FILE......: cpu_sams_layout.asm
* Purpose...: Low level support for SAMS memory expansion card

*//////////////////////////////////////////////////////////////
*                SAMS Memory Expansion support
*//////////////////////////////////////////////////////////////

***************************************************************
* sams.layout
* Setup SAMS memory banks
***************************************************************
* bl  @sams.layout
*     data P0
*--------------------------------------------------------------
* INPUT
* P0 = Pointer to SAMS page layout table
*--------------------------------------------------------------
* bl  @xsams.layout
*
* tmp0 = Pointer to SAMS page layout table
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, r12
********|*****|*********************|**************************
sams.layout:
        mov   *r11+,tmp0            ; Get P0
xsams.layout:          
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Save tmp0
        dect  stack
        mov   r12,*stack            ; Save r12
        ;------------------------------------------------------
        ; Set SAMS registers
        ;------------------------------------------------------
        li    r12,>1e00             ; SAMS CRU address

        sbo   0                     ; Enable access to SAMS registers

        mov  *tmp0+,@>4004          ; Set page for >2000 - >2fff
        mov  *tmp0+,@>4006          ; Set page for >3000 - >3fff
        mov  *tmp0+,@>4014          ; Set page for >a000 - >afff
        mov  *tmp0+,@>4016          ; Set page for >b000 - >bfff
        mov  *tmp0+,@>4018          ; Set page for >c000 - >cfff
        mov  *tmp0+,@>401a          ; Set page for >d000 - >dfff
        mov  *tmp0+,@>401c          ; Set page for >e000 - >efff
        mov  *tmp0+,@>401e          ; Set page for >f000 - >ffff        

        sbz   0                     ; Disable access to SAMS registers
        sbo   1                     ; Enable SAMS mapper
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.layout.exit:        
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
***************************************************************
* SAMS standard page layout table
*--------------------------------------------------------------
sams.layout.standard:
        data  >0200                 ; >2000-2fff, SAMS page >02
        data  >0300                 ; >3000-3fff, SAMS page >03
        data  >0a00                 ; >a000-afff, SAMS page >0a
        data  >0b00                 ; >b000-bfff, SAMS page >0b
        data  >0c00                 ; >c000-cfff, SAMS page >0c
        data  >0d00                 ; >d000-dfff, SAMS page >0d
        data  >0e00                 ; >e000-efff, SAMS page >0e
        data  >0f00                 ; >f000-ffff, SAMS page >0f
