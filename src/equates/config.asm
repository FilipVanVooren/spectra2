* FILE......: config.asm
* Purpose...: Equates for bits in config register

***************************************************************                                     
* The config register equates                                                                       
*--------------------------------------------------------------                                     
* Configuration flags                                                                               
* ===================                                                                               
*                                                                                                   
* ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY                                 
* ; 14  Sound player: repeat tune       1=yes          0=no                                         
* ; 13  Sound player: enabled           1=yes          0=no (or pause)                              
* ; 12  VDP9918 sprite collision?       1=yes          0=no                                         
* ; 11  Keyboard: ANY key pressed       1=yes          0=no                                         
* ; 10  Keyboard: Alpha lock key down   1=yes          0=no                                         
* ; 09  Timer: Kernel thread enabled    1=yes          0=no                                         
* ; 08  Timer: Block kernel thread      1=yes          0=no                                         
* ; 07  Timer: User hook enabled        1=yes          0=no                                         
* ; 06  Timer: Block user hook          1=yes          0=no                                         
* ; 05  Speech synthesizer present      1=yes          0=no                                         
* ; 04  Speech player: busy             1=yes          0=no                                         
* ; 03  Speech player: enabled          1=yes          0=no                                         
* ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)                                     
* ; 01  F18A present                    1=on           0=off                                        
* ; 00  Subroutine state flag           1=on           0=off                                        
********@*****@*********************@**************************                                     
palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)                               
enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)                                  
enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)                                                     
anykey  equ   wbit11                ; BIT 11 in the CONFIG register                                 
***************************************************************                                     

