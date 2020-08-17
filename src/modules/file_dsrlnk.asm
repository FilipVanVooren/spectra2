* FILE......: file_dsrlnk.asm
* Purpose...: Custom DSRLNK implementation

*//////////////////////////////////////////////////////////////
*                          DSRLNK 
*//////////////////////////////////////////////////////////////
                                    

***************************************************************
* dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
***************************************************************
*  blwp @dsrlnk
*  data p0
*--------------------------------------------------------------
*  P0 = 8 or 10 (a)
*--------------------------------------------------------------
*  Output:
*  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned 
*--------------------------------------------------------------
; Spectra2 scratchpad memory needs to be paged out before.
; You need to specify following equates in main program
;
; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
; 
; Scratchpad memory usage
; >8322            Parameter (>08) or (>0A) passed to dsrlnk            
; >8356            Pointer to PAB
; >83D0            CRU address of current device
; >83D2            DSR entry address
; >83e0 - >83ff    GPL / DSRLNK workspace 
; 
; Credits
; Originally appeared in Miller Graphics The Smart Programmer.
; This version based on version of Paolo Bagnaresi.
*--------------------------------------------------------------
dsrlnk.dstype equ   dsrlnk.dsrlws + 10
                                    ; dstype is address of R5 of DSRLNK ws
dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a                                           
********|*****|*********************|**************************                                     
dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
        data  dsrlnk.init           ; entry point
        ;------------------------------------------------------
        ; DSRLNK entry point
        ;------------------------------------------------------ 
dsrlnk.init:        
        mov   *r14+,r5              ; get pgm type for link
        mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
        szcb  @hb$20,r15            ; reset equal bit
        mov   @>8356,r0             ; get ptr to pab
        mov   r0,r9                 ; save ptr
        ;------------------------------------------------------
        ; Fetch file descriptor length from PAB
        ;------------------------------------------------------ 
        ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8

        ;---------------------------; Inline VSBR start
        swpb  r0                    ; 
        movb  r0,@vdpa              ; send low byte 
        swpb  r0                    ;
        movb  r0,@vdpa              ; send high byte
        movb  @vdpr,r3              ; read byte from VDP ram
        ;---------------------------; Inline VSBR end
        srl   r3,8                  ; Move to low byte

        ;------------------------------------------------------
        ; Fetch file descriptor device name from PAB
        ;------------------------------------------------------ 
        seto  r4                    ; init counter
        li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
!       inc   r0                    ; point to next char of name
        inc   r4                    ; incr char counter
        ci    r4,>0007              ; see if length more than 7 chars
        jgt   dsrlnk.error.devicename_invalid
                                    ; yes, error
        c     r4,r3                 ; end of name?
        jeq   dsrlnk.device_name.get_length
                                    ; yes

        ;---------------------------; Inline VSBR start
        swpb  r0                    ;
        movb  r0,@vdpa              ; send low byte 
        swpb  r0                    ;
        movb  r0,@vdpa              ; send high byte
        movb  @vdpr,r1              ; read byte from VDP ram
        ;---------------------------; Inline VSBR end

        ;------------------------------------------------------
        ; Look for end of device name, for example "DSK1."
        ;------------------------------------------------------
        movb  r1,*r2+               ; move into buffer
        cb    r1,@dsrlnk.period     ; is character a '.'
        jne   -!                    ; no, loop next char
        ;------------------------------------------------------
        ; Determine device name length
        ;------------------------------------------------------ 
dsrlnk.device_name.get_length:
        mov   r4,r4                 ; Check if length = 0
        jeq   dsrlnk.error.devicename_invalid
                                    ; yes, error
        clr   @>83d0
        mov   r4,@>8354             ; save name length for search
        inc   r4                    ; adjust for dot
        a     r4,@>8356             ; point to position after name
        ;------------------------------------------------------
        ; Prepare for DSR scan >1000 - >1f00
        ;------------------------------------------------------ 
dsrlnk.dsrscan.start:        
        lwpi  >83e0                 ; Use GPL WS
        clr   r1                    ; version found of dsr
        li    r12,>0f00             ; init cru addr
        ;------------------------------------------------------
        ; Turn off ROM on current card
        ;------------------------------------------------------ 
dsrlnk.dsrscan.cardoff:
        mov   r12,r12               ; anything to turn off?
        jeq   dsrlnk.dsrscan.cardloop
                                    ; no, loop over cards
        sbz   0                     ; yes, turn off
        ;------------------------------------------------------
        ; Loop over cards and look if DSR present
        ;------------------------------------------------------
dsrlnk.dsrscan.cardloop:        
        ai    r12,>0100             ; next rom to turn on
        clr   @>83d0                ; clear in case we are done
        ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
        jeq   dsrlnk.error.nodsr_found
                                    ; yes, no matching DSR found
        mov   r12,@>83d0            ; save addr of next cru
        ;------------------------------------------------------
        ; Look at card ROM (@>4000 eq 'AA' ?)
        ;------------------------------------------------------
        sbo   0                     ; turn on rom
        li    r2,>4000              ; start at beginning of rom
        cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
        jne   dsrlnk.dsrscan.cardoff
                                    ; no rom found on card
        ;------------------------------------------------------
        ; Valid DSR ROM found. Now loop over chain/subprograms
        ;------------------------------------------------------
        ; dstype is the address of R5 of the DSRLNK workspace,
        ; which is where 8 for a DSR or 10 (>A) for a subprogram
        ; is stored before the DSR ROM is searched.
        ;------------------------------------------------------
        a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
        jmp   dsrlnk.dsrscan.getentry
        ;------------------------------------------------------
        ; Next DSR entry
        ;------------------------------------------------------
dsrlnk.dsrscan.nextentry:        
        mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or 
                                    ; subprogram

        sbo   0                     ; turn rom back on
        ;------------------------------------------------------
        ; Get DSR entry
        ;------------------------------------------------------
dsrlnk.dsrscan.getentry:        
        mov   *r2,r2                ; is addr a zero? (end of chain?)
        jeq   dsrlnk.dsrscan.cardoff
                                    ; yes, no more DSRs or programs to check
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
        movb  @>8355,r5             ; get length as counter
        jeq   dsrlnk.dsrscan.call_dsr
                                    ; if zero, do not further check, call DSR
                                    ; program

        cb    r5,*r2+               ; see if length matches
        jne   dsrlnk.dsrscan.nextentry 
                                    ; no, length does not match. Go process next
                                    ; DSR entry

        srl   r5,8                  ; yes, move to low byte
        li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
!       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in 
                                    ; DSR ROM
        jne   dsrlnk.dsrscan.nextentry 
                                    ; try next DSR entry if no match
        dec   r5                    ; loop until full length checked
        jne   -!
        ;------------------------------------------------------
        ; Device name/Subprogram match
        ;------------------------------------------------------
dsrlnk.dsrscan.match:                
        mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2

        ;------------------------------------------------------
        ; Call DSR program in device card
        ;------------------------------------------------------
dsrlnk.dsrscan.call_dsr:        
        inc   r1                    ; next version found
        bl    *r9                   ; go run routine
        ;
        ; Depending on IO result the DSR in card ROM does RET
        ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
        ;
        jmp   dsrlnk.dsrscan.nextentry
                                    ; (1) error return
        sbz   0                     ; (2) turn off rom if good return        
        lwpi  dsrlnk.dsrlws         ; (2) restore workspace
        mov   r9,r0                 ; point to flag in pab
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

********************************************************************************

dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
                                    ; a @blwp @dsrlnk
dsrlnk.period     text  '.'         ; For finding end of device name

        even