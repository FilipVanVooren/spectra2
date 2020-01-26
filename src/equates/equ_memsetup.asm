* FILE......: memsetup.asm
* Purpose...: Equates for spectra2 memory layout

***************************************************************                                     
* >8300 - >8341     Scratchpad memory layout (66 bytes)                                             
********|*****|*********************|**************************                                     
ws1     equ   >8300                 ; 32 - Primary workspace                                        
mcloop  equ   >8320                 ; 08 - Machine code for loop & speech                           
wbase   equ   >8328                 ; 02 - PNT base address                                         
wyx     equ   >832a                 ; 02 - Cursor YX position                                       
wtitab  equ   >832c                 ; 02 - Timers: Address of timer table                           
wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook                             
wtitmp  equ   >8330                 ; 02 - Timers: Internal use                                     
wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags                                   
wsdlst  equ   >8334                 ; 02 - Sound player: Tune address                               
wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use                              
wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data                       
wcolmn  equ   >833a                 ; 02 - Screen size, columns per row                             
waux1   equ   >833c                 ; 02 - Temporary storage 1                                      
waux2   equ   >833e                 ; 02 - Temporary storage 2                                      
waux3   equ   >8340                 ; 02 - Temporary storage 3                                      
***************************************************************                                     
by      equ   wyx                   ;      Cursor Y position                                        
bx      equ   wyx+1                 ;      Cursor X position                                        
mcsprd  equ   mcloop+2              ;      Speech read routine                                      
***************************************************************       
