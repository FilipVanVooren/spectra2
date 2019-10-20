XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > fio.asm.6396
0001               ***************************************************************
0002               *
0003               *                          File I/O test
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: fio.asm                     ; Version 191020-6396
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
0022      0001     startup_keep_vdpdiskbuf   equ  1    ; Keep VDP memory reserved for 3 VDP disk buffers
0023               *--------------------------------------------------------------
0024               * Skip unused spectra2 code modules for reduced code size
0025               *--------------------------------------------------------------
0026      0001     skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
0027      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0028      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0029      0001     skip_vdp_hchar            equ  1    ; Skip hchar, xchar
0030      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0031      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0032      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0033      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0034      0001     skip_vdp_rle_decompress   equ  1    ; Skip RLE decompress to VRAM
0035      0001     skip_vdp_yx2px_calc       equ  1    ; Skip YX to pixel calculation
0036      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0037      0001     skip_vdp_sprites          equ  1    ; Skip sprites support
0038      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0039      0001     skip_tms52xx_detection    equ  1    ; Skip speech synthesizer detection
0040      0001     skip_tms52xx_player       equ  1    ; Skip inclusion of speech player code
0041      0001     skip_random_generator     equ  1    ; Skip random functions
0042      0001     skip_timer_alloc          equ  1    ; Skip support for timers allocation
0043               
0044               *--------------------------------------------------------------
0045               * Cartridge header
0046               *--------------------------------------------------------------
0047 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0048 6006 6010             data  prog0
0049 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0050 6010 0000     prog0   data  0                     ; No more items following
0051 6012 715C             data  runlib
0053               
0054 6014 1446             byte  20
0055 6015 ....             text  'FIO TEST 191020-6396'
0056                       even
0057               
0065               *--------------------------------------------------------------
0066               * Include required files
0067               *--------------------------------------------------------------
0068                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0046               * skip_tms52xx_detection    equ  1  ; Skip speech synthesizer detection
0047               * skip_tms52xx_player       equ  1  ; Skip inclusion of speech player code
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
0062               * skip_iosupport            equ  1  ; Skip support for file I/O, dsrlnk
0063               *
0064               * == Startup behaviour
0065               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0066               * startup_keep_vdpdiskbuf   equ  1  ; Keep VDP memory reseved for 3 VDP disk buffers
0067               *******************************************************************************
0068               
0069               *//////////////////////////////////////////////////////////////
0070               *                       RUNLIB SETUP
0071               *//////////////////////////////////////////////////////////////
0072               
0073                       copy  "memsetup.equ"             ; runlib scratchpad memory setup
**** **** ****     > memsetup.equ
0001               * FILE......: memsetup.equ
0002               * Purpose...: Equates for memory setup
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
0074                       copy  "registers.equ"            ; runlib registers
**** **** ****     > registers.equ
0001               * FILE......: registers.equ
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
0075                       copy  "portaddr.equ"             ; runlib hardware port addresses
**** **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
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
0076                       copy  "param.equ"                ; runlib parameters
**** **** ****     > param.equ
0001               * FILE......: param.equ
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
0013 602A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0014 602C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0015 602E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0016 6030 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0017 6032 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0018 6034 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0019 6036 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0020 6038 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0021 603A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0022 603C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0023 603E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0024 6040 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0025 6042 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0026 6044 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0027 6046 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0028 6048 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0029 604A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0030 604C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0031 604E D000     w$d000  data  >d000                 ; >d000
0032               *--------------------------------------------------------------
0033               * Byte values - High byte (=MSB) for byte operations
0034               *--------------------------------------------------------------
0035      602A     hb$00   equ   w$0000                ; >0000
0036      603C     hb$01   equ   w$0100                ; >0100
0037      603E     hb$02   equ   w$0200                ; >0200
0038      6040     hb$04   equ   w$0400                ; >0400
0039      6042     hb$08   equ   w$0800                ; >0800
0040      6044     hb$10   equ   w$1000                ; >1000
0041      6046     hb$20   equ   w$2000                ; >2000
0042      6048     hb$40   equ   w$4000                ; >4000
0043      604A     hb$80   equ   w$8000                ; >8000
0044      604E     hb$d0   equ   w$d000                ; >d000
0045               *--------------------------------------------------------------
0046               * Byte values - Low byte (=LSB) for byte operations
0047               *--------------------------------------------------------------
0048      602A     lb$00   equ   w$0000                ; >0000
0049      602C     lb$01   equ   w$0001                ; >0001
0050      602E     lb$02   equ   w$0002                ; >0002
0051      6030     lb$04   equ   w$0004                ; >0004
0052      6032     lb$08   equ   w$0008                ; >0008
0053      6034     lb$10   equ   w$0010                ; >0010
0054      6036     lb$20   equ   w$0020                ; >0020
0055      6038     lb$40   equ   w$0040                ; >0040
0056      603A     lb$80   equ   w$0080                ; >0080
0057               *--------------------------------------------------------------
0058               * Bit values
0059               *--------------------------------------------------------------
0060               ;                                   ;       0123456789ABCDEF
0061      602C     wbit15  equ   w$0001                ; >0001 0000000000000001
0062      602E     wbit14  equ   w$0002                ; >0002 0000000000000010
0063      6030     wbit13  equ   w$0004                ; >0004 0000000000000100
0064      6032     wbit12  equ   w$0008                ; >0008 0000000000001000
0065      6034     wbit11  equ   w$0010                ; >0010 0000000000010000
0066      6036     wbit10  equ   w$0020                ; >0020 0000000000100000
0067      6038     wbit9   equ   w$0040                ; >0040 0000000001000000
0068      603A     wbit8   equ   w$0080                ; >0080 0000000010000000
0069      603C     wbit7   equ   w$0100                ; >0100 0000000100000000
0070      603E     wbit6   equ   w$0200                ; >0200 0000001000000000
0071      6040     wbit5   equ   w$0400                ; >0400 0000010000000000
0072      6042     wbit4   equ   w$0800                ; >0800 0000100000000000
0073      6044     wbit3   equ   w$1000                ; >1000 0001000000000000
0074      6046     wbit2   equ   w$2000                ; >2000 0010000000000000
0075      6048     wbit1   equ   w$4000                ; >4000 0100000000000000
0076      604A     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0083                       copy  "config.equ"               ; Equates for bits in config register
**** **** ****     > config.equ
0001               * FILE......: config.equ
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
0027      6046     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      603C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6038     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6036     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      6034     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0032               ***************************************************************
0033               
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
0012               *  bl  @crash
0013               *--------------------------------------------------------------
0014               *  REMARKS
0015               *  Is expected to be called via bl statement so that R11
0016               *  contains address that triggered us
0017               ********@*****@*********************@**************************
0018 6050 0420  54 crash   blwp  @>0000                ; Soft-reset
     6052 0000 
**** **** ****     > runlib.asm
0085                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6054 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6056 000E 
     6058 0106 
     605A 0201 
     605C 0020 
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
0032 605E 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6060 000E 
     6062 0106 
     6064 00C1 
     6066 0028 
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
0058 6068 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     606A 003F 
     606C 0240 
     606E 03C1 
     6070 0050 
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
0084 6072 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6074 003F 
     6076 0240 
     6078 03C1 
     607A 0050 
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
0013 607C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 607E 16FD             data  >16fd                 ; |         jne   mcloop
0015 6080 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6082 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6084 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6086 C0F9  30 popr3   mov   *stack+,r3
0039 6088 C0B9  30 popr2   mov   *stack+,r2
0040 608A C079  30 popr1   mov   *stack+,r1
0041 608C C039  30 popr0   mov   *stack+,r0
0042 608E C2F9  30 poprt   mov   *stack+,r11
0043 6090 045B  20         b     *r11
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
0067 6092 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6094 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6096 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 6098 C1C6  18 xfilm   mov   tmp2,tmp3
0074 609A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     609C 0001 
0075               
0076 609E 1301  14         jeq   film1
0077 60A0 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60A2 D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60A4 830B 
     60A6 830A 
0079 60A8 CD05  34 film2   mov   tmp1,*tmp0+
0080 60AA 0646  14         dect  tmp2
0081 60AC 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60AE C1C7  18         mov   tmp3,tmp3
0086 60B0 1301  14         jeq   filmz
0087 60B2 D505  30         movb  tmp1,*tmp0
0088 60B4 045B  20 filmz   b     *r11
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
0107 60B6 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60B8 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60BA C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60BC 0264  22 xfilv   ori   tmp0,>4000
     60BE 4000 
0114 60C0 06C4  14         swpb  tmp0
0115 60C2 D804  38         movb  tmp0,@vdpa
     60C4 8C02 
0116 60C6 06C4  14         swpb  tmp0
0117 60C8 D804  38         movb  tmp0,@vdpa
     60CA 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60CC 020F  20         li    r15,vdpw              ; Set VDP write address
     60CE 8C00 
0122 60D0 06C5  14         swpb  tmp1
0123 60D2 C820  54         mov   @filzz,@mcloop        ; Setup move command
     60D4 60DC 
     60D6 8320 
0124 60D8 0460  28         b     @mcloop               ; Write data to VDP
     60DA 8320 
0125               *--------------------------------------------------------------
0129 60DC D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60DE 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     60E0 4000 
0150 60E2 06C4  14 vdra    swpb  tmp0
0151 60E4 D804  38         movb  tmp0,@vdpa
     60E6 8C02 
0152 60E8 06C4  14         swpb  tmp0
0153 60EA D804  38         movb  tmp0,@vdpa            ; Set VDP address
     60EC 8C02 
0154 60EE 045B  20         b     *r11
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
0165 60F0 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 60F2 C17B  30         mov   *r11+,tmp1
0167 60F4 C18B  18 xvputb  mov   r11,tmp2              ; Save R11
0168 60F6 06A0  32         bl    @vdwa                 ; Set VDP write address
     60F8 60DE 
0169               
0170 60FA 06C5  14         swpb  tmp1                  ; Get byte to write
0171 60FC D7C5  30         movb  tmp1,*r15             ; Write byte
0172 60FE 0456  20         b     *tmp2                 ; Exit
0173               
0174               
0175               ***************************************************************
0176               * VGETB - VDP get single byte
0177               ***************************************************************
0178               *  BL @VGETB
0179               *  DATA P0
0180               *--------------------------------------------------------------
0181               *  P0 = VDP source address
0182               ********@*****@*********************@**************************
0183 6100 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0184 6102 C18B  18 xvgetb  mov   r11,tmp2              ; Save R11
0185 6104 06A0  32         bl    @vdra                 ; Set VDP read address
     6106 60E2 
0186               
0187 6108 D120  34         movb  @vdpr,tmp0            ; Read byte
     610A 8800 
0188               
0189 610C 0984  56         srl   tmp0,8                ; Right align
0190 610E 0456  20         b     *tmp2                 ; Exit
0191               
0192               
0193               ***************************************************************
0194               * VIDTAB - Dump videomode table
0195               ***************************************************************
0196               *  BL   @VIDTAB
0197               *  DATA P0
0198               *--------------------------------------------------------------
0199               *  P0 = Address of video mode table
0200               *--------------------------------------------------------------
0201               *  BL   @XIDTAB
0202               *
0203               *  TMP0 = Address of video mode table
0204               *--------------------------------------------------------------
0205               *  Remarks
0206               *  TMP1 = MSB is the VDP target register
0207               *         LSB is the value to write
0208               ********@*****@*********************@**************************
0209 6110 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0210 6112 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0211               *--------------------------------------------------------------
0212               * Calculate PNT base address
0213               *--------------------------------------------------------------
0214 6114 C144  18         mov   tmp0,tmp1
0215 6116 05C5  14         inct  tmp1
0216 6118 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0217 611A 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     611C FF00 
0218 611E 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0219 6120 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6122 8328 
0220               *--------------------------------------------------------------
0221               * Dump VDP shadow registers
0222               *--------------------------------------------------------------
0223 6124 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6126 8000 
0224 6128 0206  20         li    tmp2,8
     612A 0008 
0225 612C D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     612E 830B 
0226 6130 06C5  14         swpb  tmp1
0227 6132 D805  38         movb  tmp1,@vdpa
     6134 8C02 
0228 6136 06C5  14         swpb  tmp1
0229 6138 D805  38         movb  tmp1,@vdpa
     613A 8C02 
0230 613C 0225  22         ai    tmp1,>0100
     613E 0100 
0231 6140 0606  14         dec   tmp2
0232 6142 16F4  14         jne   vidta1                ; Next register
0233 6144 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6146 833A 
0234 6148 045B  20         b     *r11
0235               
0236               
0237               ***************************************************************
0238               * PUTVR  - Put single VDP register
0239               ***************************************************************
0240               *  BL   @PUTVR
0241               *  DATA P0
0242               *--------------------------------------------------------------
0243               *  P0 = MSB is the VDP target register
0244               *       LSB is the value to write
0245               *--------------------------------------------------------------
0246               *  BL   @PUTVRX
0247               *
0248               *  TMP0 = MSB is the VDP target register
0249               *         LSB is the value to write
0250               ********@*****@*********************@**************************
0251 614A C13B  30 putvr   mov   *r11+,tmp0
0252 614C 0264  22 putvrx  ori   tmp0,>8000
     614E 8000 
