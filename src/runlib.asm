*******************************************************************************
*              ___  ____  ____  ___  ____  ____    __    ___
*             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \
*             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
*             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
*    v2.0
*                TMS9900 Monitor with Arcade Game support
*                                  for
*              the Texas Instruments TI-99/4A Home Computer
*
*                      2010-2019 by Filip Van Vooren
*
*              https://github.com/FilipVanVooren/spectra2.git
*******************************************************************************
* This file: runlib.a99
*******************************************************************************
* Use following equates to skip/exclude support modules and to control startup
* behaviour.
*
* == Memory
* skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
* skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
* skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
* skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
* skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
* skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
*
* == VDP
* skip_textmode_support     equ  1  ; Skip 40x24 textmode support
* skip_vdp_f18a_support     equ  1  ; Skip f18a support
* skip_vdp_hchar            equ  1  ; Skip hchar, xchar
* skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
* skip_vdp_boxes            equ  1  ; Skip filbox, putbox
* skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
* skip_vdp_bitmap           equ  1  ; Skip bitmap functions
* skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
* skip_vdp_viewport         equ  1  ; Skip viewport functions
* skip_vdp_rle_decompress   equ  1  ; Skip RLE decompress to VRAM
* skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
* skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
* skip_vdp_sprites          equ  1  ; Skip sprites support
* skip_vdp_cursor           equ  1  ; Skip cursor support
*
* == Sound & speech
* skip_snd_player           equ  1  ; Skip inclusionm of sound player code
* skip_speech_detection     equ  1  ; Skip speech synthesizer detection
* skip_speech_player        equ  1  ; Skip inclusion of speech player code
*
* ==  Keyboard 
* skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
* skip_real_keyboard        equ  1  ; Skip real keyboard scan
*
* == Utilities
* skip_random_generator     equ  1  ; Skip random generator functions
* skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
* skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
* skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
*
* == Kernel/Multitasking
* skip_timer_alloc          equ  1  ; Skip support for timers allocation
* skip_mem_paging           equ  1  ; Skip support for memory paging 
* skip_iosupport            equ  1  ; Skip support for file I/O, dsrlnk
*
* == Startup behaviour 
* startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
* startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
*******************************************************************************

*//////////////////////////////////////////////////////////////
*                       RUNLIB SETUP
*//////////////////////////////////////////////////////////////

        copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
        copy  "equ_registers.asm"        ; Equates for runlib registers
        copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
        copy  "equ_param.asm"            ; Equates for runlib parameters

    .ifndef skip_rom_bankswitch
        copy  "rom_bankswitch.asm"       ; Bank switch routine
    .endif

        copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
        copy  "equ_config.asm"           ; Equates for bits in config register
        copy  "cpu_crash_hndlr.asm"      ; CPU program crashed handler
        copy  "vdp_tables.asm"           ; Data used by runtime library
        copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions

    .ifndef skip_cpu_vram_copy
        copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
    .endif

    .ifndef skip_vram_cpu_copy
        copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
    .endif

    .ifndef skip_cpu_cpu_copy
        copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
    .endif

    .ifndef skip_grom_cpu_copy
        copy  "copy_grom_cpu.asm"        ; GROM to CPU copy functions
    .endif

    .ifndef skip_grom_vram_copy
        copy  "copy_grom_vram.asm"       ; GROM to VRAM copy functions
    .endif

    .ifndef skip_vdp_rle_decompress
        copy  "vdp_rle_decompr.asm"      ; RLE decompress to VRAM
    .endif

    .ifndef skip_vdp_intscr
        copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
    .endif

    .ifndef skip_vdp_sprites
        copy  "vdp_sprites.asm"          ; VDP sprites 
    .endif

    .ifndef skip_vdp_cursor
        copy  "vdp_cursor.asm"           ; VDP cursor handling
    .endif

    .ifndef skip_vdp_yx2px_calc
        copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
    .endif

    .ifndef skip_vdp_px2yx_calc
        copy  "vdp_px2yx_calc.asm"       ; VDP calculate YX coordinate for pixel pos
    .endif

    .ifndef skip_vdp_bitmap
        copy  "vdp_bitmap.asm"           ; VDP Bitmap functions
    .endif

    .ifndef skip_vdp_f18a_support
        copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
    .endif

    .ifndef skip_vdp_hchar
        copy  "vdp_hchar.asm"            ; VDP hchar functions
    .endif

    .ifndef skip_vdp_vchar
        copy  "vdp_vchar.asm"            ; VDP vchar functions
    .endif

    .ifndef skip_vdp_boxes
        copy  "vdp_boxes.asm"            ; VDP box functions
    .endif

    .ifndef skip_vdp_viewport
        copy  "vdp_viewport.asm"         ; VDP viewport functionality
    .endif

    .ifndef skip_sound_player
        copy  "snd_player.asm"           ; Sound player
    .endif

    .ifndef skip_speech_detection
        copy  "speech_detect.asm"        ; Detect speech synthesizer
    .endif

    .ifndef skip_speech_player
        copy  "speech_player.asm"        ; Speech synthesizer player
    .endif

    .ifndef skip_virtual_keyboard
        copy  "keyb_virtual.asm"         ; Virtual keyboard scanning
    .endif

    .ifndef skip_real_keyboard
        copy  "keyb_real.asm"            ; Real Keyboard support 
    .endif

    .ifndef skip_cpu_hexsupport
        copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
    .endif

    .ifndef skip_cpu_numsupport
        copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
    .endif

    .ifndef skip_cpu_crc16
         copy  "cpu_crc16.asm"           ; CRC-16 checksum calculation
    .endif

    .ifndef skip_random_generator
        copy  "rnd_support.asm"          ; Random number generator
    .endif

    .ifndef skip_mem_paging
        copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore 
        copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
    .endif

    .ifndef skip_iosupport
        copy  "equ_file_io.asm"          ; File I/O equates
        copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication 
        copy  "fio_level2.asm"           ; File I/O level 2 support
    .endif



