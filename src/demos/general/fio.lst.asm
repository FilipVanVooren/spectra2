XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > fio.asm.17997
0001               ***************************************************************
0002               *
0003               *                          File I/O test
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: fio.asm                     ; Version 191123-17997
0009               *--------------------------------------------------------------
0010               * 2018-04-01   Development started
0011               ********@*****@*********************@**************************
0012                       save  >6000,>7fff
0013                       aorg  >6000
0014               *--------------------------------------------------------------
0015      0001     debug                     equ  1    ; Turn on debugging
0016               ;--------------------------------------------------------------
0017               ; Equates for spectra2 DSRLNK
0018               ;--------------------------------------------------------------
0019      B000     dsrlnk.dsrlws             equ >b000 ; Address of dsrlnk workspace
0020      2100     dsrlnk.namsto             equ >2100 ; 8-byte RAM buffer for storing device name
0021      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0022      0001     startup_keep_vdpmemory    equ  1    ; Do not clear VDP vram upon startup
0023               
0024               *--------------------------------------------------------------
0025               * Skip unused spectra2 code modules for reduced code size
0026               *--------------------------------------------------------------
0027      0001     skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
0028      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0029      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0030      0001     skip_vdp_hchar            equ  1    ; Skip hchar, xchar
0031      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0032      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0033      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0034      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0035      0001     skip_vdp_rle_decompress   equ  1    ; Skip RLE decompress to VRAM
0036      0001     skip_vdp_yx2px_calc       equ  1    ; Skip YX to pixel calculation
0037      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0038      0001     skip_vdp_sprites          equ  1    ; Skip sprites support
0039      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0040      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0041      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0042      0001     skip_random_generator     equ  1    ; Skip random functions
0043      0001     skip_timer_alloc          equ  1    ; Skip support for timers allocation
0044      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0045               
0046               *--------------------------------------------------------------
0047               * Cartridge header
0048               *--------------------------------------------------------------
0049 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0050 6006 6010             data  prog0
0051 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0052 6010 0000     prog0   data  0                     ; No more items following
0053 6012 6FC2             data  runlib
0055               
0056 6014 1146             byte  17
0057 6015 ....             text  'FIOT 191123-17997'
0058                       even
0059               
0067               *--------------------------------------------------------------
0068               * Include required files
0069               *--------------------------------------------------------------
0070                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *    v2.0
0007               *                TMS9900 Monitor with Arcade Game support
0008               *                                  for
0009               *              the Texas Instruments TI-99/4A Home Computer
0010               *
0011               *                      2010-2019 by Filip Van Vooren
0012               *
0013               *              https://github.com/FilipVanVooren/spectra2.git
0014               *******************************************************************************
0015               * This file: runlib.a99
0016               *******************************************************************************
0017               * Use following equates to skip/exclude support modules and to control startup
0018               * behaviour.
0019               *
0020               * == Memory
0021               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0022               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0023               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0024               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0025               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0026               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0027               *
0028               * == VDP
0029               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0030               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0031               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0032               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0033               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0034               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0035               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0036               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0037               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0038               * skip_vdp_rle_decompress   equ  1  ; Skip RLE decompress to VRAM
0039               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0040               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0041               * skip_vdp_sprites          equ  1  ; Skip sprites support
0042               * skip_vdp_cursor           equ  1  ; Skip cursor support
0043               *
0044               * == Sound & speech
0045               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0046               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0047               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0048               *
0049               * ==  Keyboard
0050               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0051               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0052               *
0053               * == Utilities
0054               * skip_random_generator     equ  1  ; Skip random generator functions
0055               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0056               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0057               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0058               *
0059               * == Kernel/Multitasking
0060               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0061               * skip_mem_paging           equ  1  ; Skip support for memory paging
0062               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0063               *
0064               * == Startup behaviour
0065               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0066               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0067               *******************************************************************************
0068               
0069               *//////////////////////////////////////////////////////////////
0070               *                       RUNLIB SETUP
0071               *//////////////////////////////////////////////////////////////
0072               
0073                       copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
**** **** ****     > equ_memsetup.asm
0001               * FILE......: memsetup.asm
0002               * Purpose...: Equates for spectra2 memory layout
0003               
0004               ***************************************************************
0005               * >8300 - >8341     Scratchpad memory layout (66 bytes)
0006               ********@*****@*********************@**************************
0007      8300     ws1     equ   >8300                 ; 32 - Primary workspace
0008      8320     mcloop  equ   >8320                 ; 08 - Machine code for loop & speech
0009      8328     wbase   equ   >8328                 ; 02 - PNT base address
0010      832A     wyx     equ   >832a                 ; 02 - Cursor YX position
0011      832C     wtitab  equ   >832c                 ; 02 - Timers: Address of timer table
0012      832E     wtiusr  equ   >832e                 ; 02 - Timers: Address of user hook
0013      8330     wtitmp  equ   >8330                 ; 02 - Timers: Internal use
0014      8332     wvrtkb  equ   >8332                 ; 02 - Virtual keyboard flags
0015      8334     wsdlst  equ   >8334                 ; 02 - Sound player: Tune address
0016      8336     wsdtmp  equ   >8336                 ; 02 - Sound player: Temporary use
0017      8338     wspeak  equ   >8338                 ; 02 - Speech player: Address of LPC data
0018      833A     wcolmn  equ   >833a                 ; 02 - Screen size, columns per row
0019      833C     waux1   equ   >833c                 ; 02 - Temporary storage 1
0020      833E     waux2   equ   >833e                 ; 02 - Temporary storage 2
0021      8340     waux3   equ   >8340                 ; 02 - Temporary storage 3
0022               ***************************************************************
0023      832A     by      equ   wyx                   ;      Cursor Y position
0024      832B     bx      equ   wyx+1                 ;      Cursor X position
0025      8322     mcsprd  equ   mcloop+2              ;      Speech read routine
0026               ***************************************************************
**** **** ****     > runlib.asm
0074                       copy  "equ_registers.asm"        ; Equates for runlib registers
**** **** ****     > equ_registers.asm
0001               * FILE......: registers.asm
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4-R8   Temporary registers/variables (tmp0-tmp4)
0011               * R9      Stack pointer
0012               * R10     Highest slot in use + Timer counter
0013               * R11     Subroutine return address
0014               * R12     CRU
0015               * R13     Copy of VDP status byte and counter for sound player
0016               * R14     Copy of VDP register #0 and VDP register #1 bytes
0017               * R15     VDP read/write address
0018               *--------------------------------------------------------------
0019               * Special purpose registers
0020               * R0      shift count
0021               * R12     CRU
0022               * R13     WS     - when using LWPI, BLWP, RTWP
0023               * R14     PC     - when using LWPI, BLWP, RTWP
0024               * R15     STATUS - when using LWPI, BLWP, RTWP
0025               ***************************************************************
0026               * Define registers
0027               ********@*****@*********************@**************************
0028      0000     r0      equ   0
0029      0001     r1      equ   1
0030      0002     r2      equ   2
0031      0003     r3      equ   3
0032      0004     r4      equ   4
0033      0005     r5      equ   5
0034      0006     r6      equ   6
0035      0007     r7      equ   7
0036      0008     r8      equ   8
0037      0009     r9      equ   9
0038      000A     r10     equ   10
0039      000B     r11     equ   11
0040      000C     r12     equ   12
0041      000D     r13     equ   13
0042      000E     r14     equ   14
0043      000F     r15     equ   15
0044               ***************************************************************
0045               * Define register equates
0046               ********@*****@*********************@**************************
0047      0002     config  equ   r2                    ; Config register
0048      0003     xconfig equ   r3                    ; Extended config register
0049      0004     tmp0    equ   r4                    ; Temp register 0
0050      0005     tmp1    equ   r5                    ; Temp register 1
0051      0006     tmp2    equ   r6                    ; Temp register 2
0052      0007     tmp3    equ   r7                    ; Temp register 3
0053      0008     tmp4    equ   r8                    ; Temp register 4
0054      0009     stack   equ   r9                    ; Stack pointer
0055      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0056      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0057               ***************************************************************
0058               * Define MSB/LSB equates for registers
0059               ********@*****@*********************@**************************
0060      8300     r0hb    equ   ws1                   ; HI byte R0
0061      8301     r0lb    equ   ws1+1                 ; LO byte R0
0062      8302     r1hb    equ   ws1+2                 ; HI byte R1
0063      8303     r1lb    equ   ws1+3                 ; LO byte R1
0064      8304     r2hb    equ   ws1+4                 ; HI byte R2
0065      8305     r2lb    equ   ws1+5                 ; LO byte R2
0066      8306     r3hb    equ   ws1+6                 ; HI byte R3
0067      8307     r3lb    equ   ws1+7                 ; LO byte R3
0068      8308     r4hb    equ   ws1+8                 ; HI byte R4
0069      8309     r4lb    equ   ws1+9                 ; LO byte R4
0070      830A     r5hb    equ   ws1+10                ; HI byte R5
0071      830B     r5lb    equ   ws1+11                ; LO byte R5
0072      830C     r6hb    equ   ws1+12                ; HI byte R6
0073      830D     r6lb    equ   ws1+13                ; LO byte R6
0074      830E     r7hb    equ   ws1+14                ; HI byte R7
0075      830F     r7lb    equ   ws1+15                ; LO byte R7
0076      8310     r8hb    equ   ws1+16                ; HI byte R8
0077      8311     r8lb    equ   ws1+17                ; LO byte R8
0078      8312     r9hb    equ   ws1+18                ; HI byte R9
0079      8313     r9lb    equ   ws1+19                ; LO byte R9
0080      8314     r10hb   equ   ws1+20                ; HI byte R10
0081      8315     r10lb   equ   ws1+21                ; LO byte R10
0082      8316     r11hb   equ   ws1+22                ; HI byte R11
0083      8317     r11lb   equ   ws1+23                ; LO byte R11
0084      8318     r12hb   equ   ws1+24                ; HI byte R12
0085      8319     r12lb   equ   ws1+25                ; LO byte R12
0086      831A     r13hb   equ   ws1+26                ; HI byte R13
0087      831B     r13lb   equ   ws1+27                ; LO byte R13
0088      831C     r14hb   equ   ws1+28                ; HI byte R14
0089      831D     r14lb   equ   ws1+29                ; LO byte R14
0090      831E     r15hb   equ   ws1+30                ; HI byte R15
0091      831F     r15lb   equ   ws1+31                ; LO byte R15
0092               ********@*****@*********************@**************************
0093      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0094      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0095      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0096      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0097      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0098      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0099      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0100      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0101      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0102      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0103               ********@*****@*********************@**************************
0104      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0105      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0106      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0107      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0108               ***************************************************************
**** **** ****     > runlib.asm
0075                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
**** **** ****     > equ_portaddr.asm
0001               * FILE......: portaddr.asm
0002               * Purpose...: Equates for hardware port addresses
0003               
0004               ***************************************************************
0005               * Equates for VDP, GROM, SOUND, SPEECH ports
0006               ********@*****@*********************@**************************
0007      8400     sound   equ   >8400                 ; Sound generator address
0008      8800     vdpr    equ   >8800                 ; VDP read data window address
0009      8C00     vdpw    equ   >8c00                 ; VDP write data window address
0010      8802     vdps    equ   >8802                 ; VDP status register
0011      8C02     vdpa    equ   >8c02                 ; VDP address register
0012      9C02     grmwa   equ   >9c02                 ; GROM set write address
0013      9802     grmra   equ   >9802                 ; GROM set read address
0014      9800     grmrd   equ   >9800                 ; GROM read byte
0015      9C00     grmwd   equ   >9c00                 ; GROM write byte
0016      9000     spchrd  equ   >9000                 ; Address of speech synth Read Data Register
0017      9400     spchwt  equ   >9400                 ; Address of speech synth Write Data Register
**** **** ****     > runlib.asm
0076                       copy  "equ_param.asm"            ; Equates for runlib parameters
**** **** ****     > equ_param.asm
0001               * FILE......: param.asm
0002               * Purpose...: Equates used for subroutine parameters
0003               
0004               ***************************************************************
0005               * Subroutine parameter equates
0006               ***************************************************************
0007      FFFF     eol     equ   >ffff                 ; End-Of-List
0008      FFFF     nofont  equ   >ffff                 ; Skip loading font in RUNLIB
0009      0000     norep   equ   0                     ; PUTBOX > Value for P3. Don't repeat box
0010      3030     num1    equ   >3030                 ; MKNUM  > ASCII 0-9, leading 0's
0011      3020     num2    equ   >3020                 ; MKNUM  > ASCII 0-9, leading spaces
0012      0007     sdopt1  equ   7                     ; SDPLAY > 111 (Player on, repeat, tune in CPU memory)
0013      0005     sdopt2  equ   5                     ; SDPLAY > 101 (Player on, no repeat, tune in CPU memory)
0014      0006     sdopt3  equ   6                     ; SDPLAY > 110 (Player on, repeat, tune in VRAM)
0015      0004     sdopt4  equ   4                     ; SDPLAY > 100 (Player on, no repeat, tune in VRAM)
0016      0000     fnopt1  equ   >0000                 ; LDFNT  > Load TI title screen font
0017      0006     fnopt2  equ   >0006                 ; LDFNT  > Load upper case font
0018      000C     fnopt3  equ   >000c                 ; LDFNT  > Load upper/lower case font
0019      0012     fnopt4  equ   >0012                 ; LDFNT  > Load lower case font
0020      8000     fnopt5  equ   >8000                 ; LDFNT  > Load TI title screen font  & bold
0021      8006     fnopt6  equ   >8006                 ; LDFNT  > Load upper case font       & bold
0022      800C     fnopt7  equ   >800c                 ; LDFNT  > Load upper/lower case font & bold
0023      8012     fnopt8  equ   >8012                 ; LDFNT  > Load lower case font       & bold
0024               *--------------------------------------------------------------
0025               *   Speech player
0026               *--------------------------------------------------------------
0027      0060     talkon  equ   >60                   ; 'start talking' command code for speech synth
0028      00FF     talkof  equ   >ff                   ; 'stop talking' command code for speech synth
0029      6000     spkon   equ   >6000                 ; 'start talking' command code for speech synth
0030      FF00     spkoff  equ   >ff00                 ; 'stop talking' command code for speech synth
**** **** ****     > runlib.asm
0077               
0081               
0082                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Constants and equates used by runlib modules
0003               
0004               
0005               ***************************************************************
0006               *                      Some constants
0007               ********@*****@*********************@**************************
0008               
0009               ---------------------------------------------------------------
0010               * Word values
0011               *--------------------------------------------------------------
0012               ;                                   ;       0123456789ABCDEF
0013 6026 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0014 6028 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0015 602A 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0016 602C 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0017 602E 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0018 6030 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0019 6032 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0020 6034 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0021 6036 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0022 6038 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0023 603A 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0024 603C 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0025 603E 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0026 6040 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0027 6042 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0028 6044 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0029 6046 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0030 6048 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0031 604A D000     w$d000  data  >d000                 ; >d000
0032               *--------------------------------------------------------------
0033               * Byte values - High byte (=MSB) for byte operations
0034               *--------------------------------------------------------------
0035      6026     hb$00   equ   w$0000                ; >0000
0036      6038     hb$01   equ   w$0100                ; >0100
0037      603A     hb$02   equ   w$0200                ; >0200
0038      603C     hb$04   equ   w$0400                ; >0400
0039      603E     hb$08   equ   w$0800                ; >0800
0040      6040     hb$10   equ   w$1000                ; >1000
0041      6042     hb$20   equ   w$2000                ; >2000
0042      6044     hb$40   equ   w$4000                ; >4000
0043      6046     hb$80   equ   w$8000                ; >8000
0044      604A     hb$d0   equ   w$d000                ; >d000
0045               *--------------------------------------------------------------
0046               * Byte values - Low byte (=LSB) for byte operations
0047               *--------------------------------------------------------------
0048      6026     lb$00   equ   w$0000                ; >0000
0049      6028     lb$01   equ   w$0001                ; >0001
0050      602A     lb$02   equ   w$0002                ; >0002
0051      602C     lb$04   equ   w$0004                ; >0004
0052      602E     lb$08   equ   w$0008                ; >0008
0053      6030     lb$10   equ   w$0010                ; >0010
0054      6032     lb$20   equ   w$0020                ; >0020
0055      6034     lb$40   equ   w$0040                ; >0040
0056      6036     lb$80   equ   w$0080                ; >0080
0057               *--------------------------------------------------------------
0058               * Bit values
0059               *--------------------------------------------------------------
0060               ;                                   ;       0123456789ABCDEF
0061      6028     wbit15  equ   w$0001                ; >0001 0000000000000001
0062      602A     wbit14  equ   w$0002                ; >0002 0000000000000010
0063      602C     wbit13  equ   w$0004                ; >0004 0000000000000100
0064      602E     wbit12  equ   w$0008                ; >0008 0000000000001000
0065      6030     wbit11  equ   w$0010                ; >0010 0000000000010000
0066      6032     wbit10  equ   w$0020                ; >0020 0000000000100000
0067      6034     wbit9   equ   w$0040                ; >0040 0000000001000000
0068      6036     wbit8   equ   w$0080                ; >0080 0000000010000000
0069      6038     wbit7   equ   w$0100                ; >0100 0000000100000000
0070      603A     wbit6   equ   w$0200                ; >0200 0000001000000000
0071      603C     wbit5   equ   w$0400                ; >0400 0000010000000000
0072      603E     wbit4   equ   w$0800                ; >0800 0000100000000000
0073      6040     wbit3   equ   w$1000                ; >1000 0001000000000000
0074      6042     wbit2   equ   w$2000                ; >2000 0010000000000000
0075      6044     wbit1   equ   w$4000                ; >4000 0100000000000000
0076      6046     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0083                       copy  "equ_config.asm"           ; Equates for bits in config register
**** **** ****     > equ_config.asm
0001               * FILE......: equ_config.asm
0002               * Purpose...: Equates for bits in config register
0003               
0004               ***************************************************************
0005               * The config register equates
0006               *--------------------------------------------------------------
0007               * Configuration flags
0008               * ===================
0009               *
0010               * ; 15  Sound player: tune source       1=ROM/RAM      0=VDP MEMORY
0011               * ; 14  Sound player: repeat tune       1=yes          0=no
0012               * ; 13  Sound player: enabled           1=yes          0=no (or pause)
0013               * ; 12  VDP9918 sprite collision?       1=yes          0=no
0014               * ; 11  Keyboard: ANY key pressed       1=yes          0=no
0015               * ; 10  Keyboard: Alpha lock key down   1=yes          0=no
0016               * ; 09  Timer: Kernel thread enabled    1=yes          0=no
0017               * ; 08  Timer: Block kernel thread      1=yes          0=no
0018               * ; 07  Timer: User hook enabled        1=yes          0=no
0019               * ; 06  Timer: Block user hook          1=yes          0=no
0020               * ; 05  Speech synthesizer present      1=yes          0=no
0021               * ; 04  Speech player: busy             1=yes          0=no
0022               * ; 03  Speech player: enabled          1=yes          0=no
0023               * ; 02  VDP9918 PAL version             1=yes(50)      0=no(60)
0024               * ; 01  F18A present                    1=on           0=off
0025               * ; 00  Subroutine state flag           1=on           0=off
0026               ********@*****@*********************@**************************
0027      6042     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6038     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6034     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6030     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
0032               
**** **** ****     > runlib.asm
0084                       copy  "cpu_crash_hndlr.asm"      ; CPU program crashed handler
**** **** ****     > cpu_crash_hndlr.asm
0001               * FILE......: cpu_crash_hndlr.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               *//////////////////////////////////////////////////////////////
0006               *                      CRASH HANDLER
0007               *//////////////////////////////////////////////////////////////
0008               
0009               ***************************************************************
0010               * crash - CPU program crashed handler
0011               ***************************************************************
0012               *  b  @crash_handler
0013               ********@*****@*********************@**************************
0014               crash_handler:
0015 604C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     604E 8300 
0016 6050 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6052 8302 
0017 6054 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     6056 4A4A 
0018 6058 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     605A 6FCA 
0019               
0020               crash_handler.main:
0021 605C 06A0  32         bl    @putat                ; Show crash message
     605E 627A 
