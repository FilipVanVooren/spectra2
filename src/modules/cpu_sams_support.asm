* FILE......: cpu_sams_support.asm
* Purpose...: Low level support for SAMS memory expansion card

*//////////////////////////////////////////////////////////////
*                SAMS Memory Expansion support
*//////////////////////////////////////////////////////////////

*--------------------------------------------------------------
* ACCESS and MAPPING
* (by the late Bruce Harisson):
*
* To use other than the default setup, you have to do two
* things:
*
* 1. You have to "turn on" the card's memory in the
*    >4000 block and write to the mapping registers there.
*    (bl  @sams.page.set)
* 
* 2. You have to "turn on" the mapper function to make what
*    you've written into the >4000 block take effect.  
*    (bl  @sams.mapping.on)
*--------------------------------------------------------------
*  SAMS                          Default SAMS page
*  Register     Memory bank      (system startup)
*  =======      ===========      ================
*  >4004        >2000-2fff          >002
*  >4006        >3000-4fff          >003
*  >4014        >a000-afff          >00a
*  >4016        >b000-bfff          >00b
*  >4018        >c000-cfff          >00c
*  >401a        >d000-dfff          >00d
*  >401c        >e000-efff          >00e
*  >401e        >f000-ffff          >00f
*  Others       Inactive
*--------------------------------------------------------------