*//////////////////////////////////////////////////////////////
*                            TIMERS
*//////////////////////////////////////////////////////////////

        copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
        copy  "timers_kthread.asm"       ; Timers / Kernel thread
        copy  "timers_hooks.asm"         ; Timers / User hooks

    .ifndef skip_timer_alloc
        copy  "timers_alloc.asm"         ; Timers / Slot calculation
    .endif



*//////////////////////////////////////////////////////////////
*                    RUNLIB INITIALISATION
*//////////////////////////////////////////////////////////////

***************************************************************
*  RUNLIB - Runtime library initalisation
***************************************************************
*  B  @RUNLIB
*--------------------------------------------------------------
*  REMARKS
*  if R0 in WS1 equals >4a4a we were called from the system
*  crash handler so we return there after initialisation.

*  If R1 in WS1 equals >FFFF we return to the TI title screen
*  after clearing scratchpad memory. This has higher priority 
*  as crash handler flag R0.
********@*****@*********************@**************************
    .ifdef startup_backup_scrpad
runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
        clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
    .else
runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
    .endif
*--------------------------------------------------------------
* Alternative entry point
*--------------------------------------------------------------
runli1  limi  0                     ; Turn off interrupts
        lwpi  ws1                   ; Activate workspace 1
        mov   @>83c0,r3             ; Get random seed from OS monitor
*--------------------------------------------------------------
* Clear scratch-pad memory from R4 upwards
*--------------------------------------------------------------
runli2  li    r2,>8308
runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
        ci    r2,>8400
        jne   runli3
*--------------------------------------------------------------
* Exit to TI-99/4A title screen ?
*--------------------------------------------------------------
runli3a
        ci    r1,>ffff              ; Exit flag set ?
        jne   runli4                ; No, continue
        blwp  @0                    ; Yes, bye bye
*--------------------------------------------------------------
* Determine if VDP is PAL or NTSC
*--------------------------------------------------------------
runli4  mov   r3,@waux1             ; Store random seed
        clr   r1                    ; Reset counter
        li    r2,10                 ; We test 10 times
runli5  mov   @vdps,r3
        coc   @wbit0,r3             ; Interupt flag set ?
        jeq   runli6
        inc   r1                    ; Increase counter
        jmp   runli5
runli6  dec   r2                    ; Next test
        jne   runli5
        ci    r1,>1250              ; Max for NTSC reached ?
        jle   runli7                ; No, so it must be NTSC
        ori   config,palon          ; Yes, it must be PAL, set flag
*--------------------------------------------------------------
* Copy machine code to scratchpad (prepare tight loop)
*--------------------------------------------------------------
runli7  li    r1,mccode             ; Machinecode to patch
        li    r2,mcloop+2           ; Scratch-pad reserved for machine code
        mov   *r1+,*r2+             ; Copy 1st instruction 
        mov   *r1+,*r2+             ; Copy 2nd instruction
        mov   *r1+,*r2+             ; Copy 3rd instruction
*--------------------------------------------------------------
* Initialize registers, memory, ...
*--------------------------------------------------------------
runli9  clr   r1
        clr   r2
        clr   r3
        li    stack,>8400           ; Set stack
        li    r15,vdpw              ; Set VDP write address
    .ifndef skip_sound_player
        bl    @mute                 ; Mute sound generators
    .endif
*--------------------------------------------------------------
* Setup video memory
*--------------------------------------------------------------
    .ifdef startup_keep_vdpmemory
        ci    r0,>4a4a              ; Crash flag set?
        jne   runlia                 
        bl    @filv                 ; Clear 12K VDP memory instead
        data  >0000,>00,>3fff       ; of 16K, so that PABs survive
    .else
        bl    @filv                 ; Clear 16K VDP memory
        data  >0000,>00,>3fff
    .endif
runlia  bl    @filv
        data  pctadr,spfclr,16      ; Load color table
*--------------------------------------------------------------
* Check if there is a F18A present
*--------------------------------------------------------------
    .ifdef skip_vdp_f18a_support
*       <<skipped>>
    .else
        bl    @f18unl               ; Unlock the F18A
        bl    @f18chk               ; Check if F18A is there
        bl    @f18lck               ; Lock the F18A again
    .endif
*--------------------------------------------------------------
* Check if there is a speech synthesizer attached
*--------------------------------------------------------------
    .ifdef skip_speech_detection
*       <<skipped>>
    .else
        bl    @spconn 
    .endif
*--------------------------------------------------------------
* Load video mode table & font
*--------------------------------------------------------------
runlic  bl    @vidtab               ; Load video mode table into VDP
        data  spvmod                ; Equate selected video mode table
        li    tmp0,spfont           ; Get font option
        inv   tmp0                  ; NOFONT (>FFFF) specified ?
        jeq   runlid                ; Yes, skip it
        bl    @ldfnt
        data  fntadr,spfont         ; Load specified font
*--------------------------------------------------------------
* Did a system crash occur before runlib was called?
*--------------------------------------------------------------
runlid  ci    r0,>4a4a              ; Crash flag set?
        jne   runlie                ; No, continue
        b     @crash_handler.main   ; Yes, back to crash handler
*--------------------------------------------------------------
* Branch to main program
*--------------------------------------------------------------
runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
        b     @main                 ; Give control to main program
