* FILE......: portaddr.asm
* Purpose...: Equates for hardware port addresses

***************************************************************                                     
* Equates for VDP, GROM, SOUND, SPEECH ports                                                        
********|*****|*********************|**************************                                     
sound   equ   >8400                 ; Sound generator address                                       
vdpr    equ   >8800                 ; VDP read data window address                                  
vdpw    equ   >8c00                 ; VDP write data window address                                 
vdps    equ   >8802                 ; VDP status register                                           
vdpa    equ   >8c02                 ; VDP address register                                          
grmwa   equ   >9c02                 ; GROM set write address                                        
grmra   equ   >9802                 ; GROM set read address                                         
grmrd   equ   >9800                 ; GROM read byte                                                
grmwd   equ   >9c00                 ; GROM write byte                                               
spchrd  equ   >9000                 ; Address of speech synth Read Data Register                    
spchwt  equ   >9400                 ; Address of speech synth Write Data Register                
