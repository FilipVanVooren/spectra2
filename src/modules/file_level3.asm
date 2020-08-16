* FILE......: file_level3.asm
* Purpose...: File I/O level 3 support 


***************************************************************
* PAB  - Peripheral Access Block
********|*****|*********************|**************************
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
*       data P0,P1
*--------------------------------------------------------------
*  P0 = Address of PAB in VDP RAM
*  P1 = LSB contains File type/mode
*--------------------------------------------------------------
*  bl   @xfile.open
*
*  R0 = Address of PAB in VDP RAM
*  R1 = LSB contains File type/mode
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
********|*****|*********************|**************************
file.open:
        mov   *r11+,r0              ; Get file descriptor (P0)
        mov   *r11+,r1              ; Get file type/mode
        mov   r11,r2                ; Save return address        
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
xfile.open:
        mov   r1,@fh.filetype       ; Set file type/mode
        clr   tmp1                  ; io.op.open
        jmp   _file.record.fop      ; Do file operation



***************************************************************
* file.close - Close currently open file
***************************************************************
*  bl   @file.close
*       data P0
*--------------------------------------------------------------
*  P0 = Address of PAB in VDP RAM
*--------------------------------------------------------------
*  bl   @xfile.close
*
*  R0 = Address of PAB in VDP RAM
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
********|*****|*********************|**************************
file.close:
        mov   *r11+,r0              ; Get file descriptor (P0)
        mov   r11,r2                ; Save return address        
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
xfile.close:
        li    tmp1,io.op.close      ; io.op.close
        jmp   _file.record.fop      ; Do file operation


***************************************************************
* file.record.read - Read record from file
***************************************************************
*  bl   @file.record.read
*       data P0
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
********|*****|*********************|**************************
file.record.read:
        mov   *r11+,r0              ; Get file descriptor (P0)
        mov   r11,r2                ; Save return address
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
        li    tmp1,io.op.read       ; io.op.read
        jmp   _file.record.fop      ; Do file operation
        


***************************************************************
* file.record.write - Write record to file
***************************************************************
*  bl   @file.record.write
*       data P0
*--------------------------------------------------------------
*  P0 = Address of PAB in VDP RAM (without +9 offset!)
*--------------------------------------------------------------
*  bl   @xfile.record.write
*
*  R0 = Address of PAB in VDP RAM
*--------------------------------------------------------------
*  Output:
*  tmp0 LSB = VDP PAB byte 1 (status) 
*  tmp1 LSB = VDP PAB byte 5 (characters read)
*  tmp2     = Status register contents upon DSRLNK return
********|*****|*********************|**************************
file.record.write:
        mov   *r11+,r0              ; Get file descriptor (P0)
        mov   r11,r2                ; Save return address        
*--------------------------------------------------------------
* Initialisation
*--------------------------------------------------------------
        mov   r0,tmp0               ; VDP write address (PAB byte 0)
        ai    tmp0,5                ; Position to PAB byte 5

        mov   @fh.reclen,tmp1       ; Get record length

        bl    @xvputb               ; Write character count to PAB
                                    ; \ i  tmp0 = VDP target address
                                    ; / i  tmp1 = Byte to write

        li    tmp1,io.op.write      ; io.op.write
        jmp   _file.record.fop      ; Do file operation



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
* file.record.fop - File operation
***************************************************************
* Called internally via JMP/B by file operations
*--------------------------------------------------------------
*  Input:
*  r0   = Address of PAB in VDP RAM
*  r1   = File type/mode
*  tmp1 = File operation opcode
*--------------------------------------------------------------
*  Output:
*  tmp2 = Saved status register
*--------------------------------------------------------------
*  Register usage:
*  r0, r1, r2, tmp0, tmp1, tmp2
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside fio_level2 module
*  via jump or branch instruction.
*
*  Uses @waux1 for backup/restore of memory word @>8322
********|*****|*********************|**************************
_file.record.fop:
        ;------------------------------------------------------
        ; Write to PAB required?
        ;------------------------------------------------------   
        mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB 
        ;------------------------------------------------------
        ; Set file opcode in VDP PAB
        ;------------------------------------------------------   
        mov   r0,tmp0               ; VDP write address (PAB byte 0)

        bl    @xvputb               ; Write file opcode to VDP
                                    ; \ i  tmp0 = VDP target address
                                    ; / i  tmp1 = Byte to write
        ;------------------------------------------------------
        ; Set file type/mode in VDP PAB
        ;------------------------------------------------------ 
        mov   r0,tmp0               ; VDP write address (PAB byte 0)
        inc   tmp0                  ; Next byte in PAB
        mov   @fh.filetype,tmp1     ; Get file type/mode

        bl    @xvputb               ; Write file type/mode to VDP
                                    ; \ i  tmp0 = VDP target address
                                    ; / i  tmp1 = Byte to write
        ;------------------------------------------------------
        ; Prepare for DSRLINK
        ;------------------------------------------------------ 
!       ai    r0,9                  ; Move to file descriptor length
        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
*--------------------------------------------------------------
* Call DSRLINK for doing file operation
*--------------------------------------------------------------
        mov   @>8322,@waux1         ; Save word at @>8322

        blwp  @dsrlnk               ; Call DSRLNK 
        data  8                     ;         
*--------------------------------------------------------------
* Return PAB details to caller
*--------------------------------------------------------------
_file.record.fop.pab:
        stst  tmp2                  ; Store status register contents in tmp2
                                    ; Upon DSRLNK return status register EQ bit
                                    ; 1 = No file error
                                    ; 0 = File error occured

        mov   @waux1,@>8322         ; Restore word at @>83223
*--------------------------------------------------------------
* Get PAB byte 5 from VDP ram into tmp1 (character count)
*--------------------------------------------------------------        
        mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
        ai    tmp0,5                ; Get address of VDP PAB byte 5
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
; equal bit in the saved status register (=tmp2) is set to 1.
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
_file.record.fop.exit:
        b     *r2                   ; Return to caller