0253 6150 06C4  14         swpb  tmp0
0254 6152 D804  38         movb  tmp0,@vdpa
     6154 8C02 
0255 6156 06C4  14         swpb  tmp0
0256 6158 D804  38         movb  tmp0,@vdpa
     615A 8C02 
0257 615C 045B  20         b     *r11
0258               
0259               
0260               ***************************************************************
0261               * PUTV01  - Put VDP registers #0 and #1
0262               ***************************************************************
0263               *  BL   @PUTV01
0264               ********@*****@*********************@**************************
0265 615E C20B  18 putv01  mov   r11,tmp4              ; Save R11
0266 6160 C10E  18         mov   r14,tmp0
0267 6162 0984  56         srl   tmp0,8
0268 6164 06A0  32         bl    @putvrx               ; Write VR#0
     6166 614C 
0269 6168 0204  20         li    tmp0,>0100
     616A 0100 
0270 616C D820  54         movb  @r14lb,@tmp0lb
     616E 831D 
     6170 8309 
0271 6172 06A0  32         bl    @putvrx               ; Write VR#1
     6174 614C 
0272 6176 0458  20         b     *tmp4                 ; Exit
0273               
0274               
0275               ***************************************************************
0276               * LDFNT - Load TI-99/4A font from GROM into VDP
0277               ***************************************************************
0278               *  BL   @LDFNT
0279               *  DATA P0,P1
0280               *--------------------------------------------------------------
0281               *  P0 = VDP Target address
0282               *  P1 = Font options
0283               *--------------------------------------------------------------
0284               * Uses registers tmp0-tmp4
0285               ********@*****@*********************@**************************
0286 6178 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0287 617A 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0288 617C C11B  26         mov   *r11,tmp0             ; Get P0
0289 617E 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6180 7FFF 
0290 6182 2120  38         coc   @wbit0,tmp0
     6184 604A 
0291 6186 1604  14         jne   ldfnt1
0292 6188 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     618A 8000 
0293 618C 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     618E 7FFF 
0294               *--------------------------------------------------------------
0295               * Read font table address from GROM into tmp1
0296               *--------------------------------------------------------------
0297 6190 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6192 61FA 
0298 6194 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6196 9C02 
0299 6198 06C4  14         swpb  tmp0
0300 619A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     619C 9C02 
0301 619E D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61A0 9800 
0302 61A2 06C5  14         swpb  tmp1
0303 61A4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61A6 9800 
0304 61A8 06C5  14         swpb  tmp1
0305               *--------------------------------------------------------------
0306               * Setup GROM source address from tmp1
0307               *--------------------------------------------------------------
0308 61AA D805  38         movb  tmp1,@grmwa
     61AC 9C02 
0309 61AE 06C5  14         swpb  tmp1
0310 61B0 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61B2 9C02 
0311               *--------------------------------------------------------------
0312               * Setup VDP target address
0313               *--------------------------------------------------------------
0314 61B4 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0315 61B6 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61B8 60DE 
0316 61BA 05C8  14         inct  tmp4                  ; R11=R11+2
0317 61BC C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0318 61BE 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61C0 7FFF 
0319 61C2 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61C4 61FC 
0320 61C6 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61C8 61FE 
0321               *--------------------------------------------------------------
0322               * Copy from GROM to VRAM
0323               *--------------------------------------------------------------
0324 61CA 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0325 61CC 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0326 61CE D120  34         movb  @grmrd,tmp0
     61D0 9800 
0327               *--------------------------------------------------------------
0328               *   Make font fat
0329               *--------------------------------------------------------------
0330 61D2 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     61D4 604A 
0331 61D6 1603  14         jne   ldfnt3                ; No, so skip
0332 61D8 D1C4  18         movb  tmp0,tmp3
0333 61DA 0917  56         srl   tmp3,1
0334 61DC E107  18         soc   tmp3,tmp0
0335               *--------------------------------------------------------------
0336               *   Dump byte to VDP and do housekeeping
0337               *--------------------------------------------------------------
0338 61DE D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     61E0 8C00 
0339 61E2 0606  14         dec   tmp2
0340 61E4 16F2  14         jne   ldfnt2
0341 61E6 05C8  14         inct  tmp4                  ; R11=R11+2
0342 61E8 020F  20         li    r15,vdpw              ; Set VDP write address
     61EA 8C00 
0343 61EC 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61EE 7FFF 
0344 61F0 0458  20         b     *tmp4                 ; Exit
0345 61F2 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     61F4 602A 
     61F6 8C00 
0346 61F8 10E8  14         jmp   ldfnt2
0347               *--------------------------------------------------------------
0348               * Fonts pointer table
0349               *--------------------------------------------------------------
0350 61FA 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     61FC 0200 
     61FE 0000 
0351 6200 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6202 01C0 
     6204 0101 
0352 6206 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6208 02A0 
     620A 0101 
0353 620C 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     620E 00E0 
     6210 0101 
0354               
0355               
0356               
0357               ***************************************************************
0358               * YX2PNT - Get VDP PNT address for current YX cursor position
0359               ***************************************************************
0360               *  BL   @YX2PNT
0361               *--------------------------------------------------------------
0362               *  INPUT
0363               *  @WYX = Cursor YX position
0364               *--------------------------------------------------------------
0365               *  OUTPUT
0366               *  TMP0 = VDP address for entry in Pattern Name Table
0367               *--------------------------------------------------------------
0368               *  Register usage
0369               *  TMP0, R14, R15
0370               ********@*****@*********************@**************************
0371 6212 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0372 6214 C3A0  34         mov   @wyx,r14              ; Get YX
     6216 832A 
0373 6218 098E  56         srl   r14,8                 ; Right justify (remove X)
0374 621A 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     621C 833A 
0375               *--------------------------------------------------------------
0376               * Do rest of calculation with R15 (16 bit part is there)
0377               * Re-use R14
0378               *--------------------------------------------------------------
0379 621E C3A0  34         mov   @wyx,r14              ; Get YX
     6220 832A 
0380 6222 024E  22         andi  r14,>00ff             ; Remove Y
     6224 00FF 
0381 6226 A3CE  18         a     r14,r15               ; pos = pos + X
0382 6228 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     622A 8328 
0383               *--------------------------------------------------------------
0384               * Clean up before exit
0385               *--------------------------------------------------------------
0386 622C C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0387 622E C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0388 6230 020F  20         li    r15,vdpw              ; VDP write address
     6232 8C00 
0389 6234 045B  20         b     *r11
0390               
0391               
0392               
0393               ***************************************************************
0394               * Put length-byte prefixed string at current YX
0395               ***************************************************************
0396               *  BL   @PUTSTR
0397               *  DATA P0
0398               *
0399               *  P0 = Pointer to string
0400               *--------------------------------------------------------------
0401               *  REMARKS
0402               *  First byte of string must contain length
0403               ********@*****@*********************@**************************
0404 6236 C17B  30 putstr  mov   *r11+,tmp1
0405 6238 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0406 623A C1CB  18 xutstr  mov   r11,tmp3
0407 623C 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     623E 6212 
0408 6240 C2C7  18         mov   tmp3,r11
0409 6242 0986  56         srl   tmp2,8                ; Right justify length byte
0410 6244 0460  28         b     @xpym2v               ; Display string
     6246 6256 
0411               
0412               
0413               ***************************************************************
0414               * Put length-byte prefixed string at YX
0415               ***************************************************************
0416               *  BL   @PUTAT
0417               *  DATA P0,P1
0418               *
0419               *  P0 = YX position
0420               *  P1 = Pointer to string
0421               *--------------------------------------------------------------
0422               *  REMARKS
0423               *  First byte of string must contain length
0424               ********@*****@*********************@**************************
0425 6248 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     624A 832A 
0426 624C 0460  28         b     @putstr
     624E 6236 
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
0020 6250 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6252 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6254 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6256 0264  22 xpym2v  ori   tmp0,>4000
     6258 4000 
0027 625A 06C4  14         swpb  tmp0
0028 625C D804  38         movb  tmp0,@vdpa
     625E 8C02 
0029 6260 06C4  14         swpb  tmp0
0030 6262 D804  38         movb  tmp0,@vdpa
     6264 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6266 020F  20         li    r15,vdpw              ; Set VDP write address
     6268 8C00 
0035 626A C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     626C 6274 
     626E 8320 
0036 6270 0460  28         b     @mcloop               ; Write data to VDP
     6272 8320 
0037 6274 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6276 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6278 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 627A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 627C 06C4  14 xpyv2m  swpb  tmp0
0027 627E D804  38         movb  tmp0,@vdpa
     6280 8C02 
0028 6282 06C4  14         swpb  tmp0
0029 6284 D804  38         movb  tmp0,@vdpa
     6286 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6288 020F  20         li    r15,vdpr              ; Set VDP read address
     628A 8800 
0034 628C C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     628E 6296 
     6290 8320 
0035 6292 0460  28         b     @mcloop               ; Read data from VDP
     6294 8320 
0036 6296 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6298 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 629A C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 629C C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 629E C186  18 xpym2m  mov    tmp2,tmp2            ; Bytes to copy = 0 ?
0031 62A0 1602  14         jne    cpym0
0032 62A2 0460  28         b      @crash               ; Yes, crash
     62A4 6050 
0033 62A6 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62A8 7FFF 
0034 62AA C1C4  18         mov   tmp0,tmp3
0035 62AC 0247  22         andi  tmp3,1
     62AE 0001 
0036 62B0 1618  14         jne   cpyodd                ; Odd source address handling
0037 62B2 C1C5  18 cpym1   mov   tmp1,tmp3
0038 62B4 0247  22         andi  tmp3,1
     62B6 0001 
0039 62B8 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62BA 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62BC 604A 
0044 62BE 1605  14         jne   cpym3
0045 62C0 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62C2 62E8 
     62C4 8320 
0046 62C6 0460  28         b     @mcloop               ; Copy memory and exit
     62C8 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62CA C1C6  18 cpym3   mov   tmp2,tmp3
0051 62CC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62CE 0001 
0052 62D0 1301  14         jeq   cpym4
0053 62D2 0606  14         dec   tmp2                  ; Make TMP2 even
0054 62D4 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 62D6 0646  14         dect  tmp2
0056 62D8 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 62DA C1C7  18         mov   tmp3,tmp3
0061 62DC 1301  14         jeq   cpymz
0062 62DE D554  38         movb  *tmp0,*tmp1
0063 62E0 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 62E2 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     62E4 8000 
0068 62E6 10E9  14         jmp   cpym2
0069 62E8 DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
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
0009 62EA 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     62EC FFBF 
0010 62EE 0460  28         b     @putv01
     62F0 615E 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 62F2 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     62F4 0040 
0018 62F6 0460  28         b     @putv01
     62F8 615E 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 62FA 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     62FC FFDF 
0026 62FE 0460  28         b     @putv01
     6300 615E 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6302 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6304 0020 
0034 6306 0460  28         b     @putv01
     6308 615E 
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
0018 630A C83B  50 at      mov   *r11+,@wyx
     630C 832A 
0019 630E 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6310 B820  54 down    ab    @hb$01,@wyx
     6312 603C 
     6314 832A 
0028 6316 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 6318 7820  54 up      sb    @hb$01,@wyx
     631A 603C 
     631C 832A 
0037 631E 045B  20         b     *r11
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
0049 6320 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6322 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6324 832A 
0051 6326 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6328 832A 
0052 632A 045B  20         b     *r11
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
0013 632C C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 632E 06A0  32         bl    @putvr                ; Write once
     6330 614A 
0015 6332 391C             data  >391c                 ; VR1/57, value 00011100
0016 6334 06A0  32         bl    @putvr                ; Write twice
     6336 614A 
0017 6338 391C             data  >391c                 ; VR1/57, value 00011100
0018 633A 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 633C C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 633E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6340 614A 
0028 6342 391C             data  >391c
0029 6344 0458  20         b     *tmp4                 ; Exit
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
0040 6346 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6348 06A0  32         bl    @cpym2v
     634A 6250 
0042 634C 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     634E 638A 
     6350 0006 
0043 6352 06A0  32         bl    @putvr
     6354 614A 
0044 6356 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6358 06A0  32         bl    @putvr
     635A 614A 
0046 635C 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 635E 0204  20         li    tmp0,>3f00
     6360 3F00 
0052 6362 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6364 60E2 
0053 6366 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6368 8800 
0054 636A 0984  56         srl   tmp0,8
0055 636C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     636E 8800 
0056 6370 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 6372 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6374 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6376 BFFF 
0060 6378 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 637A 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     637C 4000 
0063               f18chk_exit:
0064 637E 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6380 60B6 
0065 6382 3F00             data  >3f00,>00,6
     6384 0000 
     6386 0006 
0066 6388 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 638A 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 638C 3F00             data  >3f00                 ; 3f02 / 3f00
0073 638E 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6390 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 6392 06A0  32         bl    @putvr
     6394 614A 