0022 6060 0000             data  >0000,crash_handler.message
     6062 6066 
0023 6064 10FF  14         jmp   $
0024               
0025               crash_handler.message:
0026 6066 0F53             byte  15
0027 6067 ....             text  'System crashed.'
0028               
0029               
**** **** ****     > runlib.asm
0085                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6076 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6078 000E 
     607A 0106 
     607C 0201 
     607E 0020 
0008               *
0009               * ; VDP#0 Control bits
0010               * ;      bit 6=0: M3 | Graphics 1 mode
0011               * ;      bit 7=0: Disable external VDP input
0012               * ; VDP#1 Control bits
0013               * ;      bit 0=1: 16K selection
0014               * ;      bit 1=1: Enable display
0015               * ;      bit 2=1: Enable VDP interrupt
0016               * ;      bit 3=0: M1 \ Graphics 1 mode
0017               * ;      bit 4=0: M2 /
0018               * ;      bit 5=0: reserved
0019               * ;      bit 6=1: 16x16 sprites
0020               * ;      bit 7=0: Sprite magnification (1x)
0021               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0022               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0023               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0024               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0025               * ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
0026               * ; VDP#7 Set screen background color
0027               
0028               
0029               ***************************************************************
0030               * Textmode (40 columns/24 rows)
0031               *--------------------------------------------------------------
0032 6080 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6082 000E 
     6084 0106 
     6086 00C1 
     6088 0028 
0033               *
0034               * ; VDP#0 Control bits
0035               * ;      bit 6=0: M3 | Graphics 1 mode
0036               * ;      bit 7=0: Disable external VDP input
0037               * ; VDP#1 Control bits
0038               * ;      bit 0=1: 16K selection
0039               * ;      bit 1=1: Enable display
0040               * ;      bit 2=1: Enable VDP interrupt
0041               * ;      bit 3=1: M1 \ TEXT MODE
0042               * ;      bit 4=0: M2 /
0043               * ;      bit 5=0: reserved
0044               * ;      bit 6=1: 16x16 sprites
0045               * ;      bit 7=0: Sprite magnification (1x)
0046               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0047               * ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
0048               * ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
0049               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0050               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0051               * ; VDP#7 Set foreground/background color
0052               ***************************************************************
0053               
0054               
0055               ***************************************************************
0056               * Textmode (80 columns, 24 rows) - F18A
0057               *--------------------------------------------------------------
0058 608A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     608C 003F 
     608E 0240 
     6090 03C1 
     6092 0050 
0059               *
0060               * ; VDP#0 Control bits
0061               * ;      bit 6=0: M3 | Graphics 1 mode
0062               * ;      bit 7=0: Disable external VDP input
0063               * ; VDP#1 Control bits
0064               * ;      bit 0=1: 16K selection
0065               * ;      bit 1=1: Enable display
0066               * ;      bit 2=1: Enable VDP interrupt
0067               * ;      bit 3=1: M1 \ TEXT MODE
0068               * ;      bit 4=0: M2 /
0069               * ;      bit 5=0: reserved
0070               * ;      bit 6=0: 8x8 sprites
0071               * ;      bit 7=0: Sprite magnification (1x)
0072               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0073               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0074               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0075               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0076               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0077               * ; VDP#7 Set foreground/background color
0078               ***************************************************************
0079               
0080               
0081               ***************************************************************
0082               * Textmode (80 columns, 30 rows) - F18A
0083               *--------------------------------------------------------------
0084 6094 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6096 003F 
     6098 0240 
     609A 03C1 
     609C 0050 
0085               *
0086               * ; VDP#0 Control bits
0087               * ;      bit 6=0: M3 | Graphics 1 mode
0088               * ;      bit 7=0: Disable external VDP input
0089               * ; VDP#1 Control bits
0090               * ;      bit 0=1: 16K selection
0091               * ;      bit 1=1: Enable display
0092               * ;      bit 2=1: Enable VDP interrupt
0093               * ;      bit 3=1: M1 \ TEXT MODE
0094               * ;      bit 4=0: M2 /
0095               * ;      bit 5=0: reserved
0096               * ;      bit 6=0: 8x8 sprites
0097               * ;      bit 7=0: Sprite magnification (1x)
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0103               * ; VDP#7 Set foreground/background color
0104               ***************************************************************
**** **** ****     > runlib.asm
0086                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
**** **** ****     > basic_cpu_vdp.asm
0001               * FILE......: basic_cpu_vdp.asm
0002               * Purpose...: Basic CPU & VDP functions used by other modules
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *       Support Machine Code for copy & fill functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ; Machine code for tight loop.
0010               * ; The MOV operation at MCLOOP must be injected by the calling routine.
0011               *--------------------------------------------------------------
0012               *       DATA  >????                 ; \ mcloop  mov   ...
0013 609E 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 60A0 16FD             data  >16fd                 ; |         jne   mcloop
0015 60A2 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 60A4 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 60A6 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               *//////////////////////////////////////////////////////////////
0027               *                    STACK SUPPORT FUNCTIONS
0028               *//////////////////////////////////////////////////////////////
0029               
0030               ***************************************************************
0031               * POPR. - Pop registers & return to caller
0032               ***************************************************************
0033               *  B  @POPRG.
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  R11 must be at stack bottom
0037               ********@*****@*********************@**************************
0038 60A8 C0F9  30 popr3   mov   *stack+,r3
0039 60AA C0B9  30 popr2   mov   *stack+,r2
0040 60AC C079  30 popr1   mov   *stack+,r1
0041 60AE C039  30 popr0   mov   *stack+,r0
0042 60B0 C2F9  30 poprt   mov   *stack+,r11
0043 60B2 045B  20         b     *r11
0044               
0045               
0046               
0047               *//////////////////////////////////////////////////////////////
0048               *                   MEMORY FILL FUNCTIONS
0049               *//////////////////////////////////////////////////////////////
0050               
0051               ***************************************************************
0052               * FILM - Fill CPU memory with byte
0053               ***************************************************************
0054               *  bl   @film
0055               *  data P0,P1,P2
0056               *--------------------------------------------------------------
0057               *  P0 = Memory start address
0058               *  P1 = Byte to fill
0059               *  P2 = Number of bytes to fill
0060               *--------------------------------------------------------------
0061               *  bl   @xfilm
0062               *
0063               *  TMP0 = Memory start address
0064               *  TMP1 = Byte to fill
0065               *  TMP2 = Number of bytes to fill
0066               ********@*****@*********************@**************************
0067 60B4 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 60B6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 60B8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 60BA C1C6  18 xfilm   mov   tmp2,tmp3
0074 60BC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60BE 0001 
0075               
0076 60C0 1301  14         jeq   film1
0077 60C2 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60C4 D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60C6 830B 
     60C8 830A 
0079 60CA CD05  34 film2   mov   tmp1,*tmp0+
0080 60CC 0646  14         dect  tmp2
0081 60CE 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60D0 C1C7  18         mov   tmp3,tmp3
0086 60D2 1301  14         jeq   filmz
0087 60D4 D505  30         movb  tmp1,*tmp0
0088 60D6 045B  20 filmz   b     *r11
0089               
0090               
0091               ***************************************************************
0092               * FILV - Fill VRAM with byte
0093               ***************************************************************
0094               *  BL   @FILV
0095               *  DATA P0,P1,P2
0096               *--------------------------------------------------------------
0097               *  P0 = VDP start address
0098               *  P1 = Byte to fill
0099               *  P2 = Number of bytes to fill
0100               *--------------------------------------------------------------
0101               *  BL   @XFILV
0102               *
0103               *  TMP0 = VDP start address
0104               *  TMP1 = Byte to fill
0105               *  TMP2 = Number of bytes to fill
0106               ********@*****@*********************@**************************
0107 60D8 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60DA C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60DC C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60DE 0264  22 xfilv   ori   tmp0,>4000
     60E0 4000 
0114 60E2 06C4  14         swpb  tmp0
0115 60E4 D804  38         movb  tmp0,@vdpa
     60E6 8C02 
0116 60E8 06C4  14         swpb  tmp0
0117 60EA D804  38         movb  tmp0,@vdpa
     60EC 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60EE 020F  20         li    r15,vdpw              ; Set VDP write address
     60F0 8C00 
0122 60F2 06C5  14         swpb  tmp1
0123 60F4 C820  54         mov   @filzz,@mcloop        ; Setup move command
     60F6 60FE 
     60F8 8320 
0124 60FA 0460  28         b     @mcloop               ; Write data to VDP
     60FC 8320 
0125               *--------------------------------------------------------------
0129 60FE D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0131               
0132               
0133               
0134               *//////////////////////////////////////////////////////////////
0135               *                  VDP LOW LEVEL FUNCTIONS
0136               *//////////////////////////////////////////////////////////////
0137               
0138               ***************************************************************
0139               * VDWA / VDRA - Setup VDP write or read address
0140               ***************************************************************
0141               *  BL   @VDWA
0142               *
0143               *  TMP0 = VDP destination address for write
0144               *--------------------------------------------------------------
0145               *  BL   @VDRA
0146               *
0147               *  TMP0 = VDP source address for read
0148               ********@*****@*********************@**************************
0149 6100 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6102 4000 
0150 6104 06C4  14 vdra    swpb  tmp0
0151 6106 D804  38         movb  tmp0,@vdpa
     6108 8C02 
0152 610A 06C4  14         swpb  tmp0
0153 610C D804  38         movb  tmp0,@vdpa            ; Set VDP address
     610E 8C02 
0154 6110 045B  20         b     *r11                  ; Exit
0155               
0156               ***************************************************************
0157               * VPUTB - VDP put single byte
0158               ***************************************************************
0159               *  BL @VPUTB
0160               *  DATA P0,P1
0161               *--------------------------------------------------------------
0162               *  P0 = VDP target address
0163               *  P1 = Byte to write
0164               ********@*****@*********************@**************************
0165 6112 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 6114 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0167               *--------------------------------------------------------------
0168               * Set VDP write address
0169               *--------------------------------------------------------------
0170 6116 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6118 4000 
0171 611A 06C4  14         swpb  tmp0                  ; \
0172 611C D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     611E 8C02 
0173 6120 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0174 6122 D804  38         movb  tmp0,@vdpa            ; /
     6124 8C02 
0175               *--------------------------------------------------------------
0176               * Write byte
0177               *--------------------------------------------------------------
0178 6126 06C5  14         swpb  tmp1                  ; LSB to MSB
0179 6128 D7C5  30         movb  tmp1,*r15             ; Write byte
0180 612A 045B  20         b     *r11                  ; Exit
0181               
0182               
0183               ***************************************************************
0184               * VGETB - VDP get single byte
0185               ***************************************************************
0186               *  bl   @vgetb
0187               *  data p0
0188               *--------------------------------------------------------------
0189               *  P0 = VDP source address
0190               *--------------------------------------------------------------
0191               *  bl   @xvgetb
0192               *
0193               *  tmp0 = VDP source address
0194               *--------------------------------------------------------------
0195               *  Output:
0196               *  tmp0 MSB = >00
0197               *  tmp0 LSB = VDP byte read
0198               ********@*****@*********************@**************************
0199 612C C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0200               *--------------------------------------------------------------
0201               * Set VDP read address
0202               *--------------------------------------------------------------
0203 612E 06C4  14 xvgetb  swpb  tmp0                  ; \
0204 6130 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6132 8C02 
0205 6134 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0206 6136 D804  38         movb  tmp0,@vdpa            ; /
     6138 8C02 
0207               *--------------------------------------------------------------
0208               * Read byte
0209               *--------------------------------------------------------------
0210 613A D120  34         movb  @vdpr,tmp0            ; Read byte
     613C 8800 
0211 613E 0984  56         srl   tmp0,8                ; Right align
0212 6140 045B  20         b     *r11                  ; Exit
0213               
0214               
0215               ***************************************************************
0216               * VIDTAB - Dump videomode table
0217               ***************************************************************
0218               *  BL   @VIDTAB
0219               *  DATA P0
0220               *--------------------------------------------------------------
0221               *  P0 = Address of video mode table
0222               *--------------------------------------------------------------
0223               *  BL   @XIDTAB
0224               *
0225               *  TMP0 = Address of video mode table
0226               *--------------------------------------------------------------
0227               *  Remarks
0228               *  TMP1 = MSB is the VDP target register
0229               *         LSB is the value to write
0230               ********@*****@*********************@**************************
0231 6142 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0232 6144 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0233               *--------------------------------------------------------------
0234               * Calculate PNT base address
0235               *--------------------------------------------------------------
0236 6146 C144  18         mov   tmp0,tmp1
0237 6148 05C5  14         inct  tmp1
0238 614A D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0239 614C 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     614E FF00 
0240 6150 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0241 6152 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6154 8328 
0242               *--------------------------------------------------------------
0243               * Dump VDP shadow registers
0244               *--------------------------------------------------------------
0245 6156 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6158 8000 
0246 615A 0206  20         li    tmp2,8
     615C 0008 
0247 615E D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6160 830B 
0248 6162 06C5  14         swpb  tmp1
0249 6164 D805  38         movb  tmp1,@vdpa
     6166 8C02 
0250 6168 06C5  14         swpb  tmp1
0251 616A D805  38         movb  tmp1,@vdpa
     616C 8C02 
0252 616E 0225  22         ai    tmp1,>0100
     6170 0100 
0253 6172 0606  14         dec   tmp2
0254 6174 16F4  14         jne   vidta1                ; Next register
0255 6176 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6178 833A 
0256 617A 045B  20         b     *r11
0257               
0258               
0259               ***************************************************************
0260               * PUTVR  - Put single VDP register
0261               ***************************************************************
0262               *  BL   @PUTVR
0263               *  DATA P0
0264               *--------------------------------------------------------------
0265               *  P0 = MSB is the VDP target register
0266               *       LSB is the value to write
0267               *--------------------------------------------------------------
0268               *  BL   @PUTVRX
0269               *
0270               *  TMP0 = MSB is the VDP target register
0271               *         LSB is the value to write
0272               ********@*****@*********************@**************************
0273 617C C13B  30 putvr   mov   *r11+,tmp0
0274 617E 0264  22 putvrx  ori   tmp0,>8000
     6180 8000 
0275 6182 06C4  14         swpb  tmp0
0276 6184 D804  38         movb  tmp0,@vdpa
     6186 8C02 
