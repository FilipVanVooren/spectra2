***************************************************************
* 
*                          Device scan
*
*                (c)2018-2019 // Filip van Vooren
*
***************************************************************
* File: hello_world.asm             ; Version %%build_date%%
*--------------------------------------------------------------
* TI-99/4a DSR scan utility
*--------------------------------------------------------------
* 2018-11-01   Development started
********|*****|*********************|**************************
        save  >6000,>7fff
        aorg  >6000
*--------------------------------------------------------------
*debug                  equ  1      ; Turn on debugging
;--------------------------------------------------------------
; Equates for spectra2 DSRLNK 
;--------------------------------------------------------------
dsrlnk.dsrlws             equ >b000 ; Address of dsrlnk workspace                                              
dsrlnk.namsto             equ >2100 ; 8-byte RAM buffer for storing device name
startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
startup_keep_vdpdiskbuf   equ  1    ; Keep VDP memory reserved for 3 VDP disk buffers
*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_fio                  equ 1     ; Skip file I/O
*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
grmhdr  byte  >aa,1,1,0,0,0
        data  prog0
        byte  0,0,0,0,0,0,0,0
prog0   data  0                     ; No more items following
        data  runlib
 .ifdef debug
        #string 'HELLO WORLD %%build_date%%'
 .else
        #string 'HELLO WORLD'
 .endif
*--------------------------------------------------------------
* Include required files
*--------------------------------------------------------------
        copy  "%%spectra2%%/runlib.asm"
*--------------------------------------------------------------
* SPECTRA2 startup options
*--------------------------------------------------------------
spfclr  equ   >c1                   ; Foreground/Background color for font.
spfbck  equ   >01                   ; Screen background color.
;--------------------------------------------------------------
; Video mode configuration
;--------------------------------------------------------------
spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
rambuf  equ   >8350

***************************************************************
* Main
********|*****|*********************|**************************
main    bl    @putat
        data  >081f,hello_world

        b     @tmgr                 ; 


hello_world:
        #string 'Hello World!'
