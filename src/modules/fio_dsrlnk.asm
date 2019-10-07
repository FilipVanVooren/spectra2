* FILE......: fio_dsrlnk.asm
* Purpose...: DSRLNK implementation for file I/O use

*//////////////////////////////////////////////////////////////
*                          DSRLNK 
*//////////////////////////////////////////////////////////////

***************************************************************                                     
* >8300 - >83ff       Equates for DSRLNK (alternative layout)
***************************************************************                                     
* Equates are used in DSRLNK. 
* Scratchpad memory needs to be paged out before use of DSRLNK.
********@*****@*********************@**************************                                     
haa     equ   >8320                 ; Loaded with HI-byte value >aa                                 
sav8a   equ   >8322                 ; Contains >08 or >0a                                           


**** Scratchpad. My choice
*flgptr  equ   >8324                 ; Pointer to pab+1 dsrlnk                                       
*savver  equ   >8326                 ; Saved version                                                 
*savent  equ   >8328                 ; Saved entry address                                           
*savcru  equ   >832a                 ; Saved cru                                                     
*savlen  equ   >832c                 ; Saved length of filename                                      
*savpab  equ   >832e                 ; Saved PAB address                                             
*namsto  equ   >8330                 ; 8-byte buffer for device name                                 

**** Low memory expansion. Official documentation?
flgptr  equ   >202e                 ; Pointer to pab+1 dsrlnk                                       
savcru  equ   >2032                 ; Saved cru                                                     
savent  equ   >2034                 ; Saved entry address                                           
savlen  equ   >2036                 ; Saved length of filename                                      
savpab  equ   >2038                 ; Saved PAB address                                             
savver  equ   >203a                 ; Saved version                                                 

namsto  equ   >2100                 ; 8-byte buffer for device name                                 



;dsrlws  equ   >8380                 ; dsrlnk workspace                                              
;dstype  equ   >838a                 ; dstype is address of R5 of DSRLNK ws

dsrlws  equ   >b000                 ; dsrlnk workspace                                              
dstype  equ   >b00a                 ; dstype is address of R5 of DSRLNK ws


***************************************************************        




***************************************************************
* dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
***************************************************************
*  blwp @dsrlnk
*  data p0
*--------------------------------------------------------------
*  P0 = 8 or 10 (a)
*--------------------------------------------------------------
; dsrlnk routine - Written by Paolo Bagnaresi
*--------------------------------------------------------------
dsrlnk  data  dsrlws               ; dsrlnk workspace
        data  dlentr               ; entry point
        ;------------------------------------------------------
        ; DSRLNK entry point
        ;------------------------------------------------------ 
dlentr  li    r0,>aa00
        movb  r0,@haa              ; load haa at @>8320
        mov   *r14+,r5             ; get pgm type for link
        mov   r5,@sav8a            ; save data following blwp @dsrlnk (8 or >a)
        szcb  @h20,r15             ; reset equal bit
        mov   @>8356,r0            ; get ptr to pab
        mov   r0,r9                ; save ptr
        mov   r0,@flgptr           ; save again pointer to pab+1 for dsrlnk 
                                   ; data 8
        ;------------------------------------------------------
        ; Fetch file descriptor length from PAB
        ;------------------------------------------------------ 
        ai    r9,>fff8             ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
        bl    @_vsbr               ; read file descriptor length
        movb  r1,r3                ; copy it
        srl   r3,8                 ; make it lo byter
        ;------------------------------------------------------
        ; Fetch file descriptor device name from PAB
        ;------------------------------------------------------ 
        seto  r4                   ; init counter
        li    r2,namsto            ; point to 8-byte buffer
lnkslp  inc   r0                   ; point to next char of name
        inc   r4                   ; incr char counter
        ci    r4,>0007             ; see if length more than 7 chars
        jgt   lnkerr               ; yes, error
        c     r4,r3                ; end of name?
        jeq   lnksln               ; yes
        bl    @_vsbr               ; read curr char
        movb  r1,*r2+              ; move into buffer
        cb    r1,@decmal           ; is it a '.' period?
        jne   lnkslp               ; no, loop next char
        ;------------------------------------------------------
        ; Determine device name length
        ;------------------------------------------------------ 
lnksln  mov   r4,r4                ; see if 0 length
        jeq   lnkerr               ; yes, error
        clr   @>83d0
        mov   r4,@>8354            ; save name length for search
        mov   r4,@savlen           ; save it here too
        inc   r4                   ; adjust for period
        a     r4,@>8356            ; point to position after name
        mov   @>8356,@savpab       ; save pointer to position after name
        ;------------------------------------------------------
        ; Prepare for DSR scan >1000 - >1f00
        ;------------------------------------------------------ 
srom    lwpi  >83e0                ; use gplws
        clr   r1                   ; version found of dsr
        li    r12,>0f00            ; init cru addr
norom   mov   r12,r12              ; anything to turn off?
        jeq   nooff                ; no
        sbz   0                    ; yes, turn off
        ;------------------------------------------------------
        ; Loop over cards and look if DSR present
        ;------------------------------------------------------
