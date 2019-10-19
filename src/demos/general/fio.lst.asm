XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > fio.asm.793
0001               ***************************************************************
0002               *
0003               *                          File I/O test
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: fio.asm                     ; Version 191019-793
0009               *--------------------------------------------------------------
0010               * 2018-04-01   Development started
0011               ********@*****@*********************@**************************
0012                       save  >6000,>7fff
0013                       aorg  >6000
0014               *--------------------------------------------------------------
0015      0001     debug                     equ  1    ; Turn on debugging
0016      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0017      0001     startup_keep_vdpdiskbuf   equ  1    ; Keep VDP memory reseved for 3 VDP disk buffers
0018               *--------------------------------------------------------------
0019               * Skip unused spectra2 code modules for reduced code size
0020               *--------------------------------------------------------------
0021      0001     skip_rom_bankswitch       equ  1    ; Skip ROM bankswitching support
0022      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0023      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0024      0001     skip_vdp_hchar            equ  1    ; Skip hchar, xchar
0025      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0026      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0027      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0028      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0029      0001     skip_vdp_rle_decompress   equ  1    ; Skip RLE decompress to VRAM
0030      0001     skip_vdp_yx2px_calc       equ  1    ; Skip YX to pixel calculation
0031      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0032      0001     skip_vdp_sprites          equ  1    ; Skip sprites support
0033      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0034      0001     skip_tms52xx_detection    equ  1    ; Skip speech synthesizer detection
0035      0001     skip_tms52xx_player       equ  1    ; Skip inclusion of speech player code
0036      0001     skip_random_generator     equ  1    ; Skip random functions
0037      0001     skip_timer_alloc          equ  1    ; Skip support for timers allocation
0038               
0039               *--------------------------------------------------------------
0040               * Cartridge header
0041               *--------------------------------------------------------------
0042 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0043 6006 6010             data  prog0
0044 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0045 6010 0000     prog0   data  0                     ; No more items following
0046 6012 7150             data  runlib
0048               
0049 6014 1346             byte  19
0050 6015 ....             text  'FIO TEST 191019-793'
0051                       even
0052               
0060               *--------------------------------------------------------------
0061               * Include required files
0062               *--------------------------------------------------------------
0063                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *    v1.3
0007               *                TMS9900 Monitor with Arcade Game support
0008               *                                  for
0009               *                     the Texas Instruments TI-99/4A
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
0037 6028 8000     wbit0   data  >8000                 ; Binary 1000000000000000
0038 602A 4000     wbit1   data  >4000                 ; Binary 0100000000000000
0039 602C 2000     wbit2   data  >2000                 ; Binary 0010000000000000
0040 602E 1000     wbit3   data  >1000                 ; Binary 0001000000000000
0041 6030 0800     wbit4   data  >0800                 ; Binary 0000100000000000
0042 6032 0400     wbit5   data  >0400                 ; Binary 0000010000000000
0043 6034 0200     wbit6   data  >0200                 ; Binary 0000001000000000
0044 6036 0100     wbit7   data  >0100                 ; Binary 0000000100000000
0045 6038 0080     wbit8   data  >0080                 ; Binary 0000000010000000
0046 603A 0040     wbit9   data  >0040                 ; Binary 0000000001000000
0047 603C 0020     wbit10  data  >0020                 ; Binary 0000000000100000
0048 603E 0010     wbit11  data  >0010                 ; Binary 0000000000010000
0049 6040 0008     wbit12  data  >0008                 ; Binary 0000000000001000
0050 6042 0004     wbit13  data  >0004                 ; Binary 0000000000000100
0051 6044 0002     wbit14  data  >0002                 ; Binary 0000000000000010
0052 6046 0001     wbit15  data  >0001                 ; Binary 0000000000000001
0053 6048 FFFF     whffff  data  >ffff                 ; Binary 1111111111111111
0054 604A 0001     bd0     byte  0                     ; Digit 0
0055               bd1     byte  1                     ; Digit 1
0056 604C 0203     bd2     byte  2                     ; Digit 2
0057               bd3     byte  3                     ; Digit 3
0058 604E 0405     bd4     byte  4                     ; Digit 4
0059               bd5     byte  5                     ; Digit 5
0060 6050 0607     bd6     byte  6                     ; Digit 6
0061               bd7     byte  7                     ; Digit 7
0062 6052 0809     bd8     byte  8                     ; Digit 8
0063               bd9     byte  9                     ; Digit 9
0064 6054 D000     bd208   byte  208                   ; Digit 208 (>D0)
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
0007      6046     w$0001  equ   wbit15                ; >0001
0008      6044     w$0002  equ   wbit14                ; >0002
0009      6042     w$0004  equ   wbit13                ; >0004
0010      6040     w$0008  equ   wbit12                ; >0008
0011      603E     w$0010  equ   wbit11                ; >0010
0012      603C     w$0020  equ   wbit10                ; >0020
0013      603A     w$0040  equ   wbit9                 ; >0040
0014      6038     w$0080  equ   wbit8                 ; >0080
0015      6036     w$0100  equ   wbit7                 ; >0100
0016      6034     w$0200  equ   wbit6                 ; >0200
0017      6032     w$0400  equ   wbit5                 ; >0400
0018      6030     w$0800  equ   wbit4                 ; >0800
0019      602E     w$1000  equ   wbit3                 ; >1000
0020      602C     w$2000  equ   wbit2                 ; >2000
0021      602A     w$4000  equ   wbit1                 ; >4000
0022      6028     w$8000  equ   wbit0                 ; >8000
0023      6048     w$ffff  equ   whffff                ; >ffff
0024               *--------------------------------------------------------------
0025               * MSB values: >01 - >0f for byte operations AB, SB, CB, ...
0026               *--------------------------------------------------------------
0027      6036     hb$01   equ   wbit7                 ; >0100
0028      6034     hb$02   equ   wbit6                 ; >0200
0029      6032     hb$04   equ   wbit5                 ; >0400
0030      6030     hb$08   equ   wbit4                 ; >0800
0031      602E     hb$10   equ   wbit3                 ; >1000
0032      602C     hb$20   equ   wbit2                 ; >2000
0033      602A     hb$40   equ   wbit1                 ; >4000
0034      6028     hb$80   equ   wbit0                 ; >8000
0035               *--------------------------------------------------------------
0036               * LSB values: >01 - >0f for byte operations AB, SB, CB, ...
0037               *--------------------------------------------------------------
0038      6046     lb$01   equ   wbit15                ; >0001
0039      6044     lb$02   equ   wbit14                ; >0002
0040      6042     lb$04   equ   wbit13                ; >0004
0041      6040     lb$08   equ   wbit12                ; >0008
0042      603E     lb$10   equ   wbit11                ; >0010
0043      603C     lb$20   equ   wbit10                ; >0020
0044      603A     lb$40   equ   wbit9                 ; >0040
0045      6038     lb$80   equ   wbit8                 ; >0080
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
0027      602C     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6036     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      603A     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      603C     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      603E     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0018 6056 0420  54 crash   blwp  @>0000                ; Soft-reset
     6058 0000 
**** **** ****     > runlib.asm
0086                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 605A 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     605C 000E 
     605E 0106 
     6060 0201 
     6062 0020 
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
0032 6064 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6066 000E 
     6068 0106 
     606A 00C1 
     606C 0028 
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
0058 606E 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6070 003F 
     6072 0240 
     6074 03C1 
     6076 0050 
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
0084 6078 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     607A 003F 
     607C 0240 
     607E 03C1 
     6080 0050 
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
0013 6082 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6084 16FD             data  >16fd                 ; |         jne   mcloop
0015 6086 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6088 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 608A 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 608C C0F9  30 popr3   mov   *stack+,r3
0039 608E C0B9  30 popr2   mov   *stack+,r2
0040 6090 C079  30 popr1   mov   *stack+,r1
0041 6092 C039  30 popr0   mov   *stack+,r0
0042 6094 C2F9  30 poprt   mov   *stack+,r11
0043 6096 045B  20         b     *r11
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
0067 6098 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 609A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 609C C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 609E C1C6  18 xfilm   mov   tmp2,tmp3
0074 60A0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60A2 0001 
0075               
0076 60A4 1301  14         jeq   film1
0077 60A6 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60A8 D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60AA 830B 
     60AC 830A 
0079 60AE CD05  34 film2   mov   tmp1,*tmp0+
0080 60B0 0646  14         dect  tmp2
0081 60B2 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60B4 C1C7  18         mov   tmp3,tmp3
0086 60B6 1301  14         jeq   filmz
0087 60B8 D505  30         movb  tmp1,*tmp0
0088 60BA 045B  20 filmz   b     *r11
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
0107 60BC C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60BE C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60C0 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60C2 0264  22 xfilv   ori   tmp0,>4000
     60C4 4000 
0114 60C6 06C4  14         swpb  tmp0
0115 60C8 D804  38         movb  tmp0,@vdpa
     60CA 8C02 
0116 60CC 06C4  14         swpb  tmp0
0117 60CE D804  38         movb  tmp0,@vdpa
     60D0 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60D2 020F  20         li    r15,vdpw              ; Set VDP write address
     60D4 8C00 
0122 60D6 06C5  14         swpb  tmp1
0123 60D8 C820  54         mov   @filzz,@mcloop        ; Setup move command
     60DA 60E2 
     60DC 8320 
0124 60DE 0460  28         b     @mcloop               ; Write data to VDP
     60E0 8320 
0125               *--------------------------------------------------------------
0129 60E2 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60E4 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     60E6 4000 
0150 60E8 06C4  14 vdra    swpb  tmp0
0151 60EA D804  38         movb  tmp0,@vdpa
     60EC 8C02 
0152 60EE 06C4  14         swpb  tmp0
0153 60F0 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     60F2 8C02 
0154 60F4 045B  20         b     *r11
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
0165 60F6 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 60F8 C17B  30         mov   *r11+,tmp1
0167 60FA C18B  18 xvputb  mov   r11,tmp2              ; Save R11
0168 60FC 06A0  32         bl    @vdwa                 ; Set VDP write address
     60FE 60E4 
0169               
0170 6100 06C5  14         swpb  tmp1                  ; Get byte to write
0171 6102 D7C5  30         movb  tmp1,*r15             ; Write byte
0172 6104 0456  20         b     *tmp2                 ; Exit
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
0183 6106 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0184 6108 C18B  18 xvgetb  mov   r11,tmp2              ; Save R11
0185 610A 06A0  32         bl    @vdra                 ; Set VDP read address
     610C 60E8 
0186               
0187 610E D120  34         movb  @vdpr,tmp0            ; Read byte
     6110 8800 
0188               
0189 6112 0984  56         srl   tmp0,8                ; Right align
0190 6114 0456  20         b     *tmp2                 ; Exit
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
0209 6116 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0210 6118 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0211               *--------------------------------------------------------------
0212               * Calculate PNT base address
0213               *--------------------------------------------------------------
0214 611A C144  18         mov   tmp0,tmp1
0215 611C 05C5  14         inct  tmp1
0216 611E D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0217 6120 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6122 FF00 
0218 6124 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0219 6126 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6128 8328 
0220               *--------------------------------------------------------------
0221               * Dump VDP shadow registers
0222               *--------------------------------------------------------------
0223 612A 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     612C 8000 
0224 612E 0206  20         li    tmp2,8
     6130 0008 
0225 6132 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6134 830B 
0226 6136 06C5  14         swpb  tmp1
0227 6138 D805  38         movb  tmp1,@vdpa
     613A 8C02 
0228 613C 06C5  14         swpb  tmp1
0229 613E D805  38         movb  tmp1,@vdpa
     6140 8C02 
0230 6142 0225  22         ai    tmp1,>0100
     6144 0100 
0231 6146 0606  14         dec   tmp2
0232 6148 16F4  14         jne   vidta1                ; Next register
0233 614A C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     614C 833A 
0234 614E 045B  20         b     *r11
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
0251 6150 C13B  30 putvr   mov   *r11+,tmp0
0252 6152 0264  22 putvrx  ori   tmp0,>8000
     6154 8000 
0253 6156 06C4  14         swpb  tmp0
0254 6158 D804  38         movb  tmp0,@vdpa
     615A 8C02 
0255 615C 06C4  14         swpb  tmp0
0256 615E D804  38         movb  tmp0,@vdpa
     6160 8C02 
0257 6162 045B  20         b     *r11
0258               
0259               
0260               ***************************************************************
0261               * PUTV01  - Put VDP registers #0 and #1
0262               ***************************************************************
0263               *  BL   @PUTV01
0264               ********@*****@*********************@**************************
0265 6164 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0266 6166 C10E  18         mov   r14,tmp0
0267 6168 0984  56         srl   tmp0,8
0268 616A 06A0  32         bl    @putvrx               ; Write VR#0
     616C 6152 
