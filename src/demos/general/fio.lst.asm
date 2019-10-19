XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > fio.asm.13122
0001               ***************************************************************
0002               *
0003               *                          File I/O test
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: fio.asm                     ; Version 191019-13122
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
0051 6012 714A             data  runlib
0053               
0054 6014 1546             byte  21
0055 6015 ....             text  'FIO TEST 191019-13122'
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
0082                       copy  "constants.asm"            ; Define constants
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Definition of constants used by runlib modules
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********@*****@*********************@**************************
0037 602A 8000     wbit0   data  >8000                 ; Binary 1000000000000000
0038 602C 4000     wbit1   data  >4000                 ; Binary 0100000000000000
0039 602E 2000     wbit2   data  >2000                 ; Binary 0010000000000000
0040 6030 1000     wbit3   data  >1000                 ; Binary 0001000000000000
0041 6032 0800     wbit4   data  >0800                 ; Binary 0000100000000000
0042 6034 0400     wbit5   data  >0400                 ; Binary 0000010000000000
0043 6036 0200     wbit6   data  >0200                 ; Binary 0000001000000000
0044 6038 0100     wbit7   data  >0100                 ; Binary 0000000100000000
0045 603A 0080     wbit8   data  >0080                 ; Binary 0000000010000000
0046 603C 0040     wbit9   data  >0040                 ; Binary 0000000001000000
0047 603E 0020     wbit10  data  >0020                 ; Binary 0000000000100000
0048 6040 0010     wbit11  data  >0010                 ; Binary 0000000000010000
0049 6042 0008     wbit12  data  >0008                 ; Binary 0000000000001000
0050 6044 0004     wbit13  data  >0004                 ; Binary 0000000000000100
0051 6046 0002     wbit14  data  >0002                 ; Binary 0000000000000010
0052 6048 0001     wbit15  data  >0001                 ; Binary 0000000000000001
0053 604A FFFF     whffff  data  >ffff                 ; Binary 1111111111111111
0054 604C 0001     bd0     byte  0                     ; Digit 0
0055               bd1     byte  1                     ; Digit 1
0056 604E 0203     bd2     byte  2                     ; Digit 2
0057               bd3     byte  3                     ; Digit 3
0058 6050 0405     bd4     byte  4                     ; Digit 4
0059               bd5     byte  5                     ; Digit 5
0060 6052 0607     bd6     byte  6                     ; Digit 6
0061               bd7     byte  7                     ; Digit 7
0062 6054 0809     bd8     byte  8                     ; Digit 8
0063               bd9     byte  9                     ; Digit 9
0064 6056 D000     bd208   byte  208                   ; Digit 208 (>D0)
0065                       even
**** **** ****     > runlib.asm
0083                       copy  "values.equ"               ; Equates for word/MSB/LSB-values
**** **** ****     > values.equ
0001               * FILE......: values.equ
0002               * Purpose...: Equates for word/MSB/LSB-values
0003               
0004               --------------------------------------------------------------
0005               * Word values
0006               *--------------------------------------------------------------
0007      6048     w$0001  equ   wbit15                ; >0001
0008      6046     w$0002  equ   wbit14                ; >0002
0009      6044     w$0004  equ   wbit13                ; >0004
0010      6042     w$0008  equ   wbit12                ; >0008
0011      6040     w$0010  equ   wbit11                ; >0010
0012      603E     w$0020  equ   wbit10                ; >0020
0013      603C     w$0040  equ   wbit9                 ; >0040
0014      603A     w$0080  equ   wbit8                 ; >0080
0015      6038     w$0100  equ   wbit7                 ; >0100
0016      6036     w$0200  equ   wbit6                 ; >0200
0017      6034     w$0400  equ   wbit5                 ; >0400
0018      6032     w$0800  equ   wbit4                 ; >0800
0019      6030     w$1000  equ   wbit3                 ; >1000
0020      602E     w$2000  equ   wbit2                 ; >2000
0021      602C     w$4000  equ   wbit1                 ; >4000
0022      602A     w$8000  equ   wbit0                 ; >8000
0023      604A     w$ffff  equ   whffff                ; >ffff
0024               *--------------------------------------------------------------
0025               * MSB values: >01 - >0f for byte operations AB, SB, CB, ...
0026               *--------------------------------------------------------------
0027      6038     hb$01   equ   wbit7                 ; >0100
0028      6036     hb$02   equ   wbit6                 ; >0200
0029      6034     hb$04   equ   wbit5                 ; >0400
0030      6032     hb$08   equ   wbit4                 ; >0800
0031      6030     hb$10   equ   wbit3                 ; >1000
0032      602E     hb$20   equ   wbit2                 ; >2000
0033      602C     hb$40   equ   wbit1                 ; >4000
0034      602A     hb$80   equ   wbit0                 ; >8000
0035               *--------------------------------------------------------------
0036               * LSB values: >01 - >0f for byte operations AB, SB, CB, ...
0037               *--------------------------------------------------------------
0038      6048     lb$01   equ   wbit15                ; >0001
0039      6046     lb$02   equ   wbit14                ; >0002
0040      6044     lb$04   equ   wbit13                ; >0004
0041      6042     lb$08   equ   wbit12                ; >0008
0042      6040     lb$10   equ   wbit11                ; >0010
0043      603E     lb$20   equ   wbit10                ; >0020
0044      603C     lb$40   equ   wbit9                 ; >0040
0045      603A     lb$80   equ   wbit8                 ; >0080
**** **** ****     > runlib.asm
0084                       copy  "config.equ"               ; Equates for bits in config register
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
0027      602E     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6038     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      603C     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      603E     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      6040     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0032               ***************************************************************
0033               
**** **** ****     > runlib.asm
0085                       copy  "cpu_crash_hndlr.asm"      ; CPU program crashed handler
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
0018 6058 0420  54 crash   blwp  @>0000                ; Soft-reset
     605A 0000 
**** **** ****     > runlib.asm
0086                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 605C 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     605E 000E 
     6060 0106 
     6062 0201 
     6064 0020 
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
0032 6066 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6068 000E 
     606A 0106 
     606C 00C1 
     606E 0028 
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
0058 6070 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6072 003F 
     6074 0240 
     6076 03C1 
     6078 0050 
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
0084 607A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     607C 003F 
     607E 0240 
     6080 03C1 
     6082 0050 
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
0087                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 6084 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6086 16FD             data  >16fd                 ; |         jne   mcloop
0015 6088 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 608A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 608C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 608E C0F9  30 popr3   mov   *stack+,r3
0039 6090 C0B9  30 popr2   mov   *stack+,r2
0040 6092 C079  30 popr1   mov   *stack+,r1
0041 6094 C039  30 popr0   mov   *stack+,r0
0042 6096 C2F9  30 poprt   mov   *stack+,r11
0043 6098 045B  20         b     *r11
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
0067 609A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 609C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 609E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 60A0 C1C6  18 xfilm   mov   tmp2,tmp3
0074 60A2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60A4 0001 
0075               
0076 60A6 1301  14         jeq   film1
0077 60A8 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60AA D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60AC 830B 
     60AE 830A 
0079 60B0 CD05  34 film2   mov   tmp1,*tmp0+
0080 60B2 0646  14         dect  tmp2
0081 60B4 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60B6 C1C7  18         mov   tmp3,tmp3
0086 60B8 1301  14         jeq   filmz
0087 60BA D505  30         movb  tmp1,*tmp0
0088 60BC 045B  20 filmz   b     *r11
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
0107 60BE C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60C0 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60C2 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60C4 0264  22 xfilv   ori   tmp0,>4000
     60C6 4000 
0114 60C8 06C4  14         swpb  tmp0
0115 60CA D804  38         movb  tmp0,@vdpa
     60CC 8C02 
0116 60CE 06C4  14         swpb  tmp0
0117 60D0 D804  38         movb  tmp0,@vdpa
     60D2 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60D4 020F  20         li    r15,vdpw              ; Set VDP write address
     60D6 8C00 
0122 60D8 06C5  14         swpb  tmp1
0123 60DA C820  54         mov   @filzz,@mcloop        ; Setup move command
     60DC 60E4 
     60DE 8320 
0124 60E0 0460  28         b     @mcloop               ; Write data to VDP
     60E2 8320 
0125               *--------------------------------------------------------------
0129 60E4 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60E6 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     60E8 4000 
0150 60EA 06C4  14 vdra    swpb  tmp0
0151 60EC D804  38         movb  tmp0,@vdpa
     60EE 8C02 
0152 60F0 06C4  14         swpb  tmp0
0153 60F2 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     60F4 8C02 
0154 60F6 045B  20         b     *r11
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
0165 60F8 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 60FA C17B  30         mov   *r11+,tmp1
0167 60FC C18B  18 xvputb  mov   r11,tmp2              ; Save R11
0168 60FE 06A0  32         bl    @vdwa                 ; Set VDP write address
     6100 60E6 
0169               
0170 6102 06C5  14         swpb  tmp1                  ; Get byte to write
0171 6104 D7C5  30         movb  tmp1,*r15             ; Write byte
0172 6106 0456  20         b     *tmp2                 ; Exit
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
0183 6108 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0184 610A C18B  18 xvgetb  mov   r11,tmp2              ; Save R11
0185 610C 06A0  32         bl    @vdra                 ; Set VDP read address
     610E 60EA 
0186               
0187 6110 D120  34         movb  @vdpr,tmp0            ; Read byte
     6112 8800 
0188               
0189 6114 0984  56         srl   tmp0,8                ; Right align
0190 6116 0456  20         b     *tmp2                 ; Exit
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
0209 6118 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0210 611A C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0211               *--------------------------------------------------------------
0212               * Calculate PNT base address
0213               *--------------------------------------------------------------
0214 611C C144  18         mov   tmp0,tmp1
0215 611E 05C5  14         inct  tmp1
0216 6120 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0217 6122 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6124 FF00 
0218 6126 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0219 6128 C805  38         mov   tmp1,@wbase           ; Store calculated base
     612A 8328 
0220               *--------------------------------------------------------------
0221               * Dump VDP shadow registers
0222               *--------------------------------------------------------------
0223 612C 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     612E 8000 
0224 6130 0206  20         li    tmp2,8
     6132 0008 
0225 6134 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6136 830B 
0226 6138 06C5  14         swpb  tmp1
0227 613A D805  38         movb  tmp1,@vdpa
     613C 8C02 
0228 613E 06C5  14         swpb  tmp1
0229 6140 D805  38         movb  tmp1,@vdpa
     6142 8C02 
0230 6144 0225  22         ai    tmp1,>0100
     6146 0100 
0231 6148 0606  14         dec   tmp2
0232 614A 16F4  14         jne   vidta1                ; Next register
0233 614C C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     614E 833A 
0234 6150 045B  20         b     *r11
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
0251 6152 C13B  30 putvr   mov   *r11+,tmp0
0252 6154 0264  22 putvrx  ori   tmp0,>8000
     6156 8000 
0253 6158 06C4  14         swpb  tmp0
0254 615A D804  38         movb  tmp0,@vdpa
     615C 8C02 
0255 615E 06C4  14         swpb  tmp0
0256 6160 D804  38         movb  tmp0,@vdpa
     6162 8C02 
0257 6164 045B  20         b     *r11
0258               
0259               
0260               ***************************************************************
0261               * PUTV01  - Put VDP registers #0 and #1
0262               ***************************************************************
0263               *  BL   @PUTV01
0264               ********@*****@*********************@**************************
0265 6166 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0266 6168 C10E  18         mov   r14,tmp0
0267 616A 0984  56         srl   tmp0,8
0268 616C 06A0  32         bl    @putvrx               ; Write VR#0
     616E 6154 
0269 6170 0204  20         li    tmp0,>0100
     6172 0100 
0270 6174 D820  54         movb  @r14lb,@tmp0lb
     6176 831D 
     6178 8309 