0097 6396 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 6398 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     639A 614A 
0100 639C 391C             data  >391c                 ; Lock the F18a
0101 639E 0458  20         b     *tmp4                 ; Exit
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
0120 63A0 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 63A2 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     63A4 6048 
0122 63A6 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 63A8 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     63AA 8802 
0127 63AC 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     63AE 614A 
0128 63B0 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 63B2 04C4  14         clr   tmp0
0130 63B4 D120  34         movb  @vdps,tmp0
     63B6 8802 
0131 63B8 0984  56         srl   tmp0,8
0132 63BA 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0088 63BC 40A0  34         szc   @wbit11,config        ; Reset ANY key
     63BE 6034 
0089 63C0 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 63C2 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 63C4 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 63C6 0207  20         li    tmp3,kbmap0           ; Start with column 0
     63C8 6438 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 63CA 04CC  14         clr   r12
0097 63CC 1E15  20         sbz   >0015                 ; Set P5
0098 63CE 1F07  20         tb    7
0099 63D0 1302  14         jeq   virtk1
0100 63D2 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     63D4 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 63D6 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 63D8 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     63DA 0024 
0107 63DC 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 63DE 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     63E0 0006 
0109 63E2 0705  14         seto  tmp1                  ; >FFFF
0110 63E4 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 63E6 0545  14         inv   tmp1
0112 63E8 1302  14         jeq   virtk2                ; >0000 ?
0113 63EA E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     63EC 6034 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 63EE 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 63F0 1601  14         jne   virtk3
0119 63F2 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 63F4 05C7  14 virtk3  inct  tmp3
0121 63F6 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     63F8 6444 
0122 63FA 16F9  14         jne   virtk2                ; No, next entry
0123 63FC 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 63FE 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     6400 0700 
0128 6402 1309  14         jeq   virtk6                ; Yes, exit
0129 6404 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     6406 0200 
0130 6408 1303  14         jeq   virtk5                ; Yes, skip
0131 640A 0224  22         ai    tmp0,>0100
     640C 0100 
0132 640E 10E3  14         jmp   virtk1
0133 6410 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6412 0500 
0134 6414 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 6416 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 6418 C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     641A 8332 
0140 641C 1601  14         jne   virtk7
0141 641E 045B  20         b     *r11                  ; Exit
0142 6420 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6422 FFFF 
0143 6424 1603  14         jne   virtk8                ; No
0144 6426 0701  14         seto  r1                    ; Set exit flag
0145 6428 0460  28         b     @runli1               ; Yes, reset computer
     642A 7164 
0146 642C 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     642E 8000 
0147 6430 1602  14         jne   virtk9
0148 6432 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     6434 6034 
0149 6436 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 6438 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     643A FFFF 
0155 643C 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     643E 0020 
0156 6440 0400             data  >0400,kenter          ; >04 00000100  enter
     6442 4000 
0157 6444 FFFF     kbeoc   data  >ffff
0158               
0159 6446 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     6448 1000 
0160 644A 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     644C 0008 
0161 644E 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6450 0004 
0162 6452 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     6454 0200 
0163 6456 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     6458 0040 
0164 645A FFFF             data  >ffff
0165               
0166 645C 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     645E 2000 
0167 6460 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6462 0002 
0168 6464 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6466 0100 
0169 6468 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     646A 0080 
0170 646C 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     646E 0010 
0171 6470 FFFF             data  >ffff
0172               
0173 6472 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     6474 0001 
0174 6476 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     6478 0800 
0175 647A 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     647C 0020 
0176 647E FFFF             data  >ffff
0177               
0178 6480 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     6482 0020 
0179 6484 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     6486 0200 
0180 6488 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     648A 0100 
0181 648C 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     648E 0040 
0182 6490 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     6492 0080 
0183 6494 FFFF             data  >ffff
0184               
0185 6496 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     6498 0001 
0186 649A 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     649C 0010 
0187 649E 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     64A0 0008 
0188 64A2 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     64A4 0002 
0189 64A6 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     64A8 0004 
0190 64AA FFFF             data  >ffff
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
0016 64AC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64AE 604A 
0017 64B0 020C  20         li    r12,>0024
     64B2 0024 
0018 64B4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64B6 6544 
0019 64B8 04C6  14         clr   tmp2
0020 64BA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64BC 04CC  14         clr   r12
0025 64BE 1F08  20         tb    >0008                 ; Shift-key ?
0026 64C0 1302  14         jeq   realk1                ; No
0027 64C2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64C4 6574 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64C6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64C8 1302  14         jeq   realk2                ; No
0033 64CA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64CC 65A4 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64CE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64D0 1302  14         jeq   realk3                ; No
0039 64D2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64D4 65D4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64D6 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64D8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64DA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 64DC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     64DE 604A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 64E0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 64E2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64E4 0006 
0052 64E6 0606  14 realk5  dec   tmp2
0053 64E8 020C  20         li    r12,>24               ; CRU address for P2-P4
     64EA 0024 
0054 64EC 06C6  14         swpb  tmp2
0055 64EE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64F0 06C6  14         swpb  tmp2
0057 64F2 020C  20         li    r12,6                 ; CRU read address
     64F4 0006 
0058 64F6 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 64F8 0547  14         inv   tmp3                  ;
0060 64FA 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     64FC FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 64FE 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6500 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6502 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6504 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6506 0285  22         ci    tmp1,8
     6508 0008 
0069 650A 1AFA  14         jl    realk6
0070 650C C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 650E 1BEB  14         jh    realk5                ; No, next column
0072 6510 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6512 C206  18 realk8  mov   tmp2,tmp4
0077 6514 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6516 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6518 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 651A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 651C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 651E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6520 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6522 604A 
0087 6524 1608  14         jne   realka                ; No, continue saving key
0088 6526 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6528 656E 
0089 652A 1A05  14         jl    realka
0090 652C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     652E 656C 
0091 6530 1B02  14         jh    realka                ; No, continue
0092 6532 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6534 E000 
0093 6536 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6538 833C 
0094 653A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     653C 6034 
0095 653E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6540 8C00 
0096 6542 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6544 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6546 0000 
     6548 FF0D 
     654A 203D 
0099 654C ....             text  'xws29ol.'
0100 6554 ....             text  'ced38ik,'
0101 655C ....             text  'vrf47ujm'
0102 6564 ....             text  'btg56yhn'
0103 656C ....             text  'zqa10p;/'
0104 6574 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6576 0000 
     6578 FF0D 
     657A 202B 
0105 657C ....             text  'XWS@(OL>'
0106 6584 ....             text  'CED#*IK<'
0107 658C ....             text  'VRF$&UJM'
0108 6594 ....             text  'BTG%^YHN'
0109 659C ....             text  'ZQA!)P:-'
0110 65A4 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65A6 0000 
     65A8 FF0D 
     65AA 2005 
0111 65AC 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65AE 0804 
     65B0 0F27 
     65B2 C2B9 
0112 65B4 600B             data  >600b,>0907,>063f,>c1B8
     65B6 0907 
     65B8 063F 
     65BA C1B8 
0113 65BC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65BE 7B02 
     65C0 015F 
     65C2 C0C3 
0114 65C4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65C6 7D0E 
     65C8 0CC6 
     65CA BFC4 
0115 65CC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65CE 7C03 
     65D0 BC22 
     65D2 BDBA 
0116 65D4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65D6 0000 
     65D8 FF0D 
     65DA 209D 
0117 65DC 9897             data  >9897,>93b2,>9f8f,>8c9B
     65DE 93B2 
     65E0 9F8F 
     65E2 8C9B 
0118 65E4 8385             data  >8385,>84b3,>9e89,>8b80
     65E6 84B3 
     65E8 9E89 
     65EA 8B80 
0119 65EC 9692             data  >9692,>86b4,>b795,>8a8D
     65EE 86B4 
     65F0 B795 
     65F2 8A8D 
0120 65F4 8294             data  >8294,>87b5,>b698,>888E
     65F6 87B5 
     65F8 B698 
     65FA 888E 
0121 65FC 9A91             data  >9a91,>81b1,>b090,>9cBB
     65FE 81B1 
     6600 B090 
     6602 9CBB 
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
0016 6604 C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 6606 C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     6608 8340 
0018 660A 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     660C 833C 
0019 660E 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 6610 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 6612 0647  14         dect  tmp3                  ; Back to WAUX1
0022 6614 C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 6616 0205  20         li    tmp1,4
     6618 0004 
0027 661A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 661C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     661E 000F 
0029 6620 A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 6622 06C6  14 mkhex2  swpb  tmp2
0031 6624 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 6626 0944  56         srl   tmp0,4                ; Next nibble
0033 6628 0605  14         dec   tmp1
0034 662A 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 662C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     662E BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 6630 C160  34         mov   @waux3,tmp1           ; Get pointer
     6632 8340 
0040 6634 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 6636 0585  14         inc   tmp1                  ; Next byte, not word!
0042 6638 C120  34         mov   @waux2,tmp0
     663A 833E 
0043 663C 06C4  14         swpb  tmp0
0044 663E DD44  32         movb  tmp0,*tmp1+
0045 6640 06C4  14         swpb  tmp0
0046 6642 DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 6644 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6646 8340 
0051 6648 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     664A 6040 
0052 664C 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 664E C120  34         mov   @waux1,tmp0
     6650 833C 
0057 6652 06C4  14         swpb  tmp0
0058 6654 DD44  32         movb  tmp0,*tmp1+
0059 6656 06C4  14         swpb  tmp0
0060 6658 DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 665A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     665C 604A 
0065 665E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 6660 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 6662 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6664 7FFF 
0071 6666 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6668 8340 
0072 666A 0460  28         b     @xutst0               ; Display string
     666C 6238 
0073 666E 0610     prefix  data  >0610                 ; Length byte + blank
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
0087 6670 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6672 832A 
0088 6674 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6676 8000 
0089 6678 10C5  14         jmp   mkhex                 ; Convert number and display
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
0019 667A 0207  20 mknum   li    tmp3,5                ; Digit counter
     667C 0005 
0020 667E C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6680 C155  26         mov   *tmp1,tmp1            ; /
0022 6682 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6684 0228  22         ai    tmp4,4                ; Get end of buffer
     6686 0004 
0024 6688 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     668A 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 668C 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 668E 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6690 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6692 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6694 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6696 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6698 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 669A 0607  14         dec   tmp3                  ; Decrease counter
0036 669C 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 669E 0207  20         li    tmp3,4                ; Check first 4 digits
     66A0 0004 
0041 66A2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 66A4 C11B  26         mov   *r11,tmp0
0043 66A6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 66A8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 66AA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 66AC 05CB  14 mknum3  inct  r11
0047 66AE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     66B0 604A 
0048 66B2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 66B4 045B  20         b     *r11                  ; Exit
0050 66B6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 66B8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 66BA 13F8  14         jeq   mknum3                ; Yes, exit
0053 66BC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 66BE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     66C0 7FFF 
0058 66C2 C10B  18         mov   r11,tmp0
0059 66C4 0224  22         ai    tmp0,-4
     66C6 FFFC 
0060 66C8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 66CA 0206  20         li    tmp2,>0500            ; String length = 5
     66CC 0500 
0062 66CE 0460  28         b     @xutstr               ; Display string
     66D0 623A 
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
0092 66D2 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 66D4 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 66D6 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 66D8 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 66DA 0207  20         li    tmp3,5                ; Set counter
     66DC 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 66DE 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 66E0 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 66E2 0584  14         inc   tmp0                  ; Next character
0104 66E4 0607  14         dec   tmp3                  ; Last digit reached ?
0105 66E6 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 66E8 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 66EA 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 66EC DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 66EE 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 66F0 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 66F2 0607  14         dec   tmp3                  ; Last character ?
0120 66F4 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 66F6 045B  20         b     *r11                  ; Return
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
0138 66F8 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     66FA 832A 
0139 66FC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     66FE 8000 
0140 6700 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0183               
0185                        copy  "cpu_crc16.asm"           ; CRC-16 checksum calculation
**** **** ****     > cpu_crc16.asm
0001               * FILE......: cpu_crc16.asm
0002               * Purpose...: CPU memory CRC-16 Cyclic Redundancy Checksum
0003               
0004               
0005               ***************************************************************
0006               * CALC_CRC - Calculate 16 bit Cyclic Redundancy Check
0007               ***************************************************************
0008               *  bl   @calc_crc
0009               *  data p0,p1
0010               *--------------------------------------------------------------
0011               *  p0 = Memory start address
0012               *  p1 = Memory end address
0013               *--------------------------------------------------------------
0014               *  bl   @calc_crcx
0015               *
0016               *  tmp0 = Memory start address
0017               *  tmp1 = Memory end address
0018               *--------------------------------------------------------------
0019               *  REMARKS
0020               *  Introduces register equate wcrc (tmp4/r8) which contains the
0021               *  calculated CRC-16 checksum upon exit.
0022               ********@*****@*********************@**************************
0023      0004     wmemory equ   tmp0                  ; Current memory address
0024      0005     wmemend equ   tmp1                  ; Highest memory address to process
0025      0008     wcrc    equ   tmp4                  ; Current CRC
0026               *--------------------------------------------------------------
0027               * Entry point
0028               *--------------------------------------------------------------
0029               calc_crc
0030 6702 C13B  30         mov   *r11+,wmemory         ; First memory address
0031 6704 C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx
0033 6706 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 6708 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * Next word
0037               *--------------------------------------------------------------
0038               calc_crc1
0039 670A 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2
0044 670C C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 670E 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 6710 C1C8  18         mov   wcrc,tmp3
0048 6712 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 6714 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 6716 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6718 00FF 
0052               
0053 671A 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 671C 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 671E 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6720 6744 
0056               *--------------------------------------------------------------
0057               * Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3
0060 6722 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 6724 0246  22         andi  tmp2,>00ff            ; Clear MSB
     6726 00FF 