0269 616E 0204  20         li    tmp0,>0100
     6170 0100 
0270 6172 D820  54         movb  @r14lb,@tmp0lb
     6174 831D 
     6176 8309 
0271 6178 06A0  32         bl    @putvrx               ; Write VR#1
     617A 6152 
0272 617C 0458  20         b     *tmp4                 ; Exit
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
0286 617E C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0287 6180 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0288 6182 C11B  26         mov   *r11,tmp0             ; Get P0
0289 6184 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6186 7FFF 
0290 6188 2120  38         coc   @wbit0,tmp0
     618A 6028 
0291 618C 1604  14         jne   ldfnt1
0292 618E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6190 8000 
0293 6192 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6194 7FFF 
0294               *--------------------------------------------------------------
0295               * Read font table address from GROM into tmp1
0296               *--------------------------------------------------------------
0297 6196 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6198 6200 
0298 619A D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     619C 9C02 
0299 619E 06C4  14         swpb  tmp0
0300 61A0 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     61A2 9C02 
0301 61A4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61A6 9800 
0302 61A8 06C5  14         swpb  tmp1
0303 61AA D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61AC 9800 
0304 61AE 06C5  14         swpb  tmp1
0305               *--------------------------------------------------------------
0306               * Setup GROM source address from tmp1
0307               *--------------------------------------------------------------
0308 61B0 D805  38         movb  tmp1,@grmwa
     61B2 9C02 
0309 61B4 06C5  14         swpb  tmp1
0310 61B6 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61B8 9C02 
0311               *--------------------------------------------------------------
0312               * Setup VDP target address
0313               *--------------------------------------------------------------
0314 61BA C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0315 61BC 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61BE 60E4 
0316 61C0 05C8  14         inct  tmp4                  ; R11=R11+2
0317 61C2 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0318 61C4 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61C6 7FFF 
0319 61C8 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61CA 6202 
0320 61CC C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61CE 6204 
0321               *--------------------------------------------------------------
0322               * Copy from GROM to VRAM
0323               *--------------------------------------------------------------
0324 61D0 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0325 61D2 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0326 61D4 D120  34         movb  @grmrd,tmp0
     61D6 9800 
0327               *--------------------------------------------------------------
0328               *   Make font fat
0329               *--------------------------------------------------------------
0330 61D8 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     61DA 6028 
0331 61DC 1603  14         jne   ldfnt3                ; No, so skip
0332 61DE D1C4  18         movb  tmp0,tmp3
0333 61E0 0917  56         srl   tmp3,1
0334 61E2 E107  18         soc   tmp3,tmp0
0335               *--------------------------------------------------------------
0336               *   Dump byte to VDP and do housekeeping
0337               *--------------------------------------------------------------
0338 61E4 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     61E6 8C00 
0339 61E8 0606  14         dec   tmp2
0340 61EA 16F2  14         jne   ldfnt2
0341 61EC 05C8  14         inct  tmp4                  ; R11=R11+2
0342 61EE 020F  20         li    r15,vdpw              ; Set VDP write address
     61F0 8C00 
0343 61F2 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61F4 7FFF 
0344 61F6 0458  20         b     *tmp4                 ; Exit
0345 61F8 D820  54 ldfnt4  movb  @bd0,@vdpw            ; Insert byte >00 into VRAM
     61FA 604A 
     61FC 8C00 
0346 61FE 10E8  14         jmp   ldfnt2
0347               *--------------------------------------------------------------
0348               * Fonts pointer table
0349               *--------------------------------------------------------------
0350 6200 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6202 0200 
     6204 0000 
0351 6206 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6208 01C0 
     620A 0101 
0352 620C 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     620E 02A0 
     6210 0101 
0353 6212 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6214 00E0 
     6216 0101 
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
0371 6218 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0372 621A C3A0  34         mov   @wyx,r14              ; Get YX
     621C 832A 
0373 621E 098E  56         srl   r14,8                 ; Right justify (remove X)
0374 6220 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6222 833A 
0375               *--------------------------------------------------------------
0376               * Do rest of calculation with R15 (16 bit part is there)
0377               * Re-use R14
0378               *--------------------------------------------------------------
0379 6224 C3A0  34         mov   @wyx,r14              ; Get YX
     6226 832A 
0380 6228 024E  22         andi  r14,>00ff             ; Remove Y
     622A 00FF 
0381 622C A3CE  18         a     r14,r15               ; pos = pos + X
0382 622E A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6230 8328 
0383               *--------------------------------------------------------------
0384               * Clean up before exit
0385               *--------------------------------------------------------------
0386 6232 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0387 6234 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0388 6236 020F  20         li    r15,vdpw              ; VDP write address
     6238 8C00 
0389 623A 045B  20         b     *r11
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
0404 623C C17B  30 putstr  mov   *r11+,tmp1
0405 623E D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0406 6240 C1CB  18 xutstr  mov   r11,tmp3
0407 6242 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6244 6218 
0408 6246 C2C7  18         mov   tmp3,r11
0409 6248 0986  56         srl   tmp2,8                ; Right justify length byte
0410 624A 0460  28         b     @xpym2v               ; Display string
     624C 625C 
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
0425 624E C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6250 832A 
0426 6252 0460  28         b     @putstr
     6254 623C 
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
0020 6256 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6258 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 625A C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 625C 0264  22 xpym2v  ori   tmp0,>4000
     625E 4000 
0027 6260 06C4  14         swpb  tmp0
0028 6262 D804  38         movb  tmp0,@vdpa
     6264 8C02 
0029 6266 06C4  14         swpb  tmp0
0030 6268 D804  38         movb  tmp0,@vdpa
     626A 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 626C 020F  20         li    r15,vdpw              ; Set VDP write address
     626E 8C00 
0035 6270 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6272 627A 
     6274 8320 
0036 6276 0460  28         b     @mcloop               ; Write data to VDP
     6278 8320 
0037 627A D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 627C C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 627E C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6280 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6282 06C4  14 xpyv2m  swpb  tmp0
0027 6284 D804  38         movb  tmp0,@vdpa
     6286 8C02 
0028 6288 06C4  14         swpb  tmp0
0029 628A D804  38         movb  tmp0,@vdpa
     628C 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 628E 020F  20         li    r15,vdpr              ; Set VDP read address
     6290 8800 
0034 6292 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6294 629C 
     6296 8320 
0035 6298 0460  28         b     @mcloop               ; Read data from VDP
     629A 8320 
0036 629C DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 629E C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 62A0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 62A2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 62A4 C186  18 xpym2m  mov    tmp2,tmp2            ; Bytes to copy = 0 ?
0031 62A6 1602  14         jne    cpym0
0032 62A8 0460  28         b      @crash               ; Yes, crash
     62AA 6056 
0033 62AC 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62AE 7FFF 
0034 62B0 C1C4  18         mov   tmp0,tmp3
0035 62B2 0247  22         andi  tmp3,1
     62B4 0001 
0036 62B6 1618  14         jne   cpyodd                ; Odd source address handling
0037 62B8 C1C5  18 cpym1   mov   tmp1,tmp3
0038 62BA 0247  22         andi  tmp3,1
     62BC 0001 
0039 62BE 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62C0 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62C2 6028 
0044 62C4 1605  14         jne   cpym3
0045 62C6 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62C8 62EE 
     62CA 8320 
0046 62CC 0460  28         b     @mcloop               ; Copy memory and exit
     62CE 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62D0 C1C6  18 cpym3   mov   tmp2,tmp3
0051 62D2 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62D4 0001 
0052 62D6 1301  14         jeq   cpym4
0053 62D8 0606  14         dec   tmp2                  ; Make TMP2 even
0054 62DA CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 62DC 0646  14         dect  tmp2
0056 62DE 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 62E0 C1C7  18         mov   tmp3,tmp3
0061 62E2 1301  14         jeq   cpymz
0062 62E4 D554  38         movb  *tmp0,*tmp1
0063 62E6 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 62E8 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     62EA 8000 
0068 62EC 10E9  14         jmp   cpym2
0069 62EE DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
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
0009 62F0 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     62F2 FFBF 
0010 62F4 0460  28         b     @putv01
     62F6 6164 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 62F8 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     62FA 0040 
0018 62FC 0460  28         b     @putv01
     62FE 6164 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 6300 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6302 FFDF 
0026 6304 0460  28         b     @putv01
     6306 6164 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6308 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     630A 0020 
0034 630C 0460  28         b     @putv01
     630E 6164 
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
0018 6310 C83B  50 at      mov   *r11+,@wyx
     6312 832A 
0019 6314 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6316 B820  54 down    ab    @hb$01,@wyx
     6318 6036 
     631A 832A 
0028 631C 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 631E 7820  54 up      sb    @hb$01,@wyx
     6320 6036 
     6322 832A 
0037 6324 045B  20         b     *r11
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
0049 6326 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6328 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     632A 832A 
0051 632C C804  38         mov   tmp0,@wyx             ; Save as new YX position
     632E 832A 
0052 6330 045B  20         b     *r11
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
0013 6332 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6334 06A0  32         bl    @putvr                ; Write once
     6336 6150 
0015 6338 391C             data  >391c                 ; VR1/57, value 00011100
0016 633A 06A0  32         bl    @putvr                ; Write twice
     633C 6150 
0017 633E 391C             data  >391c                 ; VR1/57, value 00011100
0018 6340 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 6342 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6344 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6346 6150 
0028 6348 391C             data  >391c
0029 634A 0458  20         b     *tmp4                 ; Exit
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
0040 634C C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 634E 06A0  32         bl    @cpym2v
     6350 6256 
0042 6352 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6354 6390 
     6356 0006 
0043 6358 06A0  32         bl    @putvr
     635A 6150 
0044 635C 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 635E 06A0  32         bl    @putvr
     6360 6150 
0046 6362 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 6364 0204  20         li    tmp0,>3f00
     6366 3F00 
0052 6368 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     636A 60E8 
0053 636C D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     636E 8800 
0054 6370 0984  56         srl   tmp0,8
0055 6372 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6374 8800 
0056 6376 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 6378 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 637A 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     637C BFFF 
0060 637E 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6380 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     6382 4000 
0063               f18chk_exit:
0064 6384 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6386 60BC 
0065 6388 3F00             data  >3f00,>00,6
     638A 0000 
     638C 0006 
0066 638E 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 6390 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 6392 3F00             data  >3f00                 ; 3f02 / 3f00
0073 6394 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6396 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 6398 06A0  32         bl    @putvr
     639A 6150 
0097 639C 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 639E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63A0 6150 
0100 63A2 391C             data  >391c                 ; Lock the F18a
0101 63A4 0458  20         b     *tmp4                 ; Exit
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
0120 63A6 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 63A8 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     63AA 602A 
0122 63AC 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 63AE C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     63B0 8802 
0127 63B2 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     63B4 6150 
0128 63B6 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 63B8 04C4  14         clr   tmp0
0130 63BA D120  34         movb  @vdps,tmp0
     63BC 8802 
0131 63BE 0984  56         srl   tmp0,8
0132 63C0 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0088 63C2 40A0  34         szc   @wbit11,config        ; Reset ANY key
     63C4 603E 
0089 63C6 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 63C8 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 63CA 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 63CC 0207  20         li    tmp3,kbmap0           ; Start with column 0
     63CE 643E 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 63D0 04CC  14         clr   r12
0097 63D2 1E15  20         sbz   >0015                 ; Set P5
0098 63D4 1F07  20         tb    7
0099 63D6 1302  14         jeq   virtk1
0100 63D8 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     63DA 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 63DC 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 63DE 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     63E0 0024 
0107 63E2 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 63E4 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     63E6 0006 
0109 63E8 0705  14         seto  tmp1                  ; >FFFF
0110 63EA 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 63EC 0545  14         inv   tmp1
0112 63EE 1302  14         jeq   virtk2                ; >0000 ?
0113 63F0 E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     63F2 603E 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 63F4 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 63F6 1601  14         jne   virtk3
0119 63F8 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 63FA 05C7  14 virtk3  inct  tmp3
0121 63FC 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     63FE 644A 
0122 6400 16F9  14         jne   virtk2                ; No, next entry
0123 6402 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 6404 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     6406 0700 
0128 6408 1309  14         jeq   virtk6                ; Yes, exit
0129 640A 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     640C 0200 
0130 640E 1303  14         jeq   virtk5                ; Yes, skip
0131 6410 0224  22         ai    tmp0,>0100
     6412 0100 