0277 6188 06C4  14         swpb  tmp0
0278 618A D804  38         movb  tmp0,@vdpa
     618C 8C02 
0279 618E 045B  20         b     *r11
0280               
0281               
0282               ***************************************************************
0283               * PUTV01  - Put VDP registers #0 and #1
0284               ***************************************************************
0285               *  BL   @PUTV01
0286               ********@*****@*********************@**************************
0287 6190 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0288 6192 C10E  18         mov   r14,tmp0
0289 6194 0984  56         srl   tmp0,8
0290 6196 06A0  32         bl    @putvrx               ; Write VR#0
     6198 617E 
0291 619A 0204  20         li    tmp0,>0100
     619C 0100 
0292 619E D820  54         movb  @r14lb,@tmp0lb
     61A0 831D 
     61A2 8309 
0293 61A4 06A0  32         bl    @putvrx               ; Write VR#1
     61A6 617E 
0294 61A8 0458  20         b     *tmp4                 ; Exit
0295               
0296               
0297               ***************************************************************
0298               * LDFNT - Load TI-99/4A font from GROM into VDP
0299               ***************************************************************
0300               *  BL   @LDFNT
0301               *  DATA P0,P1
0302               *--------------------------------------------------------------
0303               *  P0 = VDP Target address
0304               *  P1 = Font options
0305               *--------------------------------------------------------------
0306               * Uses registers tmp0-tmp4
0307               ********@*****@*********************@**************************
0308 61AA C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0309 61AC 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0310 61AE C11B  26         mov   *r11,tmp0             ; Get P0
0311 61B0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61B2 7FFF 
0312 61B4 2120  38         coc   @wbit0,tmp0
     61B6 6046 
0313 61B8 1604  14         jne   ldfnt1
0314 61BA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     61BC 8000 
0315 61BE 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     61C0 7FFF 
0316               *--------------------------------------------------------------
0317               * Read font table address from GROM into tmp1
0318               *--------------------------------------------------------------
0319 61C2 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     61C4 622C 
0320 61C6 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     61C8 9C02 
0321 61CA 06C4  14         swpb  tmp0
0322 61CC D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     61CE 9C02 
0323 61D0 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61D2 9800 
0324 61D4 06C5  14         swpb  tmp1
0325 61D6 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61D8 9800 
0326 61DA 06C5  14         swpb  tmp1
0327               *--------------------------------------------------------------
0328               * Setup GROM source address from tmp1
0329               *--------------------------------------------------------------
0330 61DC D805  38         movb  tmp1,@grmwa
     61DE 9C02 
0331 61E0 06C5  14         swpb  tmp1
0332 61E2 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61E4 9C02 
0333               *--------------------------------------------------------------
0334               * Setup VDP target address
0335               *--------------------------------------------------------------
0336 61E6 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0337 61E8 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61EA 6100 
0338 61EC 05C8  14         inct  tmp4                  ; R11=R11+2
0339 61EE C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0340 61F0 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61F2 7FFF 
0341 61F4 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61F6 622E 
0342 61F8 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61FA 6230 
0343               *--------------------------------------------------------------
0344               * Copy from GROM to VRAM
0345               *--------------------------------------------------------------
0346 61FC 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0347 61FE 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0348 6200 D120  34         movb  @grmrd,tmp0
     6202 9800 
0349               *--------------------------------------------------------------
0350               *   Make font fat
0351               *--------------------------------------------------------------
0352 6204 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6206 6046 
0353 6208 1603  14         jne   ldfnt3                ; No, so skip
0354 620A D1C4  18         movb  tmp0,tmp3
0355 620C 0917  56         srl   tmp3,1
0356 620E E107  18         soc   tmp3,tmp0
0357               *--------------------------------------------------------------
0358               *   Dump byte to VDP and do housekeeping
0359               *--------------------------------------------------------------
0360 6210 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6212 8C00 
0361 6214 0606  14         dec   tmp2
0362 6216 16F2  14         jne   ldfnt2
0363 6218 05C8  14         inct  tmp4                  ; R11=R11+2
0364 621A 020F  20         li    r15,vdpw              ; Set VDP write address
     621C 8C00 
0365 621E 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6220 7FFF 
0366 6222 0458  20         b     *tmp4                 ; Exit
0367 6224 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6226 6026 
     6228 8C00 
0368 622A 10E8  14         jmp   ldfnt2
0369               *--------------------------------------------------------------
0370               * Fonts pointer table
0371               *--------------------------------------------------------------
0372 622C 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     622E 0200 
     6230 0000 
0373 6232 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6234 01C0 
     6236 0101 
0374 6238 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     623A 02A0 
     623C 0101 
0375 623E 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6240 00E0 
     6242 0101 
0376               
0377               
0378               
0379               ***************************************************************
0380               * YX2PNT - Get VDP PNT address for current YX cursor position
0381               ***************************************************************
0382               *  BL   @YX2PNT
0383               *--------------------------------------------------------------
0384               *  INPUT
0385               *  @WYX = Cursor YX position
0386               *--------------------------------------------------------------
0387               *  OUTPUT
0388               *  TMP0 = VDP address for entry in Pattern Name Table
0389               *--------------------------------------------------------------
0390               *  Register usage
0391               *  TMP0, R14, R15
0392               ********@*****@*********************@**************************
0393 6244 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0394 6246 C3A0  34         mov   @wyx,r14              ; Get YX
     6248 832A 
0395 624A 098E  56         srl   r14,8                 ; Right justify (remove X)
0396 624C 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     624E 833A 
0397               *--------------------------------------------------------------
0398               * Do rest of calculation with R15 (16 bit part is there)
0399               * Re-use R14
0400               *--------------------------------------------------------------
0401 6250 C3A0  34         mov   @wyx,r14              ; Get YX
     6252 832A 
0402 6254 024E  22         andi  r14,>00ff             ; Remove Y
     6256 00FF 
0403 6258 A3CE  18         a     r14,r15               ; pos = pos + X
0404 625A A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     625C 8328 
0405               *--------------------------------------------------------------
0406               * Clean up before exit
0407               *--------------------------------------------------------------
0408 625E C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0409 6260 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0410 6262 020F  20         li    r15,vdpw              ; VDP write address
     6264 8C00 
0411 6266 045B  20         b     *r11
0412               
0413               
0414               
0415               ***************************************************************
0416               * Put length-byte prefixed string at current YX
0417               ***************************************************************
0418               *  BL   @PUTSTR
0419               *  DATA P0
0420               *
0421               *  P0 = Pointer to string
0422               *--------------------------------------------------------------
0423               *  REMARKS
0424               *  First byte of string must contain length
0425               ********@*****@*********************@**************************
0426 6268 C17B  30 putstr  mov   *r11+,tmp1
0427 626A D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0428 626C C1CB  18 xutstr  mov   r11,tmp3
0429 626E 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6270 6244 
0430 6272 C2C7  18         mov   tmp3,r11
0431 6274 0986  56         srl   tmp2,8                ; Right justify length byte
0432 6276 0460  28         b     @xpym2v               ; Display string
     6278 6288 
0433               
0434               
0435               ***************************************************************
0436               * Put length-byte prefixed string at YX
0437               ***************************************************************
0438               *  BL   @PUTAT
0439               *  DATA P0,P1
0440               *
0441               *  P0 = YX position
0442               *  P1 = Pointer to string
0443               *--------------------------------------------------------------
0444               *  REMARKS
0445               *  First byte of string must contain length
0446               ********@*****@*********************@**************************
0447 627A C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     627C 832A 
0448 627E 0460  28         b     @putstr
     6280 6268 
**** **** ****     > runlib.asm
0087               
0089                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
**** **** ****     > copy_cpu_vram.asm
0001               * FILE......: copy_cpu_vram.asm
0002               * Purpose...: CPU memory to VRAM copy support module
0003               
0004               ***************************************************************
0005               * CPYM2V - Copy CPU memory to VRAM
0006               ***************************************************************
0007               *  BL   @CPYM2V
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP start address
0011               *  P1 = RAM/ROM start address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYM2V
0015               *
0016               *  TMP0 = VDP start address
0017               *  TMP1 = RAM/ROM start address
0018               *  TMP2 = Number of bytes to copy
0019               ********@*****@*********************@**************************
0020 6282 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6284 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6286 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6288 0264  22 xpym2v  ori   tmp0,>4000
     628A 4000 
0027 628C 06C4  14         swpb  tmp0
0028 628E D804  38         movb  tmp0,@vdpa
     6290 8C02 
0029 6292 06C4  14         swpb  tmp0
0030 6294 D804  38         movb  tmp0,@vdpa
     6296 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6298 020F  20         li    r15,vdpw              ; Set VDP write address
     629A 8C00 
0035 629C C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     629E 62A6 
     62A0 8320 
0036 62A2 0460  28         b     @mcloop               ; Write data to VDP
     62A4 8320 
0037 62A6 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0091               
0093                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
**** **** ****     > copy_vram_cpu.asm
0001               * FILE......: copy_vram_cpu.asm
0002               * Purpose...: VRAM to CPU memory copy support module
0003               
0004               ***************************************************************
0005               * CPYV2M - Copy VRAM to CPU memory
0006               ***************************************************************
0007               *  BL   @CPYV2M
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = VDP source address
0011               *  P1 = RAM target address
0012               *  P2 = Number of bytes to copy
0013               *--------------------------------------------------------------
0014               *  BL @XPYV2M
0015               *
0016               *  TMP0 = VDP source address
0017               *  TMP1 = RAM target address
0018               *  TMP2 = Number of bytes to copy
0019               ********@*****@*********************@**************************
0020 62A8 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 62AA C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 62AC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 62AE 06C4  14 xpyv2m  swpb  tmp0
0027 62B0 D804  38         movb  tmp0,@vdpa
     62B2 8C02 
0028 62B4 06C4  14         swpb  tmp0
0029 62B6 D804  38         movb  tmp0,@vdpa
     62B8 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 62BA 020F  20         li    r15,vdpr              ; Set VDP read address
     62BC 8800 
0034 62BE C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     62C0 62C8 
     62C2 8320 
0035 62C4 0460  28         b     @mcloop               ; Read data from VDP
     62C6 8320 
0036 62C8 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0095               
0097                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
**** **** ****     > copy_cpu_cpu.asm
0001               * FILE......: copy_cpu_cpu.asm
0002               * Purpose...: CPU to CPU memory copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       CPU COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * CPYM2M - Copy CPU memory to CPU memory
0010               ***************************************************************
0011               *  BL   @CPYM2M
0012               *  DATA P0,P1,P2
0013               *--------------------------------------------------------------
0014               *  P0 = Memory source address
0015               *  P1 = Memory target address
0016               *  P2 = Number of bytes to copy
0017               *--------------------------------------------------------------
0018               *  BL @XPYM2M
0019               *
0020               *  TMP0 = Memory source address
0021               *  TMP1 = Memory target address
0022               *  TMP2 = Number of bytes to copy
0023               ********@*****@*********************@**************************
0024 62CA C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 62CC C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 62CE C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 62D0 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 62D2 1602  14         jne   cpym0
0032 62D4 0460  28         b     @crash_handler        ; Yes, crash
     62D6 604C 
0033 62D8 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62DA 7FFF 
0034 62DC C1C4  18         mov   tmp0,tmp3
0035 62DE 0247  22         andi  tmp3,1
     62E0 0001 
0036 62E2 1618  14         jne   cpyodd                ; Odd source address handling
0037 62E4 C1C5  18 cpym1   mov   tmp1,tmp3
0038 62E6 0247  22         andi  tmp3,1
     62E8 0001 
0039 62EA 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62EC 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62EE 6046 
0044 62F0 1605  14         jne   cpym3
0045 62F2 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62F4 631A 
     62F6 8320 
0046 62F8 0460  28         b     @mcloop               ; Copy memory and exit
     62FA 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62FC C1C6  18 cpym3   mov   tmp2,tmp3
0051 62FE 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6300 0001 
0052 6302 1301  14         jeq   cpym4
0053 6304 0606  14         dec   tmp2                  ; Make TMP2 even
0054 6306 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 6308 0646  14         dect  tmp2
0056 630A 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 630C C1C7  18         mov   tmp3,tmp3
0061 630E 1301  14         jeq   cpymz
0062 6310 D554  38         movb  *tmp0,*tmp1
0063 6312 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 6314 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     6316 8000 
0068 6318 10E9  14         jmp   cpym2
0069 631A DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0099               
0103               
0107               
0111               
0113                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********@*****@*********************@**************************
0009 631C 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     631E FFBF 
0010 6320 0460  28         b     @putv01
     6322 6190 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 6324 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6326 0040 
0018 6328 0460  28         b     @putv01
     632A 6190 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 632C 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     632E FFDF 
0026 6330 0460  28         b     @putv01
     6332 6190 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6334 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6336 0020 
0034 6338 0460  28         b     @putv01
     633A 6190 
**** **** ****     > runlib.asm
0115               
0119               
0121                       copy  "vdp_cursor.asm"           ; VDP cursor handling
**** **** ****     > vdp_cursor.asm
0001               * FILE......: vdp_cursor.asm
0002               * Purpose...: VDP cursor handling
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *               VDP cursor movement functions
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * AT - Set cursor YX position
0011               ***************************************************************
0012               *  bl   @yx
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  INPUT
0016               *  P0 = New Cursor YX position
0017               ********@*****@*********************@**************************
0018 633C C83B  50 at      mov   *r11+,@wyx
     633E 832A 
0019 6340 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6342 B820  54 down    ab    @hb$01,@wyx
     6344 6038 
     6346 832A 
0028 6348 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 634A 7820  54 up      sb    @hb$01,@wyx
     634C 6038 
     634E 832A 
0037 6350 045B  20         b     *r11
0038               
0039               
0040               ***************************************************************
0041               * setx - Set cursor X position
0042               ***************************************************************
0043               *  bl   @setx
0044               *  data p0
0045               *--------------------------------------------------------------
0046               *  Register usage
0047               *  TMP0
0048               ********@*****@*********************@**************************
0049 6352 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6354 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6356 832A 
0051 6358 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     635A 832A 
0052 635C 045B  20         b     *r11
**** **** ****     > runlib.asm
0123               
0127               
0131               
0135               
0137                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
**** **** ****     > vdp_f18a_support.asm
0001               * FILE......: vdp_f18a_support.asm
0002               * Purpose...: VDP F18A Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                 VDP F18A LOW-LEVEL FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * f18unl - Unlock F18A VDP
0010               ***************************************************************
0011               *  bl   @f18unl
0012               ********@*****@*********************@**************************
0013 635E C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6360 06A0  32         bl    @putvr                ; Write once
     6362 617C 
0015 6364 391C             data  >391c                 ; VR1/57, value 00011100
0016 6366 06A0  32         bl    @putvr                ; Write twice
     6368 617C 
0017 636A 391C             data  >391c                 ; VR1/57, value 00011100
0018 636C 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 636E C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6370 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6372 617C 
0028 6374 391C             data  >391c
0029 6376 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********@*****@*********************@**************************
0040 6378 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 637A 06A0  32         bl    @cpym2v
     637C 6282 
0042 637E 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6380 63BC 
     6382 0006 
0043 6384 06A0  32         bl    @putvr
     6386 617C 
0044 6388 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 638A 06A0  32         bl    @putvr
     638C 617C 
0046 638E 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 6390 0204  20         li    tmp0,>3f00
     6392 3F00 
0052 6394 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6396 6104 
0053 6398 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     639A 8800 
0054 639C 0984  56         srl   tmp0,8
0055 639E D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     63A0 8800 
0056 63A2 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 63A4 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 63A6 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     63A8 BFFF 
0060 63AA 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 63AC 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     63AE 4000 
0063               f18chk_exit:
0064 63B0 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     63B2 60D8 
0065 63B4 3F00             data  >3f00,>00,6
     63B6 0000 
     63B8 0006 
0066 63BA 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 63BC 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 63BE 3F00             data  >3f00                 ; 3f02 / 3f00
0073 63C0 0340             data  >0340                 ; 3f04   0340  idle
0074               
0075               
0076               ***************************************************************
0077               * f18rst - Reset f18a into standard settings
0078               ***************************************************************
0079               *  bl   @f18rst
0080               *--------------------------------------------------------------
0081               *  REMARKS
0082               *  This is used to leave the F18A mode and revert all settings
0083               *  that could lead to corruption when doing BLWP @0
0084               *
0085               *  There are some F18a settings that stay on when doing blwp @0
0086               *  and the TI title screen cannot recover from that.
0087               *
0088               *  It is your responsibility to set video mode tables should
0089               *  you want to continue instead of doing blwp @0 after your
0090               *  program cleanup
0091               ********@*****@*********************@**************************
0092 63C2 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 63C4 06A0  32         bl    @putvr
     63C6 617C 