0271 617A 06A0  32         bl    @putvrx               ; Write VR#1
     617C 6154 
0272 617E 0458  20         b     *tmp4                 ; Exit
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
0286 6180 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0287 6182 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0288 6184 C11B  26         mov   *r11,tmp0             ; Get P0
0289 6186 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6188 7FFF 
0290 618A 2120  38         coc   @wbit0,tmp0
     618C 602A 
0291 618E 1604  14         jne   ldfnt1
0292 6190 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6192 8000 
0293 6194 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6196 7FFF 
0294               *--------------------------------------------------------------
0295               * Read font table address from GROM into tmp1
0296               *--------------------------------------------------------------
0297 6198 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     619A 6202 
0298 619C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     619E 9C02 
0299 61A0 06C4  14         swpb  tmp0
0300 61A2 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     61A4 9C02 
0301 61A6 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61A8 9800 
0302 61AA 06C5  14         swpb  tmp1
0303 61AC D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61AE 9800 
0304 61B0 06C5  14         swpb  tmp1
0305               *--------------------------------------------------------------
0306               * Setup GROM source address from tmp1
0307               *--------------------------------------------------------------
0308 61B2 D805  38         movb  tmp1,@grmwa
     61B4 9C02 
0309 61B6 06C5  14         swpb  tmp1
0310 61B8 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61BA 9C02 
0311               *--------------------------------------------------------------
0312               * Setup VDP target address
0313               *--------------------------------------------------------------
0314 61BC C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0315 61BE 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61C0 60E6 
0316 61C2 05C8  14         inct  tmp4                  ; R11=R11+2
0317 61C4 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0318 61C6 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61C8 7FFF 
0319 61CA C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61CC 6204 
0320 61CE C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61D0 6206 
0321               *--------------------------------------------------------------
0322               * Copy from GROM to VRAM
0323               *--------------------------------------------------------------
0324 61D2 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0325 61D4 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0326 61D6 D120  34         movb  @grmrd,tmp0
     61D8 9800 
0327               *--------------------------------------------------------------
0328               *   Make font fat
0329               *--------------------------------------------------------------
0330 61DA 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     61DC 602A 
0331 61DE 1603  14         jne   ldfnt3                ; No, so skip
0332 61E0 D1C4  18         movb  tmp0,tmp3
0333 61E2 0917  56         srl   tmp3,1
0334 61E4 E107  18         soc   tmp3,tmp0
0335               *--------------------------------------------------------------
0336               *   Dump byte to VDP and do housekeeping
0337               *--------------------------------------------------------------
0338 61E6 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     61E8 8C00 
0339 61EA 0606  14         dec   tmp2
0340 61EC 16F2  14         jne   ldfnt2
0341 61EE 05C8  14         inct  tmp4                  ; R11=R11+2
0342 61F0 020F  20         li    r15,vdpw              ; Set VDP write address
     61F2 8C00 
0343 61F4 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61F6 7FFF 
0344 61F8 0458  20         b     *tmp4                 ; Exit
0345 61FA D820  54 ldfnt4  movb  @bd0,@vdpw            ; Insert byte >00 into VRAM
     61FC 604C 
     61FE 8C00 
0346 6200 10E8  14         jmp   ldfnt2
0347               *--------------------------------------------------------------
0348               * Fonts pointer table
0349               *--------------------------------------------------------------
0350 6202 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6204 0200 
     6206 0000 
0351 6208 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     620A 01C0 
     620C 0101 
0352 620E 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6210 02A0 
     6212 0101 
0353 6214 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6216 00E0 
     6218 0101 
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
0371 621A C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0372 621C C3A0  34         mov   @wyx,r14              ; Get YX
     621E 832A 
0373 6220 098E  56         srl   r14,8                 ; Right justify (remove X)
0374 6222 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6224 833A 
0375               *--------------------------------------------------------------
0376               * Do rest of calculation with R15 (16 bit part is there)
0377               * Re-use R14
0378               *--------------------------------------------------------------
0379 6226 C3A0  34         mov   @wyx,r14              ; Get YX
     6228 832A 
0380 622A 024E  22         andi  r14,>00ff             ; Remove Y
     622C 00FF 
0381 622E A3CE  18         a     r14,r15               ; pos = pos + X
0382 6230 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6232 8328 
0383               *--------------------------------------------------------------
0384               * Clean up before exit
0385               *--------------------------------------------------------------
0386 6234 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0387 6236 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0388 6238 020F  20         li    r15,vdpw              ; VDP write address
     623A 8C00 
0389 623C 045B  20         b     *r11
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
0404 623E C17B  30 putstr  mov   *r11+,tmp1
0405 6240 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0406 6242 C1CB  18 xutstr  mov   r11,tmp3
0407 6244 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6246 621A 
0408 6248 C2C7  18         mov   tmp3,r11
0409 624A 0986  56         srl   tmp2,8                ; Right justify length byte
0410 624C 0460  28         b     @xpym2v               ; Display string
     624E 625E 
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
0425 6250 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6252 832A 
0426 6254 0460  28         b     @putstr
     6256 623E 
**** **** ****     > runlib.asm
0088               
0090                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 6258 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 625A C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 625C C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 625E 0264  22 xpym2v  ori   tmp0,>4000
     6260 4000 
0027 6262 06C4  14         swpb  tmp0
0028 6264 D804  38         movb  tmp0,@vdpa
     6266 8C02 
0029 6268 06C4  14         swpb  tmp0
0030 626A D804  38         movb  tmp0,@vdpa
     626C 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 626E 020F  20         li    r15,vdpw              ; Set VDP write address
     6270 8C00 
0035 6272 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6274 627C 
     6276 8320 
0036 6278 0460  28         b     @mcloop               ; Write data to VDP
     627A 8320 
0037 627C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0092               
0094                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 627E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6280 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6282 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6284 06C4  14 xpyv2m  swpb  tmp0
0027 6286 D804  38         movb  tmp0,@vdpa
     6288 8C02 
0028 628A 06C4  14         swpb  tmp0
0029 628C D804  38         movb  tmp0,@vdpa
     628E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6290 020F  20         li    r15,vdpr              ; Set VDP read address
     6292 8800 
0034 6294 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6296 629E 
     6298 8320 
0035 629A 0460  28         b     @mcloop               ; Read data from VDP
     629C 8320 
0036 629E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0096               
0098                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 62A0 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 62A2 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 62A4 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 62A6 C186  18 xpym2m  mov    tmp2,tmp2            ; Bytes to copy = 0 ?
0031 62A8 1602  14         jne    cpym0
0032 62AA 0460  28         b      @crash               ; Yes, crash
     62AC 6058 
0033 62AE 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62B0 7FFF 
0034 62B2 C1C4  18         mov   tmp0,tmp3
0035 62B4 0247  22         andi  tmp3,1
     62B6 0001 
0036 62B8 1618  14         jne   cpyodd                ; Odd source address handling
0037 62BA C1C5  18 cpym1   mov   tmp1,tmp3
0038 62BC 0247  22         andi  tmp3,1
     62BE 0001 
0039 62C0 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62C2 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62C4 602A 
0044 62C6 1605  14         jne   cpym3
0045 62C8 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62CA 62F0 
     62CC 8320 
0046 62CE 0460  28         b     @mcloop               ; Copy memory and exit
     62D0 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62D2 C1C6  18 cpym3   mov   tmp2,tmp3
0051 62D4 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62D6 0001 
0052 62D8 1301  14         jeq   cpym4
0053 62DA 0606  14         dec   tmp2                  ; Make TMP2 even
0054 62DC CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 62DE 0646  14         dect  tmp2
0056 62E0 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 62E2 C1C7  18         mov   tmp3,tmp3
0061 62E4 1301  14         jeq   cpymz
0062 62E6 D554  38         movb  *tmp0,*tmp1
0063 62E8 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 62EA 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     62EC 8000 
0068 62EE 10E9  14         jmp   cpym2
0069 62F0 DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0100               
0104               
0108               
0112               
0114                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********@*****@*********************@**************************
0009 62F2 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     62F4 FFBF 
0010 62F6 0460  28         b     @putv01
     62F8 6166 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 62FA 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     62FC 0040 
0018 62FE 0460  28         b     @putv01
     6300 6166 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 6302 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6304 FFDF 
0026 6306 0460  28         b     @putv01
     6308 6166 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 630A 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     630C 0020 
0034 630E 0460  28         b     @putv01
     6310 6166 
**** **** ****     > runlib.asm
0116               
0120               
0122                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 6312 C83B  50 at      mov   *r11+,@wyx
     6314 832A 
0019 6316 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6318 B820  54 down    ab    @hb$01,@wyx
     631A 6038 
     631C 832A 
0028 631E 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 6320 7820  54 up      sb    @hb$01,@wyx
     6322 6038 
     6324 832A 
0037 6326 045B  20         b     *r11
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
0049 6328 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 632A D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     632C 832A 
0051 632E C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6330 832A 
0052 6332 045B  20         b     *r11
**** **** ****     > runlib.asm
0124               
0128               
0132               
0136               
0138                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0013 6334 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6336 06A0  32         bl    @putvr                ; Write once
     6338 6152 
0015 633A 391C             data  >391c                 ; VR1/57, value 00011100
0016 633C 06A0  32         bl    @putvr                ; Write twice
     633E 6152 
0017 6340 391C             data  >391c                 ; VR1/57, value 00011100
0018 6342 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 6344 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6346 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6348 6152 
0028 634A 391C             data  >391c
0029 634C 0458  20         b     *tmp4                 ; Exit
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
0040 634E C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6350 06A0  32         bl    @cpym2v
     6352 6258 
0042 6354 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6356 6392 
     6358 0006 
0043 635A 06A0  32         bl    @putvr
     635C 6152 
0044 635E 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6360 06A0  32         bl    @putvr
     6362 6152 
0046 6364 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 6366 0204  20         li    tmp0,>3f00
     6368 3F00 
0052 636A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     636C 60EA 
0053 636E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6370 8800 
0054 6372 0984  56         srl   tmp0,8
0055 6374 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6376 8800 
0056 6378 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 637A 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 637C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     637E BFFF 
0060 6380 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6382 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6384 4000 
0063               f18chk_exit:
0064 6386 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6388 60BE 
0065 638A 3F00             data  >3f00,>00,6
     638C 0000 
     638E 0006 
0066 6390 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 6392 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6394 3F00             data  >3f00                 ; 3f02 / 3f00
0073 6396 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6398 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 639A 06A0  32         bl    @putvr
     639C 6152 
0097 639E 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 63A0 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63A2 6152 
0100 63A4 391C             data  >391c                 ; Lock the F18a
0101 63A6 0458  20         b     *tmp4                 ; Exit
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
0120 63A8 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 63AA 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     63AC 602C 
0122 63AE 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 63B0 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     63B2 8802 
0127 63B4 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     63B6 6152 
0128 63B8 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 63BA 04C4  14         clr   tmp0
0130 63BC D120  34         movb  @vdps,tmp0
     63BE 8802 
0131 63C0 0984  56         srl   tmp0,8
0132 63C2 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0140               
0144               
0148               
0152               
0156               
0160               
0164               
0168               
0170                       copy  "keyb_virtual.asm"         ; Virtual keyboard scanning
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
0088 63C4 40A0  34         szc   @wbit11,config        ; Reset ANY key
     63C6 6040 
0089 63C8 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 63CA 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 63CC 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 63CE 0207  20         li    tmp3,kbmap0           ; Start with column 0
     63D0 6440 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 63D2 04CC  14         clr   r12
