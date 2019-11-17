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
io.op.scratch    equ >08            ; SCRATCH 
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
* File error codes - Bits 13-15 in PAB byte 1
************************************@**************************
io.err.no_error_occured             equ 0
        ; Error code 0 with condition bit reset, indicates that
        ; no error has occured

io.err.bad_device_name              equ 0
        ; Device indicated not in system
        ; Error code 0 with condition bit set, indicates a
        ; device not present in system

io.err.device_write_prottected      equ 1   
        ; Device is write protected

io.err.bad_open_attribute           equ 2   
        ; One or more of the OPEN attributes are illegal or do
        ; not match the file's actual characteristics.
        ; This could be:
        ;   * File type
        ;   * Record length
        ;   * I/O mode
        ;   * File organization

io.err.illegal_operation            equ 3
        ; Either an issued I/O command was not supported, or a 
        ; conflict with the OPEN mode has occured

io.err.out_of_table_buffer_space    equ 4
        ; The amount of space left on the device is insufficient
        ; for the requested operation

io.err.eof                          equ 5
        ; Attempt to read past end of file.
        ; This error may also be given for non-existing records
        ; in a relative record file

io.err.device_error                 equ 6
        ; Covers all hard device errors, such as parity and
        ; bad medium errors

io.err.file_error                   equ 7
        ; Covers all file-related error like: program/data
        ; file mismatch, non-existing file opened for input mode, etc.


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
;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
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
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
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
        data  8                     ; Level 2 IO call
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
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
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
***************************************************************
* Called internally via JMP/B by file operations
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
********@*****@*********************@**************************

********@*****@*********************@**************************
file.record.pab.details:
        stst  tmp2                  ; Store status register contents in tmp2
                                    ; Upon DSRLNK return status register EQ bit
                                    ; 1 = No file error
                                    ; 0 = File error occured
*--------------------------------------------------------------
* Get PAB byte 5 from VDP ram into tmp1 (character count)
*--------------------------------------------------------------        
        mov   @>8356,tmp0           ; Get PAB VDP address + 9
        ai    tmp0,-4               ; Get address of PAB + 5
        bl    @xvgetb               ; VDP read PAB status byte into tmp0
        mov   tmp0,tmp1             ; Move to destination
*--------------------------------------------------------------
* Get PAB byte 1 from VDP ram into tmp0 (status)
*--------------------------------------------------------------        
        mov   r0,tmp0               ; VDP PAB byte 1 (status) 
                                    ; as returned by DSRLNK                                    
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
; If an error occured during the IO operation, then the 
; equal bit in the saved status register (=R2) is set to 1.
; 
; If no error occured during the IO operation, then the 
; equal bit in the saved status register (=R2) is set to 0.
;
; Upon return from this IO call you should basically test with:
;       coc   @wbit2,tmp2           ; Equal bit set?
;       jeq   my_file_io_handler    ; Yes, IO error occured
;
; Then look for further details in the copy of VDP PAB byte 1
; in register tmp0, bits 13-15
;
;       srl   tmp0,8                ; Right align (only for DSR type >8
;                                   ; calls, skip for type >A subprograms!)
;       ci    tmp0,io.err.<code>    ; Check for error pattern
;       jeq   my_error_handler      
*--------------------------------------------------------------
file.record.pab.details.exit:
        b     *r1                   ; Return to caller