0097 63C8 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 63CA 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63CC 617C 
0100 63CE 391C             data  >391c                 ; Lock the F18a
0101 63D0 0458  20         b     *tmp4                 ; Exit
0102               
0103               
0104               
0105               ***************************************************************
0106               * f18fwv - Get F18A Firmware Version
0107               ***************************************************************
0108               *  bl   @f18fwv
0109               *--------------------------------------------------------------
0110               *  REMARKS
0111               *  Successfully tested with F18A v1.8, note that this does not
0112               *  work with F18 v1.3 but you shouldn't be using such old F18A
0113               *  firmware to begin with.
0114               *--------------------------------------------------------------
0115               *  TMP0 High nibble = major version
0116               *  TMP0 Low nibble  = minor version
0117               *
0118               *  Example: >0018     F18a Firmware v1.8
0119               ********@*****@*********************@**************************
0120 63D2 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 63D4 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     63D6 6044 
0122 63D8 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 63DA C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     63DC 8802 
0127 63DE 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     63E0 617C 
0128 63E2 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 63E4 04C4  14         clr   tmp0
0130 63E6 D120  34         movb  @vdps,tmp0
     63E8 8802 
0131 63EA 0984  56         srl   tmp0,8
0132 63EC 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0139               
0143               
0147               
0151               
0155               
0159               
0163               
0167               
0169                       copy  "keyb_virtual.asm"         ; Virtual keyboard scanning
**** **** ****     > keyb_virtual.asm
0001               * FILE......: keyb_virtual.asm
0002               * Purpose...: Virtual keyboard module
0003               
0004               ***************************************************************
0005               * Virtual keyboard equates
0006               ***************************************************************
0007               * bit  0: ALPHA LOCK down             0=no  1=yes
0008               * bit  1: ENTER                       0=no  1=yes
0009               * bit  2: REDO                        0=no  1=yes
0010               * bit  3: BACK                        0=no  1=yes
0011               * bit  4: Pause                       0=no  1=yes
0012               * bit  5: *free*                      0=no  1=yes
0013               * bit  6: P1 Left                     0=no  1=yes
0014               * bit  7: P1 Right                    0=no  1=yes
0015               * bit  8: P1 Up                       0=no  1=yes
0016               * bit  9: P1 Down                     0=no  1=yes
0017               * bit 10: P1 Space / fire / Q         0=no  1=yes
0018               * bit 11: P2 Left                     0=no  1=yes
0019               * bit 12: P2 Right                    0=no  1=yes
0020               * bit 13: P2 Up                       0=no  1=yes
0021               * bit 14: P2 Down                     0=no  1=yes
0022               * bit 15: P2 Space / fire / Q         0=no  1=yes
0023               ***************************************************************
0024      8000     kalpha  equ   >8000                 ; Virtual key alpha lock
0025      4000     kenter  equ   >4000                 ; Virtual key enter
0026      2000     kredo   equ   >2000                 ; Virtual key REDO
0027      1000     kback   equ   >1000                 ; Virtual key BACK
0028      0800     kpause  equ   >0800                 ; Virtual key pause
0029      0400     kfree   equ   >0400                 ; ***NOT USED YET***
0030               *--------------------------------------------------------------
0031               * Keyboard Player 1
0032               *--------------------------------------------------------------
0033      0280     k1uplf  equ   >0280                 ; Virtual key up   + left
0034      0180     k1uprg  equ   >0180                 ; Virtual key up   + right
0035      0240     k1dnlf  equ   >0240                 ; Virtual key down + left
0036      0140     k1dnrg  equ   >0140                 ; Virtual key down + right
0037      0200     k1lf    equ   >0200                 ; Virtual key left
0038      0100     k1rg    equ   >0100                 ; Virtual key right
0039      0080     k1up    equ   >0080                 ; Virtual key up
0040      0040     k1dn    equ   >0040                 ; Virtual key down
0041      0020     k1fire  equ   >0020                 ; Virtual key fire
0042               *--------------------------------------------------------------
0043               * Keyboard Player 2
0044               *--------------------------------------------------------------
0045      0014     k2uplf  equ   >0014                 ; Virtual key up   + left
0046      000C     k2uprg  equ   >000c                 ; Virtual key up   + right
0047      0012     k2dnlf  equ   >0012                 ; Virtual key down + left
0048      000A     k2dnrg  equ   >000a                 ; Virtual key down + right
0049      0010     k2lf    equ   >0010                 ; Virtual key left
0050      0008     k2rg    equ   >0008                 ; Virtual key right
0051      0004     k2up    equ   >0004                 ; Virtual key up
0052      0002     k2dn    equ   >0002                 ; Virtual key down
0053      0001     k2fire  equ   >0001                 ; Virtual key fire
0054                       even
0055               
0056               
0057               
0058               ***************************************************************
0059               * VIRTKB - Read virtual keyboard and joysticks
0060               ***************************************************************
0061               *  BL @VIRTKB
0062               *--------------------------------------------------------------
0063               *  COLUMN     0     1  2  3  4  5    6   7
0064               *         +---------------------------------+------+
0065               *  ROW 7  |   =     .  ,  M  N  /   JS1 JS2 | Fire |
0066               *  ROW 6  | SPACE   L  K  J  H  :;  JS1 JS2 | Left |
0067               *  ROW 5  | ENTER   O  I  U  Y  P   JS1 JS2 | Right|
0068               *  ROW 4  |         9  8  7  6  0   JS1 JS2 | Down |
0069               *  ROW 3  | FCTN    2  3  4  5  1   JS1 JS2 | Up   |
0070               *  ROW 2  | SHIFT   S  D  F  G  A           +------|
0071               *  ROW 1  | CTRL    W  E  R  T  Q                  |
0072               *  ROW 0  |         X  C  V  B  Z                  |
0073               *         +----------------------------------------+
0074               *  See MG smart programmer 1986
0075               *  September/Page 15 and November/Page 6
0076               *  Also see virtual keyboard status for bits to check
0077               *--------------------------------------------------------------
0078               *  Register usage
0079               *  TMP0     Keyboard matrix column to process
0080               *  TMP1MSB  Keyboard matrix 8 bits of 1 column
0081               *  TMP2     Virtual keyboard flags
0082               *  TMP3     Address of entry in mapping table
0083               *  TMP4     Copy of R12 (CONFIG REGISTER)
0084               *  R12      CRU communication
0085               ********@*****@*********************@**************************
0086               virtkb
0087               *       szc   @wbit10,config        ; Reset alpha lock down key
0088 63EE 40A0  34         szc   @wbit11,config        ; Reset ANY key
     63F0 6030 
0089 63F2 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 63F4 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 63F6 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 63F8 0207  20         li    tmp3,kbmap0           ; Start with column 0
     63FA 646A 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 63FC 04CC  14         clr   r12
0097 63FE 1E15  20         sbz   >0015                 ; Set P5
0098 6400 1F07  20         tb    7
0099 6402 1302  14         jeq   virtk1
0100 6404 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     6406 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 6408 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 640A 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     640C 0024 
0107 640E 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 6410 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     6412 0006 
0109 6414 0705  14         seto  tmp1                  ; >FFFF
0110 6416 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 6418 0545  14         inv   tmp1
0112 641A 1302  14         jeq   virtk2                ; >0000 ?
0113 641C E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     641E 6030 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 6420 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 6422 1601  14         jne   virtk3
0119 6424 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 6426 05C7  14 virtk3  inct  tmp3
0121 6428 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     642A 6476 
0122 642C 16F9  14         jne   virtk2                ; No, next entry
0123 642E 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 6430 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     6432 0700 
0128 6434 1309  14         jeq   virtk6                ; Yes, exit
0129 6436 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     6438 0200 
0130 643A 1303  14         jeq   virtk5                ; Yes, skip
0131 643C 0224  22         ai    tmp0,>0100
     643E 0100 
0132 6440 10E3  14         jmp   virtk1
0133 6442 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6444 0500 
0134 6446 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 6448 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 644A C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     644C 8332 
0140 644E 1601  14         jne   virtk7
0141 6450 045B  20         b     *r11                  ; Exit
0142 6452 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6454 FFFF 
0143 6456 1603  14         jne   virtk8                ; No
0144 6458 0701  14         seto  r1                    ; Set exit flag
0145 645A 0460  28         b     @runli1               ; Yes, reset computer
     645C 6FCA 
0146 645E 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     6460 8000 
0147 6462 1602  14         jne   virtk9
0148 6464 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     6466 6030 
0149 6468 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 646A 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     646C FFFF 
0155 646E 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     6470 0020 
0156 6472 0400             data  >0400,kenter          ; >04 00000100  enter
     6474 4000 
0157 6476 FFFF     kbeoc   data  >ffff
0158               
0159 6478 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     647A 1000 
0160 647C 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     647E 0008 
0161 6480 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6482 0004 
0162 6484 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     6486 0200 
0163 6488 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     648A 0040 
0164 648C FFFF             data  >ffff
0165               
0166 648E 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     6490 2000 
0167 6492 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6494 0002 
0168 6496 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6498 0100 
0169 649A 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     649C 0080 
0170 649E 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     64A0 0010 
0171 64A2 FFFF             data  >ffff
0172               
0173 64A4 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     64A6 0001 
0174 64A8 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     64AA 0800 
0175 64AC 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     64AE 0020 
0176 64B0 FFFF             data  >ffff
0177               
0178 64B2 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     64B4 0020 
0179 64B6 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     64B8 0200 
0180 64BA 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     64BC 0100 
0181 64BE 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     64C0 0040 
0182 64C2 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     64C4 0080 
0183 64C6 FFFF             data  >ffff
0184               
0185 64C8 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     64CA 0001 
0186 64CC 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     64CE 0010 
0187 64D0 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     64D2 0008 
0188 64D4 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     64D6 0002 
0189 64D8 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     64DA 0004 
0190 64DC FFFF             data  >ffff
**** **** ****     > runlib.asm
0171               
0173                       copy  "keyb_real.asm"            ; Real Keyboard support
**** **** ****     > keyb_real.asm
0001               * FILE......: keyb_real.asm
0002               * Purpose...: Full (real) keyboard support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     KEYBOARD FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * REALKB - Scan keyboard in real mode
0010               ***************************************************************
0011               *  BL @REALKB
0012               *--------------------------------------------------------------
0013               *  Based on work done by Simon Koppelmann
0014               *  taken from the book "TMS9900 assembler auf dem TI-99/4A"
0015               ********@*****@*********************@**************************
0016 64DE 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64E0 6046 
0017 64E2 020C  20         li    r12,>0024
     64E4 0024 
0018 64E6 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64E8 6576 
0019 64EA 04C6  14         clr   tmp2
0020 64EC 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64EE 04CC  14         clr   r12
0025 64F0 1F08  20         tb    >0008                 ; Shift-key ?
0026 64F2 1302  14         jeq   realk1                ; No
0027 64F4 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64F6 65A6 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64F8 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64FA 1302  14         jeq   realk2                ; No
0033 64FC 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64FE 65D6 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6500 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6502 1302  14         jeq   realk3                ; No
0039 6504 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6506 6606 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6508 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 650A 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 650C 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 650E E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6510 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6512 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6514 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6516 0006 
0052 6518 0606  14 realk5  dec   tmp2
0053 651A 020C  20         li    r12,>24               ; CRU address for P2-P4
     651C 0024 
0054 651E 06C6  14         swpb  tmp2
0055 6520 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6522 06C6  14         swpb  tmp2
0057 6524 020C  20         li    r12,6                 ; CRU read address
     6526 0006 
0058 6528 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 652A 0547  14         inv   tmp3                  ;
0060 652C 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     652E FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6530 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6532 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6534 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6536 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6538 0285  22         ci    tmp1,8
     653A 0008 
0069 653C 1AFA  14         jl    realk6
0070 653E C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6540 1BEB  14         jh    realk5                ; No, next column
0072 6542 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6544 C206  18 realk8  mov   tmp2,tmp4
0077 6546 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6548 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 654A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 654C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 654E 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6550 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6552 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6554 6046 
0087 6556 1608  14         jne   realka                ; No, continue saving key
0088 6558 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     655A 65A0 
0089 655C 1A05  14         jl    realka
0090 655E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6560 659E 
0091 6562 1B02  14         jh    realka                ; No, continue
0092 6564 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6566 E000 
0093 6568 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     656A 833C 
0094 656C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     656E 6030 
0095 6570 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6572 8C00 
0096 6574 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6576 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6578 0000 
     657A FF0D 
     657C 203D 
0099 657E ....             text  'xws29ol.'
0100 6586 ....             text  'ced38ik,'
0101 658E ....             text  'vrf47ujm'
0102 6596 ....             text  'btg56yhn'
0103 659E ....             text  'zqa10p;/'
0104 65A6 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     65A8 0000 
     65AA FF0D 
     65AC 202B 
0105 65AE ....             text  'XWS@(OL>'
0106 65B6 ....             text  'CED#*IK<'
0107 65BE ....             text  'VRF$&UJM'
0108 65C6 ....             text  'BTG%^YHN'
0109 65CE ....             text  'ZQA!)P:-'
0110 65D6 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65D8 0000 
     65DA FF0D 
     65DC 2005 
0111 65DE 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65E0 0804 
     65E2 0F27 
     65E4 C2B9 
0112 65E6 600B             data  >600b,>0907,>063f,>c1B8
     65E8 0907 
     65EA 063F 
     65EC C1B8 
0113 65EE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65F0 7B02 
     65F2 015F 
     65F4 C0C3 
0114 65F6 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65F8 7D0E 
     65FA 0CC6 
     65FC BFC4 
0115 65FE 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6600 7C03 
     6602 BC22 
     6604 BDBA 
0116 6606 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6608 0000 
     660A FF0D 
     660C 209D 
0117 660E 9897             data  >9897,>93b2,>9f8f,>8c9B
     6610 93B2 
     6612 9F8F 
     6614 8C9B 
0118 6616 8385             data  >8385,>84b3,>9e89,>8b80
     6618 84B3 
     661A 9E89 
     661C 8B80 
0119 661E 9692             data  >9692,>86b4,>b795,>8a8D
     6620 86B4 
     6622 B795 
     6624 8A8D 
0120 6626 8294             data  >8294,>87b5,>b698,>888E
     6628 87B5 
     662A B698 
     662C 888E 
0121 662E 9A91             data  >9a91,>81b1,>b090,>9cBB
     6630 81B1 
     6632 B090 
     6634 9CBB 