0062               
0063 6728 C1C8  18         mov   wcrc,tmp3
0064 672A 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 672C 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 672E 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6730 00FF 
0068               
0069 6732 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 6734 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 6736 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6738 6744 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 673A 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 673C 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 673E 04C7  14         clr   tmp3
0081 6740 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082 6742 045B  20         b     *r11                  ; Return
0083               
0084               
0085               
0086               ***************************************************************
0087               * CRC Lookup Table - 1024 bytes
0088               * http://www.sunshine2k.de/coding/javascript/crc/crc_js.html
0089               *--------------------------------------------------------------
0090               * Polynomial........: 0x1021
0091               * Initial value.....: 0x0
0092               * Final Xor value...: 0x0
0093               ***************************************************************
0094               crc_table
0095 6744 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     6746 1021 
     6748 2042 
     674A 3063 
     674C 4084 
     674E 50A5 
     6750 60C6 
     6752 70E7 
0096 6754 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     6756 9129 
     6758 A14A 
     675A B16B 
     675C C18C 
     675E D1AD 
     6760 E1CE 
     6762 F1EF 
0097 6764 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     6766 0210 
     6768 3273 
     676A 2252 
     676C 52B5 
     676E 4294 
     6770 72F7 
     6772 62D6 
0098 6774 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     6776 8318 
     6778 B37B 
     677A A35A 
     677C D3BD 
     677E C39C 
     6780 F3FF 
     6782 E3DE 
0099 6784 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     6786 3443 
     6788 0420 
     678A 1401 
     678C 64E6 
     678E 74C7 
     6790 44A4 
     6792 5485 
0100 6794 A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     6796 B54B 
     6798 8528 
     679A 9509 
     679C E5EE 
     679E F5CF 
     67A0 C5AC 
     67A2 D58D 
0101 67A4 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     67A6 2672 
     67A8 1611 
     67AA 0630 
     67AC 76D7 
     67AE 66F6 
     67B0 5695 
     67B2 46B4 
0102 67B4 B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     67B6 A77A 
     67B8 9719 
     67BA 8738 
     67BC F7DF 
     67BE E7FE 
     67C0 D79D 
     67C2 C7BC 
0103 67C4 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     67C6 58E5 
     67C8 6886 
     67CA 78A7 
     67CC 0840 
     67CE 1861 
     67D0 2802 
     67D2 3823 
0104 67D4 C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     67D6 D9ED 
     67D8 E98E 
     67DA F9AF 
     67DC 8948 
     67DE 9969 
     67E0 A90A 
     67E2 B92B 
0105 67E4 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     67E6 4AD4 
     67E8 7AB7 
     67EA 6A96 
     67EC 1A71 
     67EE 0A50 
     67F0 3A33 
     67F2 2A12 
0106 67F4 DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     67F6 CBDC 
     67F8 FBBF 
     67FA EB9E 
     67FC 9B79 
     67FE 8B58 
     6800 BB3B 
     6802 AB1A 
0107 6804 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     6806 7C87 
     6808 4CE4 
     680A 5CC5 
     680C 2C22 
     680E 3C03 
     6810 0C60 
     6812 1C41 
0108 6814 EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     6816 FD8F 
     6818 CDEC 
     681A DDCD 
     681C AD2A 
     681E BD0B 
     6820 8D68 
     6822 9D49 
0109 6824 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     6826 6EB6 
     6828 5ED5 
     682A 4EF4 
     682C 3E13 
     682E 2E32 
     6830 1E51 
     6832 0E70 
0110 6834 FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     6836 EFBE 
     6838 DFDD 
     683A CFFC 
     683C BF1B 
     683E AF3A 
     6840 9F59 
     6842 8F78 
0111 6844 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     6846 81A9 
     6848 B1CA 
     684A A1EB 
     684C D10C 
     684E C12D 
     6850 F14E 
     6852 E16F 
0112 6854 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     6856 00A1 
     6858 30C2 
     685A 20E3 
     685C 5004 
     685E 4025 
     6860 7046 
     6862 6067 
0113 6864 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     6866 9398 
     6868 A3FB 
     686A B3DA 
     686C C33D 
     686E D31C 
     6870 E37F 
     6872 F35E 
0114 6874 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     6876 1290 
     6878 22F3 
     687A 32D2 
     687C 4235 
     687E 5214 
     6880 6277 
     6882 7256 
0115 6884 B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     6886 A5CB 
     6888 95A8 
     688A 8589 
     688C F56E 
     688E E54F 
     6890 D52C 
     6892 C50D 
0116 6894 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     6896 24C3 
     6898 14A0 
     689A 0481 
     689C 7466 
     689E 6447 
     68A0 5424 
     68A2 4405 
0117 68A4 A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     68A6 B7FA 
     68A8 8799 
     68AA 97B8 
     68AC E75F 
     68AE F77E 
     68B0 C71D 
     68B2 D73C 
0118 68B4 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     68B6 36F2 
     68B8 0691 
     68BA 16B0 
     68BC 6657 
     68BE 7676 
     68C0 4615 
     68C2 5634 
0119 68C4 D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     68C6 C96D 
     68C8 F90E 
     68CA E92F 
     68CC 99C8 
     68CE 89E9 
     68D0 B98A 
     68D2 A9AB 
0120 68D4 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     68D6 4865 
     68D8 7806 
     68DA 6827 
     68DC 18C0 
     68DE 08E1 
     68E0 3882 
     68E2 28A3 
0121 68E4 CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     68E6 DB5C 
     68E8 EB3F 
     68EA FB1E 
     68EC 8BF9 
     68EE 9BD8 
     68F0 ABBB 
     68F2 BB9A 
0122 68F4 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     68F6 5A54 
     68F8 6A37 
     68FA 7A16 
     68FC 0AF1 
     68FE 1AD0 
     6900 2AB3 
     6902 3A92 
0123 6904 FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     6906 ED0F 
     6908 DD6C 
     690A CD4D 
     690C BDAA 
     690E AD8B 
     6910 9DE8 
     6912 8DC9 
0124 6914 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     6916 6C07 
     6918 5C64 
     691A 4C45 
     691C 3CA2 
     691E 2C83 
     6920 1CE0 
     6922 0CC1 
0125 6924 EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     6926 FF3E 
     6928 CF5D 
     692A DF7C 
     692C AF9B 
     692E BFBA 
     6930 8FD9 
     6932 9FF8 
0126 6934 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     6936 7E36 
     6938 4E55 
     693A 5E74 
     693C 2E93 
     693E 3EB2 
     6940 0ED1 
     6942 1EF0 
**** **** ****     > runlib.asm
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
0021 6944 C820  54         mov   @>8300,@>2000
     6946 8300 
     6948 2000 
0022 694A C820  54         mov   @>8302,@>2002
     694C 8302 
     694E 2002 
0023 6950 C820  54         mov   @>8304,@>2004
     6952 8304 
     6954 2004 
0024 6956 C820  54         mov   @>8306,@>2006
     6958 8306 
     695A 2006 
0025 695C C820  54         mov   @>8308,@>2008
     695E 8308 
     6960 2008 
0026 6962 C820  54         mov   @>830A,@>200A
     6964 830A 
     6966 200A 
0027 6968 C820  54         mov   @>830C,@>200C
     696A 830C 
     696C 200C 
0028 696E C820  54         mov   @>830E,@>200E
     6970 830E 
     6972 200E 
0029 6974 C820  54         mov   @>8310,@>2010
     6976 8310 
     6978 2010 
0030 697A C820  54         mov   @>8312,@>2012
     697C 8312 
     697E 2012 
0031 6980 C820  54         mov   @>8314,@>2014
     6982 8314 
     6984 2014 
0032 6986 C820  54         mov   @>8316,@>2016
     6988 8316 
     698A 2016 
0033 698C C820  54         mov   @>8318,@>2018
     698E 8318 
     6990 2018 
0034 6992 C820  54         mov   @>831A,@>201A
     6994 831A 
     6996 201A 
0035 6998 C820  54         mov   @>831C,@>201C
     699A 831C 
     699C 201C 
0036 699E C820  54         mov   @>831E,@>201E
     69A0 831E 
     69A2 201E 
0037 69A4 C820  54         mov   @>8320,@>2020
     69A6 8320 
     69A8 2020 
0038 69AA C820  54         mov   @>8322,@>2022
     69AC 8322 
     69AE 2022 
0039 69B0 C820  54         mov   @>8324,@>2024
     69B2 8324 
     69B4 2024 
0040 69B6 C820  54         mov   @>8326,@>2026
     69B8 8326 
     69BA 2026 
0041 69BC C820  54         mov   @>8328,@>2028
     69BE 8328 
     69C0 2028 
0042 69C2 C820  54         mov   @>832A,@>202A
     69C4 832A 
     69C6 202A 
0043 69C8 C820  54         mov   @>832C,@>202C
     69CA 832C 
     69CC 202C 
0044 69CE C820  54         mov   @>832E,@>202E
     69D0 832E 
     69D2 202E 
0045 69D4 C820  54         mov   @>8330,@>2030
     69D6 8330 
     69D8 2030 
0046 69DA C820  54         mov   @>8332,@>2032
     69DC 8332 
     69DE 2032 
0047 69E0 C820  54         mov   @>8334,@>2034
     69E2 8334 
     69E4 2034 
0048 69E6 C820  54         mov   @>8336,@>2036
     69E8 8336 
     69EA 2036 
0049 69EC C820  54         mov   @>8338,@>2038
     69EE 8338 
     69F0 2038 
0050 69F2 C820  54         mov   @>833A,@>203A
     69F4 833A 
     69F6 203A 
0051 69F8 C820  54         mov   @>833C,@>203C
     69FA 833C 
     69FC 203C 
0052 69FE C820  54         mov   @>833E,@>203E
     6A00 833E 
     6A02 203E 
0053 6A04 C820  54         mov   @>8340,@>2040
     6A06 8340 
     6A08 2040 
0054 6A0A C820  54         mov   @>8342,@>2042
     6A0C 8342 
     6A0E 2042 
0055 6A10 C820  54         mov   @>8344,@>2044
     6A12 8344 
     6A14 2044 
0056 6A16 C820  54         mov   @>8346,@>2046
     6A18 8346 
     6A1A 2046 
0057 6A1C C820  54         mov   @>8348,@>2048
     6A1E 8348 
     6A20 2048 
0058 6A22 C820  54         mov   @>834A,@>204A
     6A24 834A 
     6A26 204A 
0059 6A28 C820  54         mov   @>834C,@>204C
     6A2A 834C 
     6A2C 204C 
0060 6A2E C820  54         mov   @>834E,@>204E
     6A30 834E 
     6A32 204E 
0061 6A34 C820  54         mov   @>8350,@>2050
     6A36 8350 
     6A38 2050 
0062 6A3A C820  54         mov   @>8352,@>2052
     6A3C 8352 
     6A3E 2052 
0063 6A40 C820  54         mov   @>8354,@>2054
     6A42 8354 
     6A44 2054 
0064 6A46 C820  54         mov   @>8356,@>2056
     6A48 8356 
     6A4A 2056 
0065 6A4C C820  54         mov   @>8358,@>2058
     6A4E 8358 
     6A50 2058 
0066 6A52 C820  54         mov   @>835A,@>205A
     6A54 835A 
     6A56 205A 
0067 6A58 C820  54         mov   @>835C,@>205C
     6A5A 835C 
     6A5C 205C 
0068 6A5E C820  54         mov   @>835E,@>205E
     6A60 835E 
     6A62 205E 
0069 6A64 C820  54         mov   @>8360,@>2060
     6A66 8360 
     6A68 2060 
0070 6A6A C820  54         mov   @>8362,@>2062
     6A6C 8362 
     6A6E 2062 
0071 6A70 C820  54         mov   @>8364,@>2064
     6A72 8364 
     6A74 2064 
0072 6A76 C820  54         mov   @>8366,@>2066
     6A78 8366 
     6A7A 2066 
0073 6A7C C820  54         mov   @>8368,@>2068
     6A7E 8368 
     6A80 2068 
0074 6A82 C820  54         mov   @>836A,@>206A
     6A84 836A 
     6A86 206A 
0075 6A88 C820  54         mov   @>836C,@>206C
     6A8A 836C 
     6A8C 206C 
