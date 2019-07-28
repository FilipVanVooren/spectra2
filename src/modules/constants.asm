* FILE......: constants.asm
* Purpose...: Definition of constants used by runlib modules

***************************************************************                                     
*                      Some constants                                                               
********@*****@*********************@**************************                                     
    .ifdef use_osrom_constants                                                                      
wbit0   equ   >06a6                 ; data >8000  Binary 1000000000000000                           
wbit1   equ   >023c                 ; data >4000  Binary 0100000000000000                           
wbit2   data  >2000                 ; data >2000  Binary 0010000000000000                           
wbit3   equ   >0036                 ; data >1000  Binary 0001000000000000                           
wbit4   equ   >08c6                 ; data >0800  Binary 0000100000000000                           
wbit5   equ   >0694                 ; data >0400  Binary 0000010000000000                           
wbit6   equ   >0030                 ; data >0200  Binary 0000001000000000                           
wbit7   equ   >002a                 ; data >0100  Binary 0000000100000000                           
wbit8   equ   >06b0                 ; data >0080  Binary 0000000010000000                           
wbit9   equ   >101e                 ; data >0040  Binary 0000000001000000                           
wbit10  equ   >0032                 ; data >0020  Binary 0000000000100000                           
wbit11  data  >0010                 ; data >0010  Binary 0000000000010000                           
wbit12  equ   >0012                 ; data >0008  Binary 0000000000001000                           
wbit13  data  >0004                 ; data >0004  Binary 0000000000000100                           
wbit14  data  >0002                 ; data >0002  Binary 0000000000000010                           
wbit15  equ   >0378                 ; data >0001  Binary 0000000000000001                           
whffff  equ   >0e2c                 ; data >ffff  Binary 1111111111111111                           
bd0     equ   >0002                 ; byte  0     Digit 0                                           
bd1     equ   >002a                 ; byte  1     Digit 1                                           
bd2     equ   >002c                 ; byte  2     Digit 2                                           
bd3     equ   >003e                 ; byte  3     Digit 3                                           
bd4     equ   >000e                 ; byte  4     Digit 4                                           
bd5     equ   >007b                 ; byte  5     Digit 5                                           
bd6     equ   >004e                 ; byte  6     Digit 6                                           
bd7     equ   >0090                 ; byte  7     Digit 7                                           
bd8     equ   >0013                 ; byte  8     Digit 8                                           
bd9     equ   >0006                 ; byte  9     Digit 9                                           
bd208   equ   >00a6                 ; byte  208   Digit 208 (>D0)                                   
    .else                                                                                           
wbit0   data  >8000                 ; Binary 1000000000000000                                       
wbit1   data  >4000                 ; Binary 0100000000000000                                       
wbit2   data  >2000                 ; Binary 0010000000000000                                       
wbit3   data  >1000                 ; Binary 0001000000000000                                       
wbit4   data  >0800                 ; Binary 0000100000000000                                       
wbit5   data  >0400                 ; Binary 0000010000000000                                       
wbit6   data  >0200                 ; Binary 0000001000000000                                       
wbit7   data  >0100                 ; Binary 0000000100000000                                       
wbit8   data  >0080                 ; Binary 0000000010000000                                       
wbit9   data  >0040                 ; Binary 0000000001000000                                       
wbit10  data  >0020                 ; Binary 0000000000100000                                       
wbit11  data  >0010                 ; Binary 0000000000010000                                       
wbit12  data  >0008                 ; Binary 0000000000001000                                       
wbit13  data  >0004                 ; Binary 0000000000000100                                       
wbit14  data  >0002                 ; Binary 0000000000000010                                       
wbit15  data  >0001                 ; Binary 0000000000000001                                       
whffff  data  >ffff                 ; Binary 1111111111111111                                       
bd0     byte  0                     ; Digit 0                                                       
bd1     byte  1                     ; Digit 1                                                       
bd2     byte  2                     ; Digit 2                                                       
bd3     byte  3                     ; Digit 3                                                       
bd4     byte  4                     ; Digit 4                                                       
bd5     byte  5                     ; Digit 5                                                       
bd6     byte  6                     ; Digit 6                                                       
bd7     byte  7                     ; Digit 7                                                       
bd8     byte  8                     ; Digit 8                                                       
bd9     byte  9                     ; Digit 9                                                       
bd208   byte  208                   ; Digit 208 (>D0)                                               
        even                                                                                        
    .endif                                                                                          