**** **** ****     > runlib.asm
0175               
0177                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
**** **** ****     > cpu_hexsupport.asm
0001               * FILE......: cpu_hexsupport.asm
0002               * Purpose...: CPU create, display hex numbers module
0003               
0004               ***************************************************************
0005               * MKHEX - Convert hex word to string
0006               ***************************************************************
0007               *  BL   @MKHEX
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = Pointer to 16 bit word
0011               *  P1 = Pointer to string buffer
0012               *  P2 = Offset for ASCII digit
0013               *
0014               *  (CONFIG#0 = 1) = Display number at cursor YX
0015               ********@*****@*********************@**************************
0016 6636 C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 6638 C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     663A 8340 
0018 663C 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     663E 833C 
0019 6640 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 6642 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 6644 0647  14         dect  tmp3                  ; Back to WAUX1
0022 6646 C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 6648 0205  20         li    tmp1,4
     664A 0004 
0027 664C C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 664E 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6650 000F 
0029 6652 A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 6654 06C6  14 mkhex2  swpb  tmp2
0031 6656 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 6658 0944  56         srl   tmp0,4                ; Next nibble
0033 665A 0605  14         dec   tmp1
0034 665C 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 665E 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6660 BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 6662 C160  34         mov   @waux3,tmp1           ; Get pointer
     6664 8340 
0040 6666 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 6668 0585  14         inc   tmp1                  ; Next byte, not word!
0042 666A C120  34         mov   @waux2,tmp0
     666C 833E 
0043 666E 06C4  14         swpb  tmp0
0044 6670 DD44  32         movb  tmp0,*tmp1+
0045 6672 06C4  14         swpb  tmp0
0046 6674 DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 6676 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6678 8340 
0051 667A D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     667C 603C 
0052 667E 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 6680 C120  34         mov   @waux1,tmp0
     6682 833C 
0057 6684 06C4  14         swpb  tmp0
0058 6686 DD44  32         movb  tmp0,*tmp1+
0059 6688 06C4  14         swpb  tmp0
0060 668A DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 668C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     668E 6046 
0065 6690 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 6692 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 6694 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6696 7FFF 
0071 6698 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     669A 8340 
0072 669C 0460  28         b     @xutst0               ; Display string
     669E 626A 
0073 66A0 0610     prefix  data  >0610                 ; Length byte + blank
0074               
0075               
0076               ***************************************************************
0077               * PUTHEX - Put 16 bit word on screen
0078               ***************************************************************
0079               *  BL   @PUTHEX
0080               *  DATA P0,P1,P2,P3
0081               *--------------------------------------------------------------
0082               *  P0 = YX position
0083               *  P1 = Pointer to 16 bit word
0084               *  P2 = Pointer to string buffer
0085               *  P3 = Offset for ASCII digit
0086               ********@*****@*********************@**************************
0087 66A2 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     66A4 832A 
0088 66A6 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     66A8 8000 
0089 66AA 10C5  14         jmp   mkhex                 ; Convert number and display
0090               
**** **** ****     > runlib.asm
0179               
0181                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
**** **** ****     > cpu_numsupport.asm
0001               * FILE......: cpu_numsupport.asm
0002               * Purpose...: CPU create, display numbers module
0003               
0004               ***************************************************************
0005               * MKNUM - Convert unsigned number to string
0006               ***************************************************************
0007               *  BL   @MKNUM
0008               *  DATA P0,P1,P2
0009               *
0010               *  P0   = Pointer to 16 bit unsigned number
0011               *  P1   = Pointer to 5 byte string buffer
0012               *  P2HB = Offset for ASCII digit
0013               *  P2LB = Character for replacing leading 0's
0014               *
0015               *  (CONFIG:0 = 1) = Display number at cursor YX
0016               *-------------------------------------------------------------
0017               *  Destroys registers tmp0-tmp4
0018               ********@*****@*********************@**************************
0019 66AC 0207  20 mknum   li    tmp3,5                ; Digit counter
     66AE 0005 
0020 66B0 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 66B2 C155  26         mov   *tmp1,tmp1            ; /
0022 66B4 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 66B6 0228  22         ai    tmp4,4                ; Get end of buffer
     66B8 0004 
0024 66BA 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     66BC 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 66BE 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 66C0 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 66C2 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 66C4 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 66C6 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 66C8 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 66CA 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 66CC 0607  14         dec   tmp3                  ; Decrease counter
0036 66CE 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 66D0 0207  20         li    tmp3,4                ; Check first 4 digits
     66D2 0004 
0041 66D4 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 66D6 C11B  26         mov   *r11,tmp0
0043 66D8 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 66DA 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 66DC 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 66DE 05CB  14 mknum3  inct  r11
0047 66E0 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     66E2 6046 
0048 66E4 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 66E6 045B  20         b     *r11                  ; Exit
0050 66E8 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 66EA 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 66EC 13F8  14         jeq   mknum3                ; Yes, exit
0053 66EE 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 66F0 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     66F2 7FFF 
0058 66F4 C10B  18         mov   r11,tmp0
0059 66F6 0224  22         ai    tmp0,-4
     66F8 FFFC 
0060 66FA C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 66FC 0206  20         li    tmp2,>0500            ; String length = 5
     66FE 0500 
0062 6700 0460  28         b     @xutstr               ; Display string
     6702 626C 
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1
0072               *--------------------------------------------------------------
0073               *  p0   = Pointer to 5 byte string buffer (no length byte!)
0074               *  p1   = Pointer to output variable
0075               *  p2   = Padding character to match against
0076               *--------------------------------------------------------------
0077               *  Copy unsigned number string into a length-padded, left
0078               *  justified string for display with putstr, putat, ...
0079               *
0080               *  The new string starts at index 5 in buffer, overwriting
0081               *  anything that is located there !
0082               *
0083               *  Before...:   XXXXX
0084               *  After....:   XXXXX|zY       where length byte z=1
0085               *               XXXXX|zYY      where length byte z=2
0086               *                 ..
0087               *               XXXXX|zYYYYY   where length byte z=5
0088               *--------------------------------------------------------------
0089               *  Destroys registers tmp0-tmp3
0090               ********@*****@*********************@**************************
0091               trimnum:
0092 6704 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6706 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6708 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 670A 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 670C 0207  20         li    tmp3,5                ; Set counter
     670E 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6710 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6712 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6714 0584  14         inc   tmp0                  ; Next character
0104 6716 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6718 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 671A 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 671C 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 671E DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6720 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6722 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6724 0607  14         dec   tmp3                  ; Last character ?
0120 6726 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6728 045B  20         b     *r11                  ; Return
0122               
0123               
0124               
0125               
0126               ***************************************************************
0127               * PUTNUM - Put unsigned number on screen
0128               ***************************************************************
0129               *  BL   @PUTNUM
0130               *  DATA P0,P1,P2,P3
0131               *--------------------------------------------------------------
0132               *  P0   = YX position
0133               *  P1   = Pointer to 16 bit unsigned number
0134               *  P2   = Pointer to 5 byte string buffer
0135               *  P3HB = Offset for ASCII digit
0136               *  P3LB = Character for replacing leading 0's
0137               ********@*****@*********************@**************************
0138 672A C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     672C 832A 
0139 672E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6730 8000 
0140 6732 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0183               
0187               
0191               
0193                       copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > mem_scrpad_backrest.asm
0001               * FILE......: mem_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.scrpad.backup - Backup scratchpad memory to >2000
0010               ***************************************************************
0011               *  bl   @mem.scrpad.backup
0012               *--------------------------------------------------------------
0013               *  Register usage
0014               *  None
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to the memory area >2000 - >20FF
0017               *  without using any registers.
0018               ********@*****@*********************@**************************
0019               mem.scrpad.backup:
0020               ********@*****@*********************@**************************
0021 6734 C820  54         mov   @>8300,@>2000
     6736 8300 
     6738 2000 
0022 673A C820  54         mov   @>8302,@>2002
     673C 8302 
     673E 2002 
0023 6740 C820  54         mov   @>8304,@>2004
     6742 8304 
     6744 2004 
0024 6746 C820  54         mov   @>8306,@>2006
     6748 8306 
     674A 2006 
0025 674C C820  54         mov   @>8308,@>2008
     674E 8308 
     6750 2008 
0026 6752 C820  54         mov   @>830A,@>200A
     6754 830A 
     6756 200A 
0027 6758 C820  54         mov   @>830C,@>200C
     675A 830C 
     675C 200C 
0028 675E C820  54         mov   @>830E,@>200E
     6760 830E 
     6762 200E 
0029 6764 C820  54         mov   @>8310,@>2010
     6766 8310 
     6768 2010 
0030 676A C820  54         mov   @>8312,@>2012
     676C 8312 
     676E 2012 
0031 6770 C820  54         mov   @>8314,@>2014
     6772 8314 
     6774 2014 
0032 6776 C820  54         mov   @>8316,@>2016
     6778 8316 
     677A 2016 
0033 677C C820  54         mov   @>8318,@>2018
     677E 8318 
     6780 2018 
0034 6782 C820  54         mov   @>831A,@>201A
     6784 831A 
     6786 201A 
0035 6788 C820  54         mov   @>831C,@>201C
     678A 831C 
     678C 201C 
0036 678E C820  54         mov   @>831E,@>201E
     6790 831E 
     6792 201E 
0037 6794 C820  54         mov   @>8320,@>2020
     6796 8320 
     6798 2020 
0038 679A C820  54         mov   @>8322,@>2022
     679C 8322 
     679E 2022 
0039 67A0 C820  54         mov   @>8324,@>2024
     67A2 8324 
     67A4 2024 
0040 67A6 C820  54         mov   @>8326,@>2026
     67A8 8326 
     67AA 2026 
0041 67AC C820  54         mov   @>8328,@>2028
     67AE 8328 
     67B0 2028 
0042 67B2 C820  54         mov   @>832A,@>202A
     67B4 832A 
     67B6 202A 
0043 67B8 C820  54         mov   @>832C,@>202C
     67BA 832C 
     67BC 202C 
0044 67BE C820  54         mov   @>832E,@>202E
     67C0 832E 
     67C2 202E 
0045 67C4 C820  54         mov   @>8330,@>2030
     67C6 8330 
     67C8 2030 
0046 67CA C820  54         mov   @>8332,@>2032
     67CC 8332 
     67CE 2032 
0047 67D0 C820  54         mov   @>8334,@>2034
     67D2 8334 
     67D4 2034 
0048 67D6 C820  54         mov   @>8336,@>2036
     67D8 8336 
     67DA 2036 
0049 67DC C820  54         mov   @>8338,@>2038
     67DE 8338 
     67E0 2038 
0050 67E2 C820  54         mov   @>833A,@>203A
     67E4 833A 
     67E6 203A 
0051 67E8 C820  54         mov   @>833C,@>203C
     67EA 833C 
     67EC 203C 
0052 67EE C820  54         mov   @>833E,@>203E
     67F0 833E 
     67F2 203E 
0053 67F4 C820  54         mov   @>8340,@>2040
     67F6 8340 
     67F8 2040 
0054 67FA C820  54         mov   @>8342,@>2042
     67FC 8342 
     67FE 2042 
0055 6800 C820  54         mov   @>8344,@>2044
     6802 8344 
     6804 2044 
0056 6806 C820  54         mov   @>8346,@>2046
     6808 8346 
     680A 2046 
0057 680C C820  54         mov   @>8348,@>2048
     680E 8348 
     6810 2048 
0058 6812 C820  54         mov   @>834A,@>204A
     6814 834A 
     6816 204A 
0059 6818 C820  54         mov   @>834C,@>204C
     681A 834C 
     681C 204C 
0060 681E C820  54         mov   @>834E,@>204E
     6820 834E 
     6822 204E 
0061 6824 C820  54         mov   @>8350,@>2050
     6826 8350 
     6828 2050 
0062 682A C820  54         mov   @>8352,@>2052
     682C 8352 
     682E 2052 
0063 6830 C820  54         mov   @>8354,@>2054
     6832 8354 
     6834 2054 
0064 6836 C820  54         mov   @>8356,@>2056
     6838 8356 
     683A 2056 
0065 683C C820  54         mov   @>8358,@>2058
     683E 8358 
     6840 2058 
0066 6842 C820  54         mov   @>835A,@>205A
     6844 835A 
     6846 205A 
0067 6848 C820  54         mov   @>835C,@>205C
     684A 835C 
     684C 205C 
0068 684E C820  54         mov   @>835E,@>205E
     6850 835E 
     6852 205E 
0069 6854 C820  54         mov   @>8360,@>2060
     6856 8360 
     6858 2060 
0070 685A C820  54         mov   @>8362,@>2062
     685C 8362 
     685E 2062 
0071 6860 C820  54         mov   @>8364,@>2064
     6862 8364 
     6864 2064 
0072 6866 C820  54         mov   @>8366,@>2066
     6868 8366 
     686A 2066 
0073 686C C820  54         mov   @>8368,@>2068
     686E 8368 
     6870 2068 
0074 6872 C820  54         mov   @>836A,@>206A
     6874 836A 
     6876 206A 
0075 6878 C820  54         mov   @>836C,@>206C
     687A 836C 
     687C 206C 
0076 687E C820  54         mov   @>836E,@>206E
     6880 836E 
     6882 206E 
0077 6884 C820  54         mov   @>8370,@>2070
     6886 8370 
     6888 2070 
0078 688A C820  54         mov   @>8372,@>2072
     688C 8372 
     688E 2072 
0079 6890 C820  54         mov   @>8374,@>2074
     6892 8374 
     6894 2074 
0080 6896 C820  54         mov   @>8376,@>2076
     6898 8376 
     689A 2076 
0081 689C C820  54         mov   @>8378,@>2078
     689E 8378 
     68A0 2078 
0082 68A2 C820  54         mov   @>837A,@>207A
     68A4 837A 
     68A6 207A 
0083 68A8 C820  54         mov   @>837C,@>207C
     68AA 837C 
     68AC 207C 
0084 68AE C820  54         mov   @>837E,@>207E
     68B0 837E 
     68B2 207E 
0085 68B4 C820  54         mov   @>8380,@>2080
     68B6 8380 
     68B8 2080 
0086 68BA C820  54         mov   @>8382,@>2082
     68BC 8382 
     68BE 2082 
0087 68C0 C820  54         mov   @>8384,@>2084
     68C2 8384 
     68C4 2084 
0088 68C6 C820  54         mov   @>8386,@>2086
     68C8 8386 
     68CA 2086 
0089 68CC C820  54         mov   @>8388,@>2088
     68CE 8388 
     68D0 2088 
0090 68D2 C820  54         mov   @>838A,@>208A
     68D4 838A 
     68D6 208A 
0091 68D8 C820  54         mov   @>838C,@>208C
     68DA 838C 
     68DC 208C 
0092 68DE C820  54         mov   @>838E,@>208E
     68E0 838E 
     68E2 208E 
0093 68E4 C820  54         mov   @>8390,@>2090
     68E6 8390 
     68E8 2090 
0094 68EA C820  54         mov   @>8392,@>2092
     68EC 8392 
     68EE 2092 
0095 68F0 C820  54         mov   @>8394,@>2094
     68F2 8394 
     68F4 2094 
0096 68F6 C820  54         mov   @>8396,@>2096
     68F8 8396 
     68FA 2096 
0097 68FC C820  54         mov   @>8398,@>2098
     68FE 8398 
     6900 2098 
0098 6902 C820  54         mov   @>839A,@>209A
     6904 839A 
     6906 209A 
0099 6908 C820  54         mov   @>839C,@>209C
     690A 839C 
     690C 209C 
0100 690E C820  54         mov   @>839E,@>209E
     6910 839E 
     6912 209E 
0101 6914 C820  54         mov   @>83A0,@>20A0
     6916 83A0 
     6918 20A0 
0102 691A C820  54         mov   @>83A2,@>20A2
     691C 83A2 
     691E 20A2 
0103 6920 C820  54         mov   @>83A4,@>20A4
     6922 83A4 
     6924 20A4 
0104 6926 C820  54         mov   @>83A6,@>20A6
     6928 83A6 
     692A 20A6 
0105 692C C820  54         mov   @>83A8,@>20A8
     692E 83A8 
     6930 20A8 
0106 6932 C820  54         mov   @>83AA,@>20AA
     6934 83AA 
     6936 20AA 
0107 6938 C820  54         mov   @>83AC,@>20AC
     693A 83AC 
     693C 20AC 
0108 693E C820  54         mov   @>83AE,@>20AE
     6940 83AE 
     6942 20AE 
0109 6944 C820  54         mov   @>83B0,@>20B0
     6946 83B0 
     6948 20B0 
0110 694A C820  54         mov   @>83B2,@>20B2
     694C 83B2 
     694E 20B2 
0111 6950 C820  54         mov   @>83B4,@>20B4
     6952 83B4 
     6954 20B4 
0112 6956 C820  54         mov   @>83B6,@>20B6
     6958 83B6 
     695A 20B6 
0113 695C C820  54         mov   @>83B8,@>20B8
     695E 83B8 
     6960 20B8 
0114 6962 C820  54         mov   @>83BA,@>20BA
     6964 83BA 
     6966 20BA 
0115 6968 C820  54         mov   @>83BC,@>20BC
     696A 83BC 
     696C 20BC 
0116 696E C820  54         mov   @>83BE,@>20BE
     6970 83BE 
     6972 20BE 
0117 6974 C820  54         mov   @>83C0,@>20C0
     6976 83C0 
     6978 20C0 
0118 697A C820  54         mov   @>83C2,@>20C2
     697C 83C2 
     697E 20C2 
0119 6980 C820  54         mov   @>83C4,@>20C4
     6982 83C4 
     6984 20C4 
0120 6986 C820  54         mov   @>83C6,@>20C6
     6988 83C6 
     698A 20C6 
0121 698C C820  54         mov   @>83C8,@>20C8
     698E 83C8 
     6990 20C8 
0122 6992 C820  54         mov   @>83CA,@>20CA
     6994 83CA 
     6996 20CA 
0123 6998 C820  54         mov   @>83CC,@>20CC
     699A 83CC 
     699C 20CC 
0124 699E C820  54         mov   @>83CE,@>20CE
     69A0 83CE 
     69A2 20CE 
0125 69A4 C820  54         mov   @>83D0,@>20D0
     69A6 83D0 
     69A8 20D0 
0126 69AA C820  54         mov   @>83D2,@>20D2
     69AC 83D2 
     69AE 20D2 
0127 69B0 C820  54         mov   @>83D4,@>20D4
     69B2 83D4 
     69B4 20D4 
0128 69B6 C820  54         mov   @>83D6,@>20D6
     69B8 83D6 
     69BA 20D6 
0129 69BC C820  54         mov   @>83D8,@>20D8
     69BE 83D8 
     69C0 20D8 
0130 69C2 C820  54         mov   @>83DA,@>20DA
     69C4 83DA 
     69C6 20DA 
0131 69C8 C820  54         mov   @>83DC,@>20DC
     69CA 83DC 
     69CC 20DC 
0132 69CE C820  54         mov   @>83DE,@>20DE
     69D0 83DE 
     69D2 20DE 
0133 69D4 C820  54         mov   @>83E0,@>20E0
     69D6 83E0 
     69D8 20E0 
0134 69DA C820  54         mov   @>83E2,@>20E2
     69DC 83E2 
     69DE 20E2 
0135 69E0 C820  54         mov   @>83E4,@>20E4
     69E2 83E4 
     69E4 20E4 
0136 69E6 C820  54         mov   @>83E6,@>20E6
     69E8 83E6 
     69EA 20E6 
0137 69EC C820  54         mov   @>83E8,@>20E8
     69EE 83E8 
     69F0 20E8 
0138 69F2 C820  54         mov   @>83EA,@>20EA
     69F4 83EA 
     69F6 20EA 
0139 69F8 C820  54         mov   @>83EC,@>20EC
     69FA 83EC 
     69FC 20EC 
0140 69FE C820  54         mov   @>83EE,@>20EE
     6A00 83EE 
     6A02 20EE 
0141 6A04 C820  54         mov   @>83F0,@>20F0
     6A06 83F0 
     6A08 20F0 
0142 6A0A C820  54         mov   @>83F2,@>20F2
     6A0C 83F2 
     6A0E 20F2 
0143 6A10 C820  54         mov   @>83F4,@>20F4
     6A12 83F4 
     6A14 20F4 
0144 6A16 C820  54         mov   @>83F6,@>20F6
     6A18 83F6 
     6A1A 20F6 
0145 6A1C C820  54         mov   @>83F8,@>20F8
     6A1E 83F8 
     6A20 20F8 
0146 6A22 C820  54         mov   @>83FA,@>20FA
     6A24 83FA 
     6A26 20FA 
0147 6A28 C820  54         mov   @>83FC,@>20FC
     6A2A 83FC 
     6A2C 20FC 
0148 6A2E C820  54         mov   @>83FE,@>20FE
     6A30 83FE 
     6A32 20FE 
0149 6A34 045B  20         b     *r11                  ; Return to caller
0150               
0151               
0152               ***************************************************************
0153               * mem.scrpad.restore - Restore scratchpad memory from >2000
0154               ***************************************************************
0155               *  bl   @mem.scrpad.restore
0156               *--------------------------------------------------------------
0157               *  Register usage
0158               *  None
0159               *--------------------------------------------------------------
0160               *  Restore scratchpad from memory area >2000 - >20FF
0161               *  without using any registers.
0162               ********@*****@*********************@**************************
0163               mem.scrpad.restore:
0164 6A36 C820  54         mov   @>2000,@>8300
     6A38 2000 
     6A3A 8300 
0165 6A3C C820  54         mov   @>2002,@>8302
     6A3E 2002 
     6A40 8302 
0166 6A42 C820  54         mov   @>2004,@>8304
     6A44 2004 
     6A46 8304 
0167 6A48 C820  54         mov   @>2006,@>8306
     6A4A 2006 
     6A4C 8306 
0168 6A4E C820  54         mov   @>2008,@>8308
     6A50 2008 
     6A52 8308 
0169 6A54 C820  54         mov   @>200A,@>830A
     6A56 200A 
     6A58 830A 
0170 6A5A C820  54         mov   @>200C,@>830C
     6A5C 200C 
     6A5E 830C 
0171 6A60 C820  54         mov   @>200E,@>830E
     6A62 200E 
     6A64 830E 
0172 6A66 C820  54         mov   @>2010,@>8310
     6A68 2010 
     6A6A 8310 
0173 6A6C C820  54         mov   @>2012,@>8312
     6A6E 2012 
     6A70 8312 
0174 6A72 C820  54         mov   @>2014,@>8314
     6A74 2014 
     6A76 8314 
0175 6A78 C820  54         mov   @>2016,@>8316
     6A7A 2016 
     6A7C 8316 
0176 6A7E C820  54         mov   @>2018,@>8318
     6A80 2018 
     6A82 8318 
0177 6A84 C820  54         mov   @>201A,@>831A
     6A86 201A 
     6A88 831A 
0178 6A8A C820  54         mov   @>201C,@>831C
     6A8C 201C 
     6A8E 831C 
0179 6A90 C820  54         mov   @>201E,@>831E
     6A92 201E 
     6A94 831E 
0180 6A96 C820  54         mov   @>2020,@>8320
     6A98 2020 
     6A9A 8320 
0181 6A9C C820  54         mov   @>2022,@>8322
     6A9E 2022 
     6AA0 8322 
0182 6AA2 C820  54         mov   @>2024,@>8324
     6AA4 2024 
     6AA6 8324 
0183 6AA8 C820  54         mov   @>2026,@>8326
     6AAA 2026 
     6AAC 8326 
0184 6AAE C820  54         mov   @>2028,@>8328
     6AB0 2028 
     6AB2 8328 
0185 6AB4 C820  54         mov   @>202A,@>832A
     6AB6 202A 
     6AB8 832A 
0186 6ABA C820  54         mov   @>202C,@>832C
     6ABC 202C 
     6ABE 832C 
0187 6AC0 C820  54         mov   @>202E,@>832E
     6AC2 202E 
     6AC4 832E 
0188 6AC6 C820  54         mov   @>2030,@>8330
     6AC8 2030 
     6ACA 8330 
0189 6ACC C820  54         mov   @>2032,@>8332
     6ACE 2032 
     6AD0 8332 
0190 6AD2 C820  54         mov   @>2034,@>8334
     6AD4 2034 
     6AD6 8334 
0191 6AD8 C820  54         mov   @>2036,@>8336
     6ADA 2036 
     6ADC 8336 
0192 6ADE C820  54         mov   @>2038,@>8338
     6AE0 2038 
     6AE2 8338 
0193 6AE4 C820  54         mov   @>203A,@>833A
     6AE6 203A 
     6AE8 833A 
0194 6AEA C820  54         mov   @>203C,@>833C
     6AEC 203C 
     6AEE 833C 
0195 6AF0 C820  54         mov   @>203E,@>833E
     6AF2 203E 
     6AF4 833E 
0196 6AF6 C820  54         mov   @>2040,@>8340
     6AF8 2040 
     6AFA 8340 
0197 6AFC C820  54         mov   @>2042,@>8342
     6AFE 2042 
     6B00 8342 
0198 6B02 C820  54         mov   @>2044,@>8344
     6B04 2044 
     6B06 8344 
0199 6B08 C820  54         mov   @>2046,@>8346
     6B0A 2046 
     6B0C 8346 
0200 6B0E C820  54         mov   @>2048,@>8348
     6B10 2048 
     6B12 8348 
0201 6B14 C820  54         mov   @>204A,@>834A
     6B16 204A 
     6B18 834A 
0202 6B1A C820  54         mov   @>204C,@>834C
     6B1C 204C 
     6B1E 834C 
0203 6B20 C820  54         mov   @>204E,@>834E
     6B22 204E 
     6B24 834E 
0204 6B26 C820  54         mov   @>2050,@>8350
     6B28 2050 
     6B2A 8350 
0205 6B2C C820  54         mov   @>2052,@>8352
     6B2E 2052 
     6B30 8352 
0206 6B32 C820  54         mov   @>2054,@>8354
     6B34 2054 
     6B36 8354 
0207 6B38 C820  54         mov   @>2056,@>8356
     6B3A 2056 
     6B3C 8356 
0208 6B3E C820  54         mov   @>2058,@>8358
     6B40 2058 
     6B42 8358 
0209 6B44 C820  54         mov   @>205A,@>835A
     6B46 205A 
     6B48 835A 
0210 6B4A C820  54         mov   @>205C,@>835C
     6B4C 205C 
     6B4E 835C 
0211 6B50 C820  54         mov   @>205E,@>835E
     6B52 205E 
     6B54 835E 
0212 6B56 C820  54         mov   @>2060,@>8360
     6B58 2060 
     6B5A 8360 
0213 6B5C C820  54         mov   @>2062,@>8362
     6B5E 2062 
     6B60 8362 
0214 6B62 C820  54         mov   @>2064,@>8364
     6B64 2064 
     6B66 8364 
0215 6B68 C820  54         mov   @>2066,@>8366
     6B6A 2066 
     6B6C 8366 
0216 6B6E C820  54         mov   @>2068,@>8368
     6B70 2068 
     6B72 8368 
0217 6B74 C820  54         mov   @>206A,@>836A
     6B76 206A 
     6B78 836A 
0218 6B7A C820  54         mov   @>206C,@>836C
     6B7C 206C 
     6B7E 836C 
0219 6B80 C820  54         mov   @>206E,@>836E
     6B82 206E 
     6B84 836E 
0220 6B86 C820  54         mov   @>2070,@>8370
     6B88 2070 
     6B8A 8370 
0221 6B8C C820  54         mov   @>2072,@>8372
     6B8E 2072 
     6B90 8372 
0222 6B92 C820  54         mov   @>2074,@>8374
     6B94 2074 
     6B96 8374 
0223 6B98 C820  54         mov   @>2076,@>8376
     6B9A 2076 
     6B9C 8376 
0224 6B9E C820  54         mov   @>2078,@>8378
     6BA0 2078 
     6BA2 8378 
0225 6BA4 C820  54         mov   @>207A,@>837A
     6BA6 207A 
     6BA8 837A 
0226 6BAA C820  54         mov   @>207C,@>837C
     6BAC 207C 
     6BAE 837C 
0227 6BB0 C820  54         mov   @>207E,@>837E
     6BB2 207E 
     6BB4 837E 
0228 6BB6 C820  54         mov   @>2080,@>8380
     6BB8 2080 
     6BBA 8380 
0229 6BBC C820  54         mov   @>2082,@>8382
     6BBE 2082 
     6BC0 8382 
0230 6BC2 C820  54         mov   @>2084,@>8384
     6BC4 2084 
     6BC6 8384 
0231 6BC8 C820  54         mov   @>2086,@>8386
     6BCA 2086 
     6BCC 8386 
0232 6BCE C820  54         mov   @>2088,@>8388
     6BD0 2088 
     6BD2 8388 
0233 6BD4 C820  54         mov   @>208A,@>838A
     6BD6 208A 
     6BD8 838A 
0234 6BDA C820  54         mov   @>208C,@>838C
     6BDC 208C 
     6BDE 838C 
0235 6BE0 C820  54         mov   @>208E,@>838E
     6BE2 208E 
     6BE4 838E 
0236 6BE6 C820  54         mov   @>2090,@>8390
     6BE8 2090 
     6BEA 8390 
0237 6BEC C820  54         mov   @>2092,@>8392
     6BEE 2092 
     6BF0 8392 
0238 6BF2 C820  54         mov   @>2094,@>8394
     6BF4 2094 
     6BF6 8394 
0239 6BF8 C820  54         mov   @>2096,@>8396
     6BFA 2096 
     6BFC 8396 
0240 6BFE C820  54         mov   @>2098,@>8398
     6C00 2098 
     6C02 8398 
0241 6C04 C820  54         mov   @>209A,@>839A
     6C06 209A 
     6C08 839A 
0242 6C0A C820  54         mov   @>209C,@>839C
     6C0C 209C 
     6C0E 839C 
0243 6C10 C820  54         mov   @>209E,@>839E
     6C12 209E 
     6C14 839E 
0244 6C16 C820  54         mov   @>20A0,@>83A0
     6C18 20A0 
     6C1A 83A0 
0245 6C1C C820  54         mov   @>20A2,@>83A2
     6C1E 20A2 
     6C20 83A2 
0246 6C22 C820  54         mov   @>20A4,@>83A4
     6C24 20A4 
     6C26 83A4 
0247 6C28 C820  54         mov   @>20A6,@>83A6
     6C2A 20A6 
     6C2C 83A6 
0248 6C2E C820  54         mov   @>20A8,@>83A8
     6C30 20A8 
     6C32 83A8 
0249 6C34 C820  54         mov   @>20AA,@>83AA
     6C36 20AA 
     6C38 83AA 
0250 6C3A C820  54         mov   @>20AC,@>83AC
     6C3C 20AC 
     6C3E 83AC 
0251 6C40 C820  54         mov   @>20AE,@>83AE
     6C42 20AE 
     6C44 83AE 
0252 6C46 C820  54         mov   @>20B0,@>83B0
     6C48 20B0 
     6C4A 83B0 
0253 6C4C C820  54         mov   @>20B2,@>83B2
     6C4E 20B2 
     6C50 83B2 
0254 6C52 C820  54         mov   @>20B4,@>83B4
     6C54 20B4 
     6C56 83B4 
0255 6C58 C820  54         mov   @>20B6,@>83B6
     6C5A 20B6 
     6C5C 83B6 
0256 6C5E C820  54         mov   @>20B8,@>83B8
     6C60 20B8 
     6C62 83B8 
0257 6C64 C820  54         mov   @>20BA,@>83BA
     6C66 20BA 
     6C68 83BA 
0258 6C6A C820  54         mov   @>20BC,@>83BC
     6C6C 20BC 
     6C6E 83BC 
0259 6C70 C820  54         mov   @>20BE,@>83BE
     6C72 20BE 
     6C74 83BE 
0260 6C76 C820  54         mov   @>20C0,@>83C0
     6C78 20C0 
     6C7A 83C0 
0261 6C7C C820  54         mov   @>20C2,@>83C2
     6C7E 20C2 
     6C80 83C2 
0262 6C82 C820  54         mov   @>20C4,@>83C4
     6C84 20C4 
     6C86 83C4 
0263 6C88 C820  54         mov   @>20C6,@>83C6
     6C8A 20C6 
     6C8C 83C6 
0264 6C8E C820  54         mov   @>20C8,@>83C8
     6C90 20C8 
     6C92 83C8 
0265 6C94 C820  54         mov   @>20CA,@>83CA
     6C96 20CA 
     6C98 83CA 
0266 6C9A C820  54         mov   @>20CC,@>83CC
     6C9C 20CC 
     6C9E 83CC 
0267 6CA0 C820  54         mov   @>20CE,@>83CE
     6CA2 20CE 
     6CA4 83CE 
0268 6CA6 C820  54         mov   @>20D0,@>83D0
     6CA8 20D0 
     6CAA 83D0 
0269 6CAC C820  54         mov   @>20D2,@>83D2
     6CAE 20D2 
     6CB0 83D2 
0270 6CB2 C820  54         mov   @>20D4,@>83D4
     6CB4 20D4 
     6CB6 83D4 
0271 6CB8 C820  54         mov   @>20D6,@>83D6
     6CBA 20D6 
     6CBC 83D6 
0272 6CBE C820  54         mov   @>20D8,@>83D8
     6CC0 20D8 
     6CC2 83D8 
0273 6CC4 C820  54         mov   @>20DA,@>83DA
     6CC6 20DA 
     6CC8 83DA 
0274 6CCA C820  54         mov   @>20DC,@>83DC
     6CCC 20DC 
     6CCE 83DC 
0275 6CD0 C820  54         mov   @>20DE,@>83DE
     6CD2 20DE 
     6CD4 83DE 
0276 6CD6 C820  54         mov   @>20E0,@>83E0
     6CD8 20E0 
     6CDA 83E0 
0277 6CDC C820  54         mov   @>20E2,@>83E2
     6CDE 20E2 
     6CE0 83E2 
0278 6CE2 C820  54         mov   @>20E4,@>83E4
     6CE4 20E4 
     6CE6 83E4 
0279 6CE8 C820  54         mov   @>20E6,@>83E6
     6CEA 20E6 
     6CEC 83E6 
0280 6CEE C820  54         mov   @>20E8,@>83E8
     6CF0 20E8 
     6CF2 83E8 
0281 6CF4 C820  54         mov   @>20EA,@>83EA
     6CF6 20EA 
     6CF8 83EA 
0282 6CFA C820  54         mov   @>20EC,@>83EC
     6CFC 20EC 
     6CFE 83EC 
0283 6D00 C820  54         mov   @>20EE,@>83EE
     6D02 20EE 
     6D04 83EE 
0284 6D06 C820  54         mov   @>20F0,@>83F0
     6D08 20F0 
     6D0A 83F0 
0285 6D0C C820  54         mov   @>20F2,@>83F2
     6D0E 20F2 
     6D10 83F2 
0286 6D12 C820  54         mov   @>20F4,@>83F4
     6D14 20F4 
     6D16 83F4 
0287 6D18 C820  54         mov   @>20F6,@>83F6
     6D1A 20F6 
     6D1C 83F6 
0288 6D1E C820  54         mov   @>20F8,@>83F8
     6D20 20F8 
     6D22 83F8 
0289 6D24 C820  54         mov   @>20FA,@>83FA
     6D26 20FA 
     6D28 83FA 
0290 6D2A C820  54         mov   @>20FC,@>83FC
     6D2C 20FC 
     6D2E 83FC 
0291 6D30 C820  54         mov   @>20FE,@>83FE
     6D32 20FE 
     6D34 83FE 
0292 6D36 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0194                       copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > mem_scrpad_paging.asm
0001               * FILE......: mem_scrpad_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * mem.scrpad.pgout - Page out scratchpad memory
0011               ***************************************************************
0012               *  bl   @mem.scrpad.pgout
0013               *  DATA p0
0014               *  P0 = CPU memory destination
0015               *--------------------------------------------------------------
0016               *  bl   @memx.scrpad.pgout
0017               *  TMP1 = CPU memory destination
0018               *--------------------------------------------------------------
0019               *  Register usage
0020               *  tmp0-tmp2 = Used as temporary registers
0021               *  tmp3      = Copy of CPU memory destination
0022               ********@*****@*********************@**************************
0023               mem.scrpad.pgout:
0024 6D38 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6D3A 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6D3C 8300 
0030 6D3E C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6D40 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D42 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6D44 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6D46 0606  14         dec   tmp2
0037 6D48 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6D4A C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6D4C 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6D4E 6D54 
0043                                                   ; R14=PC
0044 6D50 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6D52 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6D54 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6D56 6A36 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6D58 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               ***************************************************************
0064               * mem.scrpad.pgin - Page in scratchpad memory
0065               ***************************************************************
0066               *  bl   @mem.scrpad.pgin
0067               *  DATA p0
0068               *  P0 = CPU memory source
0069               *--------------------------------------------------------------
0070               *  bl   @memx.scrpad.pgin
0071               *  TMP1 = CPU memory source
0072               *--------------------------------------------------------------
0073               *  Register usage
0074               *  tmp0-tmp2 = Used as temporary registers
0075               ********@*****@*********************@**************************
0076               mem.scrpad.pgin:
0077 6D5A C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6D5C 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6D5E 8300 
0083 6D60 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D62 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6D64 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6D66 0606  14         dec   tmp2
0089 6D68 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6D6A 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6D6C 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6D6E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0196               
0198                       copy  "equ_fio.asm"              ; File I/O equates
**** **** ****     > equ_fio.asm
0001               * FILE......: equ_fio.asm
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations
0006               ************************************@**************************
0007      0000     io.op.open       equ >00            ; OPEN
0008      0001     io.op.close      equ >01            ; CLOSE
0009      0002     io.op.read       equ >02            ; READ
0010      0003     io.op.write      equ >03            ; WRITE
0011      0004     io.op.rewind     equ >04            ; RESTORE/REWIND
0012      0005     io.op.load       equ >05            ; LOAD
0013      0006     io.op.save       equ >06            ; SAVE
0014      0007     io.op.delfile    equ >07            ; DELETE FILE
0015      0008     io.op.scratch    equ >08            ; SCRATCH
0016      0009     io.op.status     equ >09            ; STATUS
0017               ***************************************************************
0018               * File types - All relative files are fixed length
0019               ************************************@**************************
0020      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
0021      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
0022      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
0023      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
0024      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
0025      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
0026               ***************************************************************
0027               * File types - Sequential files
0028               ************************************@**************************
0029      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
0030      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
0031      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
0032      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
0033      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
0034      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
0035      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
0036      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
0037      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
0038      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
0039      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
0040      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
0041               
0042               ***************************************************************
0043               * File error codes - Bits 13-15 in PAB byte 1
0044               ************************************@**************************
0045      0000     io.err.no_error_occured             equ 0
0046                       ; Error code 0 with condition bit reset, indicates that
0047                       ; no error has occured
0048               
0049      0000     io.err.bad_device_name              equ 0
0050                       ; Device indicated not in system
0051                       ; Error code 0 with condition bit set, indicates a
0052                       ; device not present in system
0053               
0054      0001     io.err.device_write_prottected      equ 1
0055                       ; Device is write protected
0056               
0057      0002     io.err.bad_open_attribute           equ 2
0058                       ; One or more of the OPEN attributes are illegal or do
0059                       ; not match the file's actual characteristics.
0060                       ; This could be:
0061                       ;   * File type
0062                       ;   * Record length
0063                       ;   * I/O mode
0064                       ;   * File organization
0065               
0066      0003     io.err.illegal_operation            equ 3
0067                       ; Either an issued I/O command was not supported, or a
0068                       ; conflict with the OPEN mode has occured
0069               
0070      0004     io.err.out_of_table_buffer_space    equ 4
0071                       ; The amount of space left on the device is insufficient
0072                       ; for the requested operation
0073               
0074      0005     io.err.eof                          equ 5
0075                       ; Attempt to read past end of file.
0076                       ; This error may also be given for non-existing records
0077                       ; in a relative record file
0078               
0079      0006     io.err.device_error                 equ 6
0080                       ; Covers all hard device errors, such as parity and
0081                       ; bad medium errors
0082               
0083      0007     io.err.file_error                   equ 7
0084                       ; Covers all file-related error like: program/data
0085                       ; file mismatch, non-existing file opened for input mode, etc.
**** **** ****     > runlib.asm
0199                       copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication
**** **** ****     > dsrlnk.asm
0001               * FILE......: dsrlnk.asm
0002               * Purpose...: Custom DSRLNK implementation
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  P0 = 8 or 10 (a)
0016               *--------------------------------------------------------------
0017               *  Output:
0018               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0019               *--------------------------------------------------------------
0020               ; Spectra2 scratchpad memory needs to be paged out before.
0021               ; You need to specify following equates in main program
0022               ;
0023               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0024               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0025               ;
0026               ; Scratchpad memory usage
0027               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
0028               ; >8356            Pointer to PAB
0029               ; >83D0            CRU address of current device
0030               ; >83D2            DSR entry address
0031               ; >83e0 - >83ff    GPL / DSRLNK workspace
0032               ;
0033               ; Credits
0034               ; Originally appeared in Miller Graphics The Smart Programmer.
0035               ; This version based on version of Paolo Bagnaresi.
0036               *--------------------------------------------------------------
0037      B00A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0038                                                   ; dstype is address of R5 of DSRLNK ws
0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0040               ********@*****@*********************@**************************
0041 6D70 B000     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6D72 6D74             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6D74 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6D76 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6D78 8322 
0049 6D7A 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6D7C 6042 
0050 6D7E C020  34         mov   @>8356,r0             ; get ptr to pab
     6D80 8356 
0051 6D82 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6D84 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6D86 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6D88 06C0  14         swpb  r0                    ;
0059 6D8A D800  38         movb  r0,@vdpa              ; send low byte
     6D8C 8C02 
0060 6D8E 06C0  14         swpb  r0                    ;
0061 6D90 D800  38         movb  r0,@vdpa              ; send high byte
     6D92 8C02 
0062 6D94 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6D96 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6D98 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6D9A 0704  14         seto  r4                    ; init counter
0070 6D9C 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6D9E 2100 
0071 6DA0 0580  14 !       inc   r0                    ; point to next char of name
0072 6DA2 0584  14         inc   r4                    ; incr char counter
0073 6DA4 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6DA6 0007 
0074 6DA8 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6DAA 80C4  18         c     r4,r3                 ; end of name?
0077 6DAC 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6DAE 06C0  14         swpb  r0                    ;
0082 6DB0 D800  38         movb  r0,@vdpa              ; send low byte
     6DB2 8C02 
0083 6DB4 06C0  14         swpb  r0                    ;
0084 6DB6 D800  38         movb  r0,@vdpa              ; send high byte
     6DB8 8C02 
0085 6DBA D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6DBC 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6DBE DC81  32         movb  r1,*r2+               ; move into buffer
0092 6DC0 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6DC2 6E84 
0093 6DC4 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6DC6 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6DC8 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6DCA 04E0  34         clr   @>83d0
     6DCC 83D0 
0102 6DCE C804  38         mov   r4,@>8354             ; save name length for search
     6DD0 8354 
0103 6DD2 0584  14         inc   r4                    ; adjust for dot
0104 6DD4 A804  38         a     r4,@>8356             ; point to position after name
     6DD6 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6DD8 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6DDA 83E0 
0110 6DDC 04C1  14         clr   r1                    ; version found of dsr
0111 6DDE 020C  20         li    r12,>0f00             ; init cru addr
     6DE0 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6DE2 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6DE4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6DE6 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6DE8 022C  22         ai    r12,>0100             ; next rom to turn on
     6DEA 0100 
0125 6DEC 04E0  34         clr   @>83d0                ; clear in case we are done
     6DEE 83D0 
0126 6DF0 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6DF2 2000 
0127 6DF4 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6DF6 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6DF8 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6DFA 1D00  20         sbo   0                     ; turn on rom
0134 6DFC 0202  20         li    r2,>4000              ; start at beginning of rom
     6DFE 4000 
0135 6E00 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6E02 6E80 
0136 6E04 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6E06 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6E08 B00A 
0146 6E0A 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6E0C C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6E0E 83D2 
0152 6E10 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6E12 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6E14 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6E16 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6E18 83D2 
0161 6E1A 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6E1C C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6E1E 04C5  14         clr   r5                    ; Remove any old stuff
0167 6E20 D160  34         movb  @>8355,r5             ; get length as counter
     6E22 8355 
0168 6E24 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6E26 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6E28 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6E2A 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6E2C 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6E2E 2100 
0175 6E30 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6E32 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6E34 0605  14         dec   r5                    ; loop until full length checked
0179 6E36 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6E38 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6E3A 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6E3C 0581  14         inc   r1                    ; next version found
0191 6E3E 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6E40 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6E42 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6E44 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6E46 B000 
0200 6E48 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6E4A C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6E4C 8322 
0202                                                   ; (8 or >a)
0203 6E4E 0281  22         ci    r1,8                  ; was it 8?
     6E50 0008 
0204 6E52 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6E54 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6E56 8350 
0206                                                   ; Get error byte from @>8350
0207 6E58 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6E5A 06C0  14         swpb  r0                    ;
0215 6E5C D800  38         movb  r0,@vdpa              ; send low byte
     6E5E 8C02 
0216 6E60 06C0  14         swpb  r0                    ;
0217 6E62 D800  38         movb  r0,@vdpa              ; send high byte
     6E64 8C02 
0218 6E66 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E68 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6E6A 09D1  56         srl   r1,13                 ; just keep error bits
0226 6E6C 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6E6E 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6E70 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E72 B000 
0235               dsrlnk.error.devicename_invalid:
0236 6E74 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6E76 06C1  14         swpb  r1                    ; put error in hi byte
0239 6E78 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6E7A F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6E7C 6042 
0241 6E7E 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6E80 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6E82 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6E84 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0248               
0249                       even
**** **** ****     > runlib.asm
0200                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********@*****@*********************@**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0011               ;                                   ;         Bit 13-15 used by DSR for returning
0012               ;                                   ;         file error details to DSRLNK
0013               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0014               ;       byte  80                    ;  4    - Record length (80 characters maximum)
0015               ;       byte  0                     ;  5    - Character count (bytes read)
0016               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
0017               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
0018               ; -------------------------------------------------------------
0019               ;       byte  11                    ;  9    - File descriptor length
0020               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
0021               ;       even
0022               ***************************************************************
0023               
0024               
0025               ***************************************************************
0026               * file.open - Open File for procesing
0027               ***************************************************************
0028               *  bl   @file.open
0029               *  data P0
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *--------------------------------------------------------------
0033               *  bl   @xfile.open
0034               *
0035               *  R0 = Address of PAB in VDP RAM
0036               *--------------------------------------------------------------
0037               *  Output:
0038               *  tmp0 LSB = VDP PAB byte 1 (status)
0039               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0040               *  tmp2     = Status register contents upon DSRLNK return
0041               ********@*****@*********************@**************************
0042               file.open:
0043 6E86 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6E88 C04B  18         mov   r11,r1                ; Save return address
0049 6E8A C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0050 6E8C 04C5  14         clr   tmp1                  ; io.op.open
0051 6E8E 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6E90 6116 
0052               file.open_init:
0053 6E92 0220  22         ai    r0,9                  ; Move to file descriptor length
     6E94 0009 
0054 6E96 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6E98 8356 
0055               *--------------------------------------------------------------
0056               * Main
0057               *--------------------------------------------------------------
0058               file.open_main:
0059 6E9A 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6E9C 6D70 
0060 6E9E 0008             data  8                     ; Level 2 IO call
0061               *--------------------------------------------------------------
0062               * Exit
0063               *--------------------------------------------------------------
0064               file.open_exit:
0065 6EA0 1025  14         jmp   file.record.pab.details
0066                                                   ; Get status and return to caller
0067                                                   ; Status register bits are unaffected
0068               
0069               
0070               
0071               ***************************************************************
0072               * file.close - Close currently open file
0073               ***************************************************************
0074               *  bl   @file.close
0075               *  data P0
0076               *--------------------------------------------------------------
0077               *  P0 = Address of PAB in VDP RAM
0078               *--------------------------------------------------------------
0079               *  bl   @xfile.close
0080               *
0081               *  R0 = Address of PAB in VD RAM
0082               *--------------------------------------------------------------
0083               *  Output:
0084               *  tmp0 LSB = VDP PAB byte 1 (status)
0085               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0086               *  tmp2     = Status register contents upon DSRLNK return
0087               ********@*****@*********************@**************************
0088               file.close:
0089 6EA2 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0090               *--------------------------------------------------------------
0091               * Initialisation
0092               *--------------------------------------------------------------
0093               xfile.close:
0094 6EA4 C04B  18         mov   r11,r1                ; Save return address
0095 6EA6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0096 6EA8 0205  20         li    tmp1,io.op.close      ; io.op.close
     6EAA 0001 
0097 6EAC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6EAE 6116 
0098               file.close_init:
0099 6EB0 0220  22         ai    r0,9                  ; Move to file descriptor length
     6EB2 0009 
0100 6EB4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EB6 8356 
0101               *--------------------------------------------------------------
0102               * Main
0103               *--------------------------------------------------------------
0104               file.close_main:
0105 6EB8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EBA 6D70 
0106 6EBC 0008             data  8                     ;
0107               *--------------------------------------------------------------
0108               * Exit
0109               *--------------------------------------------------------------
0110               file.close_exit:
0111 6EBE 1016  14         jmp   file.record.pab.details
0112                                                   ; Get status and return to caller
0113                                                   ; Status register bits are unaffected
0114               
0115               
0116               
0117               
0118               
0119               ***************************************************************
0120               * file.record.read - Read record from file
0121               ***************************************************************
0122               *  bl   @file.record.read
0123               *  data P0
0124               *--------------------------------------------------------------
0125               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0126               *--------------------------------------------------------------
0127               *  bl   @xfile.record.read
0128               *
0129               *  R0 = Address of PAB in VDP RAM
0130               *--------------------------------------------------------------
0131               *  Output:
0132               *  tmp0 LSB = VDP PAB byte 1 (status)
0133               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0134               *  tmp2     = Status register contents upon DSRLNK return
0135               ********@*****@*********************@**************************
0136               file.record.read:
0137 6EC0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0138               *--------------------------------------------------------------
0139               * Initialisation
0140               *--------------------------------------------------------------
0141               xfile.record.read:
0142 6EC2 C04B  18         mov   r11,r1                ; Save return address
0143 6EC4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0144 6EC6 0205  20         li    tmp1,io.op.read       ; io.op.read
     6EC8 0002 
0145 6ECA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6ECC 6116 
0146               file.record.read_init:
0147 6ECE 0220  22         ai    r0,9                  ; Move to file descriptor length
     6ED0 0009 
0148 6ED2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6ED4 8356 
0149               *--------------------------------------------------------------
0150               * Main
0151               *--------------------------------------------------------------
0152               file.record.read_main:
0153 6ED6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6ED8 6D70 
0154 6EDA 0008             data  8                     ;
0155               *--------------------------------------------------------------
0156               * Exit
0157               *--------------------------------------------------------------
0158               file.record.read_exit:
0159 6EDC 1007  14         jmp   file.record.pab.details
0160                                                   ; Get status and return to caller
0161                                                   ; Status register bits are unaffected
0162               
0163               
0164               
0165               
0166               file.record.write:
0167 6EDE 1000  14         nop
0168               
0169               
0170               file.record.seek:
0171 6EE0 1000  14         nop
0172               
0173               
0174               file.image.load:
0175 6EE2 1000  14         nop
0176               
0177               
0178               file.image.save:
0179 6EE4 1000  14         nop
0180               
0181               
0182               file.delete:
0183 6EE6 1000  14         nop
0184               
0185               
0186               file.rename:
0187 6EE8 1000  14         nop
0188               
0189               
0190               file.status:
0191 6EEA 1000  14         nop
0192               
0193               
0194               
0195               ***************************************************************
0196               * file.record.pab.details - Return PAB details to caller
0197               ***************************************************************
0198               * Called internally via JMP/B by file operations
0199               *--------------------------------------------------------------
0200               *  Output:
0201               *  tmp0 LSB = VDP PAB byte 1 (status)
0202               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0203               *  tmp2     = Status register contents upon DSRLNK return
0204               ********@*****@*********************@**************************
0205               
0206               ********@*****@*********************@**************************
0207               file.record.pab.details:
0208 6EEC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0209                                                   ; Upon DSRLNK return status register EQ bit
0210                                                   ; 1 = No file error
0211                                                   ; 0 = File error occured
0212               *--------------------------------------------------------------
0213               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0214               *--------------------------------------------------------------
0215 6EEE C120  34         mov   @>8356,tmp0           ; Get PAB VDP address + 9
     6EF0 8356 
0216 6EF2 0224  22         ai    tmp0,-4               ; Get address of VDP PAB byte 5
     6EF4 FFFC 
0217 6EF6 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6EF8 612E 
0218 6EFA C144  18         mov   tmp0,tmp1             ; Move to destination
0219               *--------------------------------------------------------------
0220               * Get PAB byte 1 from VDP ram into tmp0 (status)
0221               *--------------------------------------------------------------
0222 6EFC C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0223                                                   ; as returned by DSRLNK
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               ; If an error occured during the IO operation, then the
0228               ; equal bit in the saved status register (=R2) is set to 1.
0229               ;
0230               ; If no error occured during the IO operation, then the
0231               ; equal bit in the saved status register (=R2) is set to 0.
0232               ;
0233               ; Upon return from this IO call you should basically test with:
0234               ;       coc   @wbit2,tmp2           ; Equal bit set?
0235               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0236               ;
0237               ; Then look for further details in the copy of VDP PAB byte 1
0238               ; in register tmp0, bits 13-15
0239               ;
0240               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0241               ;                                   ; calls, skip for type >A subprograms!)
0242               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0243               ;       jeq   my_error_handler
0244               *--------------------------------------------------------------
0245               file.record.pab.details.exit:
0246 6EFE 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0202               
0203               
0204               
0205               *//////////////////////////////////////////////////////////////
0206               *                            TIMERS
0207               *//////////////////////////////////////////////////////////////
0208               
0209                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
**** **** ****     > timers_tmgr.asm
0001               * FILE......: timers_tmgr.asm
0002               * Purpose...: Timers / Thread scheduler
0003               
0004               ***************************************************************
0005               * TMGR - X - Start Timers/Thread scheduler
0006               ***************************************************************
0007               *  B @TMGR
0008               *--------------------------------------------------------------
0009               *  REMARKS
0010               *  Timer/Thread scheduler. Normally called from MAIN.
0011               *  This is basically the kernel keeping everything togehter.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********@*****@*********************@**************************
0020 6F00 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F02 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F04 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F06 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F08 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F0A 6042 
0029 6F0C 1602  14         jne   tmgr1a                ; No, so move on
0030 6F0E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F10 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F12 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F14 6046 
0035 6F16 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F18 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F1A 6036 
0048 6F1C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F1E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F20 6034 
0050 6F22 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F24 0460  28         b     @kthread              ; Run kernel thread
     6F26 6F9E 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F28 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F2A 603A 