0097 63D4 1E15  20         sbz   >0015                 ; Set P5
0098 63D6 1F07  20         tb    7
0099 63D8 1302  14         jeq   virtk1
0100 63DA 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     63DC 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 63DE 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 63E0 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     63E2 0024 
0107 63E4 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 63E6 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     63E8 0006 
0109 63EA 0705  14         seto  tmp1                  ; >FFFF
0110 63EC 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 63EE 0545  14         inv   tmp1
0112 63F0 1302  14         jeq   virtk2                ; >0000 ?
0113 63F2 E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     63F4 6040 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 63F6 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 63F8 1601  14         jne   virtk3
0119 63FA E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 63FC 05C7  14 virtk3  inct  tmp3
0121 63FE 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     6400 644C 
0122 6402 16F9  14         jne   virtk2                ; No, next entry
0123 6404 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 6406 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     6408 0700 
0128 640A 1309  14         jeq   virtk6                ; Yes, exit
0129 640C 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     640E 0200 
0130 6410 1303  14         jeq   virtk5                ; Yes, skip
0131 6412 0224  22         ai    tmp0,>0100
     6414 0100 
0132 6416 10E3  14         jmp   virtk1
0133 6418 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     641A 0500 
0134 641C 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 641E C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 6420 C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     6422 8332 
0140 6424 1601  14         jne   virtk7
0141 6426 045B  20         b     *r11                  ; Exit
0142 6428 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     642A FFFF 
0143 642C 1603  14         jne   virtk8                ; No
0144 642E 0701  14         seto  r1                    ; Set exit flag
0145 6430 0460  28         b     @runli1               ; Yes, reset computer
     6432 7152 
0146 6434 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     6436 8000 
0147 6438 1602  14         jne   virtk9
0148 643A 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     643C 6040 
0149 643E 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 6440 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     6442 FFFF 
0155 6444 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     6446 0020 
0156 6448 0400             data  >0400,kenter          ; >04 00000100  enter
     644A 4000 
0157 644C FFFF     kbeoc   data  >ffff
0158               
0159 644E 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     6450 1000 
0160 6452 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     6454 0008 
0161 6456 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6458 0004 
0162 645A 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     645C 0200 
0163 645E 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     6460 0040 
0164 6462 FFFF             data  >ffff
0165               
0166 6464 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     6466 2000 
0167 6468 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     646A 0002 
0168 646C 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     646E 0100 
0169 6470 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     6472 0080 
0170 6474 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     6476 0010 
0171 6478 FFFF             data  >ffff
0172               
0173 647A 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     647C 0001 
0174 647E 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     6480 0800 
0175 6482 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     6484 0020 
0176 6486 FFFF             data  >ffff
0177               
0178 6488 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     648A 0020 
0179 648C 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     648E 0200 
0180 6490 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     6492 0100 
0181 6494 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     6496 0040 
0182 6498 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     649A 0080 
0183 649C FFFF             data  >ffff
0184               
0185 649E 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     64A0 0001 
0186 64A2 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     64A4 0010 
0187 64A6 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     64A8 0008 
0188 64AA 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     64AC 0002 
0189 64AE 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     64B0 0004 
0190 64B2 FFFF             data  >ffff
**** **** ****     > runlib.asm
0172               
0174                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 64B4 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64B6 602A 
0017 64B8 020C  20         li    r12,>0024
     64BA 0024 
0018 64BC 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64BE 654C 
0019 64C0 04C6  14         clr   tmp2
0020 64C2 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64C4 04CC  14         clr   r12
0025 64C6 1F08  20         tb    >0008                 ; Shift-key ?
0026 64C8 1302  14         jeq   realk1                ; No
0027 64CA 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64CC 657C 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64CE 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64D0 1302  14         jeq   realk2                ; No
0033 64D2 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64D4 65AC 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64D6 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64D8 1302  14         jeq   realk3                ; No
0039 64DA 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64DC 65DC 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64DE 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64E0 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64E2 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 64E4 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     64E6 602A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 64E8 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 64EA 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64EC 0006 
0052 64EE 0606  14 realk5  dec   tmp2
0053 64F0 020C  20         li    r12,>24               ; CRU address for P2-P4
     64F2 0024 
0054 64F4 06C6  14         swpb  tmp2
0055 64F6 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64F8 06C6  14         swpb  tmp2
0057 64FA 020C  20         li    r12,6                 ; CRU read address
     64FC 0006 
0058 64FE 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6500 0547  14         inv   tmp3                  ;
0060 6502 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6504 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6506 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6508 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 650A 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 650C 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 650E 0285  22         ci    tmp1,8
     6510 0008 
0069 6512 1AFA  14         jl    realk6
0070 6514 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6516 1BEB  14         jh    realk5                ; No, next column
0072 6518 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 651A C206  18 realk8  mov   tmp2,tmp4
0077 651C 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 651E A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6520 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6522 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6524 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6526 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6528 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     652A 602A 
0087 652C 1608  14         jne   realka                ; No, continue saving key
0088 652E 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6530 6576 
0089 6532 1A05  14         jl    realka
0090 6534 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6536 6574 
0091 6538 1B02  14         jh    realka                ; No, continue
0092 653A 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     653C E000 
0093 653E C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6540 833C 
0094 6542 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6544 6040 
0095 6546 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6548 8C00 
0096 654A 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 654C FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     654E 0000 
     6550 FF0D 
     6552 203D 
0099 6554 ....             text  'xws29ol.'
0100 655C ....             text  'ced38ik,'
0101 6564 ....             text  'vrf47ujm'
0102 656C ....             text  'btg56yhn'
0103 6574 ....             text  'zqa10p;/'
0104 657C FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     657E 0000 
     6580 FF0D 
     6582 202B 
0105 6584 ....             text  'XWS@(OL>'
0106 658C ....             text  'CED#*IK<'
0107 6594 ....             text  'VRF$&UJM'
0108 659C ....             text  'BTG%^YHN'
0109 65A4 ....             text  'ZQA!)P:-'
0110 65AC FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65AE 0000 
     65B0 FF0D 
     65B2 2005 
0111 65B4 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65B6 0804 
     65B8 0F27 
     65BA C2B9 
0112 65BC 600B             data  >600b,>0907,>063f,>c1B8
     65BE 0907 
     65C0 063F 
     65C2 C1B8 
0113 65C4 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65C6 7B02 
     65C8 015F 
     65CA C0C3 
0114 65CC BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65CE 7D0E 
     65D0 0CC6 
     65D2 BFC4 
0115 65D4 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65D6 7C03 
     65D8 BC22 
     65DA BDBA 
0116 65DC FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65DE 0000 
     65E0 FF0D 
     65E2 209D 
0117 65E4 9897             data  >9897,>93b2,>9f8f,>8c9B
     65E6 93B2 
     65E8 9F8F 
     65EA 8C9B 
0118 65EC 8385             data  >8385,>84b3,>9e89,>8b80
     65EE 84B3 
     65F0 9E89 
     65F2 8B80 
0119 65F4 9692             data  >9692,>86b4,>b795,>8a8D
     65F6 86B4 
     65F8 B795 
     65FA 8A8D 
0120 65FC 8294             data  >8294,>87b5,>b698,>888E
     65FE 87B5 
     6600 B698 
     6602 888E 
0121 6604 9A91             data  >9a91,>81b1,>b090,>9cBB
     6606 81B1 
     6608 B090 
     660A 9CBB 
**** **** ****     > runlib.asm
0176               
0178                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0016 660C C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 660E C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     6610 8340 
0018 6612 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     6614 833C 
0019 6616 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 6618 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 661A 0647  14         dect  tmp3                  ; Back to WAUX1
0022 661C C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 661E 0205  20         li    tmp1,4
     6620 0004 
0027 6622 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 6624 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6626 000F 
0029 6628 A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 662A 06C6  14 mkhex2  swpb  tmp2
0031 662C DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 662E 0944  56         srl   tmp0,4                ; Next nibble
0033 6630 0605  14         dec   tmp1
0034 6632 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 6634 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6636 BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 6638 C160  34         mov   @waux3,tmp1           ; Get pointer
     663A 8340 
0040 663C 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 663E 0585  14         inc   tmp1                  ; Next byte, not word!
0042 6640 C120  34         mov   @waux2,tmp0
     6642 833E 
0043 6644 06C4  14         swpb  tmp0
0044 6646 DD44  32         movb  tmp0,*tmp1+
0045 6648 06C4  14         swpb  tmp0
0046 664A DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 664C C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     664E 8340 
0051 6650 D520  46         movb  @bd4,*tmp0            ; Set lengh byte to 4
     6652 6050 
0052 6654 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 6656 C120  34         mov   @waux1,tmp0
     6658 833C 
0057 665A 06C4  14         swpb  tmp0
0058 665C DD44  32         movb  tmp0,*tmp1+
0059 665E 06C4  14         swpb  tmp0
0060 6660 DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 6662 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6664 602A 
0065 6666 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 6668 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 666A 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     666C 7FFF 
0071 666E C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6670 8340 
0072 6672 0460  28         b     @xutst0               ; Display string
     6674 6240 
0073 6676 0610     prefix  data  >0610                 ; Length byte + blank
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
0087 6678 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     667A 832A 
0088 667C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     667E 8000 
0089 6680 10C5  14         jmp   mkhex                 ; Convert number and display
0090               
**** **** ****     > runlib.asm
0180               
0182                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 6682 0207  20 mknum   li    tmp3,5                ; Digit counter
     6684 0005 
0020 6686 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6688 C155  26         mov   *tmp1,tmp1            ; /
0022 668A C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 668C 0228  22         ai    tmp4,4                ; Get end of buffer
     668E 0004 
0024 6690 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6692 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6694 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6696 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6698 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 669A B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 669C D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 669E C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 66A0 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 66A2 0607  14         dec   tmp3                  ; Decrease counter
0036 66A4 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 66A6 0207  20         li    tmp3,4                ; Check first 4 digits
     66A8 0004 
0041 66AA 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 66AC C11B  26         mov   *r11,tmp0
0043 66AE 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 66B0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 66B2 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 66B4 05CB  14 mknum3  inct  r11
0047 66B6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     66B8 602A 
0048 66BA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 66BC 045B  20         b     *r11                  ; Exit
0050 66BE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 66C0 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 66C2 13F8  14         jeq   mknum3                ; Yes, exit
0053 66C4 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 66C6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     66C8 7FFF 
0058 66CA C10B  18         mov   r11,tmp0
0059 66CC 0224  22         ai    tmp0,-4
     66CE FFFC 
0060 66D0 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 66D2 0206  20         li    tmp2,>0500            ; String length = 5
     66D4 0500 
0062 66D6 0460  28         b     @xutstr               ; Display string
     66D8 6242 
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
0092 66DA C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 66DC C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 66DE C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 66E0 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 66E2 0207  20         li    tmp3,5                ; Set counter
     66E4 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 66E6 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 66E8 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 66EA 0584  14         inc   tmp0                  ; Next character
0104 66EC 0607  14         dec   tmp3                  ; Last digit reached ?
0105 66EE 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 66F0 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 66F2 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 66F4 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 66F6 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 66F8 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 66FA 0607  14         dec   tmp3                  ; Last character ?
0120 66FC 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 66FE 045B  20         b     *r11                  ; Return
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
0138 6700 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6702 832A 
0139 6704 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6706 8000 
0140 6708 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0184               
0186                        copy  "cpu_crc16.asm"           ; CRC-16 checksum calculation
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
0030 670A C13B  30         mov   *r11+,wmemory         ; First memory address
0031 670C C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx
0033 670E 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 6710 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * Next word
0037               *--------------------------------------------------------------
0038               calc_crc1
0039 6712 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2
0044 6714 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 6716 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 6718 C1C8  18         mov   wcrc,tmp3
0048 671A 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 671C 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 671E 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6720 00FF 
0052               
0053 6722 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 6724 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 6726 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6728 674C 
0056               *--------------------------------------------------------------
0057               * Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3
0060 672A C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 672C 0246  22         andi  tmp2,>00ff            ; Clear MSB
     672E 00FF 