0076 6A8E C820  54         mov   @>836E,@>206E
     6A90 836E 
     6A92 206E 
0077 6A94 C820  54         mov   @>8370,@>2070
     6A96 8370 
     6A98 2070 
0078 6A9A C820  54         mov   @>8372,@>2072
     6A9C 8372 
     6A9E 2072 
0079 6AA0 C820  54         mov   @>8374,@>2074
     6AA2 8374 
     6AA4 2074 
0080 6AA6 C820  54         mov   @>8376,@>2076
     6AA8 8376 
     6AAA 2076 
0081 6AAC C820  54         mov   @>8378,@>2078
     6AAE 8378 
     6AB0 2078 
0082 6AB2 C820  54         mov   @>837A,@>207A
     6AB4 837A 
     6AB6 207A 
0083 6AB8 C820  54         mov   @>837C,@>207C
     6ABA 837C 
     6ABC 207C 
0084 6ABE C820  54         mov   @>837E,@>207E
     6AC0 837E 
     6AC2 207E 
0085 6AC4 C820  54         mov   @>8380,@>2080
     6AC6 8380 
     6AC8 2080 
0086 6ACA C820  54         mov   @>8382,@>2082
     6ACC 8382 
     6ACE 2082 
0087 6AD0 C820  54         mov   @>8384,@>2084
     6AD2 8384 
     6AD4 2084 
0088 6AD6 C820  54         mov   @>8386,@>2086
     6AD8 8386 
     6ADA 2086 
0089 6ADC C820  54         mov   @>8388,@>2088
     6ADE 8388 
     6AE0 2088 
0090 6AE2 C820  54         mov   @>838A,@>208A
     6AE4 838A 
     6AE6 208A 
0091 6AE8 C820  54         mov   @>838C,@>208C
     6AEA 838C 
     6AEC 208C 
0092 6AEE C820  54         mov   @>838E,@>208E
     6AF0 838E 
     6AF2 208E 
0093 6AF4 C820  54         mov   @>8390,@>2090
     6AF6 8390 
     6AF8 2090 
0094 6AFA C820  54         mov   @>8392,@>2092
     6AFC 8392 
     6AFE 2092 
0095 6B00 C820  54         mov   @>8394,@>2094
     6B02 8394 
     6B04 2094 
0096 6B06 C820  54         mov   @>8396,@>2096
     6B08 8396 
     6B0A 2096 
0097 6B0C C820  54         mov   @>8398,@>2098
     6B0E 8398 
     6B10 2098 
0098 6B12 C820  54         mov   @>839A,@>209A
     6B14 839A 
     6B16 209A 
0099 6B18 C820  54         mov   @>839C,@>209C
     6B1A 839C 
     6B1C 209C 
0100 6B1E C820  54         mov   @>839E,@>209E
     6B20 839E 
     6B22 209E 
0101 6B24 C820  54         mov   @>83A0,@>20A0
     6B26 83A0 
     6B28 20A0 
0102 6B2A C820  54         mov   @>83A2,@>20A2
     6B2C 83A2 
     6B2E 20A2 
0103 6B30 C820  54         mov   @>83A4,@>20A4
     6B32 83A4 
     6B34 20A4 
0104 6B36 C820  54         mov   @>83A6,@>20A6
     6B38 83A6 
     6B3A 20A6 
0105 6B3C C820  54         mov   @>83A8,@>20A8
     6B3E 83A8 
     6B40 20A8 
0106 6B42 C820  54         mov   @>83AA,@>20AA
     6B44 83AA 
     6B46 20AA 
0107 6B48 C820  54         mov   @>83AC,@>20AC
     6B4A 83AC 
     6B4C 20AC 
0108 6B4E C820  54         mov   @>83AE,@>20AE
     6B50 83AE 
     6B52 20AE 
0109 6B54 C820  54         mov   @>83B0,@>20B0
     6B56 83B0 
     6B58 20B0 
0110 6B5A C820  54         mov   @>83B2,@>20B2
     6B5C 83B2 
     6B5E 20B2 
0111 6B60 C820  54         mov   @>83B4,@>20B4
     6B62 83B4 
     6B64 20B4 
0112 6B66 C820  54         mov   @>83B6,@>20B6
     6B68 83B6 
     6B6A 20B6 
0113 6B6C C820  54         mov   @>83B8,@>20B8
     6B6E 83B8 
     6B70 20B8 
0114 6B72 C820  54         mov   @>83BA,@>20BA
     6B74 83BA 
     6B76 20BA 
0115 6B78 C820  54         mov   @>83BC,@>20BC
     6B7A 83BC 
     6B7C 20BC 
0116 6B7E C820  54         mov   @>83BE,@>20BE
     6B80 83BE 
     6B82 20BE 
0117 6B84 C820  54         mov   @>83C0,@>20C0
     6B86 83C0 
     6B88 20C0 
0118 6B8A C820  54         mov   @>83C2,@>20C2
     6B8C 83C2 
     6B8E 20C2 
0119 6B90 C820  54         mov   @>83C4,@>20C4
     6B92 83C4 
     6B94 20C4 
0120 6B96 C820  54         mov   @>83C6,@>20C6
     6B98 83C6 
     6B9A 20C6 
0121 6B9C C820  54         mov   @>83C8,@>20C8
     6B9E 83C8 
     6BA0 20C8 
0122 6BA2 C820  54         mov   @>83CA,@>20CA
     6BA4 83CA 
     6BA6 20CA 
0123 6BA8 C820  54         mov   @>83CC,@>20CC
     6BAA 83CC 
     6BAC 20CC 
0124 6BAE C820  54         mov   @>83CE,@>20CE
     6BB0 83CE 
     6BB2 20CE 
0125 6BB4 C820  54         mov   @>83D0,@>20D0
     6BB6 83D0 
     6BB8 20D0 
0126 6BBA C820  54         mov   @>83D2,@>20D2
     6BBC 83D2 
     6BBE 20D2 
0127 6BC0 C820  54         mov   @>83D4,@>20D4
     6BC2 83D4 
     6BC4 20D4 
0128 6BC6 C820  54         mov   @>83D6,@>20D6
     6BC8 83D6 
     6BCA 20D6 
0129 6BCC C820  54         mov   @>83D8,@>20D8
     6BCE 83D8 
     6BD0 20D8 
0130 6BD2 C820  54         mov   @>83DA,@>20DA
     6BD4 83DA 
     6BD6 20DA 
0131 6BD8 C820  54         mov   @>83DC,@>20DC
     6BDA 83DC 
     6BDC 20DC 
0132 6BDE C820  54         mov   @>83DE,@>20DE
     6BE0 83DE 
     6BE2 20DE 
0133 6BE4 C820  54         mov   @>83E0,@>20E0
     6BE6 83E0 
     6BE8 20E0 
0134 6BEA C820  54         mov   @>83E2,@>20E2
     6BEC 83E2 
     6BEE 20E2 
0135 6BF0 C820  54         mov   @>83E4,@>20E4
     6BF2 83E4 
     6BF4 20E4 
0136 6BF6 C820  54         mov   @>83E6,@>20E6
     6BF8 83E6 
     6BFA 20E6 
0137 6BFC C820  54         mov   @>83E8,@>20E8
     6BFE 83E8 
     6C00 20E8 
0138 6C02 C820  54         mov   @>83EA,@>20EA
     6C04 83EA 
     6C06 20EA 
0139 6C08 C820  54         mov   @>83EC,@>20EC
     6C0A 83EC 
     6C0C 20EC 
0140 6C0E C820  54         mov   @>83EE,@>20EE
     6C10 83EE 
     6C12 20EE 
0141 6C14 C820  54         mov   @>83F0,@>20F0
     6C16 83F0 
     6C18 20F0 
0142 6C1A C820  54         mov   @>83F2,@>20F2
     6C1C 83F2 
     6C1E 20F2 
0143 6C20 C820  54         mov   @>83F4,@>20F4
     6C22 83F4 
     6C24 20F4 
0144 6C26 C820  54         mov   @>83F6,@>20F6
     6C28 83F6 
     6C2A 20F6 
0145 6C2C C820  54         mov   @>83F8,@>20F8
     6C2E 83F8 
     6C30 20F8 
0146 6C32 C820  54         mov   @>83FA,@>20FA
     6C34 83FA 
     6C36 20FA 
0147 6C38 C820  54         mov   @>83FC,@>20FC
     6C3A 83FC 
     6C3C 20FC 
0148 6C3E C820  54         mov   @>83FE,@>20FE
     6C40 83FE 
     6C42 20FE 
0149 6C44 045B  20         b     *r11                  ; Return to caller
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
0164 6C46 C820  54         mov   @>2000,@>8300
     6C48 2000 
     6C4A 8300 
0165 6C4C C820  54         mov   @>2002,@>8302
     6C4E 2002 
     6C50 8302 
0166 6C52 C820  54         mov   @>2004,@>8304
     6C54 2004 
     6C56 8304 
0167 6C58 C820  54         mov   @>2006,@>8306
     6C5A 2006 
     6C5C 8306 
0168 6C5E C820  54         mov   @>2008,@>8308
     6C60 2008 
     6C62 8308 
0169 6C64 C820  54         mov   @>200A,@>830A
     6C66 200A 
     6C68 830A 
0170 6C6A C820  54         mov   @>200C,@>830C
     6C6C 200C 
     6C6E 830C 
0171 6C70 C820  54         mov   @>200E,@>830E
     6C72 200E 
     6C74 830E 
0172 6C76 C820  54         mov   @>2010,@>8310
     6C78 2010 
     6C7A 8310 
0173 6C7C C820  54         mov   @>2012,@>8312
     6C7E 2012 
     6C80 8312 
0174 6C82 C820  54         mov   @>2014,@>8314
     6C84 2014 
     6C86 8314 
0175 6C88 C820  54         mov   @>2016,@>8316
     6C8A 2016 
     6C8C 8316 
0176 6C8E C820  54         mov   @>2018,@>8318
     6C90 2018 
     6C92 8318 
0177 6C94 C820  54         mov   @>201A,@>831A
     6C96 201A 
     6C98 831A 
0178 6C9A C820  54         mov   @>201C,@>831C
     6C9C 201C 
     6C9E 831C 
0179 6CA0 C820  54         mov   @>201E,@>831E
     6CA2 201E 
     6CA4 831E 
0180 6CA6 C820  54         mov   @>2020,@>8320
     6CA8 2020 
     6CAA 8320 
0181 6CAC C820  54         mov   @>2022,@>8322
     6CAE 2022 
     6CB0 8322 
0182 6CB2 C820  54         mov   @>2024,@>8324
     6CB4 2024 
     6CB6 8324 
0183 6CB8 C820  54         mov   @>2026,@>8326
     6CBA 2026 
     6CBC 8326 
0184 6CBE C820  54         mov   @>2028,@>8328
     6CC0 2028 
     6CC2 8328 
0185 6CC4 C820  54         mov   @>202A,@>832A
     6CC6 202A 
     6CC8 832A 
0186 6CCA C820  54         mov   @>202C,@>832C
     6CCC 202C 
     6CCE 832C 
0187 6CD0 C820  54         mov   @>202E,@>832E
     6CD2 202E 
     6CD4 832E 
0188 6CD6 C820  54         mov   @>2030,@>8330
     6CD8 2030 
     6CDA 8330 
0189 6CDC C820  54         mov   @>2032,@>8332
     6CDE 2032 
     6CE0 8332 
0190 6CE2 C820  54         mov   @>2034,@>8334
     6CE4 2034 
     6CE6 8334 
0191 6CE8 C820  54         mov   @>2036,@>8336
     6CEA 2036 
     6CEC 8336 
0192 6CEE C820  54         mov   @>2038,@>8338
     6CF0 2038 
     6CF2 8338 
0193 6CF4 C820  54         mov   @>203A,@>833A
     6CF6 203A 
     6CF8 833A 
0194 6CFA C820  54         mov   @>203C,@>833C
     6CFC 203C 
     6CFE 833C 
0195 6D00 C820  54         mov   @>203E,@>833E
     6D02 203E 
     6D04 833E 
0196 6D06 C820  54         mov   @>2040,@>8340
     6D08 2040 
     6D0A 8340 
0197 6D0C C820  54         mov   @>2042,@>8342
     6D0E 2042 
     6D10 8342 
0198 6D12 C820  54         mov   @>2044,@>8344
     6D14 2044 
     6D16 8344 
0199 6D18 C820  54         mov   @>2046,@>8346
     6D1A 2046 
     6D1C 8346 
0200 6D1E C820  54         mov   @>2048,@>8348
     6D20 2048 
     6D22 8348 
0201 6D24 C820  54         mov   @>204A,@>834A
     6D26 204A 
     6D28 834A 
0202 6D2A C820  54         mov   @>204C,@>834C
     6D2C 204C 
     6D2E 834C 
0203 6D30 C820  54         mov   @>204E,@>834E
     6D32 204E 
     6D34 834E 
0204 6D36 C820  54         mov   @>2050,@>8350
     6D38 2050 
     6D3A 8350 
0205 6D3C C820  54         mov   @>2052,@>8352
     6D3E 2052 
     6D40 8352 
