* FILE......: cpu_scrpad_backrest.asm
* Purpose...: Scratchpad memory backup/restore functions

*//////////////////////////////////////////////////////////////
*                Scratchpad memory backup/restore
*//////////////////////////////////////////////////////////////

***************************************************************
* cpu.scrpad.backup - Backup scratchpad memory to >2000
***************************************************************
*  bl   @cpu.scrpad.backup
*--------------------------------------------------------------
*  Register usage
*  r0-r2, but values restored before exit
*--------------------------------------------------------------
*  Backup scratchpad memory to the memory area >2000 - >20FF.
*  Expects current workspace to be in scratchpad memory.
********|*****|*********************|**************************
cpu.scrpad.backup:
        mov   r0,@>2000             ; Save @>8300 (r0)
        mov   r1,@>2002             ; Save @>8302 (r1)
        mov   r2,@>2004             ; Save @>8304 (r2)
        ;------------------------------------------------------
        ; Prepare for copy loop
        ;------------------------------------------------------
        li    r0,>8306              ; Scratpad source address 
        li    r1,>2006              ; RAM target address
        li    r2,62                 ; Loop counter
        ;------------------------------------------------------
        ; Copy memory range >8306 - >83ff
        ;------------------------------------------------------
cpu.scrpad.backup.copy:
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        dect  r2
        jne   cpu.scrpad.backup.copy
        mov   @>83fe,@>20fe         ; Copy last word
        ;------------------------------------------------------
        ; Restore register r0 - r2
        ;------------------------------------------------------
        mov   @>2000,r0             ; Restore r0
        mov   @>2002,r1             ; Restore r1
        mov   @>2004,r2             ; Restore r2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.backup.exit:        
        b     *r11                  ; Return to caller


***************************************************************
* cpu.scrpad.restore - Restore scratchpad memory from >2000
***************************************************************
*  bl   @cpu.scrpad.restore
*--------------------------------------------------------------
*  Register usage
*  r0-r2, but values restored before exit
*--------------------------------------------------------------
*  Restore scratchpad from memory area >2000 - >20FF
*  Current workspace can be outside scratchpad when called.
********|*****|*********************|**************************
cpu.scrpad.restore:
        ;------------------------------------------------------
        ; Restore scratchpad >8300 - >8304
        ;------------------------------------------------------
        mov   @>2000,@>8300
        mov   @>2002,@>8302
        mov   @>2004,@>8304
        ;------------------------------------------------------
        ; save current r0 - r2 (WS can be outside scratchpad!)
        ;------------------------------------------------------
        mov   r0,@>2000
        mov   r1,@>2002
        mov   r2,@>2004
        ;------------------------------------------------------
        ; Prepare for copy loop, WS 
        ;------------------------------------------------------
        li    r0,>2006
        li    r1,>8306
        li    r2,62
        ;------------------------------------------------------
        ; Copy memory range >2006 - >20ff
        ;------------------------------------------------------
cpu.scrpad.restore.copy:
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        dect  r2
        jne   cpu.scrpad.restore.copy
        mov   @>20fe,@>83fe         ; Copy last word        
        ;------------------------------------------------------
        ; Restore register r0 - r2
        ;------------------------------------------------------
        mov   @>2000,r0             ; Restore r0
        mov   @>2002,r1             ; Restore r1
        mov   @>2004,r2             ; Restore r2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.restore.exit:        
        b     *r11                  ; Return to caller