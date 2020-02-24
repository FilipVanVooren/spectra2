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
*  Backup scratchpad memory to destination range
*  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
*
*  Expects current workspace to be in scratchpad memory.
********|*****|*********************|**************************
cpu.scrpad.backup:
        mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
        mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
        mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
        ;------------------------------------------------------
        ; Prepare for copy loop
        ;------------------------------------------------------
        li    r0,>8306              ; Scratpad source address 
        li    r1,cpu.scrpad.tgt+6   ; RAM target address
        li    r2,62                 ; Loop counter
        ;------------------------------------------------------
        ; Copy memory range >8306 - >83ff
        ;------------------------------------------------------
cpu.scrpad.backup.copy:
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        dect  r2
        jne   cpu.scrpad.backup.copy
        mov   @>83fe,@cpu.scrpad.tgt + >fe 
                                    ; Copy last word
        ;------------------------------------------------------
        ; Restore register r0 - r2
        ;------------------------------------------------------
        mov   @cpu.scrpad.tgt,r0    ; Restore r0
        mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
        mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
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
*  Restore scratchpad from memory area
*  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
*  Current workspace can be outside scratchpad when called.
********|*****|*********************|**************************
cpu.scrpad.restore:
        ;------------------------------------------------------
        ; Restore scratchpad >8300 - >8304
        ;------------------------------------------------------
        mov   @cpu.scrpad.tgt,@>8300
        mov   @cpu.scrpad.tgt + 2,@>8302
        mov   @cpu.scrpad.tgt + 4,@>8304
        ;------------------------------------------------------
        ; save current r0 - r2 (WS can be outside scratchpad!)
        ;------------------------------------------------------
        mov   r0,@cpu.scrpad.tgt
        mov   r1,@cpu.scrpad.tgt + 2
        mov   r2,@cpu.scrpad.tgt + 4
        ;------------------------------------------------------
        ; Prepare for copy loop, WS 
        ;------------------------------------------------------
        li    r0,cpu.scrpad.tgt + 6
        li    r1,>8306
        li    r2,62
        ;------------------------------------------------------
        ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
        ;------------------------------------------------------
cpu.scrpad.restore.copy:
        mov   *r0+,*r1+
        mov   *r0+,*r1+        
        dect  r2
        jne   cpu.scrpad.restore.copy
        mov   @cpu.scrpad.tgt + > fe,@>83fe   
                                    ; Copy last word        
        ;------------------------------------------------------
        ; Restore register r0 - r2
        ;------------------------------------------------------
        mov   @cpu.scrpad.tgt,r0
        mov   @cpu.scrpad.tgt + 2,r1                                             
        mov   @cpu.scrpad.tgt + 4,r2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cpu.scrpad.restore.exit:        
        b     *r11                  ; Return to caller