0132 6414 10E3  14         jmp   virtk1
0133 6416 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6418 0500 
0134 641A 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 641C C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 641E C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     6420 8332 
0140 6422 1601  14         jne   virtk7
0141 6424 045B  20         b     *r11                  ; Exit
0142 6426 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6428 FFFF 
0143 642A 1603  14         jne   virtk8                ; No
0144 642C 0701  14         seto  r1                    ; Set exit flag
0145 642E 0460  28         b     @runli1               ; Yes, reset computer
     6430 7158 
0146 6432 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     6434 8000 
0147 6436 1602  14         jne   virtk9
0148 6438 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     643A 603E 
0149 643C 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 643E 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     6440 FFFF 
0155 6442 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     6444 0020 
0156 6446 0400             data  >0400,kenter          ; >04 00000100  enter
     6448 4000 
0157 644A FFFF     kbeoc   data  >ffff
0158               
0159 644C 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     644E 1000 
0160 6450 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     6452 0008 
0161 6454 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6456 0004 
0162 6458 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     645A 0200 
0163 645C 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     645E 0040 
0164 6460 FFFF             data  >ffff
0165               
0166 6462 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     6464 2000 
0167 6466 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6468 0002 
0168 646A 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     646C 0100 
0169 646E 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     6470 0080 
0170 6472 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     6474 0010 
0171 6476 FFFF             data  >ffff
0172               
0173 6478 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     647A 0001 
0174 647C 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     647E 0800 
0175 6480 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     6482 0020 
0176 6484 FFFF             data  >ffff
0177               
0178 6486 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     6488 0020 
0179 648A 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     648C 0200 
0180 648E 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     6490 0100 
0181 6492 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     6494 0040 
0182 6496 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     6498 0080 
0183 649A FFFF             data  >ffff
0184               
0185 649C 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     649E 0001 
0186 64A0 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     64A2 0010 
0187 64A4 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     64A6 0008 
0188 64A8 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     64AA 0002 
0189 64AC 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     64AE 0004 
0190 64B0 FFFF             data  >ffff
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
0016 64B2 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64B4 6028 
0017 64B6 020C  20         li    r12,>0024
     64B8 0024 
0018 64BA 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64BC 654A 
0019 64BE 04C6  14         clr   tmp2
0020 64C0 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64C2 04CC  14         clr   r12
0025 64C4 1F08  20         tb    >0008                 ; Shift-key ?
0026 64C6 1302  14         jeq   realk1                ; No
0027 64C8 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64CA 657A 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64CC 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64CE 1302  14         jeq   realk2                ; No
0033 64D0 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64D2 65AA 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64D4 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64D6 1302  14         jeq   realk3                ; No
0039 64D8 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64DA 65DA 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64DC 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64DE 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64E0 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 64E2 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     64E4 6028 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 64E6 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 64E8 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64EA 0006 
0052 64EC 0606  14 realk5  dec   tmp2
0053 64EE 020C  20         li    r12,>24               ; CRU address for P2-P4
     64F0 0024 
0054 64F2 06C6  14         swpb  tmp2
0055 64F4 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64F6 06C6  14         swpb  tmp2
0057 64F8 020C  20         li    r12,6                 ; CRU read address
     64FA 0006 
0058 64FC 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 64FE 0547  14         inv   tmp3                  ;
0060 6500 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6502 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6504 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6506 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6508 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 650A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 650C 0285  22         ci    tmp1,8
     650E 0008 
0069 6510 1AFA  14         jl    realk6
0070 6512 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6514 1BEB  14         jh    realk5                ; No, next column
0072 6516 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6518 C206  18 realk8  mov   tmp2,tmp4
0077 651A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 651C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 651E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6520 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6522 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6524 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6526 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6528 6028 
0087 652A 1608  14         jne   realka                ; No, continue saving key
0088 652C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     652E 6574 
0089 6530 1A05  14         jl    realka
0090 6532 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6534 6572 
0091 6536 1B02  14         jh    realka                ; No, continue
0092 6538 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     653A E000 
0093 653C C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     653E 833C 
0094 6540 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6542 603E 
0095 6544 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6546 8C00 
0096 6548 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 654A FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     654C 0000 
     654E FF0D 
     6550 203D 
0099 6552 ....             text  'xws29ol.'
0100 655A ....             text  'ced38ik,'
0101 6562 ....             text  'vrf47ujm'
0102 656A ....             text  'btg56yhn'
0103 6572 ....             text  'zqa10p;/'
0104 657A FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     657C 0000 
     657E FF0D 
     6580 202B 
0105 6582 ....             text  'XWS@(OL>'
0106 658A ....             text  'CED#*IK<'
0107 6592 ....             text  'VRF$&UJM'
0108 659A ....             text  'BTG%^YHN'
0109 65A2 ....             text  'ZQA!)P:-'
0110 65AA FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65AC 0000 
     65AE FF0D 
     65B0 2005 
0111 65B2 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65B4 0804 
     65B6 0F27 
     65B8 C2B9 
0112 65BA 600B             data  >600b,>0907,>063f,>c1B8
     65BC 0907 
     65BE 063F 
     65C0 C1B8 
0113 65C2 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65C4 7B02 
     65C6 015F 
     65C8 C0C3 
0114 65CA BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65CC 7D0E 
     65CE 0CC6 
     65D0 BFC4 
0115 65D2 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65D4 7C03 
     65D6 BC22 
     65D8 BDBA 
0116 65DA FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65DC 0000 
     65DE FF0D 
     65E0 209D 
0117 65E2 9897             data  >9897,>93b2,>9f8f,>8c9B
     65E4 93B2 
     65E6 9F8F 
     65E8 8C9B 
0118 65EA 8385             data  >8385,>84b3,>9e89,>8b80
     65EC 84B3 
     65EE 9E89 
     65F0 8B80 
0119 65F2 9692             data  >9692,>86b4,>b795,>8a8D
     65F4 86B4 
     65F6 B795 
     65F8 8A8D 
0120 65FA 8294             data  >8294,>87b5,>b698,>888E
     65FC 87B5 
     65FE B698 
     6600 888E 
0121 6602 9A91             data  >9a91,>81b1,>b090,>9cBB
     6604 81B1 
     6606 B090 
     6608 9CBB 
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
0016 660A C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 660C C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     660E 8340 
0018 6610 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     6612 833C 
0019 6614 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 6616 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 6618 0647  14         dect  tmp3                  ; Back to WAUX1
0022 661A C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 661C 0205  20         li    tmp1,4
     661E 0004 
0027 6620 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 6622 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6624 000F 
0029 6626 A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 6628 06C6  14 mkhex2  swpb  tmp2
0031 662A DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 662C 0944  56         srl   tmp0,4                ; Next nibble
0033 662E 0605  14         dec   tmp1
0034 6630 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 6632 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6634 BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 6636 C160  34         mov   @waux3,tmp1           ; Get pointer
     6638 8340 
0040 663A 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 663C 0585  14         inc   tmp1                  ; Next byte, not word!
0042 663E C120  34         mov   @waux2,tmp0
     6640 833E 
0043 6642 06C4  14         swpb  tmp0
0044 6644 DD44  32         movb  tmp0,*tmp1+
0045 6646 06C4  14         swpb  tmp0
0046 6648 DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 664A C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     664C 8340 
0051 664E D520  46         movb  @bd4,*tmp0            ; Set lengh byte to 4
     6650 604E 
0052 6652 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 6654 C120  34         mov   @waux1,tmp0
     6656 833C 
0057 6658 06C4  14         swpb  tmp0
0058 665A DD44  32         movb  tmp0,*tmp1+
0059 665C 06C4  14         swpb  tmp0
0060 665E DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 6660 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6662 6028 
0065 6664 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 6666 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 6668 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     666A 7FFF 
0071 666C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     666E 8340 
0072 6670 0460  28         b     @xutst0               ; Display string
     6672 623E 
0073 6674 0610     prefix  data  >0610                 ; Length byte + blank
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
0087 6676 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6678 832A 
0088 667A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     667C 8000 
0089 667E 10C5  14         jmp   mkhex                 ; Convert number and display
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
0019 6680 0207  20 mknum   li    tmp3,5                ; Digit counter
     6682 0005 
0020 6684 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6686 C155  26         mov   *tmp1,tmp1            ; /
0022 6688 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 668A 0228  22         ai    tmp4,4                ; Get end of buffer
     668C 0004 
0024 668E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6690 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6692 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6694 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6696 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6698 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 669A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 669C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 669E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 66A0 0607  14         dec   tmp3                  ; Decrease counter
0036 66A2 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 66A4 0207  20         li    tmp3,4                ; Check first 4 digits
     66A6 0004 
0041 66A8 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 66AA C11B  26         mov   *r11,tmp0
0043 66AC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 66AE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 66B0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 66B2 05CB  14 mknum3  inct  r11
0047 66B4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     66B6 6028 
0048 66B8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 66BA 045B  20         b     *r11                  ; Exit
0050 66BC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 66BE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 66C0 13F8  14         jeq   mknum3                ; Yes, exit
0053 66C2 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 66C4 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     66C6 7FFF 
0058 66C8 C10B  18         mov   r11,tmp0
0059 66CA 0224  22         ai    tmp0,-4
     66CC FFFC 
0060 66CE C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 66D0 0206  20         li    tmp2,>0500            ; String length = 5
     66D2 0500 
0062 66D4 0460  28         b     @xutstr               ; Display string
     66D6 6240 
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
0092 66D8 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 66DA C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 66DC C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 66DE 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 66E0 0207  20         li    tmp3,5                ; Set counter
     66E2 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 66E4 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 66E6 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 66E8 0584  14         inc   tmp0                  ; Next character
0104 66EA 0607  14         dec   tmp3                  ; Last digit reached ?
0105 66EC 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 66EE 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 66F0 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 66F2 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 66F4 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 66F6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 66F8 0607  14         dec   tmp3                  ; Last character ?
0120 66FA 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 66FC 045B  20         b     *r11                  ; Return
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
0138 66FE C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6700 832A 
0139 6702 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6704 8000 
0140 6706 10BC  14         jmp   mknum                 ; Convert number and display
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
0030 6708 C13B  30         mov   *r11+,wmemory         ; First memory address
0031 670A C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx
0033 670C 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 670E 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * Next word
0037               *--------------------------------------------------------------
0038               calc_crc1
0039 6710 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2
0044 6712 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 6714 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 6716 C1C8  18         mov   wcrc,tmp3
0048 6718 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 671A 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 671C 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     671E 00FF 
0052               
0053 6720 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 6722 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 6724 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6726 674A 
0056               *--------------------------------------------------------------
0057               * Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3
0060 6728 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 672A 0246  22         andi  tmp2,>00ff            ; Clear MSB
     672C 00FF 
0062               
0063 672E C1C8  18         mov   wcrc,tmp3
0064 6730 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 6732 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 6734 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6736 00FF 
0068               
0069 6738 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 673A 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 673C 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     673E 674A 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 6740 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 6742 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 6744 04C7  14         clr   tmp3
0081 6746 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082 6748 045B  20         b     *r11                  ; Return
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
0095 674A 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     674C 1021 
     674E 2042 
     6750 3063 
     6752 4084 
     6754 50A5 
     6756 60C6 
     6758 70E7 
0096 675A 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     675C 9129 
     675E A14A 
     6760 B16B 
     6762 C18C 
     6764 D1AD 
     6766 E1CE 
     6768 F1EF 
0097 676A 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     676C 0210 
     676E 3273 
     6770 2252 
     6772 52B5 
     6774 4294 
     6776 72F7 
     6778 62D6 
0098 677A 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     677C 8318 
     677E B37B 
     6780 A35A 
     6782 D3BD 
     6784 C39C 
     6786 F3FF 
     6788 E3DE 
0099 678A 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     678C 3443 
     678E 0420 
     6790 1401 
     6792 64E6 
     6794 74C7 
     6796 44A4 
     6798 5485 
0100 679A A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     679C B54B 
     679E 8528 
     67A0 9509 
     67A2 E5EE 
     67A4 F5CF 
     67A6 C5AC 
     67A8 D58D 
0101 67AA 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     67AC 2672 
     67AE 1611 
     67B0 0630 
     67B2 76D7 
     67B4 66F6 
     67B6 5695 
     67B8 46B4 
0102 67BA B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     67BC A77A 
     67BE 9719 
     67C0 8738 
     67C2 F7DF 
     67C4 E7FE 
     67C6 D79D 
     67C8 C7BC 
0103 67CA 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     67CC 58E5 
     67CE 6886 
     67D0 78A7 
     67D2 0840 
     67D4 1861 
     67D6 2802 
     67D8 3823 
0104 67DA C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     67DC D9ED 
     67DE E98E 
     67E0 F9AF 
     67E2 8948 
     67E4 9969 
     67E6 A90A 
     67E8 B92B 