0062               
0063 6730 C1C8  18         mov   wcrc,tmp3
0064 6732 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 6734 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 6736 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6738 00FF 
0068               
0069 673A 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 673C 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 673E 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6740 674C 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 6742 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 6744 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 6746 04C7  14         clr   tmp3
0081 6748 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082 674A 045B  20         b     *r11                  ; Return
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
0095 674C 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     674E 1021 
     6750 2042 
     6752 3063 
     6754 4084 
     6756 50A5 
     6758 60C6 
     675A 70E7 
0096 675C 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     675E 9129 
     6760 A14A 
     6762 B16B 
     6764 C18C 
     6766 D1AD 
     6768 E1CE 
     676A F1EF 
0097 676C 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     676E 0210 
     6770 3273 
     6772 2252 
     6774 52B5 
     6776 4294 
     6778 72F7 
     677A 62D6 
0098 677C 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     677E 8318 
     6780 B37B 
     6782 A35A 
     6784 D3BD 
     6786 C39C 
     6788 F3FF 
     678A E3DE 
0099 678C 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     678E 3443 
     6790 0420 
     6792 1401 
     6794 64E6 
     6796 74C7 
     6798 44A4 
     679A 5485 
0100 679C A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     679E B54B 
     67A0 8528 
     67A2 9509 
     67A4 E5EE 
     67A6 F5CF 
     67A8 C5AC 
     67AA D58D 
0101 67AC 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     67AE 2672 
     67B0 1611 
     67B2 0630 
     67B4 76D7 
     67B6 66F6 
     67B8 5695 
     67BA 46B4 
0102 67BC B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     67BE A77A 
     67C0 9719 
     67C2 8738 
     67C4 F7DF 
     67C6 E7FE 
     67C8 D79D 
     67CA C7BC 
0103 67CC 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     67CE 58E5 
     67D0 6886 
     67D2 78A7 
     67D4 0840 
     67D6 1861 
     67D8 2802 
     67DA 3823 
0104 67DC C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     67DE D9ED 
     67E0 E98E 
     67E2 F9AF 
     67E4 8948 
     67E6 9969 
     67E8 A90A 
     67EA B92B 
0105 67EC 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     67EE 4AD4 
     67F0 7AB7 
     67F2 6A96 
     67F4 1A71 
     67F6 0A50 
     67F8 3A33 
     67FA 2A12 
0106 67FC DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     67FE CBDC 
     6800 FBBF 
     6802 EB9E 
     6804 9B79 
     6806 8B58 
     6808 BB3B 
     680A AB1A 
0107 680C 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     680E 7C87 
     6810 4CE4 
     6812 5CC5 
     6814 2C22 
     6816 3C03 
     6818 0C60 
     681A 1C41 
0108 681C EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     681E FD8F 
     6820 CDEC 
     6822 DDCD 
     6824 AD2A 
     6826 BD0B 
     6828 8D68 
     682A 9D49 
0109 682C 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     682E 6EB6 
     6830 5ED5 
     6832 4EF4 
     6834 3E13 
     6836 2E32 
     6838 1E51 
     683A 0E70 
0110 683C FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     683E EFBE 
     6840 DFDD 
     6842 CFFC 
     6844 BF1B 
     6846 AF3A 
     6848 9F59 
     684A 8F78 
0111 684C 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     684E 81A9 
     6850 B1CA 
     6852 A1EB 
     6854 D10C 
     6856 C12D 
     6858 F14E 
     685A E16F 
0112 685C 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     685E 00A1 
     6860 30C2 
     6862 20E3 
     6864 5004 
     6866 4025 
     6868 7046 
     686A 6067 
0113 686C 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     686E 9398 
     6870 A3FB 
     6872 B3DA 
     6874 C33D 
     6876 D31C 
     6878 E37F 
     687A F35E 
0114 687C 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     687E 1290 
     6880 22F3 
     6882 32D2 
     6884 4235 
     6886 5214 
     6888 6277 
     688A 7256 
0115 688C B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     688E A5CB 
     6890 95A8 
     6892 8589 
     6894 F56E 
     6896 E54F 
     6898 D52C 
     689A C50D 
0116 689C 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     689E 24C3 
     68A0 14A0 
     68A2 0481 
     68A4 7466 
     68A6 6447 
     68A8 5424 
     68AA 4405 
0117 68AC A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     68AE B7FA 
     68B0 8799 
     68B2 97B8 
     68B4 E75F 
     68B6 F77E 
     68B8 C71D 
     68BA D73C 
0118 68BC 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     68BE 36F2 
     68C0 0691 
     68C2 16B0 
     68C4 6657 
     68C6 7676 
     68C8 4615 
     68CA 5634 
0119 68CC D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     68CE C96D 
     68D0 F90E 
     68D2 E92F 
     68D4 99C8 
     68D6 89E9 
     68D8 B98A 
     68DA A9AB 
0120 68DC 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     68DE 4865 
     68E0 7806 
     68E2 6827 
     68E4 18C0 
     68E6 08E1 
     68E8 3882 
     68EA 28A3 
0121 68EC CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     68EE DB5C 
     68F0 EB3F 
     68F2 FB1E 
     68F4 8BF9 
     68F6 9BD8 
     68F8 ABBB 
     68FA BB9A 
0122 68FC 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     68FE 5A54 
     6900 6A37 
     6902 7A16 
     6904 0AF1 
     6906 1AD0 
     6908 2AB3 
     690A 3A92 
0123 690C FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     690E ED0F 
     6910 DD6C 
     6912 CD4D 
     6914 BDAA 
     6916 AD8B 
     6918 9DE8 
     691A 8DC9 
0124 691C 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     691E 6C07 
     6920 5C64 
     6922 4C45 
     6924 3CA2 
     6926 2C83 
     6928 1CE0 
     692A 0CC1 
0125 692C EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     692E FF3E 
     6930 CF5D 
     6932 DF7C 
     6934 AF9B 
     6936 BFBA 
     6938 8FD9 
     693A 9FF8 
0126 693C 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     693E 7E36 
     6940 4E55 
     6942 5E74 
     6944 2E93 
     6946 3EB2 
     6948 0ED1 
     694A 1EF0 
**** **** ****     > runlib.asm
0188               
0192               
0194                       copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0021 694C C820  54         mov   @>8300,@>2000
     694E 8300 
     6950 2000 
0022 6952 C820  54         mov   @>8302,@>2002
     6954 8302 
     6956 2002 
0023 6958 C820  54         mov   @>8304,@>2004
     695A 8304 
     695C 2004 
0024 695E C820  54         mov   @>8306,@>2006
     6960 8306 
     6962 2006 
0025 6964 C820  54         mov   @>8308,@>2008
     6966 8308 
     6968 2008 
0026 696A C820  54         mov   @>830A,@>200A
     696C 830A 
     696E 200A 
0027 6970 C820  54         mov   @>830C,@>200C
     6972 830C 
     6974 200C 
0028 6976 C820  54         mov   @>830E,@>200E
     6978 830E 
     697A 200E 
0029 697C C820  54         mov   @>8310,@>2010
     697E 8310 
     6980 2010 
0030 6982 C820  54         mov   @>8312,@>2012
     6984 8312 
     6986 2012 
0031 6988 C820  54         mov   @>8314,@>2014
     698A 8314 
     698C 2014 
0032 698E C820  54         mov   @>8316,@>2016
     6990 8316 
     6992 2016 
0033 6994 C820  54         mov   @>8318,@>2018
     6996 8318 
     6998 2018 
0034 699A C820  54         mov   @>831A,@>201A
     699C 831A 
     699E 201A 
0035 69A0 C820  54         mov   @>831C,@>201C
     69A2 831C 
     69A4 201C 
0036 69A6 C820  54         mov   @>831E,@>201E
     69A8 831E 
     69AA 201E 
0037 69AC C820  54         mov   @>8320,@>2020
     69AE 8320 
     69B0 2020 
0038 69B2 C820  54         mov   @>8322,@>2022
     69B4 8322 
     69B6 2022 
0039 69B8 C820  54         mov   @>8324,@>2024
     69BA 8324 
     69BC 2024 
0040 69BE C820  54         mov   @>8326,@>2026
     69C0 8326 
     69C2 2026 
0041 69C4 C820  54         mov   @>8328,@>2028
     69C6 8328 
     69C8 2028 
0042 69CA C820  54         mov   @>832A,@>202A
     69CC 832A 
     69CE 202A 
0043 69D0 C820  54         mov   @>832C,@>202C
     69D2 832C 
     69D4 202C 
0044 69D6 C820  54         mov   @>832E,@>202E
     69D8 832E 
     69DA 202E 
0045 69DC C820  54         mov   @>8330,@>2030
     69DE 8330 
     69E0 2030 
0046 69E2 C820  54         mov   @>8332,@>2032
     69E4 8332 
     69E6 2032 
0047 69E8 C820  54         mov   @>8334,@>2034
     69EA 8334 
     69EC 2034 
0048 69EE C820  54         mov   @>8336,@>2036
     69F0 8336 
     69F2 2036 
0049 69F4 C820  54         mov   @>8338,@>2038
     69F6 8338 
     69F8 2038 
0050 69FA C820  54         mov   @>833A,@>203A
     69FC 833A 
     69FE 203A 
0051 6A00 C820  54         mov   @>833C,@>203C
     6A02 833C 
     6A04 203C 
0052 6A06 C820  54         mov   @>833E,@>203E
     6A08 833E 
     6A0A 203E 
0053 6A0C C820  54         mov   @>8340,@>2040
     6A0E 8340 
     6A10 2040 
0054 6A12 C820  54         mov   @>8342,@>2042
     6A14 8342 
     6A16 2042 
0055 6A18 C820  54         mov   @>8344,@>2044
     6A1A 8344 
     6A1C 2044 
0056 6A1E C820  54         mov   @>8346,@>2046
     6A20 8346 
     6A22 2046 
0057 6A24 C820  54         mov   @>8348,@>2048
     6A26 8348 
     6A28 2048 
0058 6A2A C820  54         mov   @>834A,@>204A
     6A2C 834A 
     6A2E 204A 
0059 6A30 C820  54         mov   @>834C,@>204C
     6A32 834C 
     6A34 204C 
0060 6A36 C820  54         mov   @>834E,@>204E
     6A38 834E 
     6A3A 204E 
0061 6A3C C820  54         mov   @>8350,@>2050
     6A3E 8350 
     6A40 2050 
0062 6A42 C820  54         mov   @>8352,@>2052
     6A44 8352 
     6A46 2052 
0063 6A48 C820  54         mov   @>8354,@>2054
     6A4A 8354 
     6A4C 2054 
0064 6A4E C820  54         mov   @>8356,@>2056
     6A50 8356 
     6A52 2056 
0065 6A54 C820  54         mov   @>8358,@>2058
     6A56 8358 
     6A58 2058 
0066 6A5A C820  54         mov   @>835A,@>205A
     6A5C 835A 
     6A5E 205A 
0067 6A60 C820  54         mov   @>835C,@>205C
     6A62 835C 
     6A64 205C 
0068 6A66 C820  54         mov   @>835E,@>205E
     6A68 835E 
     6A6A 205E 
0069 6A6C C820  54         mov   @>8360,@>2060
     6A6E 8360 
     6A70 2060 
0070 6A72 C820  54         mov   @>8362,@>2062
     6A74 8362 
     6A76 2062 
0071 6A78 C820  54         mov   @>8364,@>2064
     6A7A 8364 
     6A7C 2064 
0072 6A7E C820  54         mov   @>8366,@>2066
     6A80 8366 
     6A82 2066 
0073 6A84 C820  54         mov   @>8368,@>2068
     6A86 8368 
     6A88 2068 
0074 6A8A C820  54         mov   @>836A,@>206A
     6A8C 836A 
     6A8E 206A 
0075 6A90 C820  54         mov   @>836C,@>206C
     6A92 836C 
     6A94 206C 
