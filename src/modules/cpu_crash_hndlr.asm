* FILE......: cpu_crash_hndlr.asm
* Purpose...: Custom crash handler module


*//////////////////////////////////////////////////////////////
*                      CRASH HANDLER 
*//////////////////////////////////////////////////////////////

***************************************************************
* crash - CPU program crashed handler 
***************************************************************
*  b  @crash_handler
********@*****@*********************@**************************
crash_handler:        
        lwpi  ws1                   ; Activate workspace 1
        clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
        li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
        b     @runli1               ; Initialize system again (VDP, Memory, etc.)

crash_handler.main:
        bl    @putat                ; Show crash message
        data  >0000,crash_handler.message
        jmp   $
        
crash_handler.message:
        byte  15
        text  'System crashed.'        