0105 67EA 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     67EC 4AD4 
     67EE 7AB7 
     67F0 6A96 
     67F2 1A71 
     67F4 0A50 
     67F6 3A33 
     67F8 2A12 
0106 67FA DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     67FC CBDC 
     67FE FBBF 
     6800 EB9E 
     6802 9B79 
     6804 8B58 
     6806 BB3B 
     6808 AB1A 
0107 680A 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     680C 7C87 
     680E 4CE4 
     6810 5CC5 
     6812 2C22 
     6814 3C03 
     6816 0C60 
     6818 1C41 
0108 681A EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     681C FD8F 
     681E CDEC 
     6820 DDCD 
     6822 AD2A 
     6824 BD0B 
     6826 8D68 
     6828 9D49 
0109 682A 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     682C 6EB6 
     682E 5ED5 
     6830 4EF4 
     6832 3E13 
     6834 2E32 
     6836 1E51 
     6838 0E70 
0110 683A FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     683C EFBE 
     683E DFDD 
     6840 CFFC 
     6842 BF1B 
     6844 AF3A 
     6846 9F59 
     6848 8F78 
0111 684A 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     684C 81A9 
     684E B1CA 
     6850 A1EB 
     6852 D10C 
     6854 C12D 
     6856 F14E 
     6858 E16F 
0112 685A 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     685C 00A1 
     685E 30C2 
     6860 20E3 
     6862 5004 
     6864 4025 
     6866 7046 
     6868 6067 
0113 686A 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     686C 9398 
     686E A3FB 
     6870 B3DA 
     6872 C33D 
     6874 D31C 
     6876 E37F 
     6878 F35E 
0114 687A 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     687C 1290 
     687E 22F3 
     6880 32D2 
     6882 4235 
     6884 5214 
     6886 6277 
     6888 7256 
0115 688A B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     688C A5CB 
     688E 95A8 
     6890 8589 
     6892 F56E 
     6894 E54F 
     6896 D52C 
     6898 C50D 
0116 689A 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     689C 24C3 
     689E 14A0 
     68A0 0481 
     68A2 7466 
     68A4 6447 
     68A6 5424 
     68A8 4405 
0117 68AA A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     68AC B7FA 
     68AE 8799 
     68B0 97B8 
     68B2 E75F 
     68B4 F77E 
     68B6 C71D 
     68B8 D73C 
0118 68BA 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     68BC 36F2 
     68BE 0691 
     68C0 16B0 
     68C2 6657 
     68C4 7676 
     68C6 4615 
     68C8 5634 
0119 68CA D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     68CC C96D 
     68CE F90E 
     68D0 E92F 
     68D2 99C8 
     68D4 89E9 
     68D6 B98A 
     68D8 A9AB 
0120 68DA 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     68DC 4865 
     68DE 7806 
     68E0 6827 
     68E2 18C0 
     68E4 08E1 
     68E6 3882 
     68E8 28A3 
0121 68EA CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     68EC DB5C 
     68EE EB3F 
     68F0 FB1E 
     68F2 8BF9 
     68F4 9BD8 
     68F6 ABBB 
     68F8 BB9A 
0122 68FA 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     68FC 5A54 
     68FE 6A37 
     6900 7A16 
     6902 0AF1 
     6904 1AD0 
     6906 2AB3 
     6908 3A92 
0123 690A FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     690C ED0F 
     690E DD6C 
     6910 CD4D 
     6912 BDAA 
     6914 AD8B 
     6916 9DE8 
     6918 8DC9 
0124 691A 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     691C 6C07 
     691E 5C64 
     6920 4C45 
     6922 3CA2 
     6924 2C83 
     6926 1CE0 
     6928 0CC1 
0125 692A EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     692C FF3E 
     692E CF5D 
     6930 DF7C 
     6932 AF9B 
     6934 BFBA 
     6936 8FD9 
     6938 9FF8 
0126 693A 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     693C 7E36 
     693E 4E55 
     6940 5E74 
     6942 2E93 
     6944 3EB2 
     6946 0ED1 
     6948 1EF0 
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
0021 694A C820  54         mov   @>8300,@>2000
     694C 8300 
     694E 2000 
0022 6950 C820  54         mov   @>8302,@>2002
     6952 8302 
     6954 2002 
0023 6956 C820  54         mov   @>8304,@>2004
     6958 8304 
     695A 2004 
0024 695C C820  54         mov   @>8306,@>2006
     695E 8306 
     6960 2006 
0025 6962 C820  54         mov   @>8308,@>2008
     6964 8308 
     6966 2008 
0026 6968 C820  54         mov   @>830A,@>200A
     696A 830A 
     696C 200A 
0027 696E C820  54         mov   @>830C,@>200C
     6970 830C 
     6972 200C 
0028 6974 C820  54         mov   @>830E,@>200E
     6976 830E 
     6978 200E 
0029 697A C820  54         mov   @>8310,@>2010
     697C 8310 
     697E 2010 
0030 6980 C820  54         mov   @>8312,@>2012
     6982 8312 
     6984 2012 
0031 6986 C820  54         mov   @>8314,@>2014
     6988 8314 
     698A 2014 
0032 698C C820  54         mov   @>8316,@>2016
     698E 8316 
     6990 2016 
0033 6992 C820  54         mov   @>8318,@>2018
     6994 8318 
     6996 2018 
0034 6998 C820  54         mov   @>831A,@>201A
     699A 831A 
     699C 201A 
0035 699E C820  54         mov   @>831C,@>201C
     69A0 831C 
     69A2 201C 
0036 69A4 C820  54         mov   @>831E,@>201E
     69A6 831E 
     69A8 201E 
0037 69AA C820  54         mov   @>8320,@>2020
     69AC 8320 
     69AE 2020 
0038 69B0 C820  54         mov   @>8322,@>2022
     69B2 8322 
     69B4 2022 
0039 69B6 C820  54         mov   @>8324,@>2024
     69B8 8324 
     69BA 2024 
0040 69BC C820  54         mov   @>8326,@>2026
     69BE 8326 
     69C0 2026 
0041 69C2 C820  54         mov   @>8328,@>2028
     69C4 8328 
     69C6 2028 
0042 69C8 C820  54         mov   @>832A,@>202A
     69CA 832A 
     69CC 202A 
0043 69CE C820  54         mov   @>832C,@>202C
     69D0 832C 
     69D2 202C 
0044 69D4 C820  54         mov   @>832E,@>202E
     69D6 832E 
     69D8 202E 
0045 69DA C820  54         mov   @>8330,@>2030
     69DC 8330 
     69DE 2030 
0046 69E0 C820  54         mov   @>8332,@>2032
     69E2 8332 
     69E4 2032 
0047 69E6 C820  54         mov   @>8334,@>2034
     69E8 8334 
     69EA 2034 
0048 69EC C820  54         mov   @>8336,@>2036
     69EE 8336 
     69F0 2036 
0049 69F2 C820  54         mov   @>8338,@>2038
     69F4 8338 
     69F6 2038 
0050 69F8 C820  54         mov   @>833A,@>203A
     69FA 833A 
     69FC 203A 
0051 69FE C820  54         mov   @>833C,@>203C
     6A00 833C 
     6A02 203C 
0052 6A04 C820  54         mov   @>833E,@>203E
     6A06 833E 
     6A08 203E 
0053 6A0A C820  54         mov   @>8340,@>2040
     6A0C 8340 
     6A0E 2040 
0054 6A10 C820  54         mov   @>8342,@>2042
     6A12 8342 
     6A14 2042 
0055 6A16 C820  54         mov   @>8344,@>2044
     6A18 8344 
     6A1A 2044 
0056 6A1C C820  54         mov   @>8346,@>2046
     6A1E 8346 
     6A20 2046 
0057 6A22 C820  54         mov   @>8348,@>2048
     6A24 8348 
     6A26 2048 
0058 6A28 C820  54         mov   @>834A,@>204A
     6A2A 834A 
     6A2C 204A 
0059 6A2E C820  54         mov   @>834C,@>204C
     6A30 834C 
     6A32 204C 
0060 6A34 C820  54         mov   @>834E,@>204E
     6A36 834E 
     6A38 204E 
0061 6A3A C820  54         mov   @>8350,@>2050
     6A3C 8350 
     6A3E 2050 
0062 6A40 C820  54         mov   @>8352,@>2052
     6A42 8352 
     6A44 2052 
0063 6A46 C820  54         mov   @>8354,@>2054
     6A48 8354 
     6A4A 2054 
0064 6A4C C820  54         mov   @>8356,@>2056
     6A4E 8356 
     6A50 2056 
0065 6A52 C820  54         mov   @>8358,@>2058
     6A54 8358 
     6A56 2058 
0066 6A58 C820  54         mov   @>835A,@>205A
     6A5A 835A 
     6A5C 205A 
0067 6A5E C820  54         mov   @>835C,@>205C
     6A60 835C 
     6A62 205C 
0068 6A64 C820  54         mov   @>835E,@>205E
     6A66 835E 
     6A68 205E 
0069 6A6A C820  54         mov   @>8360,@>2060
     6A6C 8360 
     6A6E 2060 
0070 6A70 C820  54         mov   @>8362,@>2062
     6A72 8362 
     6A74 2062 
0071 6A76 C820  54         mov   @>8364,@>2064
     6A78 8364 
     6A7A 2064 
0072 6A7C C820  54         mov   @>8366,@>2066
     6A7E 8366 
     6A80 2066 
0073 6A82 C820  54         mov   @>8368,@>2068
     6A84 8368 
     6A86 2068 
0074 6A88 C820  54         mov   @>836A,@>206A
     6A8A 836A 
     6A8C 206A 
0075 6A8E C820  54         mov   @>836C,@>206C
     6A90 836C 
     6A92 206C 
0076 6A94 C820  54         mov   @>836E,@>206E
     6A96 836E 
     6A98 206E 
0077 6A9A C820  54         mov   @>8370,@>2070
     6A9C 8370 
     6A9E 2070 
0078 6AA0 C820  54         mov   @>8372,@>2072
     6AA2 8372 
     6AA4 2072 
0079 6AA6 C820  54         mov   @>8374,@>2074
     6AA8 8374 
     6AAA 2074 
0080 6AAC C820  54         mov   @>8376,@>2076
     6AAE 8376 
     6AB0 2076 
0081 6AB2 C820  54         mov   @>8378,@>2078
     6AB4 8378 
     6AB6 2078 
0082 6AB8 C820  54         mov   @>837A,@>207A
     6ABA 837A 
     6ABC 207A 
0083 6ABE C820  54         mov   @>837C,@>207C
     6AC0 837C 
     6AC2 207C 
0084 6AC4 C820  54         mov   @>837E,@>207E
     6AC6 837E 
     6AC8 207E 
0085 6ACA C820  54         mov   @>8380,@>2080
     6ACC 8380 
     6ACE 2080 
0086 6AD0 C820  54         mov   @>8382,@>2082
     6AD2 8382 
     6AD4 2082 
0087 6AD6 C820  54         mov   @>8384,@>2084
     6AD8 8384 
     6ADA 2084 
0088 6ADC C820  54         mov   @>8386,@>2086
     6ADE 8386 
     6AE0 2086 
0089 6AE2 C820  54         mov   @>8388,@>2088
     6AE4 8388 
     6AE6 2088 
0090 6AE8 C820  54         mov   @>838A,@>208A
     6AEA 838A 
     6AEC 208A 
0091 6AEE C820  54         mov   @>838C,@>208C
     6AF0 838C 
     6AF2 208C 
0092 6AF4 C820  54         mov   @>838E,@>208E
     6AF6 838E 
     6AF8 208E 
0093 6AFA C820  54         mov   @>8390,@>2090
     6AFC 8390 
     6AFE 2090 
0094 6B00 C820  54         mov   @>8392,@>2092
     6B02 8392 
     6B04 2092 
0095 6B06 C820  54         mov   @>8394,@>2094
     6B08 8394 
     6B0A 2094 
0096 6B0C C820  54         mov   @>8396,@>2096
     6B0E 8396 
     6B10 2096 
0097 6B12 C820  54         mov   @>8398,@>2098
     6B14 8398 
     6B16 2098 
0098 6B18 C820  54         mov   @>839A,@>209A
     6B1A 839A 
     6B1C 209A 
0099 6B1E C820  54         mov   @>839C,@>209C
     6B20 839C 
     6B22 209C 
0100 6B24 C820  54         mov   @>839E,@>209E
     6B26 839E 
     6B28 209E 
0101 6B2A C820  54         mov   @>83A0,@>20A0
     6B2C 83A0 
     6B2E 20A0 