0056 6F2C 13EB  14         jeq   tmgr1
0057 6F2E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F30 6038 
0058 6F32 16E8  14         jne   tmgr1
0059 6F34 C120  34         mov   @wtiusr,tmp0
     6F36 832E 
0060 6F38 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F3A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F3C 6F9C 
0065 6F3E C10A  18         mov   r10,tmp0
0066 6F40 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F42 00FF 
0067 6F44 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F46 6042 
0068 6F48 1303  14         jeq   tmgr5
0069 6F4A 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F4C 003C 
0070 6F4E 1002  14         jmp   tmgr6
0071 6F50 0284  22 tmgr5   ci    tmp0,50
     6F52 0032 
0072 6F54 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F56 1001  14         jmp   tmgr8
0074 6F58 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F5A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F5C 832C 
0079 6F5E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F60 FF00 
0080 6F62 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F64 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F66 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F68 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F6A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F6C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F6E 830C 
     6F70 830D 
0089 6F72 1608  14         jne   tmgr10                ; No, get next slot
0090 6F74 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F76 FF00 
0091 6F78 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F7A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F7C 8330 
0096 6F7E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6F80 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6F82 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6F84 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6F86 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6F88 8315 
     6F8A 8314 
0103 6F8C 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6F8E 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6F90 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6F92 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6F94 10F7  14         jmp   tmgr10                ; Process next slot
0108 6F96 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6F98 FF00 
0109 6F9A 10B4  14         jmp   tmgr1
0110 6F9C 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0210                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
**** **** ****     > timers_kthread.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / The kernel thread
0003               
0004               
0005               ***************************************************************
0006               * KTHREAD - The kernel thread
0007               *--------------------------------------------------------------
0008               *  REMARKS
0009               *  You should not call the kernel thread manually.
0010               *  Instead control it via the CONFIG register.
0011               *
0012               *  The kernel thread is responsible for running the sound
0013               *  player and doing keyboard scan.
0014               ********@*****@*********************@**************************
0015 6F9E E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6FA0 6036 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 6FA2 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     6FA4 63EE 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FA6 06A0  32         bl    @realkb               ; Scan full keyboard
     6FA8 64DE 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FAA 0460  28         b     @tmgr3                ; Exit
     6FAC 6F28 
