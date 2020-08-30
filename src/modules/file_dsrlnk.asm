* FILE......: file_dsrlnk.asm
* Purpose...: Custom DSRLNK implementation

*//////////////////////////////////////////////////////////////
*                          DSRLNK 
*//////////////////////////////////////////////////////////////


***************************************************************
* dsrlnk - DSRLNK for file I/O in DSR space >1000 - >1F00
***************************************************************
*  blwp @dsrlnk
*  data p0
*--------------------------------------------------------------
*  Input:
*  P0     = 8 or 10 (a)
*  @>8356 = Pointer to VDP PAB file descriptor length (PAB+9)
*--------------------------------------------------------------
*  Output:
*  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned 
*--------------------------------------------------------------
*  Remarks:
*
*  You need to specify following equates in main program
*
*  dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
*  dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
* 
*  Scratchpad memory usage
*  >8322            Parameter (>08) or (>0A) passed to dsrlnk            
*  >8356            Pointer to PAB
*  >83D0            CRU address of current device
*  >83D2            DSR entry address
*  >83e0 - >83ff    GPL / DSRLNK workspace 
* 
*  Credits
*  Originally appeared in Miller Graphics The Smart Programmer.
*  This version based on version of Paolo Bagnaresi.
*
*  The following memory address can be used to directly jump 
*  into the DSR in consequtive calls without having to 
*  scan the PEB cards again:
* 
*  @dsrlnk.savcru - CRU address of device in previous DSR call
*  @dsrlnk.savent - DSR entry address of previous DSR call
*  @dsrlnk.savver - Version used in previous DSR call
*--------------------------------------------------------------
dsrlnk.dstype equ   dsrlnk.dsrlws + 10
                                    ; dstype is address of R5 of DSRLNK ws
dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a                                           
********|*****|*********************|**************************                                     
dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
        data  dsrlnk.init           ; Entry point
        ;------------------------------------------------------
        ; DSRLNK entry point
        ;------------------------------------------------------ 
dsrlnk.init:        
        mov   *r14+,r5              ; Get pgm type for link
        mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
        szcb  @hb$20,r15            ; Reset equal bit in status register
        mov   @>8356,r0             ; Get pointer to PAB+9 in VDP        
        mov   r0,r9                 ; Save pointer
        ;------------------------------------------------------
        ; Fetch file descriptor length from PAB
        ;------------------------------------------------------ 
        ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1 (FLAG byte)
                                    ; FLAG byte->(pabaddr+9)-8
        mov   r9,@dsrlnk.pabflg     ; Save pointer
        ;---------------------------; Inline VSBR start
        swpb  r0                    ; 
        movb  r0,@vdpa              ; Send low byte 
        swpb  r0                    ;
        movb  r0,@vdpa              ; Send high byte
        movb  @vdpr,r3              ; Read byte from VDP RAM
        ;---------------------------; Inline VSBR end
        srl   r3,8                  ; Move to low byte

        ;------------------------------------------------------
        ; Fetch file descriptor device name from PAB
        ;------------------------------------------------------ 
        seto  r4                    ; Init counter
        li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
!       inc   r0                    ; Point to next char of name
        inc   r4                    ; Increment char counter
        ci    r4,>0007              ; Check if length more than 7 chars
        jgt   dsrlnk.error.devicename_invalid
                                    ; Yes, error
        c     r4,r3                 ; End of name?
        jeq   dsrlnk.device_name.get_length
                                    ; Yes

        ;---------------------------; Inline VSBR start
        swpb  r0                    ;
        movb  r0,@vdpa              ; Send low byte 
        swpb  r0                    ;
        movb  r0,@vdpa              ; Send high byte
        movb  @vdpr,r1              ; Read byte from VDP RAM
        ;---------------------------; Inline VSBR end

        ;------------------------------------------------------
        ; Look for end of device name, for example "DSK1."
        ;------------------------------------------------------
        movb  r1,*r2+               ; Move into buffer
        cb    r1,@dsrlnk.period     ; Is character a '.'
        jne   -!                    ; No, loop next char
        ;------------------------------------------------------
        ; Determine device name length
        ;------------------------------------------------------ 
dsrlnk.device_name.get_length:
        mov   r4,r4                 ; Check if length = 0
        jeq   dsrlnk.error.devicename_invalid
                                    ; Yes, error
        clr   @>83d0
        mov   r4,@>8354             ; Save name length for search (length
                                    ; goes to >8355 but overwrites >8354!)

        inc   r4                    ; Adjust for dot
        a     r4,@>8356             ; Point to position after name
        ;------------------------------------------------------
        ; Prepare for DSR scan >1000 - >1f00
        ;------------------------------------------------------ 