0102 6B30 C820  54         mov   @>83A2,@>20A2
     6B32 83A2 
     6B34 20A2 
0103 6B36 C820  54         mov   @>83A4,@>20A4
     6B38 83A4 
     6B3A 20A4 
0104 6B3C C820  54         mov   @>83A6,@>20A6
     6B3E 83A6 
     6B40 20A6 
0105 6B42 C820  54         mov   @>83A8,@>20A8
     6B44 83A8 
     6B46 20A8 
0106 6B48 C820  54         mov   @>83AA,@>20AA
     6B4A 83AA 
     6B4C 20AA 
0107 6B4E C820  54         mov   @>83AC,@>20AC
     6B50 83AC 
     6B52 20AC 
0108 6B54 C820  54         mov   @>83AE,@>20AE
     6B56 83AE 
     6B58 20AE 
0109 6B5A C820  54         mov   @>83B0,@>20B0
     6B5C 83B0 
     6B5E 20B0 
0110 6B60 C820  54         mov   @>83B2,@>20B2
     6B62 83B2 
     6B64 20B2 
0111 6B66 C820  54         mov   @>83B4,@>20B4
     6B68 83B4 
     6B6A 20B4 
0112 6B6C C820  54         mov   @>83B6,@>20B6
     6B6E 83B6 
     6B70 20B6 
0113 6B72 C820  54         mov   @>83B8,@>20B8
     6B74 83B8 
     6B76 20B8 
0114 6B78 C820  54         mov   @>83BA,@>20BA
     6B7A 83BA 
     6B7C 20BA 
0115 6B7E C820  54         mov   @>83BC,@>20BC
     6B80 83BC 
     6B82 20BC 
0116 6B84 C820  54         mov   @>83BE,@>20BE
     6B86 83BE 
     6B88 20BE 
0117 6B8A C820  54         mov   @>83C0,@>20C0
     6B8C 83C0 
     6B8E 20C0 
0118 6B90 C820  54         mov   @>83C2,@>20C2
     6B92 83C2 
     6B94 20C2 
0119 6B96 C820  54         mov   @>83C4,@>20C4
     6B98 83C4 
     6B9A 20C4 
0120 6B9C C820  54         mov   @>83C6,@>20C6
     6B9E 83C6 
     6BA0 20C6 
0121 6BA2 C820  54         mov   @>83C8,@>20C8
     6BA4 83C8 
     6BA6 20C8 
0122 6BA8 C820  54         mov   @>83CA,@>20CA
     6BAA 83CA 
     6BAC 20CA 
0123 6BAE C820  54         mov   @>83CC,@>20CC
     6BB0 83CC 
     6BB2 20CC 
0124 6BB4 C820  54         mov   @>83CE,@>20CE
     6BB6 83CE 
     6BB8 20CE 
0125 6BBA C820  54         mov   @>83D0,@>20D0
     6BBC 83D0 
     6BBE 20D0 
0126 6BC0 C820  54         mov   @>83D2,@>20D2
     6BC2 83D2 
     6BC4 20D2 
0127 6BC6 C820  54         mov   @>83D4,@>20D4
     6BC8 83D4 
     6BCA 20D4 
0128 6BCC C820  54         mov   @>83D6,@>20D6
     6BCE 83D6 
     6BD0 20D6 
0129 6BD2 C820  54         mov   @>83D8,@>20D8
     6BD4 83D8 
     6BD6 20D8 
0130 6BD8 C820  54         mov   @>83DA,@>20DA
     6BDA 83DA 
     6BDC 20DA 
0131 6BDE C820  54         mov   @>83DC,@>20DC
     6BE0 83DC 
     6BE2 20DC 
0132 6BE4 C820  54         mov   @>83DE,@>20DE
     6BE6 83DE 
     6BE8 20DE 
0133 6BEA C820  54         mov   @>83E0,@>20E0
     6BEC 83E0 
     6BEE 20E0 
0134 6BF0 C820  54         mov   @>83E2,@>20E2
     6BF2 83E2 
     6BF4 20E2 
0135 6BF6 C820  54         mov   @>83E4,@>20E4
     6BF8 83E4 
     6BFA 20E4 
0136 6BFC C820  54         mov   @>83E6,@>20E6
     6BFE 83E6 
     6C00 20E6 
0137 6C02 C820  54         mov   @>83E8,@>20E8
     6C04 83E8 
     6C06 20E8 
0138 6C08 C820  54         mov   @>83EA,@>20EA
     6C0A 83EA 
     6C0C 20EA 
0139 6C0E C820  54         mov   @>83EC,@>20EC
     6C10 83EC 
     6C12 20EC 
0140 6C14 C820  54         mov   @>83EE,@>20EE
     6C16 83EE 
     6C18 20EE 
0141 6C1A C820  54         mov   @>83F0,@>20F0
     6C1C 83F0 
     6C1E 20F0 
0142 6C20 C820  54         mov   @>83F2,@>20F2
     6C22 83F2 
     6C24 20F2 
0143 6C26 C820  54         mov   @>83F4,@>20F4
     6C28 83F4 
     6C2A 20F4 
0144 6C2C C820  54         mov   @>83F6,@>20F6
     6C2E 83F6 
     6C30 20F6 
0145 6C32 C820  54         mov   @>83F8,@>20F8
     6C34 83F8 
     6C36 20F8 
0146 6C38 C820  54         mov   @>83FA,@>20FA
     6C3A 83FA 
     6C3C 20FA 
0147 6C3E C820  54         mov   @>83FC,@>20FC
     6C40 83FC 
     6C42 20FC 
0148 6C44 C820  54         mov   @>83FE,@>20FE
     6C46 83FE 
     6C48 20FE 
0149 6C4A 045B  20         b     *r11                  ; Return to caller
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
0164 6C4C C820  54         mov   @>2000,@>8300
     6C4E 2000 
     6C50 8300 
0165 6C52 C820  54         mov   @>2002,@>8302
     6C54 2002 
     6C56 8302 
0166 6C58 C820  54         mov   @>2004,@>8304
     6C5A 2004 
     6C5C 8304 
0167 6C5E C820  54         mov   @>2006,@>8306
     6C60 2006 
     6C62 8306 
0168 6C64 C820  54         mov   @>2008,@>8308
     6C66 2008 
     6C68 8308 
0169 6C6A C820  54         mov   @>200A,@>830A
     6C6C 200A 
     6C6E 830A 
0170 6C70 C820  54         mov   @>200C,@>830C
     6C72 200C 
     6C74 830C 
0171 6C76 C820  54         mov   @>200E,@>830E
     6C78 200E 
     6C7A 830E 
0172 6C7C C820  54         mov   @>2010,@>8310
     6C7E 2010 
     6C80 8310 
0173 6C82 C820  54         mov   @>2012,@>8312
     6C84 2012 
     6C86 8312 
0174 6C88 C820  54         mov   @>2014,@>8314
     6C8A 2014 
     6C8C 8314 
0175 6C8E C820  54         mov   @>2016,@>8316
     6C90 2016 
     6C92 8316 
0176 6C94 C820  54         mov   @>2018,@>8318
     6C96 2018 
     6C98 8318 
0177 6C9A C820  54         mov   @>201A,@>831A
     6C9C 201A 
     6C9E 831A 
0178 6CA0 C820  54         mov   @>201C,@>831C
     6CA2 201C 
     6CA4 831C 
0179 6CA6 C820  54         mov   @>201E,@>831E
     6CA8 201E 
     6CAA 831E 
0180 6CAC C820  54         mov   @>2020,@>8320
     6CAE 2020 
     6CB0 8320 
0181 6CB2 C820  54         mov   @>2022,@>8322
     6CB4 2022 
     6CB6 8322 
0182 6CB8 C820  54         mov   @>2024,@>8324
     6CBA 2024 
     6CBC 8324 
0183 6CBE C820  54         mov   @>2026,@>8326
     6CC0 2026 
     6CC2 8326 
0184 6CC4 C820  54         mov   @>2028,@>8328
     6CC6 2028 
     6CC8 8328 
0185 6CCA C820  54         mov   @>202A,@>832A
     6CCC 202A 
     6CCE 832A 
0186 6CD0 C820  54         mov   @>202C,@>832C
     6CD2 202C 
     6CD4 832C 
0187 6CD6 C820  54         mov   @>202E,@>832E
     6CD8 202E 
     6CDA 832E 
0188 6CDC C820  54         mov   @>2030,@>8330
     6CDE 2030 
     6CE0 8330 
0189 6CE2 C820  54         mov   @>2032,@>8332
     6CE4 2032 
     6CE6 8332 
0190 6CE8 C820  54         mov   @>2034,@>8334
     6CEA 2034 
     6CEC 8334 
0191 6CEE C820  54         mov   @>2036,@>8336
     6CF0 2036 
     6CF2 8336 
0192 6CF4 C820  54         mov   @>2038,@>8338
     6CF6 2038 
     6CF8 8338 
0193 6CFA C820  54         mov   @>203A,@>833A
     6CFC 203A 
     6CFE 833A 
0194 6D00 C820  54         mov   @>203C,@>833C
     6D02 203C 
     6D04 833C 
0195 6D06 C820  54         mov   @>203E,@>833E
     6D08 203E 
     6D0A 833E 
0196 6D0C C820  54         mov   @>2040,@>8340
     6D0E 2040 
     6D10 8340 
0197 6D12 C820  54         mov   @>2042,@>8342
     6D14 2042 
     6D16 8342 
0198 6D18 C820  54         mov   @>2044,@>8344
     6D1A 2044 
     6D1C 8344 
0199 6D1E C820  54         mov   @>2046,@>8346
     6D20 2046 
     6D22 8346 
0200 6D24 C820  54         mov   @>2048,@>8348
     6D26 2048 
     6D28 8348 
0201 6D2A C820  54         mov   @>204A,@>834A
     6D2C 204A 
     6D2E 834A 
0202 6D30 C820  54         mov   @>204C,@>834C
     6D32 204C 
     6D34 834C 
0203 6D36 C820  54         mov   @>204E,@>834E
     6D38 204E 
     6D3A 834E 
0204 6D3C C820  54         mov   @>2050,@>8350
     6D3E 2050 
     6D40 8350 
0205 6D42 C820  54         mov   @>2052,@>8352
     6D44 2052 
     6D46 8352 
0206 6D48 C820  54         mov   @>2054,@>8354
     6D4A 2054 
     6D4C 8354 
0207 6D4E C820  54         mov   @>2056,@>8356
     6D50 2056 
     6D52 8356 
0208 6D54 C820  54         mov   @>2058,@>8358
     6D56 2058 
     6D58 8358 
0209 6D5A C820  54         mov   @>205A,@>835A
     6D5C 205A 
     6D5E 835A 
0210 6D60 C820  54         mov   @>205C,@>835C
     6D62 205C 
     6D64 835C 
0211 6D66 C820  54         mov   @>205E,@>835E
     6D68 205E 
     6D6A 835E 
0212 6D6C C820  54         mov   @>2060,@>8360
     6D6E 2060 
     6D70 8360 
0213 6D72 C820  54         mov   @>2062,@>8362
     6D74 2062 
     6D76 8362 
0214 6D78 C820  54         mov   @>2064,@>8364
     6D7A 2064 
     6D7C 8364 
0215 6D7E C820  54         mov   @>2066,@>8366
     6D80 2066 
     6D82 8366 
0216 6D84 C820  54         mov   @>2068,@>8368
     6D86 2068 
     6D88 8368 
0217 6D8A C820  54         mov   @>206A,@>836A
     6D8C 206A 
     6D8E 836A 
0218 6D90 C820  54         mov   @>206C,@>836C
     6D92 206C 
     6D94 836C 
0219 6D96 C820  54         mov   @>206E,@>836E
     6D98 206E 
     6D9A 836E 
0220 6D9C C820  54         mov   @>2070,@>8370
     6D9E 2070 
     6DA0 8370 
0221 6DA2 C820  54         mov   @>2072,@>8372
     6DA4 2072 
     6DA6 8372 
0222 6DA8 C820  54         mov   @>2074,@>8374
     6DAA 2074 
     6DAC 8374 
0223 6DAE C820  54         mov   @>2076,@>8376
     6DB0 2076 
     6DB2 8376 
0224 6DB4 C820  54         mov   @>2078,@>8378
     6DB6 2078 
     6DB8 8378 
0225 6DBA C820  54         mov   @>207A,@>837A
     6DBC 207A 
     6DBE 837A 
0226 6DC0 C820  54         mov   @>207C,@>837C
     6DC2 207C 
     6DC4 837C 
0227 6DC6 C820  54         mov   @>207E,@>837E
     6DC8 207E 
     6DCA 837E 