nooff   ai    r12,>0100            ; next rom to turn on
        clr   @>83d0               ; clear in case we are done
        ci    r12,>2000            ; Card scan complete? (>1000 to >1F00)
        jeq   nodsr                ; yes, no dsr match
        mov   r12,@>83d0           ; save addr of next cru
        ;------------------------------------------------------
        ; Look at card ROM (@>4000 eq 'AA' ?)
        ;------------------------------------------------------
        sbo   0                    ; turn on rom
        li    r2,>4000             ; start at beginning of rom
        cb    *r2,@haa             ; check for a valid DSR header
        jne   norom                ; no rom here
        ;------------------------------------------------------
        ; Valid DSR ROM found. Now loop over chain/subprograms
        ;------------------------------------------------------
        ; dstype is the address of R5 of the DSRLNK workspace,
        ; which is where 8 for a DSR or 10 (>A) for a subprogram
        ; is stored before the DSR ROM is searched.
        ;------------------------------------------------------
        a     @dstype,r2           ; go to first pointer (byte 8 or 10)
        jmp   sgo2

sgo     mov   @>83d2,r2            ; Offset 0 > Fetch link to next DSR or subprogram
        sbo   0                    ; turn rom back on
        ;------------------------------------------------------
        ; Get DSR entry
        ;------------------------------------------------------
sgo2    mov   *r2,r2               ; is addr a zero? (end of chain?)
        jeq   norom                ; yes, no more DSRs or programs to check
        mov   r2,@>83d2            ; Offset 0 > Store link to next DSR or subprogram
        inct  r2                   ; Offset 2 > Has call address of current DSR/subprogram code
        mov   *r2+,r9              ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
        ;------------------------------------------------------
        ; Check file descriptor in DSR
        ;------------------------------------------------------
        clr   r5                   ; Remove any old stuff
        movb  @>8355,r5            ; get length as counter
        jeq   namtwo               ; if zero, do not check
        cb    r5,*r2+              ; see if length matches
        jne   sgo                  ; no, length does not match. Go process next DSR entry
        srl   r5,8                 ; yes, move to low byte
        li    r6,namsto            ; Point to 8-byte CPU buffer
namone  cb    *r6+,*r2+            ; compare byte in CPU buffer with byte in DSR ROM
        jne   sgo                  ; try next if no match
        dec   r5                   ; loop til full length checked
        jne   namone
        ;------------------------------------------------------
        ; Device name match
        ;------------------------------------------------------
        mov   r2,@>83d2            ; DSR entry addr must be saved at @>83d2
namtwo  inc   r1                   ; next version found
        mov   r1,@savver           ; save version number
        mov   r9,@savent           ; save entry address
        mov   r12,@savcru          ; save cru address
        ;------------------------------------------------------
        ; Call DSR program in device card
        ;------------------------------------------------------
        bl    *r9                  ; go run routine
        ;
        ; Depending on IO result the DSR either does RET or
        ; INCT R11 and RET meaning that jmp or sbz gets executed
        ;
        jmp   sgo                  ; error return
        sbz   0                    ; turn off rom if good return        
        lwpi  dsrlws               ; restore workspace
        mov   r9,r0                ; point to flag in pab
frmdsr  mov   @sav8a,r1            ; get back data following blwp @dsrlnk
                                   ; (8 or >a)
        ci    r1,8                 ; was it 8?
        jeq   dsrdt8               ; yes, jump: normal dsrlnk
        movb  @>8350,r1            ; no, we have a data >a. get error byte from 
                                   ; >8350
        jmp   dsrdta               ; go and return error byte to the caller
        ;------------------------------------------------------
        ; Read PAB status flag after DSR call completed
        ;------------------------------------------------------
dsrdt8  bl    @_vsbr               ; read flag
        ;------------------------------------------------------
        ; Return DSR error to caller 
        ;------------------------------------------------------
dsrdta  srl   r1,13                ; just keep error bits
        jne   ioerr                ; handle error
        rtwp                       ; Return from DSR workspace to caller workspace
        ;------------------------------------------------------
        ; IO-error handler
        ;------------------------------------------------------
nodsr   lwpi  dsrlws               ; no dsr, restore workspace
lnkerr  clr   r1                   ; clear flag for error 0 = bad device name
ioerr   swpb  r1                   ; put error in hi byte
        movb  r1,*r13              ; store error flags in callers r0
        socb  @h20,r15             ; set equal bit to indicate error
        rtwp                       ; Return from DSR workspace to caller workspace

****************************************************************************************

data8   data  >8                   ; just to compare. 8 is the data that
                                   ; usually follows a blwp @dsrlnk
decmal  text  '.'                  ; for finding end of device name
        even
h20     data  >2000


; Following code added for supporting VDP SINGLE BYTE READ
; Filip van Vooren

_vsbr   swpb  r0
        movb  r0,@vdpa             ; send low byte 
        swpb  r0
        movb  r0,@vdpa             ; send high byte
        movb  @vdpr,r1             ; read byte from VDP ram
        rt 