dsrlnk.dsrscan.start:        
        lwpi  >83e0                 ; Use GPL WS
        clr   r1                    ; Version found of dsr
        li    r12,>0f00             ; Init cru address
        ;------------------------------------------------------
        ; Turn off ROM on current card
        ;------------------------------------------------------ 
dsrlnk.dsrscan.cardoff:
        mov   r12,r12               ; Anything to turn off?
        jeq   dsrlnk.dsrscan.cardloop
                                    ; No, loop over cards
        sbz   0                     ; Yes, turn off
        ;------------------------------------------------------
        ; Loop over cards and look if DSR present
        ;------------------------------------------------------
dsrlnk.dsrscan.cardloop:        
        ai    r12,>0100             ; Next ROM to turn on
        clr   @>83d0                ; Clear in case we are done
        ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
        jeq   dsrlnk.error.nodsr_found
                                    ; Yes, no matching DSR found
        mov   r12,@>83d0            ; Save address of next cru
        ;------------------------------------------------------
        ; Look at card ROM (@>4000 eq 'AA' ?)
        ;------------------------------------------------------
        sbo   0                     ; Turn on ROM
        li    r2,>4000              ; Start at beginning of ROM
        cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
        jne   dsrlnk.dsrscan.cardoff
                                    ; No ROM found on card
        ;------------------------------------------------------
        ; Valid DSR ROM found. Now loop over chain/subprograms
        ;------------------------------------------------------
        ; dstype is the address of R5 of the DSRLNK workspace,
        ; which is where 8 for a DSR or 10 (>A) for a subprogram
        ; is stored before the DSR ROM is searched.
        ;------------------------------------------------------
        a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
        jmp   dsrlnk.dsrscan.getentry
        ;------------------------------------------------------
        ; Next DSR entry
        ;------------------------------------------------------
dsrlnk.dsrscan.nextentry:        
        mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or 
                                    ; subprogram

        sbo   0                     ; Turn ROM back on
        ;------------------------------------------------------
        ; Get DSR entry
        ;------------------------------------------------------
dsrlnk.dsrscan.getentry:        
        mov   *r2,r2                ; Is address a zero? (end of chain?)
        jeq   dsrlnk.dsrscan.cardoff
                                    ; Yes, no more DSRs or programs to check
        mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
                                    ; subprogram

        inct  r2                    ; Offset 2 > Has call address of current
                                    ; DSR/subprogram code

        mov   *r2+,r9               ; Store call address in r9. Move r2 to 
                                    ; offset 4 (DSR/subprogram name)
        ;------------------------------------------------------
        ; Check file descriptor in DSR
        ;------------------------------------------------------
        clr   r5                    ; Remove any old stuff
        movb  @>8355,r5             ; Get length as counter
        jeq   dsrlnk.dsrscan.call_dsr
                                    ; If zero, do not further check, call DSR
                                    ; program

        cb    r5,*r2+               ; See if length matches
        jne   dsrlnk.dsrscan.nextentry 
                                    ; No, length does not match. 
                                    ; Go process next DSR entry

        srl   r5,8                  ; Yes, move to low byte
        li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
!       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in 
                                    ; DSR ROM
        jne   dsrlnk.dsrscan.nextentry 
                                    ; Try next DSR entry if no match
        dec   r5                    ; Update loop counter
        jne   -!                    ; Loop until full length checked
        ;------------------------------------------------------
        ; Call DSR program in card/device
        ;------------------------------------------------------
dsrlnk.dsrscan.call_dsr:        
        inc   r1                    ; Next version found

        mov   r1,@dsrlnk.savver     ; Save DSR Version number
        mov   r9,@dsrlnk.savent     ; Save DSR entry address
        mov   r12,@dsrlnk.savcru    ; Save CRU address

        li    r15,>8C02             ; Set VDP port address, needed to prevent
                                    ; lockup of TI Disk Controller DSR.
                                    
        bl    *r9                   ; go run routine
        ;
        ; Depending on IO result the DSR in card ROM does RET
        ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
        ;
        jmp   dsrlnk.dsrscan.nextentry
                                    ; (1) error return
        sbz   0                     ; (2) turn off card/device if good return        
        lwpi  dsrlnk.dsrlws         ; (2) restore workspace
        mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
        ;------------------------------------------------------
        ; Returned from DSR
        ;------------------------------------------------------
dsrlnk.dsrscan.return_dsr:
        mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
                                    ; (8 or >a)
        ci    r1,8                  ; was it 8?
        jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
        movb  @>8350,r1             ; no, we have a data >a.
                                    ; Get error byte from @>8350
        jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller

        ;------------------------------------------------------
        ; Read VDP PAB byte 1 after DSR call completed (status)
        ;------------------------------------------------------
