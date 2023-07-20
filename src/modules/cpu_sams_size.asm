* FILE......: cpu_sams_size.asm
* Purpose...: Check SAMS size

*//////////////////////////////////////////////////////////////
*                SAMS Memory Expansion support
*//////////////////////////////////////////////////////////////


***************************************************************
* sams.size
* Check size of SAMS card
***************************************************************
* bl  @sams.size
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* waux1 = Highest SAMS page number (>0000 if no SAMS)
*--------------------------------------------------------------
* REMARKS
*
* Testing will start with 32 MiB SAMS and will proceed by halving the range
* until 128 KiB is reached. 128 KiB is assumed to be the lowest viable SAMS.
* The actual bank tested will be >000E higher than the lowest bank in the
* upper half of the range.
*
* To test, Map >000E + lowest bank in upper half of SAMS range to >E000. For
* 32 MiB, this is >1000 + >000E. We initially store >0010 (LSB,MSB) in
* tmp1 to allow a circular shift each round before MOVing to r0 to then add
* >0e00 (LSB,MSB) for the next test. If the test fails at >001E, the last
* viable SAMS (128 KiB), tmp1 will go to >0800, at which point the loop
* exits, setting tmp1 to 0, effectively reporting "no SAMS".
*
* Author of original code: Lee Steward
*--------------------------------------------------------------
* Register usage
* r0, tmp0, tmp1, r12
********|*****|*********************|**************************
sams.size:
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
        ;------------------------------------------------------
        ; Prepare for checkng SAMS card
        ;------------------------------------------------------
sams.size.prepare:
        dect  stack
        mov   @>e000,*stack         ; Push value in >e000 to stack

        li    tmp0,>994a            ; check-value
        mov   tmp0,@>e000           ; check-value to check-location
        ;
        ; classic99 emulator can do 32 MiB
        ;
        li    tmp1,>0010            ; \ lowest bank in upper half SAMS
                                    ; / to tmp1 (LSB,MSB)
        li    r12,>1e00             ; CRU address of SAMS
        ;------------------------------------------------------
        ; Check SAMS card bank
        ;------------------------------------------------------
sams.size.loop: 
        mov   tmp1,r0               ; lowest bank in upper half of SAMS range
        ai    r0,>0e00              ; get >000E banks higher
        sbo   0                     ; enable SAMS registers
        mov   r0,@>401c             ; poke SAMS register for >E000
        sbz   0                     ; disable SAMS registers
        c     @>e000,tmp0           ; compare possible copy with test value
        jne   sams.size.exit       ; exit if SAMS mapped, viz., no match
        src   tmp1,1                ; shift right circular ^2 to next lower SAMS
        ci    tmp1,>0800            ; too far?
        jne   sams.size.loop.next  ; try half as much if not >0008 (LSB,MSB)
        clr   tmp1                  ; no-SAMS. Set flag to 0
        jmp   sams.size.save       ; we're outta here
        ;------------------------------------------------------
        ; Next iteration
        ;------------------------------------------------------        
sams.size.loop.next:
        swpb  tmp1                  ; restore bank#
        sla   tmp1,1                ; double value (highest bank# + 1)
        dec   tmp1                  ; decrement to highest bank#
        jmp   sams.size.loop       ; check next SAMS card bank
        ;------------------------------------------------------
        ; Check completed. Save result
        ;------------------------------------------------------        
sams.size.save:
        mov   tmp1,@waux1           ; save SAMS bank value
        jeq   sams.size.restore    ; ...no need to remap anything if no SAMS
        ;------------------------------------------------------
        ; Check completed. Remap default bank >0e
        ;------------------------------------------------------          
        ; Remap default bank >0E to >E000.
        ; CRU should still have correct value.
        ;
        li    r0,>0e00              ; load SAMS bank >000E
        sbo   0                     ; enable SAMS registers
        mov   r0,@>401C             ; poke SAMS register for >E000
        sbz   0                     ; disable SAMS registers
        ;------------------------------------------------------
        ; Check completed. Restore >e000
        ;------------------------------------------------------ 
sams.size.restore:
        mov   *stack+,@>e000        ; Restore value in >e000
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.size.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,r0            ; Pop r0
        mov   *stack+,r11           ; Pop return address
        b     *r11                  ; Return to caller
