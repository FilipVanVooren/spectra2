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
;skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
;skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
;skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
;skip_vdp_hchar          equ  1      ; Skip hchar, xchar
;skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
;skip_vdp_boxes          equ  1      ; Skip filbox, putbox
;skip_vdp_bitmap         equ  1      ; Skip bitmap functions
;skip_vdp_viewport       equ  1      ; Skip viewport functions
;skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
;skip_vdp_yx2px_calc     equ  1      ; Skip YX to pixel calculation
;skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
;skip_vdp_sprites        equ  1      ; Skip sprites support
;skip_sound_player       equ  1      ; Skip inclusion of sound player code
;skip_speech_detection   equ  1      ; Skip speech synthesizer detection
;skip_speech_player      equ  1      ; Skip inclusion of speech player code
;skip_random_generator   equ  1      ; Skip random functions 
;skip_timer_alloc        equ  1      ; Skip support for timers allocation

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

***************************************************************
* Main
********|*****|*********************|**************************
main    bl    @putat
        data  >081f,hello_world

        b     @tmgr                 ; 


hello_world:
        #string 'Hello World!'