0206 6D42 C820  54         mov   @>2054,@>8354
     6D44 2054 
     6D46 8354 
0207 6D48 C820  54         mov   @>2056,@>8356
     6D4A 2056 
     6D4C 8356 
0208 6D4E C820  54         mov   @>2058,@>8358
     6D50 2058 
     6D52 8358 
0209 6D54 C820  54         mov   @>205A,@>835A
     6D56 205A 
     6D58 835A 
0210 6D5A C820  54         mov   @>205C,@>835C
     6D5C 205C 
     6D5E 835C 
0211 6D60 C820  54         mov   @>205E,@>835E
     6D62 205E 
     6D64 835E 
0212 6D66 C820  54         mov   @>2060,@>8360
     6D68 2060 
     6D6A 8360 
0213 6D6C C820  54         mov   @>2062,@>8362
     6D6E 2062 
     6D70 8362 
0214 6D72 C820  54         mov   @>2064,@>8364
     6D74 2064 
     6D76 8364 
0215 6D78 C820  54         mov   @>2066,@>8366
     6D7A 2066 
     6D7C 8366 
0216 6D7E C820  54         mov   @>2068,@>8368
     6D80 2068 
     6D82 8368 
0217 6D84 C820  54         mov   @>206A,@>836A
     6D86 206A 
     6D88 836A 
0218 6D8A C820  54         mov   @>206C,@>836C
     6D8C 206C 
     6D8E 836C 
0219 6D90 C820  54         mov   @>206E,@>836E
     6D92 206E 
     6D94 836E 
0220 6D96 C820  54         mov   @>2070,@>8370
     6D98 2070 
     6D9A 8370 
0221 6D9C C820  54         mov   @>2072,@>8372
     6D9E 2072 
     6DA0 8372 
0222 6DA2 C820  54         mov   @>2074,@>8374
     6DA4 2074 
     6DA6 8374 
0223 6DA8 C820  54         mov   @>2076,@>8376
     6DAA 2076 
     6DAC 8376 
0224 6DAE C820  54         mov   @>2078,@>8378
     6DB0 2078 
     6DB2 8378 
0225 6DB4 C820  54         mov   @>207A,@>837A
     6DB6 207A 
     6DB8 837A 
0226 6DBA C820  54         mov   @>207C,@>837C
     6DBC 207C 
     6DBE 837C 
0227 6DC0 C820  54         mov   @>207E,@>837E
     6DC2 207E 
     6DC4 837E 
0228 6DC6 C820  54         mov   @>2080,@>8380
     6DC8 2080 
     6DCA 8380 
0229 6DCC C820  54         mov   @>2082,@>8382
     6DCE 2082 
     6DD0 8382 
0230 6DD2 C820  54         mov   @>2084,@>8384
     6DD4 2084 
     6DD6 8384 
0231 6DD8 C820  54         mov   @>2086,@>8386
     6DDA 2086 
     6DDC 8386 
0232 6DDE C820  54         mov   @>2088,@>8388
     6DE0 2088 
     6DE2 8388 
0233 6DE4 C820  54         mov   @>208A,@>838A
     6DE6 208A 
     6DE8 838A 
0234 6DEA C820  54         mov   @>208C,@>838C
     6DEC 208C 
     6DEE 838C 
0235 6DF0 C820  54         mov   @>208E,@>838E
     6DF2 208E 
     6DF4 838E 
0236 6DF6 C820  54         mov   @>2090,@>8390
     6DF8 2090 
     6DFA 8390 
0237 6DFC C820  54         mov   @>2092,@>8392
     6DFE 2092 
     6E00 8392 
0238 6E02 C820  54         mov   @>2094,@>8394
     6E04 2094 
     6E06 8394 
0239 6E08 C820  54         mov   @>2096,@>8396
     6E0A 2096 
     6E0C 8396 
0240 6E0E C820  54         mov   @>2098,@>8398
     6E10 2098 
     6E12 8398 
0241 6E14 C820  54         mov   @>209A,@>839A
     6E16 209A 
     6E18 839A 
0242 6E1A C820  54         mov   @>209C,@>839C
     6E1C 209C 
     6E1E 839C 
0243 6E20 C820  54         mov   @>209E,@>839E
     6E22 209E 
     6E24 839E 
0244 6E26 C820  54         mov   @>20A0,@>83A0
     6E28 20A0 
     6E2A 83A0 
0245 6E2C C820  54         mov   @>20A2,@>83A2
     6E2E 20A2 
     6E30 83A2 
0246 6E32 C820  54         mov   @>20A4,@>83A4
     6E34 20A4 
     6E36 83A4 
0247 6E38 C820  54         mov   @>20A6,@>83A6
     6E3A 20A6 
     6E3C 83A6 
0248 6E3E C820  54         mov   @>20A8,@>83A8
     6E40 20A8 
     6E42 83A8 
0249 6E44 C820  54         mov   @>20AA,@>83AA
     6E46 20AA 
     6E48 83AA 
0250 6E4A C820  54         mov   @>20AC,@>83AC
     6E4C 20AC 
     6E4E 83AC 
0251 6E50 C820  54         mov   @>20AE,@>83AE
     6E52 20AE 
     6E54 83AE 
0252 6E56 C820  54         mov   @>20B0,@>83B0
     6E58 20B0 
     6E5A 83B0 
0253 6E5C C820  54         mov   @>20B2,@>83B2
     6E5E 20B2 
     6E60 83B2 
0254 6E62 C820  54         mov   @>20B4,@>83B4
     6E64 20B4 
     6E66 83B4 
0255 6E68 C820  54         mov   @>20B6,@>83B6
     6E6A 20B6 
     6E6C 83B6 
0256 6E6E C820  54         mov   @>20B8,@>83B8
     6E70 20B8 
     6E72 83B8 
0257 6E74 C820  54         mov   @>20BA,@>83BA
     6E76 20BA 
     6E78 83BA 
0258 6E7A C820  54         mov   @>20BC,@>83BC
     6E7C 20BC 
     6E7E 83BC 
0259 6E80 C820  54         mov   @>20BE,@>83BE
     6E82 20BE 
     6E84 83BE 
0260 6E86 C820  54         mov   @>20C0,@>83C0
     6E88 20C0 
     6E8A 83C0 
0261 6E8C C820  54         mov   @>20C2,@>83C2
     6E8E 20C2 
     6E90 83C2 
0262 6E92 C820  54         mov   @>20C4,@>83C4
     6E94 20C4 
     6E96 83C4 
0263 6E98 C820  54         mov   @>20C6,@>83C6
     6E9A 20C6 
     6E9C 83C6 
0264 6E9E C820  54         mov   @>20C8,@>83C8
     6EA0 20C8 
     6EA2 83C8 
0265 6EA4 C820  54         mov   @>20CA,@>83CA
     6EA6 20CA 
     6EA8 83CA 
0266 6EAA C820  54         mov   @>20CC,@>83CC
     6EAC 20CC 
     6EAE 83CC 
0267 6EB0 C820  54         mov   @>20CE,@>83CE
     6EB2 20CE 
     6EB4 83CE 
0268 6EB6 C820  54         mov   @>20D0,@>83D0
     6EB8 20D0 
     6EBA 83D0 
0269 6EBC C820  54         mov   @>20D2,@>83D2
     6EBE 20D2 
     6EC0 83D2 
0270 6EC2 C820  54         mov   @>20D4,@>83D4
     6EC4 20D4 
     6EC6 83D4 
0271 6EC8 C820  54         mov   @>20D6,@>83D6
     6ECA 20D6 
     6ECC 83D6 
0272 6ECE C820  54         mov   @>20D8,@>83D8
     6ED0 20D8 
     6ED2 83D8 
0273 6ED4 C820  54         mov   @>20DA,@>83DA
     6ED6 20DA 
     6ED8 83DA 
0274 6EDA C820  54         mov   @>20DC,@>83DC
     6EDC 20DC 
     6EDE 83DC 
0275 6EE0 C820  54         mov   @>20DE,@>83DE
     6EE2 20DE 
     6EE4 83DE 
0276 6EE6 C820  54         mov   @>20E0,@>83E0
     6EE8 20E0 
     6EEA 83E0 
0277 6EEC C820  54         mov   @>20E2,@>83E2
     6EEE 20E2 
     6EF0 83E2 
0278 6EF2 C820  54         mov   @>20E4,@>83E4
     6EF4 20E4 
     6EF6 83E4 
0279 6EF8 C820  54         mov   @>20E6,@>83E6
     6EFA 20E6 
     6EFC 83E6 
0280 6EFE C820  54         mov   @>20E8,@>83E8
     6F00 20E8 
     6F02 83E8 
0281 6F04 C820  54         mov   @>20EA,@>83EA
     6F06 20EA 
     6F08 83EA 
0282 6F0A C820  54         mov   @>20EC,@>83EC
     6F0C 20EC 
     6F0E 83EC 
0283 6F10 C820  54         mov   @>20EE,@>83EE
     6F12 20EE 
     6F14 83EE 
0284 6F16 C820  54         mov   @>20F0,@>83F0
     6F18 20F0 
     6F1A 83F0 
0285 6F1C C820  54         mov   @>20F2,@>83F2
     6F1E 20F2 
     6F20 83F2 
0286 6F22 C820  54         mov   @>20F4,@>83F4
     6F24 20F4 
     6F26 83F4 
0287 6F28 C820  54         mov   @>20F6,@>83F6
     6F2A 20F6 
     6F2C 83F6 
0288 6F2E C820  54         mov   @>20F8,@>83F8
     6F30 20F8 
     6F32 83F8 
0289 6F34 C820  54         mov   @>20FA,@>83FA
     6F36 20FA 
     6F38 83FA 
0290 6F3A C820  54         mov   @>20FC,@>83FC
     6F3C 20FC 
     6F3E 83FC 
0291 6F40 C820  54         mov   @>20FE,@>83FE
     6F42 20FE 
     6F44 83FE 
0292 6F46 045B  20         b     *r11                  ; Return to caller
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
0024 6F48 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6F4A 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6F4C 8300 
0030 6F4E C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6F50 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     6F52 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6F54 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6F56 0606  14         dec   tmp2
0037 6F58 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6F5A C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6F5C 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6F5E 6F64 
0043                                                   ; R14=PC
0044 6F60 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6F62 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6F64 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6F66 6C46 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6F68 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0196               
0198                       copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication
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
0017               ; Spectra2 scratchpad memory needs to be paged out before.
0018               ; You need to specify following equates in main program
0019               ;
0020               ; dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0021               ; dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0022               ;
0023               ; Scratchpad memory usage
0024               ; >8322            Parameter (>08) or (>0A) passed to dsrlnk
0025               ; >8356            Pointer to PAB
0026               ; >83D0            CRU address of current device
0027               ; >83D2            DSR entry address
0028               ; >83e0 - >83ff    GPL / DSRLNK workspace
0029               ;
0030               ; Credits
0031               ; Originally appeared in Miller Graphics The Smart Programmer.
0032               ; This version based on version of Paolo Bagnaresi.
0033               *--------------------------------------------------------------
0034      B00A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0035                                                   ; dstype is address of R5 of DSRLNK ws
0036      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0037               ********@*****@*********************@**************************
0038 6F6A B000     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0039 6F6C 6F6E             data  dsrlnk.init           ; entry point
0040                       ;------------------------------------------------------
0041                       ; DSRLNK entry point
0042                       ;------------------------------------------------------
0043               dsrlnk.init:
0044 6F6E C17E  30         mov   *r14+,r5              ; get pgm type for link
0045 6F70 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6F72 8322 
0046 6F74 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6F76 6046 
0047 6F78 C020  34         mov   @>8356,r0             ; get ptr to pab
     6F7A 8356 
0048 6F7C C240  18         mov   r0,r9                 ; save ptr
0049                       ;------------------------------------------------------
0050                       ; Fetch file descriptor length from PAB
0051                       ;------------------------------------------------------
0052 6F7E 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6F80 FFF8 
0053               
0054                       ;---------------------------; Inline VSBR start
0055 6F82 06C0  14         swpb  r0                    ;
0056 6F84 D800  38         movb  r0,@vdpa              ; send low byte
     6F86 8C02 
0057 6F88 06C0  14         swpb  r0                    ;
0058 6F8A D800  38         movb  r0,@vdpa              ; send high byte
     6F8C 8C02 
0059 6F8E D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6F90 8800 
0060                       ;---------------------------; Inline VSBR end
0061 6F92 0983  56         srl   r3,8                  ; Move to low byte
0062               
0063                       ;------------------------------------------------------
0064                       ; Fetch file descriptor device name from PAB
0065                       ;------------------------------------------------------
0066 6F94 0704  14         seto  r4                    ; init counter
0067 6F96 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6F98 2100 
0068 6F9A 0580  14 !       inc   r0                    ; point to next char of name
0069 6F9C 0584  14         inc   r4                    ; incr char counter
0070 6F9E 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6FA0 0007 
0071 6FA2 1565  14         jgt   dsrlnk.error.devicename_invalid
0072                                                   ; yes, error
0073 6FA4 80C4  18         c     r4,r3                 ; end of name?
0074 6FA6 130C  14         jeq   dsrlnk.device_name.get_length
0075                                                   ; yes
0076               
0077                       ;---------------------------; Inline VSBR start
0078 6FA8 06C0  14         swpb  r0                    ;
0079 6FAA D800  38         movb  r0,@vdpa              ; send low byte
     6FAC 8C02 