0228 6DCC C820  54         mov   @>2080,@>8380
     6DCE 2080 
     6DD0 8380 
0229 6DD2 C820  54         mov   @>2082,@>8382
     6DD4 2082 
     6DD6 8382 
0230 6DD8 C820  54         mov   @>2084,@>8384
     6DDA 2084 
     6DDC 8384 
0231 6DDE C820  54         mov   @>2086,@>8386
     6DE0 2086 
     6DE2 8386 
0232 6DE4 C820  54         mov   @>2088,@>8388
     6DE6 2088 
     6DE8 8388 
0233 6DEA C820  54         mov   @>208A,@>838A
     6DEC 208A 
     6DEE 838A 
0234 6DF0 C820  54         mov   @>208C,@>838C
     6DF2 208C 
     6DF4 838C 
0235 6DF6 C820  54         mov   @>208E,@>838E
     6DF8 208E 
     6DFA 838E 
0236 6DFC C820  54         mov   @>2090,@>8390
     6DFE 2090 
     6E00 8390 
0237 6E02 C820  54         mov   @>2092,@>8392
     6E04 2092 
     6E06 8392 
0238 6E08 C820  54         mov   @>2094,@>8394
     6E0A 2094 
     6E0C 8394 
0239 6E0E C820  54         mov   @>2096,@>8396
     6E10 2096 
     6E12 8396 
0240 6E14 C820  54         mov   @>2098,@>8398
     6E16 2098 
     6E18 8398 
0241 6E1A C820  54         mov   @>209A,@>839A
     6E1C 209A 
     6E1E 839A 
0242 6E20 C820  54         mov   @>209C,@>839C
     6E22 209C 
     6E24 839C 
0243 6E26 C820  54         mov   @>209E,@>839E
     6E28 209E 
     6E2A 839E 
0244 6E2C C820  54         mov   @>20A0,@>83A0
     6E2E 20A0 
     6E30 83A0 
0245 6E32 C820  54         mov   @>20A2,@>83A2
     6E34 20A2 
     6E36 83A2 
0246 6E38 C820  54         mov   @>20A4,@>83A4
     6E3A 20A4 
     6E3C 83A4 
0247 6E3E C820  54         mov   @>20A6,@>83A6
     6E40 20A6 
     6E42 83A6 
0248 6E44 C820  54         mov   @>20A8,@>83A8
     6E46 20A8 
     6E48 83A8 
0249 6E4A C820  54         mov   @>20AA,@>83AA
     6E4C 20AA 
     6E4E 83AA 
0250 6E50 C820  54         mov   @>20AC,@>83AC
     6E52 20AC 
     6E54 83AC 
0251 6E56 C820  54         mov   @>20AE,@>83AE
     6E58 20AE 
     6E5A 83AE 
0252 6E5C C820  54         mov   @>20B0,@>83B0
     6E5E 20B0 
     6E60 83B0 
0253 6E62 C820  54         mov   @>20B2,@>83B2
     6E64 20B2 
     6E66 83B2 
0254 6E68 C820  54         mov   @>20B4,@>83B4
     6E6A 20B4 
     6E6C 83B4 
0255 6E6E C820  54         mov   @>20B6,@>83B6
     6E70 20B6 
     6E72 83B6 
0256 6E74 C820  54         mov   @>20B8,@>83B8
     6E76 20B8 
     6E78 83B8 
0257 6E7A C820  54         mov   @>20BA,@>83BA
     6E7C 20BA 
     6E7E 83BA 
0258 6E80 C820  54         mov   @>20BC,@>83BC
     6E82 20BC 
     6E84 83BC 
0259 6E86 C820  54         mov   @>20BE,@>83BE
     6E88 20BE 
     6E8A 83BE 
0260 6E8C C820  54         mov   @>20C0,@>83C0
     6E8E 20C0 
     6E90 83C0 
0261 6E92 C820  54         mov   @>20C2,@>83C2
     6E94 20C2 
     6E96 83C2 
0262 6E98 C820  54         mov   @>20C4,@>83C4
     6E9A 20C4 
     6E9C 83C4 
0263 6E9E C820  54         mov   @>20C6,@>83C6
     6EA0 20C6 
     6EA2 83C6 
0264 6EA4 C820  54         mov   @>20C8,@>83C8
     6EA6 20C8 
     6EA8 83C8 
0265 6EAA C820  54         mov   @>20CA,@>83CA
     6EAC 20CA 
     6EAE 83CA 
0266 6EB0 C820  54         mov   @>20CC,@>83CC
     6EB2 20CC 
     6EB4 83CC 
0267 6EB6 C820  54         mov   @>20CE,@>83CE
     6EB8 20CE 
     6EBA 83CE 
0268 6EBC C820  54         mov   @>20D0,@>83D0
     6EBE 20D0 
     6EC0 83D0 
0269 6EC2 C820  54         mov   @>20D2,@>83D2
     6EC4 20D2 
     6EC6 83D2 
0270 6EC8 C820  54         mov   @>20D4,@>83D4
     6ECA 20D4 
     6ECC 83D4 
0271 6ECE C820  54         mov   @>20D6,@>83D6
     6ED0 20D6 
     6ED2 83D6 
0272 6ED4 C820  54         mov   @>20D8,@>83D8
     6ED6 20D8 
     6ED8 83D8 
0273 6EDA C820  54         mov   @>20DA,@>83DA
     6EDC 20DA 
     6EDE 83DA 
0274 6EE0 C820  54         mov   @>20DC,@>83DC
     6EE2 20DC 
     6EE4 83DC 
0275 6EE6 C820  54         mov   @>20DE,@>83DE
     6EE8 20DE 
     6EEA 83DE 
0276 6EEC C820  54         mov   @>20E0,@>83E0
     6EEE 20E0 
     6EF0 83E0 
0277 6EF2 C820  54         mov   @>20E2,@>83E2
     6EF4 20E2 
     6EF6 83E2 
0278 6EF8 C820  54         mov   @>20E4,@>83E4
     6EFA 20E4 
     6EFC 83E4 
0279 6EFE C820  54         mov   @>20E6,@>83E6
     6F00 20E6 
     6F02 83E6 
0280 6F04 C820  54         mov   @>20E8,@>83E8
     6F06 20E8 
     6F08 83E8 
0281 6F0A C820  54         mov   @>20EA,@>83EA
     6F0C 20EA 
     6F0E 83EA 
0282 6F10 C820  54         mov   @>20EC,@>83EC
     6F12 20EC 
     6F14 83EC 
0283 6F16 C820  54         mov   @>20EE,@>83EE
     6F18 20EE 
     6F1A 83EE 
0284 6F1C C820  54         mov   @>20F0,@>83F0
     6F1E 20F0 
     6F20 83F0 
0285 6F22 C820  54         mov   @>20F2,@>83F2
     6F24 20F2 
     6F26 83F2 
0286 6F28 C820  54         mov   @>20F4,@>83F4
     6F2A 20F4 
     6F2C 83F4 
0287 6F2E C820  54         mov   @>20F6,@>83F6
     6F30 20F6 
     6F32 83F6 
0288 6F34 C820  54         mov   @>20F8,@>83F8
     6F36 20F8 
     6F38 83F8 
0289 6F3A C820  54         mov   @>20FA,@>83FA
     6F3C 20FA 
     6F3E 83FA 
0290 6F40 C820  54         mov   @>20FC,@>83FC
     6F42 20FC 
     6F44 83FC 
0291 6F46 C820  54         mov   @>20FE,@>83FE
     6F48 20FE 
     6F4A 83FE 
0292 6F4C 045B  20         b     *r11                  ; Return to caller
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
0024 6F4E C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6F50 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6F52 8300 
0030 6F54 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6F56 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     6F58 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6F5A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6F5C 0606  14         dec   tmp2
0037 6F5E 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6F60 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6F62 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6F64 6F6A 
0043                                                   ; R14=PC
0044 6F66 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6F68 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6F6A 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6F6C 6C4C 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6F6E 045B  20         b     *r11                  ; Return to caller
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
0008               ***************************************************************
0009               * >8300 - >83ff       Equates for DSRLNK (alternative layout)
0010               ***************************************************************
0011               * Equates are used in DSRLNK.
0012               * Scratchpad memory needs to be paged out before use of DSRLNK.
0013               ********@*****@*********************@**************************
0014      8320     haa     equ   >8320                 ; Loaded with HI-byte value >aa
0015      8322     sav8a   equ   >8322                 ; Contains >08 or >0a
0016               
0017               
0018               
0019               **** Low memory expansion. Official documentation?
0020      2100     namsto  equ   >2100                 ; 8-byte buffer for device name
0021      B000     dsrlws  equ   >b000                 ; dsrlnk workspace
0022      B00A     dstype  equ   >b00a                 ; dstype is address of R5 of DSRLNK ws
0023               
0024               
0025               
0026               ***************************************************************
0027               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
0028               ***************************************************************
0029               *  blwp @dsrlnk
0030               *  data p0
0031               *--------------------------------------------------------------
0032               *  P0 = 8 or 10 (a)
0033               *--------------------------------------------------------------
0034               ; dsrlnk routine
0035               ;
0036               ; Scratchpad memory used in DSRLNK
0037               ;
0038               ; >8356            Pointer to PAB
0039               ; >83D0            CRU address of current device
0040               ; >83D2            DSR entry address
0041               ; >83e0 - >83ff    GPL/DSRLNK workspace
0042               ;
0043               ; Credits
0044               ; Originally appeared in Miller Graphics The Smart Programmer.
0045               ; Enhanced by Paolo Bagnaresi.
0046               *--------------------------------------------------------------
0047 6F70 B000     dsrlnk  data  dsrlws               ; dsrlnk workspace
0048 6F72 6F74             data  dsrlnk.init          ; entry point
0049                       ;------------------------------------------------------
0050                       ; DSRLNK entry point
0051                       ;------------------------------------------------------
0052               dsrlnk.init:
0053 6F74 0200  20         li    r0,>aa00
     6F76 AA00 
0054 6F78 D800  38         movb  r0,@haa              ; load haa at @>8320
     6F7A 8320 
0055 6F7C C17E  30         mov   *r14+,r5             ; get pgm type for link
0056 6F7E C805  38         mov   r5,@sav8a            ; save data following blwp @dsrlnk (8 or >a)
     6F80 8322 
0057 6F82 53E0  34         szcb  @h20,r15             ; reset equal bit
     6F84 708C 
0058 6F86 C020  34         mov   @>8356,r0            ; get ptr to pab
     6F88 8356 
0059 6F8A C240  18         mov   r0,r9                ; save ptr
0060                       ;------------------------------------------------------
0061                       ; Fetch file descriptor length from PAB
0062                       ;------------------------------------------------------
0063 6F8C 0229  22         ai    r9,>fff8             ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6F8E FFF8 
0064               
0065                       ;--------------------------; Inline VSBR start
0066 6F90 06C0  14         swpb  r0                   ;
0067 6F92 D800  38         movb  r0,@vdpa             ; send low byte
     6F94 8C02 
0068 6F96 06C0  14         swpb  r0                   ;
0069 6F98 D800  38         movb  r0,@vdpa             ; send high byte
     6F9A 8C02 
0070 6F9C D0E0  34         movb  @vdpr,r3             ; read byte from VDP ram
     6F9E 8800 
0071                       ;--------------------------; Inline VSBR end
0072 6FA0 0983  56         srl   r3,8                 ; Move to low byte
0073                       ;------------------------------------------------------
0074                       ; Fetch file descriptor device name from PAB
0075                       ;------------------------------------------------------
0076 6FA2 0704  14         seto  r4                   ; init counter
0077 6FA4 0202  20         li    r2,namsto            ; point to 8-byte buffer
     6FA6 2100 
0078 6FA8 0580  14 !       inc   r0                   ; point to next char of name
0079 6FAA 0584  14         inc   r4                   ; incr char counter
0080 6FAC 0284  22         ci    r4,>0007             ; see if length more than 7 chars
     6FAE 0007 
0081 6FB0 1565  14         jgt   dsrlnk.error.devicename_invalid
0082                                                  ; yes, error
0083 6FB2 80C4  18         c     r4,r3                ; end of name?
0084 6FB4 130C  14         jeq   dsrlnk.device_name.get_length
0085                                                  ; yes
0086               
0087                       ;--------------------------; Inline VSBR start
0088 6FB6 06C0  14         swpb  r0                   ;
0089 6FB8 D800  38         movb  r0,@vdpa             ; send low byte
     6FBA 8C02 
0090 6FBC 06C0  14         swpb  r0                   ;
0091 6FBE D800  38         movb  r0,@vdpa             ; send high byte
     6FC0 8C02 