**** **** ****     > runlib.asm
0211                       copy  "timers_hooks.asm"         ; Timers / User hooks
**** **** ****     > timers_hooks.asm
0001               * FILE......: timers_kthread.asm
0002               * Purpose...: Timers / User hooks
0003               
0004               
0005               ***************************************************************
0006               * MKHOOK - Allocate user hook
0007               ***************************************************************
0008               *  BL    @MKHOOK
0009               *  DATA  P0
0010               *--------------------------------------------------------------
0011               *  P0 = Address of user hook
0012               *--------------------------------------------------------------
0013               *  REMARKS
0014               *  The user hook gets executed after the kernel thread.
0015               *  The user hook must always exit with "B @HOOKOK"
0016               ********@*****@*********************@**************************
0017 6FAE C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FB0 832E 
0018 6FB2 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FB4 6038 
0019 6FB6 045B  20 mkhoo1  b     *r11                  ; Return
0020      6F04     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6FB8 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FBA 832E 
0029 6FBC 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FBE FEFF 
0030 6FC0 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0212               
0216               
0217               
0218               
0219               *//////////////////////////////////////////////////////////////
0220               *                    RUNLIB INITIALISATION
0221               *//////////////////////////////////////////////////////////////
0222               
0223               ***************************************************************
0224               *  RUNLIB - Runtime library initalisation
0225               ***************************************************************
0226               *  B  @RUNLIB
0227               *--------------------------------------------------------------
0228               *  REMARKS
0229               *  if R0 in WS1 equals >4a4a we were called from the system
0230               *  crash handler so we return there after initialisation.
0231               
0232               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0233               *  after clearing scratchpad memory. This has higher priority
0234               *  as crash handler flag R0.
0235               ********@*****@*********************@**************************
0237 6FC2 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     6FC4 6734 
0238 6FC6 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6FC8 8302 
0242               *--------------------------------------------------------------
0243               * Alternative entry point
0244               *--------------------------------------------------------------
0245 6FCA 0300  24 runli1  limi  0                     ; Turn off interrupts
     6FCC 0000 