0076 6A96 C820  54         mov   @>836E,@>206E
     6A98 836E 
     6A9A 206E 
0077 6A9C C820  54         mov   @>8370,@>2070
     6A9E 8370 
     6AA0 2070 
0078 6AA2 C820  54         mov   @>8372,@>2072
     6AA4 8372 
     6AA6 2072 
0079 6AA8 C820  54         mov   @>8374,@>2074
     6AAA 8374 
     6AAC 2074 
0080 6AAE C820  54         mov   @>8376,@>2076
     6AB0 8376 
     6AB2 2076 
0081 6AB4 C820  54         mov   @>8378,@>2078
     6AB6 8378 
     6AB8 2078 
0082 6ABA C820  54         mov   @>837A,@>207A
     6ABC 837A 
     6ABE 207A 
0083 6AC0 C820  54         mov   @>837C,@>207C
     6AC2 837C 
     6AC4 207C 
0084 6AC6 C820  54         mov   @>837E,@>207E
     6AC8 837E 
     6ACA 207E 
0085 6ACC C820  54         mov   @>8380,@>2080
     6ACE 8380 
     6AD0 2080 
0086 6AD2 C820  54         mov   @>8382,@>2082
     6AD4 8382 
     6AD6 2082 
0087 6AD8 C820  54         mov   @>8384,@>2084
     6ADA 8384 
     6ADC 2084 
0088 6ADE C820  54         mov   @>8386,@>2086
     6AE0 8386 
     6AE2 2086 
0089 6AE4 C820  54         mov   @>8388,@>2088
     6AE6 8388 
     6AE8 2088 
0090 6AEA C820  54         mov   @>838A,@>208A
     6AEC 838A 
     6AEE 208A 
0091 6AF0 C820  54         mov   @>838C,@>208C
     6AF2 838C 
     6AF4 208C 
0092 6AF6 C820  54         mov   @>838E,@>208E
     6AF8 838E 
     6AFA 208E 
0093 6AFC C820  54         mov   @>8390,@>2090
     6AFE 8390 
     6B00 2090 
0094 6B02 C820  54         mov   @>8392,@>2092
     6B04 8392 
     6B06 2092 
0095 6B08 C820  54         mov   @>8394,@>2094
     6B0A 8394 
     6B0C 2094 
0096 6B0E C820  54         mov   @>8396,@>2096
     6B10 8396 
     6B12 2096 
0097 6B14 C820  54         mov   @>8398,@>2098
     6B16 8398 
     6B18 2098 
0098 6B1A C820  54         mov   @>839A,@>209A
     6B1C 839A 
     6B1E 209A 
0099 6B20 C820  54         mov   @>839C,@>209C
     6B22 839C 
     6B24 209C 
0100 6B26 C820  54         mov   @>839E,@>209E
     6B28 839E 
     6B2A 209E 
0101 6B2C C820  54         mov   @>83A0,@>20A0
     6B2E 83A0 
     6B30 20A0 
0102 6B32 C820  54         mov   @>83A2,@>20A2
     6B34 83A2 
     6B36 20A2 
0103 6B38 C820  54         mov   @>83A4,@>20A4
     6B3A 83A4 
     6B3C 20A4 
0104 6B3E C820  54         mov   @>83A6,@>20A6
     6B40 83A6 
     6B42 20A6 
0105 6B44 C820  54         mov   @>83A8,@>20A8
     6B46 83A8 
     6B48 20A8 
0106 6B4A C820  54         mov   @>83AA,@>20AA
     6B4C 83AA 
     6B4E 20AA 
0107 6B50 C820  54         mov   @>83AC,@>20AC
     6B52 83AC 
     6B54 20AC 
0108 6B56 C820  54         mov   @>83AE,@>20AE
     6B58 83AE 
     6B5A 20AE 
0109 6B5C C820  54         mov   @>83B0,@>20B0
     6B5E 83B0 
     6B60 20B0 
0110 6B62 C820  54         mov   @>83B2,@>20B2
     6B64 83B2 
     6B66 20B2 
0111 6B68 C820  54         mov   @>83B4,@>20B4
     6B6A 83B4 
     6B6C 20B4 
0112 6B6E C820  54         mov   @>83B6,@>20B6
     6B70 83B6 
     6B72 20B6 
0113 6B74 C820  54         mov   @>83B8,@>20B8
     6B76 83B8 
     6B78 20B8 
0114 6B7A C820  54         mov   @>83BA,@>20BA
     6B7C 83BA 
     6B7E 20BA 
0115 6B80 C820  54         mov   @>83BC,@>20BC
     6B82 83BC 
     6B84 20BC 
0116 6B86 C820  54         mov   @>83BE,@>20BE
     6B88 83BE 
     6B8A 20BE 
0117 6B8C C820  54         mov   @>83C0,@>20C0
     6B8E 83C0 
     6B90 20C0 
0118 6B92 C820  54         mov   @>83C2,@>20C2
     6B94 83C2 
     6B96 20C2 
0119 6B98 C820  54         mov   @>83C4,@>20C4
     6B9A 83C4 
     6B9C 20C4 
0120 6B9E C820  54         mov   @>83C6,@>20C6
     6BA0 83C6 
     6BA2 20C6 
0121 6BA4 C820  54         mov   @>83C8,@>20C8
     6BA6 83C8 
     6BA8 20C8 
0122 6BAA C820  54         mov   @>83CA,@>20CA
     6BAC 83CA 
     6BAE 20CA 
0123 6BB0 C820  54         mov   @>83CC,@>20CC
     6BB2 83CC 
     6BB4 20CC 
0124 6BB6 C820  54         mov   @>83CE,@>20CE
     6BB8 83CE 
     6BBA 20CE 
0125 6BBC C820  54         mov   @>83D0,@>20D0
     6BBE 83D0 
     6BC0 20D0 
0126 6BC2 C820  54         mov   @>83D2,@>20D2
     6BC4 83D2 
     6BC6 20D2 
0127 6BC8 C820  54         mov   @>83D4,@>20D4
     6BCA 83D4 
     6BCC 20D4 
0128 6BCE C820  54         mov   @>83D6,@>20D6
     6BD0 83D6 
     6BD2 20D6 
0129 6BD4 C820  54         mov   @>83D8,@>20D8
     6BD6 83D8 
     6BD8 20D8 
0130 6BDA C820  54         mov   @>83DA,@>20DA
     6BDC 83DA 
     6BDE 20DA 
0131 6BE0 C820  54         mov   @>83DC,@>20DC
     6BE2 83DC 
     6BE4 20DC 
0132 6BE6 C820  54         mov   @>83DE,@>20DE
     6BE8 83DE 
     6BEA 20DE 
0133 6BEC C820  54         mov   @>83E0,@>20E0
     6BEE 83E0 
     6BF0 20E0 
0134 6BF2 C820  54         mov   @>83E2,@>20E2
     6BF4 83E2 
     6BF6 20E2 
0135 6BF8 C820  54         mov   @>83E4,@>20E4
     6BFA 83E4 
     6BFC 20E4 
0136 6BFE C820  54         mov   @>83E6,@>20E6
     6C00 83E6 
     6C02 20E6 
0137 6C04 C820  54         mov   @>83E8,@>20E8
     6C06 83E8 
     6C08 20E8 
0138 6C0A C820  54         mov   @>83EA,@>20EA
     6C0C 83EA 
     6C0E 20EA 
0139 6C10 C820  54         mov   @>83EC,@>20EC
     6C12 83EC 
     6C14 20EC 
0140 6C16 C820  54         mov   @>83EE,@>20EE
     6C18 83EE 
     6C1A 20EE 
0141 6C1C C820  54         mov   @>83F0,@>20F0
     6C1E 83F0 
     6C20 20F0 
0142 6C22 C820  54         mov   @>83F2,@>20F2
     6C24 83F2 
     6C26 20F2 
0143 6C28 C820  54         mov   @>83F4,@>20F4
     6C2A 83F4 
     6C2C 20F4 
0144 6C2E C820  54         mov   @>83F6,@>20F6
     6C30 83F6 
     6C32 20F6 
0145 6C34 C820  54         mov   @>83F8,@>20F8
     6C36 83F8 
     6C38 20F8 
0146 6C3A C820  54         mov   @>83FA,@>20FA
     6C3C 83FA 
     6C3E 20FA 
0147 6C40 C820  54         mov   @>83FC,@>20FC
     6C42 83FC 
     6C44 20FC 
0148 6C46 C820  54         mov   @>83FE,@>20FE
     6C48 83FE 
     6C4A 20FE 
0149 6C4C 045B  20         b     *r11                  ; Return to caller
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
0164 6C4E C820  54         mov   @>2000,@>8300
     6C50 2000 
     6C52 8300 
0165 6C54 C820  54         mov   @>2002,@>8302
     6C56 2002 
     6C58 8302 
0166 6C5A C820  54         mov   @>2004,@>8304
     6C5C 2004 
     6C5E 8304 
0167 6C60 C820  54         mov   @>2006,@>8306
     6C62 2006 
     6C64 8306 
0168 6C66 C820  54         mov   @>2008,@>8308
     6C68 2008 
     6C6A 8308 
0169 6C6C C820  54         mov   @>200A,@>830A
     6C6E 200A 
     6C70 830A 
0170 6C72 C820  54         mov   @>200C,@>830C
     6C74 200C 
     6C76 830C 
0171 6C78 C820  54         mov   @>200E,@>830E
     6C7A 200E 
     6C7C 830E 
0172 6C7E C820  54         mov   @>2010,@>8310
     6C80 2010 
     6C82 8310 
0173 6C84 C820  54         mov   @>2012,@>8312
     6C86 2012 
     6C88 8312 
0174 6C8A C820  54         mov   @>2014,@>8314
     6C8C 2014 
     6C8E 8314 
0175 6C90 C820  54         mov   @>2016,@>8316
     6C92 2016 
     6C94 8316 
0176 6C96 C820  54         mov   @>2018,@>8318
     6C98 2018 
     6C9A 8318 
0177 6C9C C820  54         mov   @>201A,@>831A
     6C9E 201A 
     6CA0 831A 
0178 6CA2 C820  54         mov   @>201C,@>831C
     6CA4 201C 
     6CA6 831C 
0179 6CA8 C820  54         mov   @>201E,@>831E
     6CAA 201E 
     6CAC 831E 
0180 6CAE C820  54         mov   @>2020,@>8320
     6CB0 2020 
     6CB2 8320 
0181 6CB4 C820  54         mov   @>2022,@>8322
     6CB6 2022 
     6CB8 8322 
0182 6CBA C820  54         mov   @>2024,@>8324
     6CBC 2024 
     6CBE 8324 
0183 6CC0 C820  54         mov   @>2026,@>8326
     6CC2 2026 
     6CC4 8326 
0184 6CC6 C820  54         mov   @>2028,@>8328
     6CC8 2028 
     6CCA 8328 
0185 6CCC C820  54         mov   @>202A,@>832A
     6CCE 202A 
     6CD0 832A 
0186 6CD2 C820  54         mov   @>202C,@>832C
     6CD4 202C 
     6CD6 832C 
0187 6CD8 C820  54         mov   @>202E,@>832E
     6CDA 202E 
     6CDC 832E 
0188 6CDE C820  54         mov   @>2030,@>8330
     6CE0 2030 
     6CE2 8330 
0189 6CE4 C820  54         mov   @>2032,@>8332
     6CE6 2032 
     6CE8 8332 
0190 6CEA C820  54         mov   @>2034,@>8334
     6CEC 2034 
     6CEE 8334 
0191 6CF0 C820  54         mov   @>2036,@>8336
     6CF2 2036 
     6CF4 8336 
0192 6CF6 C820  54         mov   @>2038,@>8338
     6CF8 2038 
     6CFA 8338 