0080 6FAE 06C0  14         swpb  r0                    ;
0081 6FB0 D800  38         movb  r0,@vdpa              ; send high byte
     6FB2 8C02 
0082 6FB4 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6FB6 8800 
0083                       ;---------------------------; Inline VSBR end
0084               
0085                       ;------------------------------------------------------
0086                       ; Look for end of device name, for example "DSK1."
0087                       ;------------------------------------------------------
0088 6FB8 DC81  32         movb  r1,*r2+               ; move into buffer
0089 6FBA 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6FBC 707E 
0090 6FBE 16ED  14         jne   -!                    ; no, loop next char
0091                       ;------------------------------------------------------
0092                       ; Determine device name length
0093                       ;------------------------------------------------------
0094               dsrlnk.device_name.get_length:
0095 6FC0 C104  18         mov   r4,r4                 ; Check if length = 0
0096 6FC2 1355  14         jeq   dsrlnk.error.devicename_invalid
0097                                                   ; yes, error
0098 6FC4 04E0  34         clr   @>83d0
     6FC6 83D0 
0099 6FC8 C804  38         mov   r4,@>8354             ; save name length for search
     6FCA 8354 
0100 6FCC 0584  14         inc   r4                    ; adjust for dot
0101 6FCE A804  38         a     r4,@>8356             ; point to position after name
     6FD0 8356 
0102                       ;------------------------------------------------------
0103                       ; Prepare for DSR scan >1000 - >1f00
0104                       ;------------------------------------------------------
0105               dsrlnk.dsrscan.start:
0106 6FD2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6FD4 83E0 
0107 6FD6 04C1  14         clr   r1                    ; version found of dsr
0108 6FD8 020C  20         li    r12,>0f00             ; init cru addr
     6FDA 0F00 
0109                       ;------------------------------------------------------
0110                       ; Turn off ROM on current card
0111                       ;------------------------------------------------------
0112               dsrlnk.dsrscan.cardoff:
0113 6FDC C30C  18         mov   r12,r12               ; anything to turn off?
0114 6FDE 1301  14         jeq   dsrlnk.dsrscan.cardloop
0115                                                   ; no, loop over cards
0116 6FE0 1E00  20         sbz   0                     ; yes, turn off
0117                       ;------------------------------------------------------
0118                       ; Loop over cards and look if DSR present
0119                       ;------------------------------------------------------
0120               dsrlnk.dsrscan.cardloop:
0121 6FE2 022C  22         ai    r12,>0100             ; next rom to turn on
     6FE4 0100 
0122 6FE6 04E0  34         clr   @>83d0                ; clear in case we are done
     6FE8 83D0 
0123 6FEA 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6FEC 2000 
0124 6FEE 133D  14         jeq   dsrlnk.error.nodsr_found
0125                                                   ; yes, no matching DSR found
0126 6FF0 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6FF2 83D0 
0127                       ;------------------------------------------------------
0128                       ; Look at card ROM (@>4000 eq 'AA' ?)
0129                       ;------------------------------------------------------
0130 6FF4 1D00  20         sbo   0                     ; turn on rom
0131 6FF6 0202  20         li    r2,>4000              ; start at beginning of rom
     6FF8 4000 
0132 6FFA 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6FFC 707A 
0133 6FFE 16EE  14         jne   dsrlnk.dsrscan.cardoff
0134                                                   ; no rom found on card
0135                       ;------------------------------------------------------
0136                       ; Valid DSR ROM found. Now loop over chain/subprograms
0137                       ;------------------------------------------------------
0138                       ; dstype is the address of R5 of the DSRLNK workspace,
0139                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0140                       ; is stored before the DSR ROM is searched.
0141                       ;------------------------------------------------------
0142 7000 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     7002 B00A 
0143 7004 1003  14         jmp   dsrlnk.dsrscan.getentry
0144                       ;------------------------------------------------------
0145                       ; Next DSR entry
0146                       ;------------------------------------------------------
0147               dsrlnk.dsrscan.nextentry:
0148 7006 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     7008 83D2 
0149 700A 1D00  20         sbo   0                     ; turn rom back on
0150                       ;------------------------------------------------------
0151                       ; Get DSR entry
0152                       ;------------------------------------------------------
0153               dsrlnk.dsrscan.getentry:
0154 700C C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0155 700E 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0156                                                   ; yes, no more DSRs or programs to check
0157 7010 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     7012 83D2 
0158 7014 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0159 7016 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0160                       ;------------------------------------------------------
0161                       ; Check file descriptor in DSR
0162                       ;------------------------------------------------------
0163 7018 04C5  14         clr   r5                    ; Remove any old stuff
0164 701A D160  34         movb  @>8355,r5             ; get length as counter
     701C 8355 
0165 701E 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0166                                                   ; if zero, do not further check, call DSR program
0167 7020 9C85  32         cb    r5,*r2+               ; see if length matches
0168 7022 16F1  14         jne   dsrlnk.dsrscan.nextentry
0169                                                   ; no, length does not match. Go process next DSR entry
0170 7024 0985  56         srl   r5,8                  ; yes, move to low byte
0171 7026 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     7028 2100 
0172 702A 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0173 702C 16EC  14         jne   dsrlnk.dsrscan.nextentry
0174                                                   ; try next DSR entry if no match
0175 702E 0605  14         dec   r5                    ; loop until full length checked
0176 7030 16FC  14         jne   -!
0177                       ;------------------------------------------------------
0178                       ; Device name/Subprogram match
0179                       ;------------------------------------------------------
0180               dsrlnk.dsrscan.match:
0181 7032 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     7034 83D2 
0182               
0183                       ;------------------------------------------------------
0184                       ; Call DSR program in device card
0185                       ;------------------------------------------------------
0186               dsrlnk.dsrscan.call_dsr:
0187 7036 0581  14         inc   r1                    ; next version found
0188 7038 0699  24         bl    *r9                   ; go run routine
0189                       ;
0190                       ; Depending on IO result the DSR in card ROM does RET
0191                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0192                       ;
0193 703A 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0194                                                   ; (1) error return
0195 703C 1E00  20         sbz   0                     ; (2) turn off rom if good return
0196 703E 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     7040 B000 
0197 7042 C009  18         mov   r9,r0                 ; point to flag in pab
0198 7044 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     7046 8322 
0199                                                   ; (8 or >a)
0200 7048 0281  22         ci    r1,8                  ; was it 8?
     704A 0008 
0201 704C 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0202 704E D060  34         movb  @>8350,r1             ; no, we have a data >a.
     7050 8350 
0203                                                   ; Get error byte from @>8350
0204 7052 1000  14         jmp   dsrlnk.dsrscan.dsr.8  ; go and return error byte to the caller
0205               
0206                       ;------------------------------------------------------
0207                       ; Read PAB status flag after DSR call completed
0208                       ;------------------------------------------------------
0209               dsrlnk.dsrscan.dsr.8:
0210                       ;---------------------------; Inline VSBR start
0211 7054 06C0  14         swpb  r0                    ;
0212 7056 D800  38         movb  r0,@vdpa              ; send low byte
     7058 8C02 
0213 705A 06C0  14         swpb  r0                    ;
0214 705C D800  38         movb  r0,@vdpa              ; send high byte
     705E 8C02 
0215 7060 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     7062 8800 
0216                       ;---------------------------; Inline VSBR end
0217               
0218                       ;------------------------------------------------------
0219                       ; Return DSR error to caller
0220                       ;------------------------------------------------------
0221               dsrlnk.dsrscan.dsr.a:
0222 7064 09D1  56         srl   r1,13                 ; just keep error bits
0223 7066 1604  14         jne   dsrlnk.error.io_error
0224                                                   ; handle IO error
0225 7068 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0226               
0227                       ;------------------------------------------------------
0228                       ; IO-error handler
0229                       ;------------------------------------------------------
0230               dsrlnk.error.nodsr_found:
0231 706A 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     706C B000 
0232               dsrlnk.error.devicename_invalid:
0233 706E 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0234               dsrlnk.error.io_error:
0235 7070 06C1  14         swpb  r1                    ; put error in hi byte
0236 7072 D741  30         movb  r1,*r13               ; store error flags in callers r0
0237 7074 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     7076 6046 
0238 7078 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0239               
0240               ****************************************************************************************
0241               
0242 707A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0243 707C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0244 707E ....     dsrlnk.period     text  '.'         ; For finding end of device name
0245               
0246                       even
**** **** ****     > runlib.asm
0199                       copy  "fio_files.asm"            ; Files I/O support
**** **** ****     > fio_files.asm
0001               * FILE......: fio_files.asm
0002               * Purpose...: File I/O support
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
0015      0009     io.op.status     equ >09            ; STATUS
0016               ***************************************************************
0017               * File types - All relative files are fixed length
0018               ************************************@**************************
0019      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
0020      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
0021      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
0022      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
0023      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
0024      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
0025               ***************************************************************
0026               * File types - Sequential files
0027               ************************************@**************************
0028      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
0029      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
0030      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
0031      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
0032      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
0033      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
0034      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
0035      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
0036      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
0037      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
0038      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
0039      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
0040               
0041               
0042               
0043               ***************************************************************
0044               * file.open - Open File for procesing
0045               ***************************************************************
0046               *  bl   @file.open
0047               *  data P0
0048               *--------------------------------------------------------------
0049               *  P0 = Address of PAB in CPU RAM (without +9 offset!)
0050               *--------------------------------------------------------------
0051               *  bl   @xfile.open
0052               *
0053               *  R0 = Address of PAB in CPU RAM
0054               ********@*****@*********************@**************************
0055               file.open:
0056 7080 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0057               *--------------------------------------------------------------
0058               * Initialisation
0059               *--------------------------------------------------------------
0060               xfile.open:
0061 7082 1000  14         nop
0062               file.open_init:
0063 7084 0220  22         ai    r0,9                  ; Move to file descriptor length
     7086 0009 
0064 7088 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     708A 8356 
0065               *--------------------------------------------------------------
0066               * Main
0067               *--------------------------------------------------------------
0068               file.open_main:
0069 708C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     708E 6F6A 
0070 7090 0008             data  8                     ;
0071               *--------------------------------------------------------------
0072               * Check if error occured during file open operation
0073               *--------------------------------------------------------------
0074 7092 1301  14         jeq   file.error            ; Jump to error handler
0075               *--------------------------------------------------------------
0076               * Exit
0077               *--------------------------------------------------------------
0078               file.open_exit:
0079 7094 045B  20         b     *r11                  ; Return to caller
0080               
0081               
0082               
0083               
0084               
0085               
0086               ***************************************************************
0087               * file.error - Error handler for file errors
0088               ********@*****@*********************@**************************
0089               file.error:
0090               ;
0091               ; When errors do occur then equal bit in status register is set (1)
0092               ; If no errors occur, the equal bit in status register is reset (0)
0093               ;
0094               ; So upon returning from DSRLNK in your file handling code you
0095               ; should basically add:
0096               ;
0097               ;       jeq   file.error            ; Jump to error handler
0098               ;
0099               *--------------------------------------------------------------
0100 7096 10FF  14         jmp   $                     ; A File error occured
0101               *--------------------------------------------------------------
0102               * Exit
0103               *--------------------------------------------------------------
0104               file.error_exit:
0105 7098 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0201               
0202               
0203               
0204               *//////////////////////////////////////////////////////////////
0205               *                            TIMERS
0206               *//////////////////////////////////////////////////////////////
0207               
0208                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 709A 0300  24 tmgr    limi  0                     ; No interrupt processing
     709C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 709E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     70A0 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 70A2 2360  38         coc   @wbit2,r13            ; C flag on ?
     70A4 6046 
0029 70A6 1602  14         jne   tmgr1a                ; No, so move on
0030 70A8 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     70AA 6032 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 70AC 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     70AE 604A 
0035 70B0 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 70B2 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     70B4 603A 
0048 70B6 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 70B8 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     70BA 6038 
0050 70BC 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 70BE 0460  28         b     @kthread              ; Run kernel thread
     70C0 7138 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 70C2 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     70C4 603E 
0056 70C6 13EB  14         jeq   tmgr1
0057 70C8 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     70CA 603C 
0058 70CC 16E8  14         jne   tmgr1
0059 70CE C120  34         mov   @wtiusr,tmp0
     70D0 832E 
0060 70D2 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 70D4 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     70D6 7136 
0065 70D8 C10A  18         mov   r10,tmp0
0066 70DA 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     70DC 00FF 
0067 70DE 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     70E0 6046 
0068 70E2 1303  14         jeq   tmgr5
0069 70E4 0284  22         ci    tmp0,60               ; 1 second reached ?
     70E6 003C 
