* FILE......: cpu_crash_hndlr.asm
* Purpose...: Custom crash handler module


*//////////////////////////////////////////////////////////////
*                      CRASH HANDLER 
*//////////////////////////////////////////////////////////////

***************************************************************
* crash - CPU program crashed handler 
***************************************************************
*  bl  @crash
*--------------------------------------------------------------
*  REMARKS
*  Is expected to be called via bl statement so that R11
*  contains address that triggered us
********@*****@*********************@**************************
crash   blwp  @>0000                ; Soft-reset