0193 6CFC C820  54         mov   @>203A,@>833A
     6CFE 203A 
     6D00 833A 
0194 6D02 C820  54         mov   @>203C,@>833C
     6D04 203C 
     6D06 833C 
0195 6D08 C820  54         mov   @>203E,@>833E
     6D0A 203E 
     6D0C 833E 
0196 6D0E C820  54         mov   @>2040,@>8340
     6D10 2040 
     6D12 8340 
0197 6D14 C820  54         mov   @>2042,@>8342
     6D16 2042 
     6D18 8342 
0198 6D1A C820  54         mov   @>2044,@>8344
     6D1C 2044 
     6D1E 8344 
0199 6D20 C820  54         mov   @>2046,@>8346
     6D22 2046 
     6D24 8346 
0200 6D26 C820  54         mov   @>2048,@>8348
     6D28 2048 
     6D2A 8348 
0201 6D2C C820  54         mov   @>204A,@>834A
     6D2E 204A 
     6D30 834A 
0202 6D32 C820  54         mov   @>204C,@>834C
     6D34 204C 
     6D36 834C 
0203 6D38 C820  54         mov   @>204E,@>834E
     6D3A 204E 
     6D3C 834E 
0204 6D3E C820  54         mov   @>2050,@>8350
     6D40 2050 
     6D42 8350 
0205 6D44 C820  54         mov   @>2052,@>8352
     6D46 2052 
     6D48 8352 
0206 6D4A C820  54         mov   @>2054,@>8354
     6D4C 2054 
     6D4E 8354 
0207 6D50 C820  54         mov   @>2056,@>8356
     6D52 2056 
     6D54 8356 
0208 6D56 C820  54         mov   @>2058,@>8358
     6D58 2058 
     6D5A 8358 
0209 6D5C C820  54         mov   @>205A,@>835A
     6D5E 205A 
     6D60 835A 
0210 6D62 C820  54         mov   @>205C,@>835C
     6D64 205C 
     6D66 835C 
0211 6D68 C820  54         mov   @>205E,@>835E
     6D6A 205E 
     6D6C 835E 
0212 6D6E C820  54         mov   @>2060,@>8360
     6D70 2060 
     6D72 8360 
0213 6D74 C820  54         mov   @>2062,@>8362
     6D76 2062 
     6D78 8362 
0214 6D7A C820  54         mov   @>2064,@>8364
     6D7C 2064 
     6D7E 8364 
0215 6D80 C820  54         mov   @>2066,@>8366
     6D82 2066 
     6D84 8366 
0216 6D86 C820  54         mov   @>2068,@>8368
     6D88 2068 
     6D8A 8368 
0217 6D8C C820  54         mov   @>206A,@>836A
     6D8E 206A 
     6D90 836A 
0218 6D92 C820  54         mov   @>206C,@>836C
     6D94 206C 
     6D96 836C 
0219 6D98 C820  54         mov   @>206E,@>836E
     6D9A 206E 
     6D9C 836E 
0220 6D9E C820  54         mov   @>2070,@>8370
     6DA0 2070 
     6DA2 8370 
0221 6DA4 C820  54         mov   @>2072,@>8372
     6DA6 2072 
     6DA8 8372 
0222 6DAA C820  54         mov   @>2074,@>8374
     6DAC 2074 
     6DAE 8374 
0223 6DB0 C820  54         mov   @>2076,@>8376
     6DB2 2076 
     6DB4 8376 
0224 6DB6 C820  54         mov   @>2078,@>8378
     6DB8 2078 
     6DBA 8378 
0225 6DBC C820  54         mov   @>207A,@>837A
     6DBE 207A 
     6DC0 837A 
0226 6DC2 C820  54         mov   @>207C,@>837C
     6DC4 207C 
     6DC6 837C 
0227 6DC8 C820  54         mov   @>207E,@>837E
     6DCA 207E 
     6DCC 837E 
0228 6DCE C820  54         mov   @>2080,@>8380
     6DD0 2080 
     6DD2 8380 
0229 6DD4 C820  54         mov   @>2082,@>8382
     6DD6 2082 
     6DD8 8382 
0230 6DDA C820  54         mov   @>2084,@>8384
     6DDC 2084 
     6DDE 8384 
0231 6DE0 C820  54         mov   @>2086,@>8386
     6DE2 2086 
     6DE4 8386 
0232 6DE6 C820  54         mov   @>2088,@>8388
     6DE8 2088 
     6DEA 8388 
0233 6DEC C820  54         mov   @>208A,@>838A
     6DEE 208A 
     6DF0 838A 
0234 6DF2 C820  54         mov   @>208C,@>838C
     6DF4 208C 
     6DF6 838C 
0235 6DF8 C820  54         mov   @>208E,@>838E
     6DFA 208E 
     6DFC 838E 
0236 6DFE C820  54         mov   @>2090,@>8390
     6E00 2090 
     6E02 8390 
0237 6E04 C820  54         mov   @>2092,@>8392
     6E06 2092 
     6E08 8392 
0238 6E0A C820  54         mov   @>2094,@>8394
     6E0C 2094 
     6E0E 8394 
0239 6E10 C820  54         mov   @>2096,@>8396
     6E12 2096 
     6E14 8396 
0240 6E16 C820  54         mov   @>2098,@>8398
     6E18 2098 
     6E1A 8398 
0241 6E1C C820  54         mov   @>209A,@>839A
     6E1E 209A 
     6E20 839A 
0242 6E22 C820  54         mov   @>209C,@>839C
     6E24 209C 
     6E26 839C 
0243 6E28 C820  54         mov   @>209E,@>839E
     6E2A 209E 
     6E2C 839E 
0244 6E2E C820  54         mov   @>20A0,@>83A0
     6E30 20A0 
     6E32 83A0 
0245 6E34 C820  54         mov   @>20A2,@>83A2
     6E36 20A2 
     6E38 83A2 
0246 6E3A C820  54         mov   @>20A4,@>83A4
     6E3C 20A4 
     6E3E 83A4 
0247 6E40 C820  54         mov   @>20A6,@>83A6
     6E42 20A6 
     6E44 83A6 
0248 6E46 C820  54         mov   @>20A8,@>83A8
     6E48 20A8 
     6E4A 83A8 
0249 6E4C C820  54         mov   @>20AA,@>83AA
     6E4E 20AA 
     6E50 83AA 
0250 6E52 C820  54         mov   @>20AC,@>83AC
     6E54 20AC 
     6E56 83AC 
0251 6E58 C820  54         mov   @>20AE,@>83AE
     6E5A 20AE 
     6E5C 83AE 
0252 6E5E C820  54         mov   @>20B0,@>83B0
     6E60 20B0 
     6E62 83B0 
0253 6E64 C820  54         mov   @>20B2,@>83B2
     6E66 20B2 
     6E68 83B2 
0254 6E6A C820  54         mov   @>20B4,@>83B4
     6E6C 20B4 
     6E6E 83B4 
0255 6E70 C820  54         mov   @>20B6,@>83B6
     6E72 20B6 
     6E74 83B6 
0256 6E76 C820  54         mov   @>20B8,@>83B8
     6E78 20B8 
     6E7A 83B8 
0257 6E7C C820  54         mov   @>20BA,@>83BA
     6E7E 20BA 
     6E80 83BA 
0258 6E82 C820  54         mov   @>20BC,@>83BC
     6E84 20BC 
     6E86 83BC 
0259 6E88 C820  54         mov   @>20BE,@>83BE
     6E8A 20BE 
     6E8C 83BE 
0260 6E8E C820  54         mov   @>20C0,@>83C0
     6E90 20C0 
     6E92 83C0 
0261 6E94 C820  54         mov   @>20C2,@>83C2
     6E96 20C2 
     6E98 83C2 
0262 6E9A C820  54         mov   @>20C4,@>83C4
     6E9C 20C4 
     6E9E 83C4 
0263 6EA0 C820  54         mov   @>20C6,@>83C6
     6EA2 20C6 
     6EA4 83C6 
0264 6EA6 C820  54         mov   @>20C8,@>83C8
     6EA8 20C8 
     6EAA 83C8 
0265 6EAC C820  54         mov   @>20CA,@>83CA
     6EAE 20CA 
     6EB0 83CA 
0266 6EB2 C820  54         mov   @>20CC,@>83CC
     6EB4 20CC 
     6EB6 83CC 
0267 6EB8 C820  54         mov   @>20CE,@>83CE
     6EBA 20CE 
     6EBC 83CE 
0268 6EBE C820  54         mov   @>20D0,@>83D0
     6EC0 20D0 
     6EC2 83D0 
0269 6EC4 C820  54         mov   @>20D2,@>83D2
     6EC6 20D2 
     6EC8 83D2 
0270 6ECA C820  54         mov   @>20D4,@>83D4
     6ECC 20D4 
     6ECE 83D4 
0271 6ED0 C820  54         mov   @>20D6,@>83D6
     6ED2 20D6 
     6ED4 83D6 
0272 6ED6 C820  54         mov   @>20D8,@>83D8
     6ED8 20D8 
     6EDA 83D8 
0273 6EDC C820  54         mov   @>20DA,@>83DA
     6EDE 20DA 
     6EE0 83DA 
0274 6EE2 C820  54         mov   @>20DC,@>83DC
     6EE4 20DC 
     6EE6 83DC 
0275 6EE8 C820  54         mov   @>20DE,@>83DE
     6EEA 20DE 
     6EEC 83DE 
0276 6EEE C820  54         mov   @>20E0,@>83E0
     6EF0 20E0 
     6EF2 83E0 
0277 6EF4 C820  54         mov   @>20E2,@>83E2
     6EF6 20E2 
     6EF8 83E2 
0278 6EFA C820  54         mov   @>20E4,@>83E4
     6EFC 20E4 
     6EFE 83E4 
0279 6F00 C820  54         mov   @>20E6,@>83E6
     6F02 20E6 
     6F04 83E6 
0280 6F06 C820  54         mov   @>20E8,@>83E8
     6F08 20E8 
     6F0A 83E8 
0281 6F0C C820  54         mov   @>20EA,@>83EA
     6F0E 20EA 
     6F10 83EA 
0282 6F12 C820  54         mov   @>20EC,@>83EC
     6F14 20EC 
     6F16 83EC 
0283 6F18 C820  54         mov   @>20EE,@>83EE
     6F1A 20EE 
     6F1C 83EE 
0284 6F1E C820  54         mov   @>20F0,@>83F0
     6F20 20F0 
     6F22 83F0 
0285 6F24 C820  54         mov   @>20F2,@>83F2
     6F26 20F2 
     6F28 83F2 
0286 6F2A C820  54         mov   @>20F4,@>83F4
     6F2C 20F4 
     6F2E 83F4 
0287 6F30 C820  54         mov   @>20F6,@>83F6
     6F32 20F6 
     6F34 83F6 
0288 6F36 C820  54         mov   @>20F8,@>83F8
     6F38 20F8 
     6F3A 83F8 
0289 6F3C C820  54         mov   @>20FA,@>83FA
     6F3E 20FA 
     6F40 83FA 
0290 6F42 C820  54         mov   @>20FC,@>83FC
     6F44 20FC 
     6F46 83FC 
0291 6F48 C820  54         mov   @>20FE,@>83FE
     6F4A 20FE 
     6F4C 83FE 
0292 6F4E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0195                       copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
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
0024 6F50 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6F52 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6F54 8300 
0030 6F56 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6F58 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     6F5A 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6F5C CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6F5E 0606  14         dec   tmp2
0037 6F60 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6F62 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6F64 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6F66 6F6C 
0043                                                   ; R14=PC
0044 6F68 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6F6A 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6F6C 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6F6E 6C4E 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6F70 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0197               
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
0038 6F72 B000     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0039 6F74 6F76             data  dsrlnk.init           ; entry point
0040                       ;------------------------------------------------------
0041                       ; DSRLNK entry point
0042                       ;------------------------------------------------------
0043               dsrlnk.init:
0044 6F76 C17E  30         mov   *r14+,r5              ; get pgm type for link
0045 6F78 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6F7A 8322 
0046 6F7C 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6F7E 602E 
0047 6F80 C020  34         mov   @>8356,r0             ; get ptr to pab
     6F82 8356 
