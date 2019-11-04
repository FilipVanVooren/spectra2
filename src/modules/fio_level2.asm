* FILE......: fio_level2.asm
* Purpose...: File I/O level 2 support 

***************************************************************
* File IO operations
************************************@**************************
io.op.open       equ >00            ; OPEN
io.op.close      equ >01            ; CLOSE
io.op.read       equ >02            ; READ
io.op.write      equ >03            ; WRITE
io.op.rewind     equ >04            ; RESTORE/REWIND
io.op.load       equ >05            ; LOAD
io.op.save       equ >06            ; SAVE
io.op.delfile    equ >07            ; DELETE FILE
io.op.status     equ >09            ; STATUS
***************************************************************
* File types - All relative files are fixed length
************************************@**************************
io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
***************************************************************
* File types - Sequential files
************************************@**************************
io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL


***************************************************************
* PAB  - Peripheral Access Block
********@*****@*********************@**************************
; my_pab:
;       byte  io.op.open            ;  0    - OPEN
;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
;                                   ;         Bit 13-15 used by DSR for returning
;                                   ;         file error details to DSRLNK
;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
;       byte  80                    ;  4    - Record length (80 characters maximum)
;       byte  0                     ;  5    - Character count (bytes read)
;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
; -------------------------------------------------------------
;       byte  11                    ;  9    - File descriptor length
;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor (Device + '.' + File name)
;       even
***************************************************************



***************************************************************
* file.open - Open File for procesing
***************************************************************
*  bl   @file.open
*  data P0
*--------------------------------------------------------------
*  P0 = Address of PAB in VDP RAM
*--------------------------------------------------------------
*  bl   @xfile.open
*
*  R0 = Address of PAB in VDP RAM
********@*****@*********************@**************************
file.open:
        mov   *r11+,r0              ; Get file descriptor (P0)
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
xfile.open:
        mov   r11,r1                ; Save return address
        mov   r0,tmp0               ; VDP write address (PAB byte 0)
        clr   tmp1                  ; io.op.open
        bl    @xvputb               ; Write file opcode to VDP
file.open_init:
        ai    r0,9                  ; Move to file descriptor length
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
*--------------------------------------------------------------
* Main 
*--------------------------------------------------------------
file.open_main:
        blwp  @dsrlnk               ; Call DSRLNK 
        data  8                     ; Level 2 IO
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
file.open_exit:
        jmp   file.record.pab.details
                                    ; Get status and return to caller
                                    ; Status register bits are unaffected



***************************************************************
* file.close - Close currently open file
***************************************************************
*  bl   @file.close
*  data P0
*--------------------------------------------------------------
*  P0 = Address of PAB in VDP RAM
*--------------------------------------------------------------
*  bl   @xfile.close
*
*  R0 = Address of PAB in VD RAM
********@*****@*********************@**************************
file.close:
        mov   *r11+,r0              ; Get file descriptor (P0)
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
xfile.close:
        mov   r11,r1                ; Save return address
        mov   r0,tmp0               ; VDP write address (PAB byte 0)
        li    tmp1,io.op.close      ; io.op.close
        bl    @xvputb               ; Write file opcode to VDP
file.close_init:
        ai    r0,9                  ; Move to file descriptor length
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
*--------------------------------------------------------------
* Main 
*--------------------------------------------------------------
file.close_main:
        blwp  @dsrlnk               ; Call DSRLNK 
        data  8                     ; 
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
file.close_exit:
        jmp   file.record.pab.details
                                    ; Get status and return to caller
                                    ; Status register bits are unaffected





***************************************************************
* file.record.read - Read record from file
***************************************************************
*  bl   @file.record.read
*  data P0
*--------------------------------------------------------------
*  P0 = Address of PAB in VDP RAM (without +9 offset!)
*--------------------------------------------------------------
*  bl   @xfile.record.read
*
*  R0 = Address of PAB in VDP RAM
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
********@*****@*********************@**************************
file.record.read:
        mov   *r11+,r0              ; Get file descriptor (P0)
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
xfile.record.read:
        mov   r11,r1                ; Save return address
        mov   r0,tmp0               ; VDP write address (PAB byte 0)
        li    tmp1,io.op.read       ; io.op.read
        bl    @xvputb               ; Write file opcode to VDP
file.record.read_init:
        ai    r0,9                  ; Move to file descriptor length
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
*--------------------------------------------------------------
* Main 
*--------------------------------------------------------------
file.record.read_main:
        blwp  @dsrlnk               ; Call DSRLNK 
        data  8                     ;         
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
file.record.read_exit:
        jmp   file.record.pab.details
                                    ; Get status and return to caller
                                    ; Status register bits are unaffected




file.record.write:
        nop


file.record.seek:
        nop


file.image.load:
        nop


file.image.save:
        nop


file.delete:
        nop


file.rename:
        nop


file.status:
        nop



***************************************************************
* file.record.pab.details - Return PAB details to caller
********@*****@*********************@**************************
file.record.pab.details:
        stst  tmp2                  ; Store status register contents in tmp2
                                    ; Upon DSRLNK return status register EQ bit
                                    ; 1 = No file error
                                    ; 0 = File error occured
*--------------------------------------------------------------
* Get PAB byte 5 from VDP ram into tmp1
*--------------------------------------------------------------        
        mov   @>8356,tmp0           ; Get PAB VDP address + 9
        ai    tmp0,-4               ; Get address of PAB + 5
        bl    @xvgetb               ; VDP read PAB status byte into tmp0
        mov   tmp0,tmp1             ; Move to destination
*--------------------------------------------------------------
* Get PAB status byte from VDP ram into tmp0
*--------------------------------------------------------------        
        mov   @>8356,tmp0           ; Get PAB VDP address + 9
        ai    tmp0,-8               ; Get address of PAB + 1
        bl    @xvgetb               ; VDP read PAB status byte into tmp0
*--------------------------------------------------------------
* Check if error occured during file open operation
*--------------------------------------------------------------        
        coc   @wbit2,tmp2           ; Equal bit set?
        jeq   file.error            ; Jump to error handler 
        b     *r1                   ; Return to caller



***************************************************************
* file.error - Error handler for file errors
********@*****@*********************@**************************
file.error:
;
; When errors do occur then equal bit in status register is set (1)
; If no errors occur, then equal bit in status register is reset (0)
;
; So upon returning from DSRLNK in your file handling code you
; should basically add:
;
;       jeq   file.error            ; Jump to error handler 
;
*--------------------------------------------------------------
        b     @crash_handler        ; A File error occured