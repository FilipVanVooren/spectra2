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

        li    r12,>002a             ; Address of alpha lock
        sbz   0                     ; Set wire low
        li    r12,>000e             ; Select keyboard row 5
        tb    0                     ; Test input wire (ALPHA-Lock key down?)
        sbo   0                     ; Set wire high
        jeq   rkscan.prepare        ; No, alpha lock is off
        soc   @wbit10,config        ; \ Yes, alpha lock is on, so
                                    ; / set CONFIG register bit 10=1
        ;------------------------------------------------------
        ; (2) Prepare for OS monitor kscan
        ;------------------------------------------------------     
rkscan.prepare:        
        mov   @scrpad.83fa,@>83fa   ; Load GPLWS R13
        mov   @scrpad.83fe,@>83fe   ; Load GPLWS R15

        ; Byte at scratchpad @>836c = 02 if mode is 5 (mixed case)
        ; Byte at scratchpad @>836c = 00 if mode is 0 (upper case only)

        li    tmp0,>0500            ; \ Keyboard mode in MSB
                                    ; | 00=Upper case only
                                    ; / 05=Mixed case

        movb  tmp0,@>8374           ; Set keyboard mode at @>8374
                                    ; (scan entire keyboard)

        lwpi  >83e0                 ; Activate GPL workspace
        bl    @kscan                ; Call KSCAN 
        lwpi  ws1                   ; Activate user workspace
        ;------------------------------------------------------
        ; (3) Check if key pressed
        ;------------------------------------------------------
        mov   @>8374,tmp0           ; \ Key pressed is at @>8375
        andi  tmp0,>00ff            ; / Only keep LSB

        ci    tmp0,>ff              ; Key pressed?
        jeq   rkscan.exit           ; No, exit early
        ;------------------------------------------------------
        ; (4) Key detected, store in memory
        ;------------------------------------------------------     
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



scrpad.83fa   data >9800

; Dummy value for GPLWS R15 (instead of VDP write address port 8c02)
; We do not want console KSCAN to fiddle with VDP registers while Stevie
; is running

scrpad.83fe   data >83a0            ; 8c02