0092 6FC2 D060  34         movb  @vdpr,r1             ; read byte from VDP ram
     6FC4 8800 
0093                       ;--------------------------; Inline VSBR end
0094               
0095 6FC6 DC81  32         movb  r1,*r2+              ; move into buffer
0096 6FC8 9801  38         cb    r1,@decmal           ; is it a '.' period?
     6FCA 708A 
0097 6FCC 16ED  14         jne   -!                   ; no, loop next char
0098                       ;------------------------------------------------------
0099                       ; Determine device name length
0100                       ;------------------------------------------------------
0101               dsrlnk.device_name.get_length:
0102 6FCE C104  18         mov   r4,r4                ; Check if length = 0
0103 6FD0 1355  14         jeq   dsrlnk.error.devicename_invalid
0104                                                  ; yes, error
0105 6FD2 04E0  34         clr   @>83d0
     6FD4 83D0 
0106 6FD6 C804  38         mov   r4,@>8354            ; save name length for search
     6FD8 8354 
0107 6FDA 0584  14         inc   r4                   ; adjust for dot
0108 6FDC A804  38         a     r4,@>8356            ; point to position after name
     6FDE 8356 
0109                       ;------------------------------------------------------
0110                       ; Prepare for DSR scan >1000 - >1f00
0111                       ;------------------------------------------------------
0112               dsrlnk.dsrscan.start:
0113 6FE0 02E0  18         lwpi  >83e0                ; use gplws
     6FE2 83E0 
0114 6FE4 04C1  14         clr   r1                   ; version found of dsr
0115 6FE6 020C  20         li    r12,>0f00            ; init cru addr
     6FE8 0F00 
0116                       ;------------------------------------------------------
0117                       ; Turn off ROM on current card
0118                       ;------------------------------------------------------
0119               dsrlnk.dsrscan.cardoff:
0120 6FEA C30C  18         mov   r12,r12              ; anything to turn off?
0121 6FEC 1301  14         jeq   dsrlnk.dsrscan.cardloop
0122                                                  ; no, loop over cards
0123 6FEE 1E00  20         sbz   0                    ; yes, turn off
0124                       ;------------------------------------------------------
0125                       ; Loop over cards and look if DSR present
0126                       ;------------------------------------------------------
0127               dsrlnk.dsrscan.cardloop:
0128 6FF0 022C  22         ai    r12,>0100            ; next rom to turn on
     6FF2 0100 
0129 6FF4 04E0  34         clr   @>83d0               ; clear in case we are done
     6FF6 83D0 
0130 6FF8 028C  22         ci    r12,>2000            ; Card scan complete? (>1000 to >1F00)
     6FFA 2000 
0131 6FFC 133D  14         jeq   dsrlnk.error.nodsr_found
0132                                                  ; yes, no matching DSR found
0133 6FFE C80C  38         mov   r12,@>83d0           ; save addr of next cru
     7000 83D0 
0134                       ;------------------------------------------------------
0135                       ; Look at card ROM (@>4000 eq 'AA' ?)
0136                       ;------------------------------------------------------
0137 7002 1D00  20         sbo   0                    ; turn on rom
0138 7004 0202  20         li    r2,>4000             ; start at beginning of rom
     7006 4000 
0139 7008 9812  46         cb    *r2,@haa             ; check for a valid DSR header
     700A 8320 
0140 700C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0141                                                  ; no rom found on card
0142                       ;------------------------------------------------------
0143                       ; Valid DSR ROM found. Now loop over chain/subprograms
0144                       ;------------------------------------------------------
0145                       ; dstype is the address of R5 of the DSRLNK workspace,
0146                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0147                       ; is stored before the DSR ROM is searched.
0148                       ;------------------------------------------------------
0149 700E A0A0  34         a     @dstype,r2           ; go to first pointer (byte 8 or 10)
     7010 B00A 
0150 7012 1003  14         jmp   dsrlnk.dsrscan.getentry
0151                       ;------------------------------------------------------
0152                       ; Next DSR entry
0153                       ;------------------------------------------------------
0154               dsrlnk.dsrscan.nextentry:
0155 7014 C0A0  34         mov   @>83d2,r2            ; Offset 0 > Fetch link to next DSR or subprogram
     7016 83D2 
0156 7018 1D00  20         sbo   0                    ; turn rom back on
0157                       ;------------------------------------------------------
0158                       ; Get DSR entry
0159                       ;------------------------------------------------------
0160               dsrlnk.dsrscan.getentry:
0161 701A C092  26         mov   *r2,r2               ; is addr a zero? (end of chain?)
0162 701C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0163                                                  ; yes, no more DSRs or programs to check
0164 701E C802  38         mov   r2,@>83d2            ; Offset 0 > Store link to next DSR or subprogram
     7020 83D2 
0165 7022 05C2  14         inct  r2                   ; Offset 2 > Has call address of current DSR/subprogram code
0166 7024 C272  30         mov   *r2+,r9              ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0167                       ;------------------------------------------------------
0168                       ; Check file descriptor in DSR
0169                       ;------------------------------------------------------
0170 7026 04C5  14         clr   r5                   ; Remove any old stuff
0171 7028 D160  34         movb  @>8355,r5            ; get length as counter
     702A 8355 
0172 702C 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0173                                                  ; if zero, do not further check, call DSR program
0174 702E 9C85  32         cb    r5,*r2+              ; see if length matches
0175 7030 16F1  14         jne   dsrlnk.dsrscan.nextentry
0176                                                  ; no, length does not match. Go process next DSR entry
0177 7032 0985  56         srl   r5,8                 ; yes, move to low byte
0178 7034 0206  20         li    r6,namsto            ; Point to 8-byte CPU buffer
     7036 2100 
0179 7038 9CB6  42 !       cb    *r6+,*r2+            ; compare byte in CPU buffer with byte in DSR ROM
0180 703A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0181                                                  ; try next DSR entry if no match
0182 703C 0605  14         dec   r5                   ; loop until full length checked
0183 703E 16FC  14         jne   -!
0184                       ;------------------------------------------------------
0185                       ; Device name/Subprogram match
0186                       ;------------------------------------------------------
0187               dsrlnk.dsrscan.match:
0188 7040 C802  38         mov   r2,@>83d2            ; DSR entry addr must be saved at @>83d2
     7042 83D2 
0189               
0190                       ;------------------------------------------------------
0191                       ; Call DSR program in device card
0192                       ;------------------------------------------------------
0193               dsrlnk.dsrscan.call_dsr:
0194 7044 0581  14         inc   r1                   ; next version found
0195 7046 0699  24         bl    *r9                  ; go run routine
0196                       ;
0197                       ; Depending on IO result the DSR in card ROM does RET
0198                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0199                       ;
0200 7048 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0201                                                  ; (1) error return
0202 704A 1E00  20         sbz   0                    ; (2) turn off rom if good return
0203 704C 02E0  18         lwpi  dsrlws               ; (2) restore workspace
     704E B000 
0204 7050 C009  18         mov   r9,r0                ; point to flag in pab
0205 7052 C060  34         mov   @sav8a,r1            ; get back data following blwp @dsrlnk
     7054 8322 
0206                                                  ; (8 or >a)
0207 7056 0281  22         ci    r1,8                 ; was it 8?
     7058 0008 
0208 705A 1303  14         jeq   dsrlnk.dsrscan.dsr.8 ; yes, jump: normal dsrlnk
0209 705C D060  34         movb  @>8350,r1            ; no, we have a data >a.
     705E 8350 
0210                                                  ; Get error byte from @>8350
0211 7060 1000  14         jmp   dsrlnk.dsrscan.dsr.8 ; go and return error byte to the caller
0212               
0213                       ;------------------------------------------------------
0214                       ; Read PAB status flag after DSR call completed
0215                       ;------------------------------------------------------
0216               dsrlnk.dsrscan.dsr.8:
0217                       ;--------------------------; Inline VSBR start
0218 7062 06C0  14         swpb  r0                   ;
0219 7064 D800  38         movb  r0,@vdpa             ; send low byte
     7066 8C02 
0220 7068 06C0  14         swpb  r0                   ;
0221 706A D800  38         movb  r0,@vdpa             ; send high byte
     706C 8C02 
0222 706E D060  34         movb  @vdpr,r1             ; read byte from VDP ram
     7070 8800 
0223                       ;--------------------------; Inline VSBR end
0224               
0225                       ;------------------------------------------------------
0226                       ; Return DSR error to caller
0227                       ;------------------------------------------------------
0228               dsrlnk.dsrscan.dsr.a:
0229 7072 09D1  56         srl   r1,13                ; just keep error bits
0230 7074 1604  14         jne   dsrlnk.error.io_error
0231                                                  ; handle IO error
0232 7076 0380  18         rtwp                       ; Return from DSR workspace to caller workspace
0233               
0234                       ;------------------------------------------------------
0235                       ; IO-error handler
0236                       ;------------------------------------------------------
0237               dsrlnk.error.nodsr_found:
0238 7078 02E0  18         lwpi  dsrlws               ; No DSR found, restore workspace
     707A B000 
0239               dsrlnk.error.devicename_invalid:
0240 707C 04C1  14         clr   r1                   ; clear flag for error 0 = bad device name
0241               dsrlnk.error.io_error:
0242 707E 06C1  14         swpb  r1                   ; put error in hi byte
0243 7080 D741  30         movb  r1,*r13              ; store error flags in callers r0
0244 7082 F3E0  34         socb  @h20,r15             ; set equal bit to indicate error
     7084 708C 
0245 7086 0380  18         rtwp                       ; Return from DSR workspace to caller workspace
0246               
0247               ****************************************************************************************
0248               
0249 7088 0008     data8   data  >8                   ; just to compare. 8 is the data that
0250                                                  ; usually follows a blwp @dsrlnk
0251 708A ....     decmal  text  '.'                  ; for finding end of device name
0252                       even
0253 708C 2000     h20     data  >2000
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
0209                       copy  "timers_tmgr.asm"    ; Timers/Thread scheduler
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
0020 708E 0300  24 tmgr    limi  0                     ; No interrupt processing
     7090 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 7092 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     7094 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 7096 2360  38         coc   @wbit2,r13            ; C flag on ?
     7098 602C 
0029 709A 1602  14         jne   tmgr1a                ; No, so move on
0030 709C E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     709E 6040 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 70A0 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     70A2 6028 
0035 70A4 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 70A6 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     70A8 6038 
0048 70AA 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 70AC 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     70AE 603A 
0050 70B0 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 70B2 0460  28         b     @kthread              ; Run kernel thread
     70B4 712C 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 70B6 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     70B8 6034 
0056 70BA 13EB  14         jeq   tmgr1
0057 70BC 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     70BE 6036 
0058 70C0 16E8  14         jne   tmgr1
0059 70C2 C120  34         mov   @wtiusr,tmp0
     70C4 832E 
0060 70C6 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 70C8 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     70CA 712A 
0065 70CC C10A  18         mov   r10,tmp0
0066 70CE 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     70D0 00FF 
0067 70D2 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     70D4 602C 
0068 70D6 1303  14         jeq   tmgr5
0069 70D8 0284  22         ci    tmp0,60               ; 1 second reached ?
     70DA 003C 
0070 70DC 1002  14         jmp   tmgr6
0071 70DE 0284  22 tmgr5   ci    tmp0,50
     70E0 0032 
0072 70E2 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 70E4 1001  14         jmp   tmgr8
0074 70E6 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 70E8 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     70EA 832C 
0079 70EC 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     70EE FF00 
0080 70F0 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 70F2 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 70F4 05C4  14         inct  tmp0                  ; Second word of slot data
0086 70F6 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 70F8 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 70FA 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     70FC 830C 
     70FE 830D 
0089 7100 1608  14         jne   tmgr10                ; No, get next slot
0090 7102 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     7104 FF00 
0091 7106 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 7108 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     710A 8330 
0096 710C 0697  24         bl    *tmp3                 ; Call routine in slot
0097 710E C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     7110 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 7112 058A  14 tmgr10  inc   r10                   ; Next slot
0102 7114 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     7116 8315 
     7118 8314 
0103 711A 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 711C 05C4  14         inct  tmp0                  ; Offset for next slot
0105 711E 10E8  14         jmp   tmgr9                 ; Process next slot
0106 7120 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 7122 10F7  14         jmp   tmgr10                ; Process next slot
0108 7124 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     7126 FF00 
0109 7128 10B4  14         jmp   tmgr1
0110 712A 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0210                       copy  "timers_kthread.asm" ; Timers/Kernel thread
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
0015 712C E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     712E 6038 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 7130 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     7132 63C2 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 7134 06A0  32         bl    @realkb               ; Scan full keyboard
     7136 64B2 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 7138 0460  28         b     @tmgr3                ; Exit
     713A 70B6 