0048 6F84 C240  18         mov   r0,r9                 ; save ptr
0049                       ;------------------------------------------------------
0050                       ; Fetch file descriptor length from PAB
0051                       ;------------------------------------------------------
0052 6F86 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6F88 FFF8 
0053               
0054                       ;---------------------------; Inline VSBR start
0055 6F8A 06C0  14         swpb  r0                    ;
0056 6F8C D800  38         movb  r0,@vdpa              ; send low byte
     6F8E 8C02 
0057 6F90 06C0  14         swpb  r0                    ;
0058 6F92 D800  38         movb  r0,@vdpa              ; send high byte
     6F94 8C02 
0059 6F96 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6F98 8800 
0060                       ;---------------------------; Inline VSBR end
0061 6F9A 0983  56         srl   r3,8                  ; Move to low byte
0062               
0063                       ;------------------------------------------------------
0064                       ; Fetch file descriptor device name from PAB
0065                       ;------------------------------------------------------
0066 6F9C 0704  14         seto  r4                    ; init counter
0067 6F9E 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6FA0 2100 
0068 6FA2 0580  14 !       inc   r0                    ; point to next char of name
0069 6FA4 0584  14         inc   r4                    ; incr char counter
0070 6FA6 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6FA8 0007 
0071 6FAA 1565  14         jgt   dsrlnk.error.devicename_invalid
0072                                                   ; yes, error
0073 6FAC 80C4  18         c     r4,r3                 ; end of name?
0074 6FAE 130C  14         jeq   dsrlnk.device_name.get_length
0075                                                   ; yes
0076               
0077                       ;---------------------------; Inline VSBR start
0078 6FB0 06C0  14         swpb  r0                    ;
0079 6FB2 D800  38         movb  r0,@vdpa              ; send low byte
     6FB4 8C02 
0080 6FB6 06C0  14         swpb  r0                    ;
0081 6FB8 D800  38         movb  r0,@vdpa              ; send high byte
     6FBA 8C02 
0082 6FBC D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6FBE 8800 
0083                       ;---------------------------; Inline VSBR end
0084               
0085                       ;------------------------------------------------------
0086                       ; Look for end of device name, for example "DSK1."
0087                       ;------------------------------------------------------
0088 6FC0 DC81  32         movb  r1,*r2+               ; move into buffer
0089 6FC2 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6FC4 7086 
0090 6FC6 16ED  14         jne   -!                    ; no, loop next char
0091                       ;------------------------------------------------------
0092                       ; Determine device name length
0093                       ;------------------------------------------------------
0094               dsrlnk.device_name.get_length:
0095 6FC8 C104  18         mov   r4,r4                 ; Check if length = 0
0096 6FCA 1355  14         jeq   dsrlnk.error.devicename_invalid
0097                                                   ; yes, error
0098 6FCC 04E0  34         clr   @>83d0
     6FCE 83D0 
0099 6FD0 C804  38         mov   r4,@>8354             ; save name length for search
     6FD2 8354 
0100 6FD4 0584  14         inc   r4                    ; adjust for dot
0101 6FD6 A804  38         a     r4,@>8356             ; point to position after name
     6FD8 8356 
0102                       ;------------------------------------------------------
0103                       ; Prepare for DSR scan >1000 - >1f00
0104                       ;------------------------------------------------------
0105               dsrlnk.dsrscan.start:
0106 6FDA 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6FDC 83E0 
0107 6FDE 04C1  14         clr   r1                    ; version found of dsr
0108 6FE0 020C  20         li    r12,>0f00             ; init cru addr
     6FE2 0F00 
0109                       ;------------------------------------------------------
0110                       ; Turn off ROM on current card
0111                       ;------------------------------------------------------
0112               dsrlnk.dsrscan.cardoff:
0113 6FE4 C30C  18         mov   r12,r12               ; anything to turn off?
0114 6FE6 1301  14         jeq   dsrlnk.dsrscan.cardloop
0115                                                   ; no, loop over cards
0116 6FE8 1E00  20         sbz   0                     ; yes, turn off
0117                       ;------------------------------------------------------
0118                       ; Loop over cards and look if DSR present
0119                       ;------------------------------------------------------
0120               dsrlnk.dsrscan.cardloop:
0121 6FEA 022C  22         ai    r12,>0100             ; next rom to turn on
     6FEC 0100 
0122 6FEE 04E0  34         clr   @>83d0                ; clear in case we are done
     6FF0 83D0 
0123 6FF2 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6FF4 2000 
0124 6FF6 133D  14         jeq   dsrlnk.error.nodsr_found
0125                                                   ; yes, no matching DSR found
0126 6FF8 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6FFA 83D0 
0127                       ;------------------------------------------------------
0128                       ; Look at card ROM (@>4000 eq 'AA' ?)
0129                       ;------------------------------------------------------
0130 6FFC 1D00  20         sbo   0                     ; turn on rom
0131 6FFE 0202  20         li    r2,>4000              ; start at beginning of rom
     7000 4000 
0132 7002 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     7004 7082 
0133 7006 16EE  14         jne   dsrlnk.dsrscan.cardoff
0134                                                   ; no rom found on card
0135                       ;------------------------------------------------------
0136                       ; Valid DSR ROM found. Now loop over chain/subprograms
0137                       ;------------------------------------------------------
0138                       ; dstype is the address of R5 of the DSRLNK workspace,
0139                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0140                       ; is stored before the DSR ROM is searched.
0141                       ;------------------------------------------------------
0142 7008 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     700A B00A 
0143 700C 1003  14         jmp   dsrlnk.dsrscan.getentry
0144                       ;------------------------------------------------------
0145                       ; Next DSR entry
0146                       ;------------------------------------------------------
0147               dsrlnk.dsrscan.nextentry:
0148 700E C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     7010 83D2 
0149 7012 1D00  20         sbo   0                     ; turn rom back on
0150                       ;------------------------------------------------------
0151                       ; Get DSR entry
0152                       ;------------------------------------------------------
0153               dsrlnk.dsrscan.getentry:
0154 7014 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0155 7016 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0156                                                   ; yes, no more DSRs or programs to check
0157 7018 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     701A 83D2 
0158 701C 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0159 701E C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0160                       ;------------------------------------------------------
0161                       ; Check file descriptor in DSR
0162                       ;------------------------------------------------------
0163 7020 04C5  14         clr   r5                    ; Remove any old stuff
0164 7022 D160  34         movb  @>8355,r5             ; get length as counter
     7024 8355 
0165 7026 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0166                                                   ; if zero, do not further check, call DSR program
0167 7028 9C85  32         cb    r5,*r2+               ; see if length matches
0168 702A 16F1  14         jne   dsrlnk.dsrscan.nextentry
0169                                                   ; no, length does not match. Go process next DSR entry
0170 702C 0985  56         srl   r5,8                  ; yes, move to low byte
0171 702E 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     7030 2100 
0172 7032 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0173 7034 16EC  14         jne   dsrlnk.dsrscan.nextentry
0174                                                   ; try next DSR entry if no match
0175 7036 0605  14         dec   r5                    ; loop until full length checked
0176 7038 16FC  14         jne   -!
0177                       ;------------------------------------------------------
0178                       ; Device name/Subprogram match
0179                       ;------------------------------------------------------
0180               dsrlnk.dsrscan.match:
0181 703A C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     703C 83D2 
0182               
0183                       ;------------------------------------------------------
0184                       ; Call DSR program in device card
0185                       ;------------------------------------------------------
0186               dsrlnk.dsrscan.call_dsr:
0187 703E 0581  14         inc   r1                    ; next version found
0188 7040 0699  24         bl    *r9                   ; go run routine
0189                       ;
0190                       ; Depending on IO result the DSR in card ROM does RET
0191                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0192                       ;
0193 7042 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0194                                                   ; (1) error return
0195 7044 1E00  20         sbz   0                     ; (2) turn off rom if good return
0196 7046 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     7048 B000 
0197 704A C009  18         mov   r9,r0                 ; point to flag in pab
0198 704C C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     704E 8322 
0199                                                   ; (8 or >a)
0200 7050 0281  22         ci    r1,8                  ; was it 8?
     7052 0008 
0201 7054 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0202 7056 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     7058 8350 
0203                                                   ; Get error byte from @>8350
0204 705A 1000  14         jmp   dsrlnk.dsrscan.dsr.8  ; go and return error byte to the caller
0205               
0206                       ;------------------------------------------------------
0207                       ; Read PAB status flag after DSR call completed
0208                       ;------------------------------------------------------
0209               dsrlnk.dsrscan.dsr.8:
0210                       ;---------------------------; Inline VSBR start
0211 705C 06C0  14         swpb  r0                    ;
0212 705E D800  38         movb  r0,@vdpa              ; send low byte
     7060 8C02 
0213 7062 06C0  14         swpb  r0                    ;
0214 7064 D800  38         movb  r0,@vdpa              ; send high byte
     7066 8C02 
0215 7068 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     706A 8800 
0216                       ;---------------------------; Inline VSBR end
0217               
0218                       ;------------------------------------------------------
0219                       ; Return DSR error to caller
0220                       ;------------------------------------------------------
0221               dsrlnk.dsrscan.dsr.a:
0222 706C 09D1  56         srl   r1,13                 ; just keep error bits
0223 706E 1604  14         jne   dsrlnk.error.io_error
0224                                                   ; handle IO error
0225 7070 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0226               
0227                       ;------------------------------------------------------
0228                       ; IO-error handler
0229                       ;------------------------------------------------------
0230               dsrlnk.error.nodsr_found:
0231 7072 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     7074 B000 
0232               dsrlnk.error.devicename_invalid:
0233 7076 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0234               dsrlnk.error.io_error:
0235 7078 06C1  14         swpb  r1                    ; put error in hi byte
0236 707A D741  30         movb  r1,*r13               ; store error flags in callers r0
0237 707C F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     707E 602E 
0238 7080 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0239               
0240               ****************************************************************************************
0241               
0242 7082 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0243 7084 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0244 7086 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0245                       even
**** **** ****     > runlib.asm
0200                       copy  "fio_files.asm"            ; Files I/O support
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
0020 7088 0300  24 tmgr    limi  0                     ; No interrupt processing
     708A 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 708C D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     708E 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 7090 2360  38         coc   @wbit2,r13            ; C flag on ?
     7092 602E 
0029 7094 1602  14         jne   tmgr1a                ; No, so move on
0030 7096 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     7098 6042 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 709A 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     709C 602A 
0035 709E 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 70A0 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     70A2 603A 
0048 70A4 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 70A6 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     70A8 603C 
0050 70AA 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 70AC 0460  28         b     @kthread              ; Run kernel thread
     70AE 7126 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 70B0 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     70B2 6036 
0056 70B4 13EB  14         jeq   tmgr1
0057 70B6 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     70B8 6038 
0058 70BA 16E8  14         jne   tmgr1
0059 70BC C120  34         mov   @wtiusr,tmp0
     70BE 832E 
0060 70C0 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 70C2 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     70C4 7124 
0065 70C6 C10A  18         mov   r10,tmp0
0066 70C8 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     70CA 00FF 
0067 70CC 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     70CE 602E 
0068 70D0 1303  14         jeq   tmgr5
0069 70D2 0284  22         ci    tmp0,60               ; 1 second reached ?
     70D4 003C 
0070 70D6 1002  14         jmp   tmgr6
0071 70D8 0284  22 tmgr5   ci    tmp0,50
     70DA 0032 