dsrlnk.dsrscan.dsr.8:
        ;---------------------------; Inline VSBR start
        swpb  r0                    ;
        movb  r0,@vdpa              ; send low byte 
        swpb  r0                    ;
        movb  r0,@vdpa              ; send high byte
        movb  @vdpr,r1              ; read byte from VDP ram        
        ;---------------------------; Inline VSBR end
        
        ;------------------------------------------------------
        ; Return DSR error to caller 
        ;------------------------------------------------------
dsrlnk.dsrscan.dsr.a:        
        srl   r1,13                 ; just keep error bits
        jne   dsrlnk.error.io_error
                                    ; handle IO error
        rtwp                        ; Return from DSR workspace to caller
                                    ; workspace

        ;------------------------------------------------------
        ; IO-error handler
        ;------------------------------------------------------
dsrlnk.error.nodsr_found_off:        
        sbz   >00                   ; Turn card off, nomatter what
dsrlnk.error.nodsr_found:        
        lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
dsrlnk.error.devicename_invalid:
        clr   r1                    ; clear flag for error 0 = bad device name
dsrlnk.error.io_error:        
        swpb  r1                    ; put error in hi byte
        movb  r1,*r13               ; store error flags in callers r0
        socb  @hb$20,r15            ; \ Set equal bit in copy of status register
                                    ; / to indicate error
        rtwp                        ; Return from DSR workspace to caller
                                    ; workspace


***************************************************************
* dsrln.reuse - Reuse previous DSRLNK call for improved speed
***************************************************************
*  blwp @dsrlnk.reuse
*--------------------------------------------------------------
*  Input:
*  @>8356         = Pointer to VDP PAB file descriptor length byte (PAB+9)
*  @dsrlnk.savcru = CRU address of device in previous DSR call
*  @dsrlnk.savent = DSR entry address of previous DSR call
*  @dsrlnk.savver = Version used in previous DSR call
*  @dsrlnk.pabptr = Pointer to PAB in VDP memory, set in previous DSR call
*--------------------------------------------------------------
*  Output:
*  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned 
*--------------------------------------------------------------
*  Remarks:
*   Call the same DSR entry again without having to scan through
*   all devices again.
*
*   Expects dsrlnk.savver, @dsrlnk.savent, @dsrlnk.savcru to be
*   set by previous DSRLNK call.
********|*****|*********************|**************************
dsrlnk.reuse:
        data  dsrlnk.dsrlws         ; dsrlnk workspace
        data  dsrlnk.reuse.init     ; entry point
        ;------------------------------------------------------
        ; DSRLNK entry point
        ;------------------------------------------------------ 
dsrlnk.reuse.init:        
        lwpi  >83e0                 ; Use GPL WS

        szcb  @hb$20,r15            ; reset equal bit in status register
        ;------------------------------------------------------
        ; Restore @dsrlnk.savcru, @dsrlnk.savent, @dsrlnk.savver
        ;------------------------------------------------------ 
        li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
        mov   *r11+,r12             ; Get CRU address         => @dsrlnk.savcru
        mov   *r11+,r9              ; Get DSR entry address   => @dsrlnk.savent
        mov   *r11+,R1              ; Get DSR Version number  => @dsrlnk.savver
        mov   *r11+,@>8356          ; \ Get pointer to Device => @file.pab.ptr
                                    ; / name or subprogram in PAB
        ;------------------------------------------------------
        ; Call DSR program in card/device
        ;------------------------------------------------------ 
        li    r15,>8C02             ; Set VDP port address, needed to prevent
                                    ; lockup of TI Disk Controller DSR.

        sbo   >00                   ; Open card/device ROM

        cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
        jne   dsrlnk.error.nodsr_found
                                    ; No, error code 0 = Bad Device name
                                    ; The above jump may happen only in case of
                                    ; either card hardware malfunction or if
                                    ; there are 2 cards opened at the same time.

        bl    *r9                   ; go run routine
        ;
        ; Depending on IO result the DSR in card ROM does RET
        ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
        ;
        nop
        ;jmp   dsrlnk.error.nodsr_found_off
                                    ; (1) error return
        sbz   >00                   ; (2) turn off card ROM if good return        
        ;------------------------------------------------------
        ; Now check if any DSR error occured
        ;------------------------------------------------------ 
        lwpi  dsrlnk.dsrlws         ; Restore workspace
        mov   @dsrlnk.pabflg,r0     ; Point to flag byte (PAB+1) in VDP PAB

        jmp   dsrlnk.dsrscan.return_dsr
                                    ; Rest is the same as with normal DSRLNK


********************************************************************************

dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
                                    ; a @blwp @dsrlnk
dsrlnk.period     text  '.'         ; For finding end of device name

        even