0246 6FCE 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6FD0 8300 
0247 6FD2 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6FD4 83C0 
0248               *--------------------------------------------------------------
0249               * Clear scratch-pad memory from R4 upwards
0250               *--------------------------------------------------------------
0251 6FD6 0202  20 runli2  li    r2,>8308
     6FD8 8308 
0252 6FDA 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0253 6FDC 0282  22         ci    r2,>8400
     6FDE 8400 
0254 6FE0 16FC  14         jne   runli3
0255               *--------------------------------------------------------------
0256               * Exit to TI-99/4A title screen ?
0257               *--------------------------------------------------------------
0258               runli3a
0259 6FE2 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6FE4 FFFF 
0260 6FE6 1602  14         jne   runli4                ; No, continue
0261 6FE8 0420  54         blwp  @0                    ; Yes, bye bye
     6FEA 0000 
0262               *--------------------------------------------------------------
0263               * Determine if VDP is PAL or NTSC
0264               *--------------------------------------------------------------
0265 6FEC C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6FEE 833C 
0266 6FF0 04C1  14         clr   r1                    ; Reset counter
0267 6FF2 0202  20         li    r2,10                 ; We test 10 times
     6FF4 000A 
0268 6FF6 C0E0  34 runli5  mov   @vdps,r3
     6FF8 8802 
0269 6FFA 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6FFC 6046 
0270 6FFE 1302  14         jeq   runli6
0271 7000 0581  14         inc   r1                    ; Increase counter
0272 7002 10F9  14         jmp   runli5
0273 7004 0602  14 runli6  dec   r2                    ; Next test
0274 7006 16F7  14         jne   runli5
0275 7008 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     700A 1250 
0276 700C 1202  14         jle   runli7                ; No, so it must be NTSC
0277 700E 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     7010 6042 
0278               *--------------------------------------------------------------
0279               * Copy machine code to scratchpad (prepare tight loop)
0280               *--------------------------------------------------------------
0281 7012 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     7014 609E 
0282 7016 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     7018 8322 
0283 701A CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0284 701C CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0285 701E CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0286               *--------------------------------------------------------------
0287               * Initialize registers, memory, ...
0288               *--------------------------------------------------------------
0289 7020 04C1  14 runli9  clr   r1
0290 7022 04C2  14         clr   r2
0291 7024 04C3  14         clr   r3
0292 7026 0209  20         li    stack,>8400           ; Set stack
     7028 8400 
0293 702A 020F  20         li    r15,vdpw              ; Set VDP write address
     702C 8C00 
0297               *--------------------------------------------------------------
0298               * Setup video memory
0299               *--------------------------------------------------------------
0301 702E 0280  22         ci    r0,>4a4a              ; Crash flag set?
     7030 4A4A 
0302 7032 1605  14         jne   runlia
0303 7034 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7036 60D8 
0304 7038 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     703A 0000 
     703C 3FFF 
0309 703E 06A0  32 runlia  bl    @filv
     7040 60D8 
0310 7042 0FC0             data  pctadr,spfclr,16      ; Load color table
     7044 00C1 
     7046 0010 
0311               *--------------------------------------------------------------
0312               * Check if there is a F18A present
0313               *--------------------------------------------------------------
0317 7048 06A0  32         bl    @f18unl               ; Unlock the F18A
     704A 635E 
0318 704C 06A0  32         bl    @f18chk               ; Check if F18A is there
     704E 6378 
0319 7050 06A0  32         bl    @f18lck               ; Lock the F18A again
     7052 636E 
0321               *--------------------------------------------------------------
0322               * Check if there is a speech synthesizer attached
0323               *--------------------------------------------------------------
0325               *       <<skipped>>
0329               *--------------------------------------------------------------
0330               * Load video mode table & font
0331               *--------------------------------------------------------------
0332 7054 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     7056 6142 
0333 7058 608A             data  spvmod                ; Equate selected video mode table
0334 705A 0204  20         li    tmp0,spfont           ; Get font option
     705C 000C 
0335 705E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0336 7060 1304  14         jeq   runlid                ; Yes, skip it
0337 7062 06A0  32         bl    @ldfnt
     7064 61AA 
0338 7066 1100             data  fntadr,spfont         ; Load specified font
     7068 000C 
0339               *--------------------------------------------------------------
0340               * Did a system crash occur before runlib was called?
0341               *--------------------------------------------------------------
0342 706A 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     706C 4A4A 
0343 706E 1602  14         jne   runlie                ; No, continue
0344 7070 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     7072 605C 
0345               *--------------------------------------------------------------
0346               * Branch to main program
0347               *--------------------------------------------------------------
0348 7074 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7076 0040 
0349 7078 0460  28         b     @main                 ; Give control to main program
     707A 707C 
**** **** ****     > fio.asm.17997
0071               *--------------------------------------------------------------
0072               * SPECTRA2 startup options
0073               *--------------------------------------------------------------
0074      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0075      0001     spfbck  equ   >01                   ; Screen background color.
0076               ;--------------------------------------------------------------
0077               ; Video mode configuration
0078               ;--------------------------------------------------------------
0079      608A     spvmod  equ   tx8024                ; Video mode.   See VIDTAB for details.
0080      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0081      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0082      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0083               ;--------------------------------------------------------------
0084               ; VDP space for PAB and file buffer
0085               ;--------------------------------------------------------------
0086      0200     vpab    equ   >0200                 ; VDP PAB    @>0200
0087      0300     vrecbuf equ   >0300                 ; VDP Buffer @>0300
0088               
0089               
0090               ;--------------------------------------------------------------
0091               ; Variables
0092               ;--------------------------------------------------------------
0093      C000     records equ   >c000                 ; Records processed so far
0094      C002     reclen  equ   >c002                 ; Current record length
0095      C004     rambuf  equ   >c004                 ; 5 byte RAM-buffer
0096               
0097               
0098               ***************************************************************
0099               * Main
0100               ********@*****@*********************@**************************
0101 707C 06A0  32 main    bl    @putat
     707E 627A 
0102 7080 0000             data  >0000,msg
     7082 7150 
0103               
0104 7084 06A0  32         bl    @putat
     7086 627A 
0105 7088 0100             data  >0100,fname
     708A 713F 
0106               
0107 708C 06A0  32         bl    @putat
     708E 627A 
0108 7090 0300             data  >0300,rec1
     7092 7166 
0109               
0110 7094 06A0  32         bl    @putat
     7096 627A 
0111 7098 0400             data  >0400,rec2
     709A 717A 
0112               
0113                       ;------------------------------------------------------
0114                       ; Initialization
0115                       ;------------------------------------------------------
0116               main.init:
0117 709C 04E0  34         clr   @records              ; Reset record counter
     709E C000 
0118 70A0 0208  20         li    tmp4,>b000            ; CPU destination for memory copy
     70A2 B000 
0119               
0120 70A4 06A0  32         bl    @cpym2v
     70A6 6282 
0121 70A8 0200                   data vpab,pab,25      ; Copy PAB to VDP
     70AA 7136 
     70AC 0019 
0122                       ;------------------------------------------------------
0123                       ; Load GPL scratchpad layout
0124                       ;------------------------------------------------------
0125 70AE 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     70B0 6D38 
0126 70B2 A000                   data >a000            ; / 8300->a000, 2000->8300
0127                       ;------------------------------------------------------
0128                       ; Open file
0129                       ;------------------------------------------------------
0130 70B4 06A0  32         bl    @file.open
     70B6 6E86 
0131 70B8 0200                   data vpab             ; Pass file descriptor to DSRLNK
0132 70BA 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     70BC 6042 
0133 70BE 132C  14         jeq   file.error            ; Yes, IO error occured
0134                       ;------------------------------------------------------
0135                       ; Read file records
0136                       ;------------------------------------------------------
0137               main.readfile:
0138 70C0 05A0  34         inc   @records              ; Update counter
     70C2 C000 
0139 70C4 04E0  34         clr   @reclen               ; Reset record length
     70C6 C002 
0140               
0141 70C8 06A0  32         bl    @file.record.read     ; Read record
     70CA 6EC0 
0142 70CC 0200                   data vpab             ; tmp0=Status byte, tmp1=Bytes read
0143                                                   ; tmp2=Status register contents upon DSRLNK return
0144               
0145 70CE C805  38         mov   tmp1,@reclen          ; Save bytes read
     70D0 C002 
0146               
0147 70D2 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     70D4 6042 
0148 70D6 1320  14         jeq   file.error            ; Yes, so handle file error
0149                       ;------------------------------------------------------
0150                       ; Load spectra scratchpad layout
0151                       ;------------------------------------------------------
0152 70D8 06A0  32         bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     70DA 6734 
0153 70DC 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     70DE 6D5A 
0154 70E0 A000                   data >a000            ; / >a000->8300
0155                       ;------------------------------------------------------
0156                       ; Display results
0157                       ;------------------------------------------------------
0158 70E2 06A0  32         bl    @putnum
     70E4 672A 
0159 70E6 0314                   byte 03,20
0160 70E8 C000                   data records,rambuf,>3020
     70EA C004 
     70EC 3020 
0161               
0162 70EE 06A0  32         bl    @putnum
     70F0 672A 
0163 70F2 0414                   byte 04,20
0164 70F4 C002                   data reclen,rambuf,>3020
     70F6 C004 
     70F8 3020 
0165               
0166                       ;------------------------------------------------------
0167                       ; Copy record to CPU memory
0168                       ;------------------------------------------------------
0169 70FA 0204  20         li    tmp0,vrecbuf          ; VDP source address
     70FC 0300 
0170 70FE C148  18         mov   tmp4,tmp1             ; RAM target address
0171 7100 0206  20         li    tmp2,80
     7102 0050 
0172 7104 A206  18         a     tmp2,tmp4
0173 7106 06A0  32         bl    @xpyv2m               ; Copy memory
     7108 62AE 
0174                       ;------------------------------------------------------
0175                       ; Load GPL scratchpad layout again
0176                       ;------------------------------------------------------
0177 710A 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     710C 6D38 
0178 710E A000                   data >a000            ; / 8300->a000, 2000->8300
0179               
0180 7110 10D7  14         jmp   main.readfile         ; Next record
0181                       ;------------------------------------------------------
0182                       ; Close file
0183                       ;------------------------------------------------------
0184               close_file
0185 7112 06A0  32         bl    @file.close           ; Close file
     7114 6EA2 
0186 7116 0200                   data vpab
0187               
0188               
0189                       ;------------------------------------------------------
0190                       ; Error handler
0191                       ;------------------------------------------------------
0192               file.error
0193 7118 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0194 711A 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     711C 0005 
0195 711E 1302  14         jeq   eof_reached           ; All good. File closed by DSRLNK
0196 7120 0460  28         b     @crash_handler        ; A File error occured. System crashed
     7122 604C 
0197               
0198               
0199               eof_reached:
0200 7124 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7126 6D5A 
0201 7128 A000                   data >a000            ; / >a000->8300
0202               
0203 712A 06A0  32         bl    @putat
     712C 627A 
0204 712E 0600             data  >0600,eof
     7130 718E 
0205               
0206 7132 0460  28         b     @tmgr
     7134 6F00 
0207               
0208               
0209               
0210               
0211               ***************************************************************
0212               * PAB for accessing file
0213               ********@*****@*********************@**************************
0214 7136 0014     pab     byte  io.op.open            ;  0    - OPEN
0215                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0216 7138 0300             data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0217 713A 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0218                       byte  00                    ;  5    - Character count
0219 713C 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0220 713E 000F             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0221               
0222               ; fname  byte  12                    ;  9    - File descriptor length
0223               ;        text 'DSK1.XBEADOC'         ; 10-.. - File descriptor (Device + '.' + File name)
0224               
0225               fname   byte  15                    ;  9    - File descriptor length
0226 7140 ....             text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
0227               
0228               
0229                       even
0230               
0231               
0232               msg
0233 7150 152A             byte  21
0234 7151 ....             text  '* File reading test *'
0235                       even
0236               
0237               rec1
0238 7166 1352             byte  19
0239 7167 ....             text  'Records read......:'
0240                       even
0241               
0242               rec2
0243 717A 1343             byte  19
0244 717B ....             text  'Characters read...:'
0245                       even
0246               
0247               eof
0248 718E 1B45             byte  27
0249 718F ....             text  'EOF reached. FCTN+Q to quit'
0250                       even
0251               
0252               