***************************************************************
* sams.page.get - Get SAMS page number for memory address
***************************************************************
* bl   @sams.page.get
*      data P0
*--------------------------------------------------------------
* P0 = Memory address (e.g. address >a100 will map to SAMS
*      register >4014 (bank >a000 - >afff)
*--------------------------------------------------------------
* bl   @xsams.page.get
*
* tmp0 = Memory address (e.g. address >a100 will map to SAMS
*        register >4014 (bank >a000 - >afff)
*--------------------------------------------------------------
* OUTPUT
* waux1 = SAMS page number
* waux2 = Address of affected SAMS register
*--------------------------------------------------------------
* Register usage
* r0, tmp0, r12
********|*****|*********************|**************************
sams.page.get:
        mov   *r11+,tmp0            ; Memory address
xsams.page.get:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   r0,*stack             ; Push r0
        dect  stack
        mov   r12,*stack            ; Push r12
*--------------------------------------------------------------
* Determine memory bank
*--------------------------------------------------------------
        srl   tmp0,12               ; Reduce address to 4K chunks 
        sla   tmp0,1                ; Registers are 2 bytes appart        

        ai    tmp0,>4000            ; Add base address of "DSR" space        
        mov   tmp0,@waux2           ; Save address of SAMS register
*--------------------------------------------------------------
* Get SAMS page number
*--------------------------------------------------------------
        li    r12,>1e00             ; SAMS CRU address
        clr   r0
        sbo   0                     ; Enable access to SAMS registers 
        movb  *tmp0,r0              ; Get SAMS page number
        movb  r0,tmp0
        srl   tmp0,8                ; Right align
        mov   tmp0,@waux1           ; Save SAMS page number
        sbz   0                     ; Disable access to SAMS registers
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.page.get.exit:
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,r0            ; Pop r0
        mov   *stack+,r11           ; Pop return address
        b     *r11                  ; Return to caller       




***************************************************************
* sams.page.set - Set SAMS memory page
***************************************************************
* bl   sams.page.set
*      data P0,P1
*--------------------------------------------------------------
* P0 = SAMS page number
* P1 = Memory address (e.g. address >a100 will map to SAMS
*      register >4014 (bank >a000 - >afff)
*--------------------------------------------------------------
* bl   @xsams.page.set
*
* tmp0 = SAMS page number
* tmp1 = Memory address (e.g. address >a100 will map to SAMS
*        register >4014 (bank >a000 - >afff)
*--------------------------------------------------------------
* Register usage
* r0, tmp0, tmp1, r12
*--------------------------------------------------------------
* SAMS page number should be in range 0-255 (>00 to >ff)
*
*  Page         Memory
*  ====         ====== 
*  >00             32K
*  >1f            128K
*  >3f            256K
*  >7f            512K
*  >ff           1024K
********|*****|*********************|**************************
sams.page.set:
        mov   *r11+,tmp0            ; Get SAMS page
        mov   *r11+,tmp1            ; Get memory address
xsams.page.set:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   r0,*stack             ; Push r0
        dect  stack
        mov   r12,*stack            ; Push r12
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
*--------------------------------------------------------------
* Determine memory bank
*--------------------------------------------------------------
        srl   tmp1,12               ; Reduce address to 4K chunks 
        sla   tmp1,1                ; Registers are 2 bytes appart
*--------------------------------------------------------------
* Assert on SAMS page number
*--------------------------------------------------------------
        ci    tmp0,255              ; Crash if page > 255
        jgt   !
*--------------------------------------------------------------
* Assert on SAMS register
*--------------------------------------------------------------
        ci    tmp1,>1e              ; r@401e   >f000 - >ffff
        jgt   !
        ci    tmp1,>04              ; r@4004   >2000 - >2fff
        jlt   !
        ci    tmp1,>12              ; r@4014   >a000 - >ffff
        jgt   sams.page.set.switch_page
        ci    tmp1,>06              ; r@4006   >3000 - >3fff
        jgt   !
        jmp   sams.page.set.switch_page
        ;------------------------------------------------------
        ; Crash the system
        ;------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system
*--------------------------------------------------------------
* Switch memory bank to specified SAMS page
*--------------------------------------------------------------
sams.page.set.switch_page
        li    r12,>1e00             ; SAMS CRU address
        mov   tmp0,r0               ; Must be in r0 for CRU use
        swpb  r0                    ; LSB to MSB      
        sbo   0                     ; Enable access to SAMS registers 
        movb  r0,@>4000(tmp1)       ; Set SAMS bank number
        sbz   0                     ; Disable access to SAMS registers
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.page.set.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,r0            ; Pop r0
        mov   *stack+,r11           ; Pop return address
        b     *r11                  ; Return to caller       




***************************************************************
* sams.mapping.on - Enable SAMS mapping mode
***************************************************************
*  bl   @sams.mapping.on
*--------------------------------------------------------------
*  Register usage
*  r12
********|*****|*********************|**************************
sams.mapping.on:
        li    r12,>1e00             ; SAMS CRU address
        sbo   1                     ; Enable SAMS mapper
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.mapping.on.exit:
        b     *r11                  ; Return to caller       




***************************************************************
* sams.mapping.off - Disable SAMS mapping mode
***************************************************************
* bl  @sams.mapping.off
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r12
********|*****|*********************|**************************
sams.mapping.off:
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
sams.mapping.off.exit:
        b     *r11                  ; Return to caller       





***************************************************************
* sams.layout
* Setup SAMS memory banks
***************************************************************
* bl  @sams.layout
*     data P0
*--------------------------------------------------------------
* INPUT
* P0 = Pointer to SAMS page layout table (16 words).
*--------------------------------------------------------------
* bl  @xsams.layout
*
* tmp0 = Pointer to SAMS page layout table (16 words).
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
********|*****|*********************|**************************
sams.layout:
        mov   *r11+,tmp3            ; Get P0
xsams.layout:          
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Save tmp0
        dect  stack
        mov   tmp1,*stack           ; Save tmp1
        dect  stack
        mov   tmp2,*stack           ; Save tmp2
        dect  stack
        mov   tmp3,*stack           ; Save tmp3
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp2,8                ; Set loop counter
        ;------------------------------------------------------
        ; Set SAMS memory pages
        ;------------------------------------------------------
sams.layout.loop:        
        mov   *tmp3+,tmp1           ; Get memory address
        mov   *tmp3+,tmp0           ; Get SAMS page

        bl    @xsams.page.set       ; \ Switch SAMS page
                                    ; | i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address

        dec   tmp2                  ; Next iteration
        jne   sams.layout.loop      ; Loop until done
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.init.exit:        
        bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
                                    ; / activating changes.

        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* sams.layout.reset
* Reset SAMS memory banks to standard layout
***************************************************************
* bl  @sams.layout.reset
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
sams.layout.reset:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS standard layout
        ;------------------------------------------------------        
        bl    @sams.layout
              data sams.layout.standard
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.layout.reset.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
***************************************************************
* SAMS standard page layout table (16 words)
*--------------------------------------------------------------
sams.layout.standard:
        data  >2000,>0002           ; >2000-2fff, SAMS page >02
        data  >3000,>0003           ; >3000-3fff, SAMS page >03
        data  >a000,>000a           ; >a000-afff, SAMS page >0a
        data  >b000,>000b           ; >b000-bfff, SAMS page >0b
        data  >c000,>000c           ; >c000-cfff, SAMS page >0c
        data  >d000,>000d           ; >d000-dfff, SAMS page >0d
        data  >e000,>000e           ; >e000-efff, SAMS page >0e
        data  >f000,>000f           ; >f000-ffff, SAMS page >0f



***************************************************************
* sams.layout.copy
* Copy SAMS memory layout
***************************************************************
* bl  @sams.layout.copy
*     data P0
*--------------------------------------------------------------
* P0 = Pointer to 8 words RAM buffer for results
*--------------------------------------------------------------
* OUTPUT
* RAM buffer will have the SAMS page number for each range
* 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
***************************************************************
sams.layout.copy:
        mov   *r11+,tmp3            ; Get P0

        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;------------------------------------------------------
        ; Copy SAMS layout
        ;------------------------------------------------------        
        li    tmp1,sams.layout.copy.data
        li    tmp2,8                ; Set loop counter
        ;------------------------------------------------------
        ; Set SAMS memory pages
        ;------------------------------------------------------
sams.layout.copy.loop:        
        mov   *tmp1+,tmp0           ; Get memory address
        bl    @xsams.page.get       ; \ Get SAMS page
                                    ; | i  tmp0   = Memory address
                                    ; / o  @waux1 = SAMS page

        mov   @waux1,*tmp3+         ; Copy SAMS page number

        dec   tmp2                  ; Next iteration
        jne   sams.layout.copy.loop ; Loop until done
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.layout.copy.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
***************************************************************
* SAMS memory range table (8 words)
*--------------------------------------------------------------
sams.layout.copy.data:
        data  >2000                 ; >2000-2fff
        data  >3000                 ; >3000-3fff
        data  >a000                 ; >a000-afff
        data  >b000                 ; >b000-bfff
        data  >c000                 ; >c000-cfff
        data  >d000                 ; >d000-dfff
        data  >e000                 ; >e000-efff
        data  >f000                 ; >f000-ffff