0070 70E8 1002  14         jmp   tmgr6
0071 70EA 0284  22 tmgr5   ci    tmp0,50
     70EC 0032 
0072 70EE 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 70F0 1001  14         jmp   tmgr8
0074 70F2 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 70F4 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     70F6 832C 
0079 70F8 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     70FA FF00 
0080 70FC C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 70FE 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 7100 05C4  14         inct  tmp0                  ; Second word of slot data
0086 7102 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 7104 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 7106 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     7108 830C 
     710A 830D 
0089 710C 1608  14         jne   tmgr10                ; No, get next slot
0090 710E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     7110 FF00 
0091 7112 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 7114 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     7116 8330 
0096 7118 0697  24         bl    *tmp3                 ; Call routine in slot
0097 711A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     711C 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 711E 058A  14 tmgr10  inc   r10                   ; Next slot
0102 7120 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     7122 8315 
     7124 8314 
0103 7126 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 7128 05C4  14         inct  tmp0                  ; Offset for next slot
0105 712A 10E8  14         jmp   tmgr9                 ; Process next slot
0106 712C 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 712E 10F7  14         jmp   tmgr10                ; Process next slot
0108 7130 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     7132 FF00 
0109 7134 10B4  14         jmp   tmgr1
0110 7136 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0209                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 7138 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     713A 603A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 713C 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     713E 63BC 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 7140 06A0  32         bl    @realkb               ; Scan full keyboard
     7142 64AC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 7144 0460  28         b     @tmgr3                ; Exit
     7146 70C2 
**** **** ****     > runlib.asm
0210                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 7148 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     714A 832E 
0018 714C E0A0  34         soc   @wbit7,config         ; Enable user hook
     714E 603C 
0019 7150 045B  20 mkhoo1  b     *r11                  ; Return
0020      709E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 7152 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     7154 832E 
0029 7156 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     7158 FEFF 
0030 715A 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0211               
0215               
0216               
0217               
0218               *//////////////////////////////////////////////////////////////
0219               *                    RUNLIB INITIALISATION
0220               *//////////////////////////////////////////////////////////////
0221               
0222               ***************************************************************
0223               *  RUNLIB - Runtime library initalisation
0224               ***************************************************************
0225               *  B  @RUNLIB
0226               *--------------------------------------------------------------
0227               *  REMARKS
0228               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0229               *  after clearing scratchpad memory.
0230               *  Use 'B @RUNLI1' to exit your program.
0231               ********@*****@*********************@**************************
0233 715C 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     715E 6944 
0234 7160 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7162 8302 
0238               *--------------------------------------------------------------
0239               * Alternative entry point
0240               *--------------------------------------------------------------
0241 7164 0300  24 runli1  limi  0                     ; Turn off interrupts
     7166 0000 
0242 7168 02E0  18         lwpi  ws1                   ; Activate workspace 1
     716A 8300 
0243 716C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     716E 83C0 
0244               *--------------------------------------------------------------
0245               * Clear scratch-pad memory from R4 upwards
0246               *--------------------------------------------------------------
0247 7170 0202  20 runli2  li    r2,>8308
     7172 8308 
0248 7174 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0249 7176 0282  22         ci    r2,>8400
     7178 8400 
0250 717A 16FC  14         jne   runli3
0251               *--------------------------------------------------------------
0252               * Exit to TI-99/4A title screen ?
0253               *--------------------------------------------------------------
0254 717C 0281  22         ci    r1,>ffff              ; Exit flag set ?
     717E FFFF 
0255 7180 1602  14         jne   runli4                ; No, continue
0256 7182 0420  54         blwp  @0                    ; Yes, bye bye
     7184 0000 
0257               *--------------------------------------------------------------
0258               * Determine if VDP is PAL or NTSC
0259               *--------------------------------------------------------------
0260 7186 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7188 833C 
0261 718A 04C1  14         clr   r1                    ; Reset counter
0262 718C 0202  20         li    r2,10                 ; We test 10 times
     718E 000A 
0263 7190 C0E0  34 runli5  mov   @vdps,r3
     7192 8802 
0264 7194 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7196 604A 
0265 7198 1302  14         jeq   runli6
0266 719A 0581  14         inc   r1                    ; Increase counter
0267 719C 10F9  14         jmp   runli5
0268 719E 0602  14 runli6  dec   r2                    ; Next test
0269 71A0 16F7  14         jne   runli5
0270 71A2 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     71A4 1250 
0271 71A6 1202  14         jle   runli7                ; No, so it must be NTSC
0272 71A8 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     71AA 6046 
0273               *--------------------------------------------------------------
0274               * Copy machine code to scratchpad (prepare tight loop)
0275               *--------------------------------------------------------------
0276 71AC 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     71AE 607C 
0277 71B0 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     71B2 8322 
0278 71B4 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0279 71B6 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0280 71B8 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0281               *--------------------------------------------------------------
0282               * Initialize registers, memory, ...
0283               *--------------------------------------------------------------
0284 71BA 04C1  14 runli9  clr   r1
0285 71BC 04C2  14         clr   r2
0286 71BE 04C3  14         clr   r3
0287 71C0 0209  20         li    stack,>8400           ; Set stack
     71C2 8400 
0288 71C4 020F  20         li    r15,vdpw              ; Set VDP write address
     71C6 8C00 
0292               *--------------------------------------------------------------
0293               * Setup video memory
0294               *--------------------------------------------------------------
0296 71C8 06A0  32         bl    @filv                 ; Clear most part of 16K VDP memory,
     71CA 60B6 
0297 71CC 0000             data  >0000,>00,>3fd8       ; Keep memory for 3 VDP disk buffers (>3fd8 - >3ff)
     71CE 0000 
     71D0 3FD8 
0302 71D2 06A0  32         bl    @filv
     71D4 60B6 
0303 71D6 0FC0             data  pctadr,spfclr,16      ; Load color table
     71D8 00C1 
     71DA 0010 
0304               *--------------------------------------------------------------
0305               * Check if there is a F18A present
0306               *--------------------------------------------------------------
0310 71DC 06A0  32         bl    @f18unl               ; Unlock the F18A
     71DE 632C 
0311 71E0 06A0  32         bl    @f18chk               ; Check if F18A is there
     71E2 6346 
0312 71E4 06A0  32         bl    @f18lck               ; Lock the F18A again
     71E6 633C 
0314               *--------------------------------------------------------------
0315               * Check if there is a speech synthesizer attached
0316               *--------------------------------------------------------------
0318               *       <<skipped>>
0322               *--------------------------------------------------------------
0323               * Load video mode table & font
0324               *--------------------------------------------------------------
0325 71E8 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     71EA 6110 
0326 71EC 6068             data  spvmod                ; Equate selected video mode table
0327 71EE 0204  20         li    tmp0,spfont           ; Get font option
     71F0 000C 
0328 71F2 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0329 71F4 1304  14         jeq   runlid                ; Yes, skip it
0330 71F6 06A0  32         bl    @ldfnt
     71F8 6178 
0331 71FA 1100             data  fntadr,spfont         ; Load specified font
     71FC 000C 
0332               *--------------------------------------------------------------
0333               * Branch to main program
0334               *--------------------------------------------------------------
0335 71FE 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7200 0040 
0336 7202 0460  28         b     @main                 ; Give control to main program
     7204 7206 
**** **** ****     > fio.asm.6396
0069               *--------------------------------------------------------------
0070               * SPECTRA2 startup options
0071               *--------------------------------------------------------------
0072      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0073      0001     spfbck  equ   >01                   ; Screen background color.
0074               ;--------------------------------------------------------------
0075               ; Video mode configuration
0076               ;--------------------------------------------------------------
0077      6068     spvmod  equ   tx8024                ; Video mode.   See VIDTAB for details.
0078      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0079      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0080      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0081               ;--------------------------------------------------------------
0082               ; VDP space for PAB and file buffer
0083               ;--------------------------------------------------------------
0084      01F0     pabadr1 equ   >01f0                 ; VDP PAB1
0085      0200     pabadr2 equ   >0200                 ; VDP PAB2
0086      0300     vrecbuf equ   >0300                 ; VDP Buffer
0087               
0088               ***************************************************************
0089               * Main
0090               ********@*****@*********************@**************************
0091 7206 06A0  32 main    bl    @putat
     7208 6248 
0092 720A 0000             data  >0000,msg
     720C 72AC 
0093               
0094 720E 06A0  32         bl    @putat
     7210 6248 
0095 7212 0100             data  >0100,fname
     7214 729B 
0096               
0097                       ;------------------------------------------------------
0098                       ; Prepare VDP for PAB and page out scratchpad
0099                       ;------------------------------------------------------
0100 7216 06A0  32         bl    @cpym2v
     7218 6250 
0101 721A 01F0             data  pabadr1,dsrsub,2      ; Copy PAB for DSR call files subprogram
     721C 7290 
     721E 0002 
0102               
0103 7220 06A0  32         bl    @cpym2v
     7222 6250 
0104 7224 0200             data  pabadr2,pab,25        ; Copy PAB to VDP
     7226 7292 
     7228 0019 
0105               
0106 722A 06A0  32         bl    @cpym2v
     722C 6250 
0107 722E 37D7             data  >37d7,schrott,6
     7230 72C2 
     7232 0006 
0108               
0109               
0110 7234 06A0  32         bl    @mem.scrpad.pgout     ; Page out scratchpad memory
     7236 6F48 
0111 7238 A000                   data  >a000           ; Memory destination @>a000
0112               
0113                       ;------------------------------------------------------
0114                       ; Set up file buffer - call files(1)
0115                       ;------------------------------------------------------
0116 723A 0200  20         li    r0,>0100
     723C 0100 
0117 723E D800  38         movb  r0,@>834c             ; Set number of disk files to 1
     7240 834C 
0118 7242 0200  20         li    r0,pabadr1
     7244 01F0 
0119 7246 C800  38         mov   r0,@>8356             ; Pass PAB to DSRLNK
     7248 8356 
0120 724A 0420  54         blwp  @dsrlnk               ; Call subprogram for "call files(1)"
     724C 6F6A 
0121 724E 000A             data  >a
0122 7250 131C  14         jeq   done1                 ; Exit on error
0123               
0124               
0125                       ;------------------------------------------------------
0126                       ; Open file
0127                       ;------------------------------------------------------
0128 7252 06A0  32         bl    @file.open
     7254 7080 
0129 7256 0200             data  pabadr2                ; Pass file descriptor to DSRLNK
0130               
0131               ;        li    r0,pabadr2+9
0132               ;        mov   r0,@>8356             ; Pass file descriptor to DSRLNK
0133               ;        blwp  @dsrlnk
0134               ;        data  8
0135               
0136                       ;------------------------------------------------------
0137                       ; Read record
0138                       ;------------------------------------------------------
0139               readfile
0140 7258 0200  20         li    r0,pabadr2+9
     725A 0209 
0141 725C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     725E 8356 
0142               
0143 7260 06A0  32         bl    @vputb
     7262 60F0 
0144 7264 0200             data  pabadr2,io.op.read
     7266 0002 
0145               
0146 7268 0420  54         blwp  @dsrlnk
     726A 6F6A 
0147 726C 0008             data  8
0148               
0149 726E 130F  14         jeq   file_error
0150 7270 10F3  14         jmp   readfile
0151               
0152                       ;------------------------------------------------------
0153                       ; Close file
0154                       ;------------------------------------------------------
0155               close_file
0156 7272 0200  20         li    r0,pabadr2+9
     7274 0209 
0157 7276 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7278 8356 
0158               
0159 727A 06A0  32         bl    @vputb
     727C 60F0 
0160 727E 0200             data  pabadr2,io.op.close
     7280 0001 
0161               
0162 7282 0420  54         blwp  @dsrlnk
     7284 6F6A 
0163 7286 0008             data  8
0164               
0165 7288 10FF  14 done0   jmp   $
0166 728A 10FF  14 done1   jmp   $
0167 728C 10FF  14 done2   jmp   $
0168               
0169               file_error
0170 728E 10F1  14         jmp   close_file
0171               
0172               
0173               
0174               
0175               
0176               
0177               
0178               
0179               
0180               ***************************************************************
0181               * DSR subprogram for call files
0182               ***************************************************************
0183                       even
0184 7290 0116     dsrsub  byte  >01,>16               ; DSR program/subprogram - set file buffers
0185               
0186               
0187               ***************************************************************
0188               * PAB for accessing file
0189               ********@*****@*********************@**************************
0190 7292 0014     pab     byte  io.op.open            ;  0    - OPEN
0191                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0192 7294 0300             data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0193 7296 5050             byte  80                    ;  4    - Record length (80 characters maximum)
0194                       byte  80                    ;  5    - Character count
0195 7298 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0196 729A 000F             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0197               fname   byte  15                    ;  9    - File descriptor length
0198 729C ....             text 'TIPI.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
0199                       even
0200               
0201               
0202               msg
0203 72AC 152A             byte  21
0204 72AD ....             text  '* File reading test *'
0205                       even
0206               
0207 72C2 00AA     schrott data  >00aa, >3fff, >1103
     72C4 3FFF 
     72C6 1103 