0072 70DC 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 70DE 1001  14         jmp   tmgr8
0074 70E0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 70E2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     70E4 832C 
0079 70E6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     70E8 FF00 
0080 70EA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 70EC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 70EE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 70F0 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 70F2 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 70F4 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     70F6 830C 
     70F8 830D 
0089 70FA 1608  14         jne   tmgr10                ; No, get next slot
0090 70FC 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     70FE FF00 
0091 7100 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 7102 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     7104 8330 
0096 7106 0697  24         bl    *tmp3                 ; Call routine in slot
0097 7108 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     710A 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 710C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 710E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     7110 8315 
     7112 8314 
0103 7114 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 7116 05C4  14         inct  tmp0                  ; Offset for next slot
0105 7118 10E8  14         jmp   tmgr9                 ; Process next slot
0106 711A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 711C 10F7  14         jmp   tmgr10                ; Process next slot
0108 711E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     7120 FF00 
0109 7122 10B4  14         jmp   tmgr1
0110 7124 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 7126 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     7128 603A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 712A 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     712C 63C4 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 712E 06A0  32         bl    @realkb               ; Scan full keyboard
     7130 64B4 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 7132 0460  28         b     @tmgr3                ; Exit
     7134 70B0 
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
0017 7136 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     7138 832E 
0018 713A E0A0  34         soc   @wbit7,config         ; Enable user hook
     713C 6038 
0019 713E 045B  20 mkhoo1  b     *r11                  ; Return
0020      708C     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 7140 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     7142 832E 
0029 7144 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     7146 FEFF 
0030 7148 045B  20         b     *r11                  ; Return
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
0229               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0230               *  after clearing scratchpad memory.
0231               *  Use 'B @RUNLI1' to exit your program.
0232               ********@*****@*********************@**************************
0234 714A 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     714C 694C 
0235 714E 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7150 8302 
0239               *--------------------------------------------------------------
0240               * Alternative entry point
0241               *--------------------------------------------------------------
0242 7152 0300  24 runli1  limi  0                     ; Turn off interrupts
     7154 0000 
0243 7156 02E0  18         lwpi  ws1                   ; Activate workspace 1
     7158 8300 
0244 715A C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     715C 83C0 
0245               *--------------------------------------------------------------
0246               * Clear scratch-pad memory from R4 upwards
0247               *--------------------------------------------------------------
0248 715E 0202  20 runli2  li    r2,>8308
     7160 8308 
0249 7162 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0250 7164 0282  22         ci    r2,>8400
     7166 8400 
0251 7168 16FC  14         jne   runli3
0252               *--------------------------------------------------------------
0253               * Exit to TI-99/4A title screen ?
0254               *--------------------------------------------------------------
0255 716A 0281  22         ci    r1,>ffff              ; Exit flag set ?
     716C FFFF 
0256 716E 1602  14         jne   runli4                ; No, continue
0257 7170 0420  54         blwp  @0                    ; Yes, bye bye
     7172 0000 
0258               *--------------------------------------------------------------
0259               * Determine if VDP is PAL or NTSC
0260               *--------------------------------------------------------------
0261 7174 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7176 833C 
0262 7178 04C1  14         clr   r1                    ; Reset counter
0263 717A 0202  20         li    r2,10                 ; We test 10 times
     717C 000A 
0264 717E C0E0  34 runli5  mov   @vdps,r3
     7180 8802 
0265 7182 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7184 602A 
0266 7186 1302  14         jeq   runli6
0267 7188 0581  14         inc   r1                    ; Increase counter
0268 718A 10F9  14         jmp   runli5
0269 718C 0602  14 runli6  dec   r2                    ; Next test
0270 718E 16F7  14         jne   runli5
0271 7190 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7192 1250 
0272 7194 1202  14         jle   runli7                ; No, so it must be NTSC
0273 7196 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     7198 602E 
0274               *--------------------------------------------------------------
0275               * Copy machine code to scratchpad (prepare tight loop)
0276               *--------------------------------------------------------------
0277 719A 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     719C 6084 
0278 719E 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     71A0 8322 
0279 71A2 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0280 71A4 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0281 71A6 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0282               *--------------------------------------------------------------
0283               * Initialize registers, memory, ...
0284               *--------------------------------------------------------------
0285 71A8 04C1  14 runli9  clr   r1
0286 71AA 04C2  14         clr   r2
0287 71AC 04C3  14         clr   r3
0288 71AE 0209  20         li    stack,>8400           ; Set stack
     71B0 8400 
0289 71B2 020F  20         li    r15,vdpw              ; Set VDP write address
     71B4 8C00 
0293               *--------------------------------------------------------------
0294               * Setup video memory
0295               *--------------------------------------------------------------
0297 71B6 06A0  32         bl    @filv                 ; Clear most part of 16K VDP memory,
     71B8 60BE 
0298 71BA 0000             data  >0000,>00,>3fd8       ; Keep memory for 3 VDP disk buffers (>3fd8 - >3ff)
     71BC 0000 
     71BE 3FD8 
0303 71C0 06A0  32         bl    @filv
     71C2 60BE 
0304 71C4 0FC0             data  pctadr,spfclr,16      ; Load color table
     71C6 00C1 
     71C8 0010 
0305               *--------------------------------------------------------------
0306               * Check if there is a F18A present
0307               *--------------------------------------------------------------
0311 71CA 06A0  32         bl    @f18unl               ; Unlock the F18A
     71CC 6334 
0312 71CE 06A0  32         bl    @f18chk               ; Check if F18A is there
     71D0 634E 
0313 71D2 06A0  32         bl    @f18lck               ; Lock the F18A again
     71D4 6344 
0315               *--------------------------------------------------------------
0316               * Check if there is a speech synthesizer attached
0317               *--------------------------------------------------------------
0319               *       <<skipped>>
0323               *--------------------------------------------------------------
0324               * Load video mode table & font
0325               *--------------------------------------------------------------
0326 71D6 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     71D8 6118 
0327 71DA 6070             data  spvmod                ; Equate selected video mode table
0328 71DC 0204  20         li    tmp0,spfont           ; Get font option
     71DE 000C 
0329 71E0 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0330 71E2 1304  14         jeq   runlid                ; Yes, skip it
0331 71E4 06A0  32         bl    @ldfnt
     71E6 6180 
0332 71E8 1100             data  fntadr,spfont         ; Load specified font
     71EA 000C 
0333               *--------------------------------------------------------------
0334               * Branch to main program
0335               *--------------------------------------------------------------
0336 71EC 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     71EE 0040 
0337 71F0 0460  28         b     @main                 ; Give control to main program
     71F2 71F4 
**** **** ****     > fio.asm.13122
0069               *--------------------------------------------------------------
0070               * SPECTRA2 startup options
0071               *--------------------------------------------------------------
0072      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0073      0001     spfbck  equ   >01                   ; Screen background color.
0074               ;--------------------------------------------------------------
0075               ; Video mode configuration
0076               ;--------------------------------------------------------------
0077      6070     spvmod  equ   tx8024                ; Video mode.   See VIDTAB for details.
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
0091 71F4 06A0  32 main    bl    @putat
     71F6 6250 
0092 71F8 0000             data  >0000,msg
     71FA 72A2 
0093               
0094 71FC 06A0  32         bl    @putat
     71FE 6250 
0095 7200 0100             data  >0100,fname
     7202 7291 
0096               
0097                       ;------------------------------------------------------
0098                       ; Prepare VDP for PAB and page out scratchpad
0099                       ;------------------------------------------------------
0100 7204 06A0  32         bl    @cpym2v
     7206 6258 
0101 7208 01F0             data  pabadr1,dsrsub,2      ; Copy PAB for DSR call files subprogram
     720A 7286 
     720C 0002 
0102               
0103 720E 06A0  32         bl    @cpym2v
     7210 6258 
0104 7212 0200             data  pabadr2,pab,25        ; Copy PAB to VDP
     7214 7288 
     7216 0019 
0105               
0106 7218 06A0  32         bl    @cpym2v
     721A 6258 
0107 721C 37D7             data  >37d7,schrott,6
     721E 72B8 
     7220 0006 
0108               
0109               
0110 7222 06A0  32         bl    @mem.scrpad.pgout     ; Page out scratchpad memory
     7224 6F50 
0111 7226 A000             data  >a000                 ; Memory destination @>a000
0112               
0113                       ;------------------------------------------------------
0114                       ; Set up file buffer - call files(1)
0115                       ;------------------------------------------------------
0116 7228 0200  20         li    r0,>0100
     722A 0100 
0117 722C D800  38         movb  r0,@>834c             ; Set number of disk files to 1
     722E 834C 
0118 7230 0200  20         li    r0,pabadr1
     7232 01F0 
0119 7234 C800  38         mov   r0,@>8356             ; Pass PAB to DSRLNK
     7236 8356 
0120 7238 0420  54         blwp  @dsrlnk               ; Call subprogram for "call files(1)"
     723A 6F72 
0121 723C 000A             data  >a
0122 723E 1320  14         jeq   done1                 ; Exit on error
0123               
0124               
0125                       ;------------------------------------------------------
0126                       ; Open file
0127                       ;------------------------------------------------------
0128 7240 0200  20         li    r0,pabadr2+9
     7242 0209 
0129 7244 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7246 8356 
0130 7248 0420  54         blwp  @dsrlnk
     724A 6F72 
0131 724C 0008             data  8
0132               
0133                       ;------------------------------------------------------
0134                       ; Read record
0135                       ;------------------------------------------------------
0136               readfile
0137 724E 0200  20         li    r0,pabadr2+9
     7250 0209 
0138 7252 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7254 8356 
0139               
0140 7256 06A0  32         bl    @vputb
     7258 60F8 
0141 725A 0200             data  pabadr2,io.op.read
     725C 0002 
0142               
0143 725E 0420  54         blwp  @dsrlnk
     7260 6F72 
0144 7262 0008             data  8
0145               
0146 7264 130F  14         jeq   file_error
0147 7266 10F3  14         jmp   readfile
0148               
0149                       ;------------------------------------------------------
0150                       ; Close file
0151                       ;------------------------------------------------------
0152               close_file
0153 7268 0200  20         li    r0,pabadr2+9
     726A 0209 
0154 726C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     726E 8356 
0155               
0156 7270 06A0  32         bl    @vputb
     7272 60F8 
0157 7274 0200             data  pabadr2,io.op.close
     7276 0001 
0158               
0159 7278 0420  54         blwp  @dsrlnk
     727A 6F72 
0160 727C 0008             data  8
0161               
0162 727E 10FF  14 done0   jmp   $
0163 7280 10FF  14 done1   jmp   $
0164 7282 10FF  14 done2   jmp   $
0165               
0166               file_error
0167 7284 10F1  14         jmp   close_file
0168               
0169               
0170               
0171               
0172               
0173               
0174               
0175               
0176               
0177               ***************************************************************
0178               * DSR subprogram for call files
0179               ***************************************************************
0180                       even
0181 7286 0116     dsrsub  byte  >01,>16               ; DSR program/subprogram - set file buffers
0182               
0183               
0184               ***************************************************************
0185               * PAB for accessing file
0186               ********@*****@*********************@**************************
0187 7288 0014     pab     byte  io.op.open            ;  0    - OPEN
0188                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0189 728A 0300             data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0190 728C 5000             byte  >50                   ;  4    - 80 characters maximum
0191                       byte  >00                   ;  5    - Filled with bytes read during read
0192 728E 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0193 7290 000F             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0194               fname   byte  15                    ;  9    - File descriptor length
0195 7292 ....             text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
0196                       even
0197               
0198               
0199               msg
0200 72A2 152A             byte  21
0201 72A3 ....             text  '* File reading test *'
0202                       even
0203               
0204 72B8 00AA     schrott data  >00aa, >3fff, >1103
     72BA 3FFF 
     72BC 1103 
