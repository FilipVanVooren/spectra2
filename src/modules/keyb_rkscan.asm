* FILE......: keyb_rkscan.asm
* Purpose...: Full (real) keyboard support module

*//////////////////////////////////////////////////////////////
*                     KEYBOARD FUNCTIONS 
*//////////////////////////////////////////////////////////////

***************************************************************
* RKSCAN - Scan keyboard using ROM#0 OS monitor KSCAN
***************************************************************
*  BL @RKSCAN
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Scratchpad usage by console KSCAN:
*
* >8373  I/O:    LSB of GPL subroutine stack pointer 80 = (>8380)
* >8374  Input:  keyboard scan mode (default=0)
* >8375  Output: ASCII code detected by keyboard scan
* >8376  Output: Joystick Y-status by keyboard scan
* >8377  Output: Joystick X-status by keyboard scan
* >837c  Output: GPL status byte (>20 if key pressed)
* >838a  I/O:    GPL substack
* >838c  I/O:    GPL substack
* >83c6  I/O:    ISRWS R3 Keyboard state and debounce info 
* >83c8  I/O:    ISRWS R4 Keyboard state and debounce info 
* >83ca  I/O:    ISRWS R5 Keyboard state and debounce info 
* >83d4  I/O:    ISRWS R10 Contents of VDP register 01
* >83d6  I/O:    ISRWS R11 Screen timeout counter, blanks when 0000
* >83d8  I/O:    ISRWS R12 (Backup return address old R11 in GPLWS)
* >83f8  output: GPLWS R12 (CRU base address for key scan)
* >83fa  output: GPLWS R13 (GROM/GRAM read data port 9800)
* >83fe  I/O:    GPLWS R15 (VDP write address port 8c02)
********|*****|*********************|**************************
rkscan:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; (1) Check for alpha lock
        ;------------------------------------------------------ 
        szc   @wbit10,config        ; Reset CONFIG register bit 10=0
         
        ; See CRU interface and keyboard sections for details
        ; http://www.nouspikel.com/ti99/titechpages.htm

        clr   r12                   ; Set base address (to bit 0) so 
                                    ; following offsets correspond 

        sbz   >0015                 ; \ Set bit 21 (PIN 5 attached to alpha
                                    ; / lock column) to 0.

        tb    7                     ; \ Copy CRU bit 7 into EQ bit
                                    ; | That is CRU INT7*/P15 pin (keyboard row
                                    ; | with keys FCTN, 2,3,4,5,1,
                                    ; / [joy1-up,joy2-up, Alpha Lock])

        jeq   rkscan.prepare        ; No, alpha lock is off

        soc   @wbit10,config        ; \ Yes, alpha lock is on.
                                    ; / Set CONFIG register bit 10=1
        ;------------------------------------------------------
        ; (2) Prepare for OS monitor kscan
        ;------------------------------------------------------     
rkscan.prepare:        
        mov   @scrpad.83c6,@>83c6   ; Required for lowercase support
        mov   @scrpad.83fa,@>83fa   ; Load GPLWS R13
        mov   @scrpad.83fe,@>83fe   ; Load GPLWS R15

        clr   tmp0                  ; \ Keyboard mode in MSB
                                    ; / 00=Scan all of keyboard
                                  
        movb  tmp0,@>8374           ; Set keyboard mode at @>8374
                                    ; (scan entire keyboard)

        lwpi  >83e0                 ; Activate GPL workspace
        bl    @kscan                ; Call KSCAN 
        lwpi  ws1                   ; Activate user workspace
        ;------------------------------------------------------
        ; (3) Check if key pressed
        ;------------------------------------------------------
        movb  @>837c,tmp0           ; Get flag
        sla   tmp0,3                ; Flag value is >20
        jnc   rkscan.exit           ; No key pressed, exit early
        ;------------------------------------------------------
        ; (4) Key detected, store in memory
        ;------------------------------------------------------  
        movb  @>8375,tmp0           ; \ Key pressed is at @>8375
        srl   tmp0,8                ; / Move to LSB
   .ifdef rom0_kscan_out
        mov   tmp0,@rom0_kscan_out  ; Store ASCII value in user location
   .else   
        mov   tmp0,@waux1           ; Store ASCII value in WAUX1 location
   .endif        
        soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
rkscan.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


scrpad.83c6   data >0200            ; Required for KSCAN to support lowercase
scrpad.83fa   data >9800

; Dummy value for GPLWS R15 (instead of VDP write address port 8c02)
; We do not want console KSCAN to fiddle with VDP registers while Stevie
; is running

scrpad.83fe   data >83a0            ; 8c02