**** **** ****     > runlib.asm
0211               
0215               
0216               
0217               
0218               
0219               
0220               ***************************************************************
0221               * MKHOOK - Allocate user hook
0222               ***************************************************************
0223               *  BL    @MKHOOK
0224               *  DATA  P0
0225               *--------------------------------------------------------------
0226               *  P0 = Address of user hook
0227               *--------------------------------------------------------------
0228               *  REMARKS
0229               *  The user hook gets executed after the kernel thread.
0230               *  The user hook must always exit with "B @HOOKOK"
0231               ********@*****@*********************@**************************
0232 713C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     713E 832E 
0233 7140 E0A0  34         soc   @wbit7,config         ; Enable user hook
     7142 6036 
0234 7144 045B  20 mkhoo1  b     *r11                  ; Return
0235      7092     hookok  equ   tmgr1                 ; Exit point for user hook
0236               
0237               
0238               ***************************************************************
0239               * CLHOOK - Clear user hook
0240               ***************************************************************
0241               *  BL    @CLHOOK
0242               ********@*****@*********************@**************************
0243 7146 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     7148 832E 
0244 714A 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     714C FEFF 
0245 714E 045B  20         b     *r11                  ; Return
0246               
0247               
0248               
0249               *//////////////////////////////////////////////////////////////
0250               *                    RUNLIB INITIALISATION
0251               *//////////////////////////////////////////////////////////////
0252               
0253               ***************************************************************
0254               *  RUNLIB - Runtime library initalisation
0255               ***************************************************************
0256               *  B  @RUNLIB
0257               *--------------------------------------------------------------
0258               *  REMARKS
0259               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0260               *  after clearing scratchpad memory.
0261               *  Use 'B @RUNLI1' to exit your program.
0262               ********@*****@*********************@**************************
0264 7150 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     7152 694A 
0265 7154 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7156 8302 
0269               *--------------------------------------------------------------
0270               * Alternative entry point
0271               *--------------------------------------------------------------
0272 7158 0300  24 runli1  limi  0                     ; Turn off interrupts
     715A 0000 
0273 715C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     715E 8300 
0274 7160 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     7162 83C0 
0275               *--------------------------------------------------------------
0276               * Clear scratch-pad memory from R4 upwards
0277               *--------------------------------------------------------------
0278 7164 0202  20 runli2  li    r2,>8308
     7166 8308 
0279 7168 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0280 716A 0282  22         ci    r2,>8400
     716C 8400 
0281 716E 16FC  14         jne   runli3
0282               *--------------------------------------------------------------
0283               * Exit to TI-99/4A title screen ?
0284               *--------------------------------------------------------------
0285 7170 0281  22         ci    r1,>ffff              ; Exit flag set ?
     7172 FFFF 
0286 7174 1602  14         jne   runli4                ; No, continue
0287 7176 0420  54         blwp  @0                    ; Yes, bye bye
     7178 0000 
0288               *--------------------------------------------------------------
0289               * Determine if VDP is PAL or NTSC
0290               *--------------------------------------------------------------
0291 717A C803  38 runli4  mov   r3,@waux1             ; Store random seed
     717C 833C 
0292 717E 04C1  14         clr   r1                    ; Reset counter
0293 7180 0202  20         li    r2,10                 ; We test 10 times
     7182 000A 
0294 7184 C0E0  34 runli5  mov   @vdps,r3
     7186 8802 
0295 7188 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     718A 6028 
0296 718C 1302  14         jeq   runli6
0297 718E 0581  14         inc   r1                    ; Increase counter
0298 7190 10F9  14         jmp   runli5
0299 7192 0602  14 runli6  dec   r2                    ; Next test
0300 7194 16F7  14         jne   runli5
0301 7196 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7198 1250 
0302 719A 1202  14         jle   runli7                ; No, so it must be NTSC
0303 719C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     719E 602C 
0304               *--------------------------------------------------------------
0305               * Copy machine code to scratchpad (prepare tight loop)
0306               *--------------------------------------------------------------
0307 71A0 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     71A2 6082 
0308 71A4 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     71A6 8322 
0309 71A8 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0310 71AA CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0311 71AC CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0312               *--------------------------------------------------------------
0313               * Initialize registers, memory, ...
0314               *--------------------------------------------------------------
0315 71AE 04C1  14 runli9  clr   r1
0316 71B0 04C2  14         clr   r2
0317 71B2 04C3  14         clr   r3
0318 71B4 0209  20         li    stack,>8400           ; Set stack
     71B6 8400 
0319 71B8 020F  20         li    r15,vdpw              ; Set VDP write address
     71BA 8C00 
0323               *--------------------------------------------------------------
0324               * Setup video memory
0325               *--------------------------------------------------------------
0327 71BC 06A0  32         bl    @filv                 ; Clear most part of 16K VDP memory,
     71BE 60BC 
0328 71C0 0000             data  >0000,>00,>3fd8       ; Keep memory for 3 VDP disk buffers (>3fd8 - >3ff)
     71C2 0000 
     71C4 3FD8 
0333 71C6 06A0  32         bl    @filv
     71C8 60BC 
0334 71CA 0FC0             data  pctadr,spfclr,16      ; Load color table
     71CC 00C1 
     71CE 0010 
0335               *--------------------------------------------------------------
0336               * Check if there is a F18A present
0337               *--------------------------------------------------------------
0341 71D0 06A0  32         bl    @f18unl               ; Unlock the F18A
     71D2 6332 
0342 71D4 06A0  32         bl    @f18chk               ; Check if F18A is there
     71D6 634C 
0343 71D8 06A0  32         bl    @f18lck               ; Lock the F18A again
     71DA 6342 
0345               *--------------------------------------------------------------
0346               * Check if there is a speech synthesizer attached
0347               *--------------------------------------------------------------
0349               *       <<skipped>>
0353               *--------------------------------------------------------------
0354               * Load video mode table & font
0355               *--------------------------------------------------------------
0356 71DC 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     71DE 6116 
0357 71E0 606E             data  spvmod                ; Equate selected video mode table
0358 71E2 0204  20         li    tmp0,spfont           ; Get font option
     71E4 000C 
0359 71E6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0360 71E8 1304  14         jeq   runlid                ; Yes, skip it
0361 71EA 06A0  32         bl    @ldfnt
     71EC 617E 
0362 71EE 1100             data  fntadr,spfont         ; Load specified font
     71F0 000C 
0363               *--------------------------------------------------------------
0364               * Branch to main program
0365               *--------------------------------------------------------------
0366 71F2 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     71F4 0040 
0367 71F6 0460  28         b     @main                 ; Give control to main program
     71F8 71FA 
**** **** ****     > fio.asm.793
0064               *--------------------------------------------------------------
0065               * SPECTRA2 startup options
0066               *--------------------------------------------------------------
0067      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0068      0001     spfbck  equ   >01                   ; Screen background color.
0069               ;--------------------------------------------------------------
0070               ; Video mode configuration
0071               ;--------------------------------------------------------------
0072      606E     spvmod  equ   tx8024                ; Video mode.   See VIDTAB for details.
0073      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0074      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0075      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0076               ;--------------------------------------------------------------
0077               ; VDP space for PAB and file buffer
0078               ;--------------------------------------------------------------
0079      01F0     pabadr1 equ   >01f0                 ; VDP PAB1
0080      0200     pabadr2 equ   >0200                 ; VDP PAB2
0081      0300     vrecbuf equ   >0300                 ; VDP Buffer
0082               
0083               
0084               
0085               ***************************************************************
0086               * Main
0087               ********@*****@*********************@**************************
0088 71FA 06A0  32 main    bl    @putat
     71FC 624E 
0089 71FE 0000             data  >0000,msg
     7200 72A8 
0090               
0091 7202 06A0  32         bl    @putat
     7204 624E 
0092 7206 0100             data  >0100,fname
     7208 7297 
0093               
0094                       ;------------------------------------------------------
0095                       ; Prepare VDP for PAB and page out scratchpad
0096                       ;------------------------------------------------------
0097 720A 06A0  32         bl    @cpym2v
     720C 6256 
0098 720E 01F0             data  pabadr1,dsrsub,2      ; Copy PAB for DSR call files subprogram
     7210 728C 
     7212 0002 
0099               
0100 7214 06A0  32         bl    @cpym2v
     7216 6256 
0101 7218 0200             data  pabadr2,pab,25        ; Copy PAB to VDP
     721A 728E 
     721C 0019 
0102               
0103 721E 06A0  32         bl    @cpym2v
     7220 6256 
0104 7222 37D7             data  >37d7,schrott,6
     7224 72BE 
     7226 0006 
0105               
0106               
0107 7228 06A0  32         bl    @mem.scrpad.pgout     ; Page out scratchpad memory
     722A 6F4E 
0108 722C A000             data  >a000                 ; Memory destination @>a000
0109               
0110               
0111                       ;--------
0112                       ; FIX SCRATCHPAD MEMORY
0113                       ;--------
0114                       ;li    r0,>37D7
0115                       ;mov   r0,@>8370             ; Highest free address in VDP memory
0116               
0117               
0118               
0119               
0120                       ;------------------------------------------------------
0121                       ; Set up file buffer - call files(1)
0122                       ;------------------------------------------------------
0123 722E 0200  20         li    r0,>0100
     7230 0100 
0124 7232 D800  38         movb  r0,@>834c             ; Set number of disk files to 1
     7234 834C 
0125 7236 0200  20         li    r0,pabadr1
     7238 01F0 
0126 723A C800  38         mov   r0,@>8356             ; Pass PAB to DSRLNK
     723C 8356 
0127 723E 0420  54         blwp  @dsrlnk               ; Call subprogram for "call files(1)"
     7240 6F70 
0128 7242 000A             data  >a
0129 7244 1320  14         jeq   done1                 ; Exit on error
0130               
0131               
0132                       ;------------------------------------------------------
0133                       ; Open file
0134                       ;------------------------------------------------------
0135 7246 0200  20         li    r0,pabadr2+9
     7248 0209 
0136 724A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     724C 8356 
0137 724E 0420  54         blwp  @dsrlnk
     7250 6F70 
0138 7252 0008             data  8
0139               
0140                       ;------------------------------------------------------
0141                       ; Read record
0142                       ;------------------------------------------------------
0143               readfile
0144 7254 0200  20         li    r0,pabadr2+9
     7256 0209 
0145 7258 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     725A 8356 
0146               
0147 725C 06A0  32         bl    @vputb
     725E 60F6 
0148 7260 0200             data  pabadr2,io.op.read
     7262 0002 
0149               
0150 7264 0420  54         blwp  @dsrlnk
     7266 6F70 
0151 7268 0008             data  8
0152               
0153 726A 130F  14         jeq   file_error
0154 726C 10F3  14         jmp   readfile
0155               
0156                       ;------------------------------------------------------
0157                       ; Close file
0158                       ;------------------------------------------------------
0159               close_file
0160 726E 0200  20         li    r0,pabadr2+9
     7270 0209 
0161 7272 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7274 8356 
0162               
0163 7276 06A0  32         bl    @vputb
     7278 60F6 
0164 727A 0200             data  pabadr2,io.op.close
     727C 0001 
0165               
0166 727E 0420  54         blwp  @dsrlnk
     7280 6F70 
0167 7282 0008             data  8
0168               
0169 7284 10FF  14 done0   jmp   $
0170 7286 10FF  14 done1   jmp   $
0171 7288 10FF  14 done2   jmp   $
0172               
0173               file_error
0174 728A 10F1  14         jmp   close_file
0175               
0176               
0177               
0178               
0179               
0180               
0181               
0182               
0183               
0184               ***************************************************************
0185               * DSR subprogram for call files
0186               ***************************************************************
0187                       even
0188 728C 0116     dsrsub  byte  >01,>16               ; DSR program/subprogram - set file buffers
0189               
0190               
0191               ***************************************************************
0192               * PAB for accessing file
0193               ********@*****@*********************@**************************
0194 728E 0014     pab     byte  io.op.open            ;  0    - OPEN
0195                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0196 7290 0300             data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0197 7292 5000             byte  >50                   ;  4    - 80 characters maximum
0198                       byte  >00                   ;  5    - Filled with bytes read during read
0199 7294 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0200 7296 000F             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0201               fname   byte  15                    ;  9    - File descriptor length
0202 7298 ....             text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
0203                       even
0204               
0205               
0206               msg
0207 72A8 152A             byte  21
0208 72A9 ....             text  '* File reading test *'
0209                       even
0210               
0211 72BE 00AA     schrott data  >00aa, >3fff, >1103
     72C0 3FFF 
     72C2 1103 
