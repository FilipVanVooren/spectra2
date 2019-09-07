XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > hello_world.asm.10853
0001               ***************************************************************
0002               *
0003               *                          Device scan
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: hello_world.asm             ; Version 190907-10853
0009               *--------------------------------------------------------------
0010               * TI-99/4a DSR scan utility
0011               *--------------------------------------------------------------
0012               * 2018-11-01   Development started
0013               ********@*****@*********************@**************************
0014                       save  >6000,>7fff
0015                       aorg  >6000
0016               *--------------------------------------------------------------
0017               *debug                  equ  1      ; Turn on debugging
0018               *--------------------------------------------------------------
0019               * Skip unused spectra2 code modules for reduced code size
0020               *--------------------------------------------------------------
0021      0001     skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0022      0001     skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0023      0001     skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0024      0001     skip_vdp_hchar          equ  1      ; Skip hchar, xchar
0025      0001     skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0026      0001     skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0027      0001     skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0028      0001     skip_vdp_viewport       equ  1      ; Skip viewport functions
0029      0001     skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0030      0001     skip_vdp_yx2px_calc     equ  1      ; Skip YX to pixel calculation
0031      0001     skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0032      0001     skip_vdp_sprites        equ  1      ; Skip sprites support
0033      0001     skip_sound_player       equ  1      ; Skip inclusion of sound player code
0034      0001     skip_tms52xx_detection  equ  1      ; Skip speech synthesizer detection
0035      0001     skip_tms52xx_player     equ  1      ; Skip inclusion of speech player code
0036      0001     skip_random_generator   equ  1      ; Skip random functions
0037      0001     skip_timer_alloc        equ  1      ; Skip support for timers allocation
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
0046 6012 6B6C             data  runlib
0054               
0055 6014 0B48             byte  11
0056 6015 ....             text  'HELLO WORLD'
0057                       even
0058               
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
0008               *                                for
0009               *                     the Texas Instruments TI-99/4A
0010               *
0011               *                      2010-2019 by Filip Van Vooren
0012               *
0013               *              https://github.com/FilipVanVooren/spectra2.git
0014               *******************************************************************************
0015               * This file: runlib.a99
0016               *******************************************************************************
0017               * Use following equates to skip/exclude support modules
0018               *
0019               * == Memory
0020               * skip_rom_bankswitch       equ  1  ; Skip support for ROM bankswitching
0021               * skip_vram_cpu_copy        equ  1  ; Skip VRAM to CPU copy functions
0022               * skip_cpu_vram_copy        equ  1  ; Skip CPU  to VRAM copy functions
0023               * skip_cpu_cpu_copy         equ  1  ; Skip CPU  to CPU copy functions
0024               * skip_grom_cpu_copy        equ  1  ; Skip GROM to CPU copy functions
0025               * skip_grom_vram_copy       equ  1  ; Skip GROM to VRAM copy functions
0026               
0027               * == VDP
0028               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0029               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0030               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0031               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0032               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0033               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0034               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0035               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0036               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0037               * skip_vdp_rle_decompress   equ  1  ; Skip RLE decompress to VRAM
0038               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0039               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0040               * skip_vdp_sprites          equ  1  ; Skip sprites support
0041               * skip_vdp_cursor           equ  1  ; Skip cursor support
0042               *
0043               * == Sound & speech
0044               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0045               * skip_tms52xx_detection    equ  1  ; Skip speech synthesizer detection
0046               * skip_tms52xx_player       equ  1  ; Skip inclusion of speech player code
0047               *
0048               * ==  Keyboard
0049               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0050               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0051               *
0052               * == Utilities
0053               * skip_random_generator     equ  1  ; Skip random generator functions
0054               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0055               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0056               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0057               
0058               * == Kernel/Multitasking
0059               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0060               * skip_mem_paging           equ  1  ; Skip support for memory paging
0061               * skip_iosupport            equ  1  ; Skip support for file I/O, dsrlnk
0062               *******************************************************************************
0063               
0064               *//////////////////////////////////////////////////////////////
0065               *                       RUNLIB SETUP
0066               *//////////////////////////////////////////////////////////////
0067               
0068                       copy  "memsetup.equ"        ; runlib scratchpad memory setup
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
0027               
0028               
0029               
0030               ***************************************************************
0031               * >8300 - >83ff       Equates for DSRLNK (alternative layout)
0032               ***************************************************************
0033               * Equates are used in DSRLNK.
0034               * Scratchpad memory needs to be paged out before use of DSRLNK.
0035               ********@*****@*********************@**************************
0036      8320     haa     equ   >8320                 ; Loaded with HI-byte value >aa
0037      8322     sav8a   equ   >8322                 ; Contains >08 or >0a
0038      8324     flgptr  equ   >8324                 ; Pointer to pab+1 dsrlnk
0039      8326     savver  equ   >8326                 ; Saved version
0040      8328     savent  equ   >8328                 ; Saved entry address
0041      832A     savcru  equ   >832a                 ; Saved cru
0042      832C     savlen  equ   >832c                 ; Saved length of filename
0043      832E     savpab  equ   >832e                 ; Saved PAB address
0044      8330     namsto  equ   >8330                 ; 8-byte buffer for device name
0045      8380     dsrlws  equ   >8380                 ; dsrlnk workspace
0046      838A     dstype  equ   >838a                 ; dstype is address of R5 of DSRLNK ws
0047               ***************************************************************
**** **** ****     > runlib.asm
0069                       copy  "registers.equ"       ; runlib registers
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
0070                       copy  "portaddr.equ"        ; runlib hardware port addresses
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
0071                       copy  "param.equ"           ; runlib parameters
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
0072               
0076               
0077                       copy  "constants.asm"       ; Define constants
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Definition of constants used by runlib modules
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********@*****@*********************@**************************
0037 6020 8000     wbit0   data  >8000                 ; Binary 1000000000000000
0038 6022 4000     wbit1   data  >4000                 ; Binary 0100000000000000
0039 6024 2000     wbit2   data  >2000                 ; Binary 0010000000000000
0040 6026 1000     wbit3   data  >1000                 ; Binary 0001000000000000
0041 6028 0800     wbit4   data  >0800                 ; Binary 0000100000000000
0042 602A 0400     wbit5   data  >0400                 ; Binary 0000010000000000
0043 602C 0200     wbit6   data  >0200                 ; Binary 0000001000000000
0044 602E 0100     wbit7   data  >0100                 ; Binary 0000000100000000
0045 6030 0080     wbit8   data  >0080                 ; Binary 0000000010000000
0046 6032 0040     wbit9   data  >0040                 ; Binary 0000000001000000
0047 6034 0020     wbit10  data  >0020                 ; Binary 0000000000100000
0048 6036 0010     wbit11  data  >0010                 ; Binary 0000000000010000
0049 6038 0008     wbit12  data  >0008                 ; Binary 0000000000001000
0050 603A 0004     wbit13  data  >0004                 ; Binary 0000000000000100
0051 603C 0002     wbit14  data  >0002                 ; Binary 0000000000000010
0052 603E 0001     wbit15  data  >0001                 ; Binary 0000000000000001
0053 6040 FFFF     whffff  data  >ffff                 ; Binary 1111111111111111
0054 6042 0001     bd0     byte  0                     ; Digit 0
0055               bd1     byte  1                     ; Digit 1
0056 6044 0203     bd2     byte  2                     ; Digit 2
0057               bd3     byte  3                     ; Digit 3
0058 6046 0405     bd4     byte  4                     ; Digit 4
0059               bd5     byte  5                     ; Digit 5
0060 6048 0607     bd6     byte  6                     ; Digit 6
0061               bd7     byte  7                     ; Digit 7
0062 604A 0809     bd8     byte  8                     ; Digit 8
0063               bd9     byte  9                     ; Digit 9
0064 604C D000     bd208   byte  208                   ; Digit 208 (>D0)
0065                       even
**** **** ****     > runlib.asm
0078                       copy  "values.equ"          ; Equates for word/MSB/LSB-values
**** **** ****     > values.equ
0001               * FILE......: values.equ
0002               * Purpose...: Equates for word/MSB/LSB-values
0003               
0004               --------------------------------------------------------------
0005               * Word values
0006               *--------------------------------------------------------------
0007      603E     w$0001  equ   wbit15                ; >0001
0008      603C     w$0002  equ   wbit14                ; >0002
0009      603A     w$0004  equ   wbit13                ; >0004
0010      6038     w$0008  equ   wbit12                ; >0008
0011      6036     w$0010  equ   wbit11                ; >0010
0012      6034     w$0020  equ   wbit10                ; >0020
0013      6032     w$0040  equ   wbit9                 ; >0040
0014      6030     w$0080  equ   wbit8                 ; >0080
0015      602E     w$0100  equ   wbit7                 ; >0100
0016      602C     w$0200  equ   wbit6                 ; >0200
0017      602A     w$0400  equ   wbit5                 ; >0400
0018      6028     w$0800  equ   wbit4                 ; >0800
0019      6026     w$1000  equ   wbit3                 ; >1000
0020      6024     w$2000  equ   wbit2                 ; >2000
0021      6022     w$4000  equ   wbit1                 ; >4000
0022      6020     w$8000  equ   wbit0                 ; >8000
0023      6040     w$ffff  equ   whffff                ; >ffff
0024               *--------------------------------------------------------------
0025               * MSB values: >01 - >0f for byte operations AB, SB, CB, ...
0026               *--------------------------------------------------------------
0027      602E     hb$01   equ   wbit7                 ; >0100
0028      602C     hb$02   equ   wbit6                 ; >0200
0029      602A     hb$04   equ   wbit5                 ; >0400
0030      6028     hb$08   equ   wbit4                 ; >0800
0031      6026     hb$10   equ   wbit3                 ; >1000
0032      6024     hb$20   equ   wbit2                 ; >2000
0033      6022     hb$40   equ   wbit1                 ; >4000
0034      6020     hb$80   equ   wbit0                 ; >8000
0035               *--------------------------------------------------------------
0036               * LSB values: >01 - >0f for byte operations AB, SB, CB, ...
0037               *--------------------------------------------------------------
0038      603E     lb$01   equ   wbit15                ; >0001
0039      603C     lb$02   equ   wbit14                ; >0002
0040      603A     lb$04   equ   wbit13                ; >0004
0041      6038     lb$08   equ   wbit12                ; >0008
0042      6036     lb$10   equ   wbit11                ; >0010
0043      6034     lb$20   equ   wbit10                ; >0020
0044      6032     lb$40   equ   wbit9                 ; >0040
0045      6030     lb$80   equ   wbit8                 ; >0080
**** **** ****     > runlib.asm
0079                       copy  "config.equ"          ; Equates for bits in config register
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
0027      6024     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      602E     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6032     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6034     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      6036     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0032               ***************************************************************
0033               
**** **** ****     > runlib.asm
0080                       copy  "cpu_crash_hndlr.asm" ; CPU program crashed handler
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
0018 604E 0420  54 crash   blwp  @>0000                ; Soft-reset
     6050 0000 
**** **** ****     > runlib.asm
0081                       copy  "vdp_tables.asm"      ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6052 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6054 000E 
     6056 0106 
     6058 0201 
     605A 0020 
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
0032 605C 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     605E 000E 
     6060 0106 
     6062 00C1 
     6064 0028 
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
0058 6066 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6068 003F 
     606A 0240 
     606C 03C1 
     606E 0050 
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
0084 6070 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6072 003F 
     6074 0240 
     6076 03C1 
     6078 0050 
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
0082                       copy  "basic_cpu_vdp.asm"   ; Basic CPU & VDP functions
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
0013 607A 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 607C 16FD             data  >16fd                 ; |         jne   mcloop
0015 607E 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6080 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6082 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6084 C0F9  30 popr3   mov   *stack+,r3
0039 6086 C0B9  30 popr2   mov   *stack+,r2
0040 6088 C079  30 popr1   mov   *stack+,r1
0041 608A C039  30 popr0   mov   *stack+,r0
0042 608C C2F9  30 poprt   mov   *stack+,r11
0043 608E 045B  20         b     *r11
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
0067 6090 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6092 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6094 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 6096 C1C6  18 xfilm   mov   tmp2,tmp3
0074 6098 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     609A 0001 
0075               
0076 609C 1301  14         jeq   film1
0077 609E 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60A0 D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60A2 830B 
     60A4 830A 
0079 60A6 CD05  34 film2   mov   tmp1,*tmp0+
0080 60A8 0646  14         dect  tmp2
0081 60AA 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60AC C1C7  18         mov   tmp3,tmp3
0086 60AE 1301  14         jeq   filmz
0087 60B0 D505  30         movb  tmp1,*tmp0
0088 60B2 045B  20 filmz   b     *r11
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
0107 60B4 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60B6 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60B8 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60BA 0264  22 xfilv   ori   tmp0,>4000
     60BC 4000 
0114 60BE 06C4  14         swpb  tmp0
0115 60C0 D804  38         movb  tmp0,@vdpa
     60C2 8C02 
0116 60C4 06C4  14         swpb  tmp0
0117 60C6 D804  38         movb  tmp0,@vdpa
     60C8 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60CA 020F  20         li    r15,vdpw              ; Set VDP write address
     60CC 8C00 
0122 60CE 06C5  14         swpb  tmp1
0123 60D0 C820  54         mov   @filzz,@mcloop        ; Setup move command
     60D2 60DA 
     60D4 8320 
0124 60D6 0460  28         b     @mcloop               ; Write data to VDP
     60D8 8320 
0125               *--------------------------------------------------------------
0129 60DA D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60DC 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     60DE 4000 
0150 60E0 06C4  14 vdra    swpb  tmp0
0151 60E2 D804  38         movb  tmp0,@vdpa
     60E4 8C02 
0152 60E6 06C4  14         swpb  tmp0
0153 60E8 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     60EA 8C02 
0154 60EC 045B  20         b     *r11
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
0165 60EE C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 60F0 C17B  30         mov   *r11+,tmp1
0167 60F2 C18B  18 xvputb  mov   r11,tmp2              ; Save R11
0168 60F4 06A0  32         bl    @vdwa                 ; Set VDP write address
     60F6 60DC 
0169               
0170 60F8 06C5  14         swpb  tmp1                  ; Get byte to write
0171 60FA D7C5  30         movb  tmp1,*r15             ; Write byte
0172 60FC 0456  20         b     *tmp2                 ; Exit
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
0183 60FE C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0184 6100 C18B  18 xvgetb  mov   r11,tmp2              ; Save R11
0185 6102 06A0  32         bl    @vdra                 ; Set VDP read address
     6104 60E0 
0186               
0187 6106 D120  34         movb  @vdpr,tmp0            ; Read byte
     6108 8800 
0188               
0189 610A 0984  56         srl   tmp0,8                ; Right align
0190 610C 0456  20         b     *tmp2                 ; Exit
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
0209 610E C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0210 6110 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0211               *--------------------------------------------------------------
0212               * Calculate PNT base address
0213               *--------------------------------------------------------------
0214 6112 C144  18         mov   tmp0,tmp1
0215 6114 05C5  14         inct  tmp1
0216 6116 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0217 6118 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     611A FF00 
0218 611C 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0219 611E C805  38         mov   tmp1,@wbase           ; Store calculated base
     6120 8328 
0220               *--------------------------------------------------------------
0221               * Dump VDP shadow registers
0222               *--------------------------------------------------------------
0223 6122 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6124 8000 
0224 6126 0206  20         li    tmp2,8
     6128 0008 
0225 612A D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     612C 830B 
0226 612E 06C5  14         swpb  tmp1
0227 6130 D805  38         movb  tmp1,@vdpa
     6132 8C02 
0228 6134 06C5  14         swpb  tmp1
0229 6136 D805  38         movb  tmp1,@vdpa
     6138 8C02 
0230 613A 0225  22         ai    tmp1,>0100
     613C 0100 
0231 613E 0606  14         dec   tmp2
0232 6140 16F4  14         jne   vidta1                ; Next register
0233 6142 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6144 833A 
0234 6146 045B  20         b     *r11
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
0251 6148 C13B  30 putvr   mov   *r11+,tmp0
0252 614A 0264  22 putvrx  ori   tmp0,>8000
     614C 8000 
0253 614E 06C4  14         swpb  tmp0
0254 6150 D804  38         movb  tmp0,@vdpa
     6152 8C02 
0255 6154 06C4  14         swpb  tmp0
0256 6156 D804  38         movb  tmp0,@vdpa
     6158 8C02 
0257 615A 045B  20         b     *r11
0258               
0259               
0260               ***************************************************************
0261               * PUTV01  - Put VDP registers #0 and #1
0262               ***************************************************************
0263               *  BL   @PUTV01
0264               ********@*****@*********************@**************************
0265 615C C20B  18 putv01  mov   r11,tmp4              ; Save R11
0266 615E C10E  18         mov   r14,tmp0
0267 6160 0984  56         srl   tmp0,8
0268 6162 06A0  32         bl    @putvrx               ; Write VR#0
     6164 614A 
0269 6166 0204  20         li    tmp0,>0100
     6168 0100 
0270 616A D820  54         movb  @r14lb,@tmp0lb
     616C 831D 
     616E 8309 
0271 6170 06A0  32         bl    @putvrx               ; Write VR#1
     6172 614A 
0272 6174 0458  20         b     *tmp4                 ; Exit
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
0286 6176 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0287 6178 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0288 617A C11B  26         mov   *r11,tmp0             ; Get P0
0289 617C 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     617E 7FFF 
0290 6180 2120  38         coc   @wbit0,tmp0
     6182 6020 
0291 6184 1604  14         jne   ldfnt1
0292 6186 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6188 8000 
0293 618A 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     618C 7FFF 
0294               *--------------------------------------------------------------
0295               * Read font table address from GROM into tmp1
0296               *--------------------------------------------------------------
0297 618E C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6190 61F8 
0298 6192 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6194 9C02 
0299 6196 06C4  14         swpb  tmp0
0300 6198 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     619A 9C02 
0301 619C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     619E 9800 
0302 61A0 06C5  14         swpb  tmp1
0303 61A2 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61A4 9800 
0304 61A6 06C5  14         swpb  tmp1
0305               *--------------------------------------------------------------
0306               * Setup GROM source address from tmp1
0307               *--------------------------------------------------------------
0308 61A8 D805  38         movb  tmp1,@grmwa
     61AA 9C02 
0309 61AC 06C5  14         swpb  tmp1
0310 61AE D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61B0 9C02 
0311               *--------------------------------------------------------------
0312               * Setup VDP target address
0313               *--------------------------------------------------------------
0314 61B2 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0315 61B4 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61B6 60DC 
0316 61B8 05C8  14         inct  tmp4                  ; R11=R11+2
0317 61BA C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0318 61BC 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61BE 7FFF 
0319 61C0 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61C2 61FA 
0320 61C4 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61C6 61FC 
0321               *--------------------------------------------------------------
0322               * Copy from GROM to VRAM
0323               *--------------------------------------------------------------
0324 61C8 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0325 61CA 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0326 61CC D120  34         movb  @grmrd,tmp0
     61CE 9800 
0327               *--------------------------------------------------------------
0328               *   Make font fat
0329               *--------------------------------------------------------------
0330 61D0 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     61D2 6020 
0331 61D4 1603  14         jne   ldfnt3                ; No, so skip
0332 61D6 D1C4  18         movb  tmp0,tmp3
0333 61D8 0917  56         srl   tmp3,1
0334 61DA E107  18         soc   tmp3,tmp0
0335               *--------------------------------------------------------------
0336               *   Dump byte to VDP and do housekeeping
0337               *--------------------------------------------------------------
0338 61DC D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     61DE 8C00 
0339 61E0 0606  14         dec   tmp2
0340 61E2 16F2  14         jne   ldfnt2
0341 61E4 05C8  14         inct  tmp4                  ; R11=R11+2
0342 61E6 020F  20         li    r15,vdpw              ; Set VDP write address
     61E8 8C00 
0343 61EA 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61EC 7FFF 
0344 61EE 0458  20         b     *tmp4                 ; Exit
0345 61F0 D820  54 ldfnt4  movb  @bd0,@vdpw            ; Insert byte >00 into VRAM
     61F2 6042 
     61F4 8C00 
0346 61F6 10E8  14         jmp   ldfnt2
0347               *--------------------------------------------------------------
0348               * Fonts pointer table
0349               *--------------------------------------------------------------
0350 61F8 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     61FA 0200 
     61FC 0000 
0351 61FE 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6200 01C0 
     6202 0101 
0352 6204 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6206 02A0 
     6208 0101 
0353 620A 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     620C 00E0 
     620E 0101 
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
0371 6210 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0372 6212 C3A0  34         mov   @wyx,r14              ; Get YX
     6214 832A 
0373 6216 098E  56         srl   r14,8                 ; Right justify (remove X)
0374 6218 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     621A 833A 
0375               *--------------------------------------------------------------
0376               * Do rest of calculation with R15 (16 bit part is there)
0377               * Re-use R14
0378               *--------------------------------------------------------------
0379 621C C3A0  34         mov   @wyx,r14              ; Get YX
     621E 832A 
0380 6220 024E  22         andi  r14,>00ff             ; Remove Y
     6222 00FF 
0381 6224 A3CE  18         a     r14,r15               ; pos = pos + X
0382 6226 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6228 8328 
0383               *--------------------------------------------------------------
0384               * Clean up before exit
0385               *--------------------------------------------------------------
0386 622A C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0387 622C C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0388 622E 020F  20         li    r15,vdpw              ; VDP write address
     6230 8C00 
0389 6232 045B  20         b     *r11
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
0404 6234 C17B  30 putstr  mov   *r11+,tmp1
0405 6236 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0406 6238 C1CB  18 xutstr  mov   r11,tmp3
0407 623A 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     623C 6210 
0408 623E C2C7  18         mov   tmp3,r11
0409 6240 0986  56         srl   tmp2,8                ; Right justify length byte
0410 6242 0460  28         b     @xpym2v               ; Display string
     6244 6254 
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
0425 6246 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6248 832A 
0426 624A 0460  28         b     @putstr
     624C 6234 
**** **** ****     > runlib.asm
0083               
0085                       copy  "copy_cpu_vram.asm"   ; CPU to VRAM copy functions
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
0020 624E C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6250 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6252 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6254 0264  22 xpym2v  ori   tmp0,>4000
     6256 4000 
0027 6258 06C4  14         swpb  tmp0
0028 625A D804  38         movb  tmp0,@vdpa
     625C 8C02 
0029 625E 06C4  14         swpb  tmp0
0030 6260 D804  38         movb  tmp0,@vdpa
     6262 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6264 020F  20         li    r15,vdpw              ; Set VDP write address
     6266 8C00 
0035 6268 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     626A 6272 
     626C 8320 
0036 626E 0460  28         b     @mcloop               ; Write data to VDP
     6270 8320 
0037 6272 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0087               
0089                       copy  "copy_vram_cpu.asm"   ; VRAM to CPU copy functions
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
0020 6274 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6276 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6278 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 627A 06C4  14 xpyv2m  swpb  tmp0
0027 627C D804  38         movb  tmp0,@vdpa
     627E 8C02 
0028 6280 06C4  14         swpb  tmp0
0029 6282 D804  38         movb  tmp0,@vdpa
     6284 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6286 020F  20         li    r15,vdpr              ; Set VDP read address
     6288 8800 
0034 628A C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     628C 6294 
     628E 8320 
0035 6290 0460  28         b     @mcloop               ; Read data from VDP
     6292 8320 
0036 6294 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0091               
0093                       copy  "copy_cpu_cpu.asm"    ; CPU to CPU copy functions
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
0024 6296 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6298 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 629A C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 629C C186  18 xpym2m  mov    tmp2,tmp2            ; Bytes to copy = 0 ?
0031 629E 1602  14         jne    cpym0
0032 62A0 0460  28         b      @crash               ; Yes, crash
     62A2 604E 
0033 62A4 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62A6 7FFF 
0034 62A8 C1C4  18         mov   tmp0,tmp3
0035 62AA 0247  22         andi  tmp3,1
     62AC 0001 
0036 62AE 1618  14         jne   cpyodd                ; Odd source address handling
0037 62B0 C1C5  18 cpym1   mov   tmp1,tmp3
0038 62B2 0247  22         andi  tmp3,1
     62B4 0001 
0039 62B6 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62B8 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62BA 6020 
0044 62BC 1605  14         jne   cpym3
0045 62BE C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62C0 62E6 
     62C2 8320 
0046 62C4 0460  28         b     @mcloop               ; Copy memory and exit
     62C6 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62C8 C1C6  18 cpym3   mov   tmp2,tmp3
0051 62CA 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62CC 0001 
0052 62CE 1301  14         jeq   cpym4
0053 62D0 0606  14         dec   tmp2                  ; Make TMP2 even
0054 62D2 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 62D4 0646  14         dect  tmp2
0056 62D6 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 62D8 C1C7  18         mov   tmp3,tmp3
0061 62DA 1301  14         jeq   cpymz
0062 62DC D554  38         movb  *tmp0,*tmp1
0063 62DE 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 62E0 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     62E2 8000 
0068 62E4 10E9  14         jmp   cpym2
0069 62E6 DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0095               
0099               
0103               
0107               
0109                       copy  "vdp_intscr.asm"      ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********@*****@*********************@**************************
0009 62E8 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     62EA FFBF 
0010 62EC 0460  28         b     @putv01
     62EE 615C 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 62F0 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     62F2 0040 
0018 62F4 0460  28         b     @putv01
     62F6 615C 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 62F8 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     62FA FFDF 
0026 62FC 0460  28         b     @putv01
     62FE 615C 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6300 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6302 0020 
0034 6304 0460  28         b     @putv01
     6306 615C 
**** **** ****     > runlib.asm
0111               
0115               
0117                       copy  "vdp_cursor.asm"      ; VDP cursor handling
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
0018 6308 C83B  50 at      mov   *r11+,@wyx
     630A 832A 
0019 630C 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 630E B820  54 down    ab    @hb$01,@wyx
     6310 602E 
     6312 832A 
0028 6314 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 6316 7820  54 up      sb    @hb$01,@wyx
     6318 602E 
     631A 832A 
0037 631C 045B  20         b     *r11
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
0049 631E C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6320 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6322 832A 
0051 6324 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6326 832A 
0052 6328 045B  20         b     *r11
**** **** ****     > runlib.asm
0119               
0123               
0127               
0131               
0133                       copy  "vdp_f18a_support.asm" ; VDP F18a low-level functions
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
0013 632A C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 632C 06A0  32         bl    @putvr                ; Write once
     632E 6148 
0015 6330 391C             data  >391c                 ; VR1/57, value 00011100
0016 6332 06A0  32         bl    @putvr                ; Write twice
     6334 6148 
0017 6336 391C             data  >391c                 ; VR1/57, value 00011100
0018 6338 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 633A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 633C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     633E 6148 
0028 6340 391C             data  >391c
0029 6342 0458  20         b     *tmp4                 ; Exit
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
0040 6344 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6346 06A0  32         bl    @cpym2v
     6348 624E 
0042 634A 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     634C 6388 
     634E 0006 
0043 6350 06A0  32         bl    @putvr
     6352 6148 
0044 6354 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6356 06A0  32         bl    @putvr
     6358 6148 
0046 635A 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 635C 0204  20         li    tmp0,>3f00
     635E 3F00 
0052 6360 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6362 60E0 
0053 6364 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6366 8800 
0054 6368 0984  56         srl   tmp0,8
0055 636A D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     636C 8800 
0056 636E C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 6370 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6372 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6374 BFFF 
0060 6376 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 6378 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     637A 4000 
0063               f18chk_exit:
0064 637C 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     637E 60B4 
0065 6380 3F00             data  >3f00,>00,6
     6382 0000 
     6384 0006 
0066 6386 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 6388 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 638A 3F00             data  >3f00                 ; 3f02 / 3f00
0073 638C 0340             data  >0340                 ; 3f04   0340  idle
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
0092 638E C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 6390 06A0  32         bl    @putvr
     6392 6148 
0097 6394 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 6396 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6398 6148 
0100 639A 391C             data  >391c                 ; Lock the F18a
0101 639C 0458  20         b     *tmp4                 ; Exit
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
0120 639E C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 63A0 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     63A2 6022 
0122 63A4 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 63A6 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     63A8 8802 
0127 63AA 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     63AC 6148 
0128 63AE 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 63B0 04C4  14         clr   tmp0
0130 63B2 D120  34         movb  @vdps,tmp0
     63B4 8802 
0131 63B6 0984  56         srl   tmp0,8
0132 63B8 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0135               
0139               
0143               
0147               
0151               
0155               
0159               
0163               
0165                       copy  "keyb_virtual.asm"    ; Virtual keyboard scanning
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
0088 63BA 40A0  34         szc   @wbit11,config        ; Reset ANY key
     63BC 6036 
0089 63BE C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 63C0 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 63C2 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 63C4 0207  20         li    tmp3,kbmap0           ; Start with column 0
     63C6 6436 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 63C8 04CC  14         clr   r12
0097 63CA 1E15  20         sbz   >0015                 ; Set P5
0098 63CC 1F07  20         tb    7
0099 63CE 1302  14         jeq   virtk1
0100 63D0 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     63D2 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 63D4 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 63D6 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     63D8 0024 
0107 63DA 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 63DC 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     63DE 0006 
0109 63E0 0705  14         seto  tmp1                  ; >FFFF
0110 63E2 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 63E4 0545  14         inv   tmp1
0112 63E6 1302  14         jeq   virtk2                ; >0000 ?
0113 63E8 E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     63EA 6036 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 63EC 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 63EE 1601  14         jne   virtk3
0119 63F0 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 63F2 05C7  14 virtk3  inct  tmp3
0121 63F4 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     63F6 6442 
0122 63F8 16F9  14         jne   virtk2                ; No, next entry
0123 63FA 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 63FC 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     63FE 0700 
0128 6400 1309  14         jeq   virtk6                ; Yes, exit
0129 6402 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     6404 0200 
0130 6406 1303  14         jeq   virtk5                ; Yes, skip
0131 6408 0224  22         ai    tmp0,>0100
     640A 0100 
0132 640C 10E3  14         jmp   virtk1
0133 640E 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6410 0500 
0134 6412 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 6414 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 6416 C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     6418 8332 
0140 641A 1601  14         jne   virtk7
0141 641C 045B  20         b     *r11                  ; Exit
0142 641E 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6420 FFFF 
0143 6422 1603  14         jne   virtk8                ; No
0144 6424 0701  14         seto  r1                    ; Set exit flag
0145 6426 0460  28         b     @runli1               ; Yes, reset computer
     6428 6B70 
0146 642A 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     642C 8000 
0147 642E 1602  14         jne   virtk9
0148 6430 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     6432 6036 
0149 6434 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 6436 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     6438 FFFF 
0155 643A 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     643C 0020 
0156 643E 0400             data  >0400,kenter          ; >04 00000100  enter
     6440 4000 
0157 6442 FFFF     kbeoc   data  >ffff
0158               
0159 6444 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     6446 1000 
0160 6448 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     644A 0008 
0161 644C 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     644E 0004 
0162 6450 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     6452 0200 
0163 6454 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     6456 0040 
0164 6458 FFFF             data  >ffff
0165               
0166 645A 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     645C 2000 
0167 645E 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6460 0002 
0168 6462 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6464 0100 
0169 6466 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     6468 0080 
0170 646A 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     646C 0010 
0171 646E FFFF             data  >ffff
0172               
0173 6470 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     6472 0001 
0174 6474 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     6476 0800 
0175 6478 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     647A 0020 
0176 647C FFFF             data  >ffff
0177               
0178 647E 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     6480 0020 
0179 6482 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     6484 0200 
0180 6486 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     6488 0100 
0181 648A 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     648C 0040 
0182 648E 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     6490 0080 
0183 6492 FFFF             data  >ffff
0184               
0185 6494 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     6496 0001 
0186 6498 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     649A 0010 
0187 649C 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     649E 0008 
0188 64A0 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     64A2 0002 
0189 64A4 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     64A6 0004 
0190 64A8 FFFF             data  >ffff
**** **** ****     > runlib.asm
0167               
0169                       copy  "keyb_real.asm"       ; Real Keyboard support
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
0016 64AA 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64AC 6020 
0017 64AE 020C  20         li    r12,>0024
     64B0 0024 
0018 64B2 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64B4 6542 
0019 64B6 04C6  14         clr   tmp2
0020 64B8 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64BA 04CC  14         clr   r12
0025 64BC 1F08  20         tb    >0008                 ; Shift-key ?
0026 64BE 1302  14         jeq   realk1                ; No
0027 64C0 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64C2 6572 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64C4 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64C6 1302  14         jeq   realk2                ; No
0033 64C8 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64CA 65A2 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64CC 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 64CE 1302  14         jeq   realk3                ; No
0039 64D0 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     64D2 65D2 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 64D4 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 64D6 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 64D8 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 64DA E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     64DC 6020 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 64DE 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 64E0 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64E2 0006 
0052 64E4 0606  14 realk5  dec   tmp2
0053 64E6 020C  20         li    r12,>24               ; CRU address for P2-P4
     64E8 0024 
0054 64EA 06C6  14         swpb  tmp2
0055 64EC 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64EE 06C6  14         swpb  tmp2
0057 64F0 020C  20         li    r12,6                 ; CRU read address
     64F2 0006 
0058 64F4 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 64F6 0547  14         inv   tmp3                  ;
0060 64F8 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     64FA FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 64FC 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 64FE 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6500 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6502 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6504 0285  22         ci    tmp1,8
     6506 0008 
0069 6508 1AFA  14         jl    realk6
0070 650A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 650C 1BEB  14         jh    realk5                ; No, next column
0072 650E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6510 C206  18 realk8  mov   tmp2,tmp4
0077 6512 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6514 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6516 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6518 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 651A 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 651C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 651E 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6520 6020 
0087 6522 1608  14         jne   realka                ; No, continue saving key
0088 6524 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6526 656C 
0089 6528 1A05  14         jl    realka
0090 652A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     652C 656A 
0091 652E 1B02  14         jh    realka                ; No, continue
0092 6530 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6532 E000 
0093 6534 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6536 833C 
0094 6538 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     653A 6036 
0095 653C 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     653E 8C00 
0096 6540 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6542 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6544 0000 
     6546 FF0D 
     6548 203D 
0099 654A ....             text  'xws29ol.'
0100 6552 ....             text  'ced38ik,'
0101 655A ....             text  'vrf47ujm'
0102 6562 ....             text  'btg56yhn'
0103 656A ....             text  'zqa10p;/'
0104 6572 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6574 0000 
     6576 FF0D 
     6578 202B 
0105 657A ....             text  'XWS@(OL>'
0106 6582 ....             text  'CED#*IK<'
0107 658A ....             text  'VRF$&UJM'
0108 6592 ....             text  'BTG%^YHN'
0109 659A ....             text  'ZQA!)P:-'
0110 65A2 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65A4 0000 
     65A6 FF0D 
     65A8 2005 
0111 65AA 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65AC 0804 
     65AE 0F27 
     65B0 C2B9 
0112 65B2 600B             data  >600b,>0907,>063f,>c1B8
     65B4 0907 
     65B6 063F 
     65B8 C1B8 
0113 65BA 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65BC 7B02 
     65BE 015F 
     65C0 C0C3 
0114 65C2 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65C4 7D0E 
     65C6 0CC6 
     65C8 BFC4 
0115 65CA 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65CC 7C03 
     65CE BC22 
     65D0 BDBA 
0116 65D2 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     65D4 0000 
     65D6 FF0D 
     65D8 209D 
0117 65DA 9897             data  >9897,>93b2,>9f8f,>8c9B
     65DC 93B2 
     65DE 9F8F 
     65E0 8C9B 
0118 65E2 8385             data  >8385,>84b3,>9e89,>8b80
     65E4 84B3 
     65E6 9E89 
     65E8 8B80 
0119 65EA 9692             data  >9692,>86b4,>b795,>8a8D
     65EC 86B4 
     65EE B795 
     65F0 8A8D 
0120 65F2 8294             data  >8294,>87b5,>b698,>888E
     65F4 87B5 
     65F6 B698 
     65F8 888E 
0121 65FA 9A91             data  >9a91,>81b1,>b090,>9cBB
     65FC 81B1 
     65FE B090 
     6600 9CBB 
**** **** ****     > runlib.asm
0171               
0173                       copy  "cpu_hexsupport.asm"  ; CPU hex numbers support
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
0016 6602 C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 6604 C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     6606 8340 
0018 6608 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     660A 833C 
0019 660C 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 660E 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 6610 0647  14         dect  tmp3                  ; Back to WAUX1
0022 6612 C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 6614 0205  20         li    tmp1,4
     6616 0004 
0027 6618 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 661A 0246  22         andi  tmp2,>000f            ; Only keep LSN
     661C 000F 
0029 661E A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 6620 06C6  14 mkhex2  swpb  tmp2
0031 6622 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 6624 0944  56         srl   tmp0,4                ; Next nibble
0033 6626 0605  14         dec   tmp1
0034 6628 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 662A 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     662C BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 662E C160  34         mov   @waux3,tmp1           ; Get pointer
     6630 8340 
0040 6632 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 6634 0585  14         inc   tmp1                  ; Next byte, not word!
0042 6636 C120  34         mov   @waux2,tmp0
     6638 833E 
0043 663A 06C4  14         swpb  tmp0
0044 663C DD44  32         movb  tmp0,*tmp1+
0045 663E 06C4  14         swpb  tmp0
0046 6640 DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 6642 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6644 8340 
0051 6646 D520  46         movb  @bd4,*tmp0            ; Set lengh byte to 4
     6648 6046 
0052 664A 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 664C C120  34         mov   @waux1,tmp0
     664E 833C 
0057 6650 06C4  14         swpb  tmp0
0058 6652 DD44  32         movb  tmp0,*tmp1+
0059 6654 06C4  14         swpb  tmp0
0060 6656 DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 6658 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     665A 6020 
0065 665C 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 665E 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 6660 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6662 7FFF 
0071 6664 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6666 8340 
0072 6668 0460  28         b     @xutst0               ; Display string
     666A 6236 
0073 666C 0610     prefix  data  >0610                 ; Length byte + blank
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
0087 666E C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6670 832A 
0088 6672 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6674 8000 
0089 6676 10C5  14         jmp   mkhex                 ; Convert number and display
0090               
**** **** ****     > runlib.asm
0175               
0177                       copy  "cpu_numsupport.asm"  ; CPU unsigned numbers support
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
0019 6678 0207  20 mknum   li    tmp3,5                ; Digit counter
     667A 0005 
0020 667C C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 667E C155  26         mov   *tmp1,tmp1            ; /
0022 6680 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6682 0228  22         ai    tmp4,4                ; Get end of buffer
     6684 0004 
0024 6686 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6688 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 668A 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 668C 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 668E 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6690 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6692 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6694 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6696 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6698 0607  14         dec   tmp3                  ; Decrease counter
0036 669A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 669C 0207  20         li    tmp3,4                ; Check first 4 digits
     669E 0004 
0041 66A0 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 66A2 C11B  26         mov   *r11,tmp0
0043 66A4 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 66A6 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 66A8 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 66AA 05CB  14 mknum3  inct  r11
0047 66AC 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     66AE 6020 
0048 66B0 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 66B2 045B  20         b     *r11                  ; Exit
0050 66B4 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 66B6 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 66B8 13F8  14         jeq   mknum3                ; Yes, exit
0053 66BA 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 66BC 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     66BE 7FFF 
0058 66C0 C10B  18         mov   r11,tmp0
0059 66C2 0224  22         ai    tmp0,-4
     66C4 FFFC 
0060 66C6 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 66C8 0206  20         li    tmp2,>0500            ; String length = 5
     66CA 0500 
0062 66CC 0460  28         b     @xutstr               ; Display string
     66CE 6238 
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
0092 66D0 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 66D2 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 66D4 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 66D6 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 66D8 0207  20         li    tmp3,5                ; Set counter
     66DA 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 66DC 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 66DE 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 66E0 0584  14         inc   tmp0                  ; Next character
0104 66E2 0607  14         dec   tmp3                  ; Last digit reached ?
0105 66E4 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 66E6 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 66E8 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 66EA DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 66EC 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 66EE DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 66F0 0607  14         dec   tmp3                  ; Last character ?
0120 66F2 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 66F4 045B  20         b     *r11                  ; Return
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
0138 66F6 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     66F8 832A 
0139 66FA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     66FC 8000 
0140 66FE 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0179               
0181                        copy  "cpu_crc16.asm"      ; CRC-16 checksum calculation
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
0030 6700 C13B  30         mov   *r11+,wmemory         ; First memory address
0031 6702 C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx
0033 6704 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 6706 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * Next word
0037               *--------------------------------------------------------------
0038               calc_crc1
0039 6708 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2
0044 670A C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 670C 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 670E C1C8  18         mov   wcrc,tmp3
0048 6710 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 6712 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 6714 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6716 00FF 
0052               
0053 6718 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 671A 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 671C 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     671E 6742 
0056               *--------------------------------------------------------------
0057               * Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3
0060 6720 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 6722 0246  22         andi  tmp2,>00ff            ; Clear MSB
     6724 00FF 
0062               
0063 6726 C1C8  18         mov   wcrc,tmp3
0064 6728 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 672A 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 672C 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     672E 00FF 
0068               
0069 6730 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 6732 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 6734 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6736 6742 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 6738 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 673A 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 673C 04C7  14         clr   tmp3
0081 673E 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082 6740 045B  20         b     *r11                  ; Return
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
0095 6742 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     6744 1021 
     6746 2042 
     6748 3063 
     674A 4084 
     674C 50A5 
     674E 60C6 
     6750 70E7 
0096 6752 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     6754 9129 
     6756 A14A 
     6758 B16B 
     675A C18C 
     675C D1AD 
     675E E1CE 
     6760 F1EF 
0097 6762 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     6764 0210 
     6766 3273 
     6768 2252 
     676A 52B5 
     676C 4294 
     676E 72F7 
     6770 62D6 
0098 6772 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     6774 8318 
     6776 B37B 
     6778 A35A 
     677A D3BD 
     677C C39C 
     677E F3FF 
     6780 E3DE 
0099 6782 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     6784 3443 
     6786 0420 
     6788 1401 
     678A 64E6 
     678C 74C7 
     678E 44A4 
     6790 5485 
0100 6792 A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     6794 B54B 
     6796 8528 
     6798 9509 
     679A E5EE 
     679C F5CF 
     679E C5AC 
     67A0 D58D 
0101 67A2 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     67A4 2672 
     67A6 1611 
     67A8 0630 
     67AA 76D7 
     67AC 66F6 
     67AE 5695 
     67B0 46B4 
0102 67B2 B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     67B4 A77A 
     67B6 9719 
     67B8 8738 
     67BA F7DF 
     67BC E7FE 
     67BE D79D 
     67C0 C7BC 
0103 67C2 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     67C4 58E5 
     67C6 6886 
     67C8 78A7 
     67CA 0840 
     67CC 1861 
     67CE 2802 
     67D0 3823 
0104 67D2 C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     67D4 D9ED 
     67D6 E98E 
     67D8 F9AF 
     67DA 8948 
     67DC 9969 
     67DE A90A 
     67E0 B92B 
0105 67E2 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     67E4 4AD4 
     67E6 7AB7 
     67E8 6A96 
     67EA 1A71 
     67EC 0A50 
     67EE 3A33 
     67F0 2A12 
0106 67F2 DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     67F4 CBDC 
     67F6 FBBF 
     67F8 EB9E 
     67FA 9B79 
     67FC 8B58 
     67FE BB3B 
     6800 AB1A 
0107 6802 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     6804 7C87 
     6806 4CE4 
     6808 5CC5 
     680A 2C22 
     680C 3C03 
     680E 0C60 
     6810 1C41 
0108 6812 EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     6814 FD8F 
     6816 CDEC 
     6818 DDCD 
     681A AD2A 
     681C BD0B 
     681E 8D68 
     6820 9D49 
0109 6822 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     6824 6EB6 
     6826 5ED5 
     6828 4EF4 
     682A 3E13 
     682C 2E32 
     682E 1E51 
     6830 0E70 
0110 6832 FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     6834 EFBE 
     6836 DFDD 
     6838 CFFC 
     683A BF1B 
     683C AF3A 
     683E 9F59 
     6840 8F78 
0111 6842 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     6844 81A9 
     6846 B1CA 
     6848 A1EB 
     684A D10C 
     684C C12D 
     684E F14E 
     6850 E16F 
0112 6852 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     6854 00A1 
     6856 30C2 
     6858 20E3 
     685A 5004 
     685C 4025 
     685E 7046 
     6860 6067 
0113 6862 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     6864 9398 
     6866 A3FB 
     6868 B3DA 
     686A C33D 
     686C D31C 
     686E E37F 
     6870 F35E 
0114 6872 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     6874 1290 
     6876 22F3 
     6878 32D2 
     687A 4235 
     687C 5214 
     687E 6277 
     6880 7256 
0115 6882 B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     6884 A5CB 
     6886 95A8 
     6888 8589 
     688A F56E 
     688C E54F 
     688E D52C 
     6890 C50D 
0116 6892 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     6894 24C3 
     6896 14A0 
     6898 0481 
     689A 7466 
     689C 6447 
     689E 5424 
     68A0 4405 
0117 68A2 A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     68A4 B7FA 
     68A6 8799 
     68A8 97B8 
     68AA E75F 
     68AC F77E 
     68AE C71D 
     68B0 D73C 
0118 68B2 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     68B4 36F2 
     68B6 0691 
     68B8 16B0 
     68BA 6657 
     68BC 7676 
     68BE 4615 
     68C0 5634 
0119 68C2 D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     68C4 C96D 
     68C6 F90E 
     68C8 E92F 
     68CA 99C8 
     68CC 89E9 
     68CE B98A 
     68D0 A9AB 
0120 68D2 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     68D4 4865 
     68D6 7806 
     68D8 6827 
     68DA 18C0 
     68DC 08E1 
     68DE 3882 
     68E0 28A3 
0121 68E2 CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     68E4 DB5C 
     68E6 EB3F 
     68E8 FB1E 
     68EA 8BF9 
     68EC 9BD8 
     68EE ABBB 
     68F0 BB9A 
0122 68F2 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     68F4 5A54 
     68F6 6A37 
     68F8 7A16 
     68FA 0AF1 
     68FC 1AD0 
     68FE 2AB3 
     6900 3A92 
0123 6902 FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     6904 ED0F 
     6906 DD6C 
     6908 CD4D 
     690A BDAA 
     690C AD8B 
     690E 9DE8 
     6910 8DC9 
0124 6912 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     6914 6C07 
     6916 5C64 
     6918 4C45 
     691A 3CA2 
     691C 2C83 
     691E 1CE0 
     6920 0CC1 
0125 6922 EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     6924 FF3E 
     6926 CF5D 
     6928 DF7C 
     692A AF9B 
     692C BFBA 
     692E 8FD9 
     6930 9FF8 
0126 6932 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     6934 7E36 
     6936 4E55 
     6938 5E74 
     693A 2E93 
     693C 3EB2 
     693E 0ED1 
     6940 1EF0 
**** **** ****     > runlib.asm
0183               
0187               
0189                       copy  "mem_paging.asm"      ; Memory paging functions
**** **** ****     > mem_paging.asm
0001               * FILE......: mem_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * mem.scrpad.pgout - Page out scratchpad memory
0010               ***************************************************************
0011               *  bl   @mem.scrpad.pgout
0012               *  DATA p0
0013               *--------------------------------------------------------------
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
0024 6942 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025 6944 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xmem.scrpad.pgout:
0030 6946 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6948 8300 
0031 694A 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     694C 0080 
0032 694E C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 6950 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 6952 0606  14         dec   tmp2
0038 6954 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 6956 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 6958 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     695A 6960 
0044                                                   ; R14=PC
0045 695C 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS will be moved to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 695E 0380  18         rtwp                        ; Activate new workspace
0052                       ;------------------------------------------------------
0053                       ; Setup scratchpad memory for DSRLNK/GPLLNK
0054                       ;------------------------------------------------------
0055               mem.scrpad.pgout.after.rtwp:
0056 6960 0205  20         li    tmp1,>8300
     6962 8300 
0057 6964 0206  20         li    tmp2,128              ; Clear 128 words of memory
     6966 0080 
0058                       ;------------------------------------------------------
0059                       ; Clear scratchpad memory >8300 - >83ff
0060                       ;------------------------------------------------------
0061 6968 04F5  30 !       clr   *tmp1+
0062 696A 0606  14         dec   tmp2
0063 696C 16FD  14         jne   -!                    ; Loop until done
0064                       ;------------------------------------------------------
0065                       ; Poke values in GPL workspace >83e0 - >83ff
0066                       ;------------------------------------------------------
0067 696E 0204  20         li    tmp0,>9800
     6970 9800 
0068 6972 C804  38         mov   tmp0,@>83fa           ; R13 = >9800
     6974 83FA 
0069               
0070 6976 0204  20         li    tmp0,>0108
     6978 0108 
0071 697A C804  38         mov   tmp0,@>83fc           ; R14 = >0001
     697C 83FC 
0072               
0073 697E 0204  20         li    tmp0,>8c02
     6980 8C02 
0074 6982 C804  38         mov   tmp0,@>83fe           ; R15 = >8c02
     6984 83FE 
0075                       ;------------------------------------------------------
0076                       ; Exit
0077                       ;------------------------------------------------------
0078               mem.scrpad.pgout.$$:
0079 6986 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0191               
0193                       copy  "io_dsrlnk.asm"       ; DSRLNK for peripheral communication
**** **** ****     > io_dsrlnk.asm
0001               * FILE......: io_dsrlnk.asm
0002               * Purpose...: DSRLNK implementation for file I/O use
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F000
0010               ***************************************************************
0011               *  blwp @dsrlnk
0012               *  data p0
0013               *--------------------------------------------------------------
0014               *  P0 = 8 or 10 (a)
0015               *--------------------------------------------------------------
0016               ; dsrlnk routine - Written by Paolo Bagnaresi
0017               *--------------------------------------------------------------
0018 6988 8380     dsrlnk  data  dsrlws               ; dsrlnk workspace
0019 698A 698C             data  dlentr               ; entry point
0020                       ;------------------------------------------------------
0021                       ; DSRLNK entry point
0022                       ;------------------------------------------------------
0023 698C 0200  20 dlentr  li    r0,>aa00
     698E AA00 
0024 6990 D800  38         movb  r0,@haa              ; load haa
     6992 8320 
0025 6994 C17E  30         mov   *r14+,r5             ; get pgm type for link
0026 6996 C805  38         mov   r5,@sav8a            ; save data following blwp @dsrlnk (8 or >a)
     6998 8322 
0027 699A 53E0  34         szcb  @h20,r15             ; reset equal bit
     699C 6A96 
0028 699E C020  34         mov   @>8356,r0            ; get ptr to pab
     69A0 8356 
0029 69A2 C240  18         mov   r0,r9                ; save ptr
0030 69A4 C800  38         mov   r0,@flgptr           ; save again pointer to pab+1 for dsrlnk
     69A6 8324 
0031                                                  ; data 8
0032                       ;------------------------------------------------------
0033                       ; Get file descriptor length
0034                       ;------------------------------------------------------
0035 69A8 0229  22         ai    r9,>fff8             ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     69AA FFF8 
0036 69AC 06A0  32         bl    @_vsbr               ; read file descriptor length
     69AE 6A98 
0037 69B0 D0C1  18         movb  r1,r3                ; copy it
0038 69B2 0983  56         srl   r3,8                 ; make it lo byter
0039                       ;------------------------------------------------------
0040                       ; Fetch file descriptor device name from PAB
0041                       ;------------------------------------------------------
0042 69B4 0704  14         seto  r4                   ; init counter
0043 69B6 0202  20         li    r2,namsto            ; point to 8-byte buffer
     69B8 8330 
0044 69BA 0580  14 lnkslp  inc   r0                   ; point to next char of name
0045 69BC 0584  14         inc   r4                   ; incr char counter
0046 69BE 0284  22         ci    r4,>0007             ; see if length more than 7 chars
     69C0 0007 
0047 69C2 1561  14         jgt   lnkerr               ; yes, error
0048 69C4 80C4  18         c     r4,r3                ; end of name?
0049 69C6 1306  14         jeq   lnksln               ; yes
0050 69C8 06A0  32         bl    @_vsbr               ; read curr char
     69CA 6A98 
0051 69CC DC81  32         movb  r1,*r2+              ; move into buffer
0052 69CE 9801  38         cb    r1,@decmal           ; is it a '.' period?
     69D0 6A94 
0053 69D2 16F3  14         jne   lnkslp               ; no, loop next char
0054                       ;------------------------------------------------------
0055                       ; Determine device name length
0056                       ;------------------------------------------------------
0057 69D4 C104  18 lnksln  mov   r4,r4                ; see if 0 length
0058 69D6 1357  14         jeq   lnkerr               ; yes, error
0059 69D8 04E0  34         clr   @>83d0
     69DA 83D0 
0060 69DC C804  38         mov   r4,@>8354            ; save name length for search
     69DE 8354 
0061 69E0 C804  38         mov   r4,@savlen           ; save it here too
     69E2 832C 
0062 69E4 0584  14         inc   r4                   ; adjust for period
0063 69E6 A804  38         a     r4,@>8356            ; point to position after name
     69E8 8356 
0064 69EA C820  54         mov   @>8356,@savpab       ; save pointer to position after name
     69EC 8356 
     69EE 832E 
0065                       ;------------------------------------------------------
0066                       ; Prepare for DSR scan >1000 - >1f00
0067                       ;------------------------------------------------------
0068 69F0 02E0  18 srom    lwpi  >83e0                ; use gplws
     69F2 83E0 
0069 69F4 04C1  14         clr   r1                   ; version found of dsr
0070 69F6 020C  20         li    r12,>0f00            ; init cru addr
     69F8 0F00 
0071 69FA C30C  18 norom   mov   r12,r12              ; anything to turn off?
0072 69FC 1301  14         jeq   nooff                ; no
0073 69FE 1E00  20         sbz   0                    ; yes, turn off
0074                       ;------------------------------------------------------
0075                       ; Loop over cards and look if DSR present
0076                       ;------------------------------------------------------
0077 6A00 022C  22 nooff   ai    r12,>0100            ; next rom to turn on
     6A02 0100 
0078 6A04 04E0  34         clr   @>83d0               ; clear in case we are done
     6A06 83D0 
0079 6A08 028C  22         ci    r12,>2000            ; see if done
     6A0A 2000 
0080 6A0C 133A  14         jeq   nodsr                ; yes, no dsr match
0081 6A0E C80C  38         mov   r12,@>83d0           ; save addr of next cru
     6A10 83D0 
0082 6A12 1D00  20         sbo   0                    ; turn on rom
0083 6A14 0202  20         li    r2,>4000             ; start at beginning of rom
     6A16 4000 
0084 6A18 9812  46         cb    *r2,@haa             ; check for a valid rom
     6A1A 8320 
0085 6A1C 16EE  14         jne   norom                ; no rom here
0086                       ;------------------------------------------------------
0087                       ; Valid DSR ROM found, now start digging in
0088                       ;------------------------------------------------------
0089                       ; dstype is the address of R5 of the DSRLNK workspace
0090                       ; (dsrlws--see bottom of page), which is where 8 for a DSR
0091                       ; or 10 (>A) for a subprogram is stored before the DSR
0092                       ; ROM is searched.
0093                       ;------------------------------------------------------
0094 6A1E A0A0  34         a     @dstype,r2           ; go to first pointer (byte 8 or 10)
     6A20 838A 
0095 6A22 1003  14         jmp   sgo2
0096 6A24 C0A0  34 sgo     mov   @>83d2,r2            ; continue where we left off
     6A26 83D2 
0097 6A28 1D00  20         sbo   0                    ; turn rom back on
0098 6A2A C092  26 sgo2    mov   *r2,r2               ; is addr a zero (end of link)
0099 6A2C 13E6  14         jeq   norom                ; yes, no programs to check
0100                       ;------------------------------------------------------
0101                       ; Loop over entries in DSR header looking for match
0102                       ;------------------------------------------------------
0103 6A2E C802  38         mov   r2,@>83d2            ; remember where to go next
     6A30 83D2 
0104 6A32 05C2  14         inct  r2                   ; go to entry point
0105 6A34 C272  30         mov   *r2+,r9              ; get entry addr just in case
0106 6A36 D160  34         movb  @>8355,r5            ; get length as counter
     6A38 8355 
0107 6A3A 1309  14         jeq   namtwo               ; if zero, do not check
0108 6A3C 9C85  32         cb    r5,*r2+              ; see if length matches
0109 6A3E 16F2  14         jne   sgo                  ; no, try next
0110 6A40 0985  56         srl   r5,8                 ; yes, move to lo byte as counter
0111 6A42 0206  20         li    r6,namsto            ; point to 8-byte buffer
     6A44 8330 
0112 6A46 9CB6  42 namone  cb    *r6+,*r2+            ; compare buffer with rom
0113 6A48 16ED  14         jne   sgo                  ; try next if no match
0114 6A4A 0605  14         dec   r5                   ; loop til full length checked
0115 6A4C 16FC  14         jne   namone
0116                       ;------------------------------------------------------
0117                       ; Device name match
0118                       ;------------------------------------------------------
0119               *        mov   r2,@>83d2            ; DSR entry addr must be saved at @>83d2
0120 6A4E 0581  14 namtwo  inc   r1                   ; next version found
0121 6A50 C801  38         mov   r1,@savver           ; save version
     6A52 8326 
0122 6A54 C809  38         mov   r9,@savent           ; save entry addr
     6A56 8328 
0123 6A58 C80C  38         mov   r12,@savcru          ; save cru
     6A5A 832A 
0124                       ;------------------------------------------------------
0125                       ; Call DSR program in device card
0126                       ;------------------------------------------------------
0127 6A5C 0699  24         bl    *r9                  ; go run routine
0128 6A5E 10E2  14         jmp   sgo                  ; error return
0129 6A60 1E00  20         sbz   0                    ; turn off rom if good return
0130 6A62 02E0  18         lwpi  dsrlws               ; restore workspace
     6A64 8380 
0131 6A66 C009  18         mov   r9,r0                ; point to flag in pab
0132 6A68 C060  34 frmdsr  mov   @sav8a,r1            ; get back data following blwp @dsrlnk
     6A6A 8322 
0133                                                  ; (8 or >a)
0134 6A6C 0281  22         ci    r1,8                 ; was it 8?
     6A6E 0008 
0135 6A70 1303  14         jeq   dsrdt8               ; yes, jump: normal dsrlnk
0136 6A72 D060  34         movb  @>8350,r1            ; no, we have a data >a. get error byte from
     6A74 8350 
0137                                                  ; >8350
0138 6A76 1002  14         jmp   dsrdta               ; go and return error byte to the caller
0139                       ;------------------------------------------------------
0140                       ; Read PAB status flag after DSR call completed
0141                       ;------------------------------------------------------
0142 6A78 06A0  32 dsrdt8  bl    @_vsbr               ; read flag
     6A7A 6A98 
0143                       ;------------------------------------------------------
0144                       ; Return DSR error to caller
0145                       ;------------------------------------------------------
0146 6A7C 09D1  56 dsrdta  srl   r1,13                ; just keep error bits
0147 6A7E 1604  14         jne   ioerr                ; handle error
0148 6A80 0380  18         rtwp                       ; Return from DSR workspace to caller workspace
0149                       ;------------------------------------------------------
0150                       ; IO-error handler
0151                       ;------------------------------------------------------
0152 6A82 02E0  18 nodsr   lwpi  dsrlws               ; no dsr, restore workspace
     6A84 8380 
0153 6A86 04C1  14 lnkerr  clr   r1                   ; clear flag for error 0 = bad device name
0154 6A88 06C1  14 ioerr   swpb  r1                   ; put error in hi byte
0155 6A8A D741  30         movb  r1,*r13              ; store error flags in callers r0
0156 6A8C F3E0  34         socb  @h20,r15             ; set equal bit to indicate error
     6A8E 6A96 
0157 6A90 0380  18         rtwp                       ; Return from DSR workspace to caller workspace
0158               
0159               ****************************************************************************************
0160               
0161 6A92 0008     data8   data  >8                   ; just to compare. 8 is the data that
0162                                                  ; usually follows a blwp @dsrlnk
0163 6A94 ....     decmal  text  '.'                  ; for finding end of device name
0164                       even
0165 6A96 2000     h20     data  >2000
0166               
0167               
0168               ; Following code added for supporting VDP SINGLE BYTE READ
0169               ; Filip van Vooren
0170               
0171 6A98 06C0  14 _vsbr   swpb  r0
0172 6A9A D800  38         movb  r0,@vdpa             ; send low byte
     6A9C 8C02 
0173 6A9E 06C0  14         swpb  r0
0174 6AA0 D800  38         movb  r0,@vdpa             ; send high byte
     6AA2 8C02 
0175 6AA4 D060  34         movb  @vdpr,r1             ; read byte from VDP ram
     6AA6 8800 
0176 6AA8 045B  20         rt
**** **** ****     > runlib.asm
0195               
0196               
0197               
0198               *//////////////////////////////////////////////////////////////
0199               *                            TIMERS
0200               *//////////////////////////////////////////////////////////////
0201               
0202               ***************************************************************
0203               * TMGR - X - Start Timer/Thread scheduler
0204               ***************************************************************
0205               *  B @TMGR
0206               *--------------------------------------------------------------
0207               *  REMARKS
0208               *  Timer/Thread scheduler. Normally called from MAIN.
0209               *  This is basically the kernel keeping everything togehter.
0210               *  Do not forget to set BTIHI to highest slot in use.
0211               *
0212               *  Register usage in TMGR8 - TMGR11
0213               *  TMP0  = Pointer to timer table
0214               *  R10LB = Use as slot counter
0215               *  TMP2  = 2nd word of slot data
0216               *  TMP3  = Address of routine to call
0217               ********@*****@*********************@**************************
0218 6AAA 0300  24 tmgr    limi  0                     ; No interrupt processing
     6AAC 0000 
0219               *--------------------------------------------------------------
0220               * Read VDP status register
0221               *--------------------------------------------------------------
0222 6AAE D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6AB0 8802 
0223               *--------------------------------------------------------------
0224               * Latch sprite collision flag
0225               *--------------------------------------------------------------
0226 6AB2 2360  38         coc   @wbit2,r13            ; C flag on ?
     6AB4 6024 
0227 6AB6 1602  14         jne   tmgr1a                ; No, so move on
0228 6AB8 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6ABA 6038 
0229               *--------------------------------------------------------------
0230               * Interrupt flag
0231               *--------------------------------------------------------------
0232 6ABC 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6ABE 6020 
0233 6AC0 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0234               *--------------------------------------------------------------
0235               * Run speech player
0236               *--------------------------------------------------------------
0242               *--------------------------------------------------------------
0243               * Run kernel thread
0244               *--------------------------------------------------------------
0245 6AC2 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6AC4 6030 
0246 6AC6 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0247 6AC8 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6ACA 6032 
0248 6ACC 1602  14         jne   tmgr3                 ; No, skip to user hook
0249 6ACE 0460  28         b     @kthread              ; Run kernel thread
     6AD0 6B48 
0250               *--------------------------------------------------------------
0251               * Run user hook
0252               *--------------------------------------------------------------
0253 6AD2 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6AD4 602C 
0254 6AD6 13EB  14         jeq   tmgr1
0255 6AD8 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6ADA 602E 
0256 6ADC 16E8  14         jne   tmgr1
0257 6ADE C120  34         mov   @wtiusr,tmp0
     6AE0 832E 
0258 6AE2 0454  20         b     *tmp0                 ; Run user hook
0259               *--------------------------------------------------------------
0260               * Do internal housekeeping
0261               *--------------------------------------------------------------
0262 6AE4 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6AE6 6B46 
0263 6AE8 C10A  18         mov   r10,tmp0
0264 6AEA 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6AEC 00FF 
0265 6AEE 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6AF0 6024 
0266 6AF2 1303  14         jeq   tmgr5
0267 6AF4 0284  22         ci    tmp0,60               ; 1 second reached ?
     6AF6 003C 
0268 6AF8 1002  14         jmp   tmgr6
0269 6AFA 0284  22 tmgr5   ci    tmp0,50
     6AFC 0032 
0270 6AFE 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0271 6B00 1001  14         jmp   tmgr8
0272 6B02 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0273               *--------------------------------------------------------------
0274               * Loop over slots
0275               *--------------------------------------------------------------
0276 6B04 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6B06 832C 
0277 6B08 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6B0A FF00 
0278 6B0C C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0279 6B0E 1316  14         jeq   tmgr11                ; Yes, get next slot
0280               *--------------------------------------------------------------
0281               *  Check if slot should be executed
0282               *--------------------------------------------------------------
0283 6B10 05C4  14         inct  tmp0                  ; Second word of slot data
0284 6B12 0594  26         inc   *tmp0                 ; Update tick count in slot
0285 6B14 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0286 6B16 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6B18 830C 
     6B1A 830D 
0287 6B1C 1608  14         jne   tmgr10                ; No, get next slot
0288 6B1E 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6B20 FF00 
0289 6B22 C506  30         mov   tmp2,*tmp0            ; Update timer table
0290               *--------------------------------------------------------------
0291               *  Run slot, we only need TMP0 to survive
0292               *--------------------------------------------------------------
0293 6B24 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6B26 8330 
0294 6B28 0697  24         bl    *tmp3                 ; Call routine in slot
0295 6B2A C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6B2C 8330 
0296               *--------------------------------------------------------------
0297               *  Prepare for next slot
0298               *--------------------------------------------------------------
0299 6B2E 058A  14 tmgr10  inc   r10                   ; Next slot
0300 6B30 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6B32 8315 
     6B34 8314 
0301 6B36 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0302 6B38 05C4  14         inct  tmp0                  ; Offset for next slot
0303 6B3A 10E8  14         jmp   tmgr9                 ; Process next slot
0304 6B3C 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0305 6B3E 10F7  14         jmp   tmgr10                ; Process next slot
0306 6B40 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6B42 FF00 
0307 6B44 10B4  14         jmp   tmgr1
0308 6B46 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0309               
0310               
0314               
0315               
0316               ***************************************************************
0317               * KTHREAD - The kernel thread
0318               *--------------------------------------------------------------
0319               *  REMARKS
0320               *  You should not call the kernel thread manually.
0321               *  Instead control it via the CONFIG register.
0322               *
0323               *  The kernel thread is responsible for running the sound
0324               *  player and doing keyboard scan.
0325               ********@*****@*********************@**************************
0326 6B48 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6B4A 6030 
0327               *--------------------------------------------------------------
0328               * Run sound player
0329               *--------------------------------------------------------------
0331               *       <<skipped>>
0337               *--------------------------------------------------------------
0338               * Scan virtual keyboard
0339               *--------------------------------------------------------------
0340               kthread_kb
0344 6B4C 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     6B4E 63BA 
0346               *--------------------------------------------------------------
0347               * Scan real keyboard
0348               *--------------------------------------------------------------
0352 6B50 06A0  32         bl    @realkb               ; Scan full keyboard
     6B52 64AA 
0354               *--------------------------------------------------------------
0355               kthread_exit
0356 6B54 0460  28         b     @tmgr3                ; Exit
     6B56 6AD2 
0357               
0358               
0359               
0360               ***************************************************************
0361               * MKHOOK - Allocate user hook
0362               ***************************************************************
0363               *  BL    @MKHOOK
0364               *  DATA  P0
0365               *--------------------------------------------------------------
0366               *  P0 = Address of user hook
0367               *--------------------------------------------------------------
0368               *  REMARKS
0369               *  The user hook gets executed after the kernel thread.
0370               *  The user hook must always exit with "B @HOOKOK"
0371               ********@*****@*********************@**************************
0372 6B58 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6B5A 832E 
0373 6B5C E0A0  34         soc   @wbit7,config         ; Enable user hook
     6B5E 602E 
0374 6B60 045B  20 mkhoo1  b     *r11                  ; Return
0375      6AAE     hookok  equ   tmgr1                 ; Exit point for user hook
0376               
0377               
0378               ***************************************************************
0379               * CLHOOK - Clear user hook
0380               ***************************************************************
0381               *  BL    @CLHOOK
0382               ********@*****@*********************@**************************
0383 6B62 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6B64 832E 
0384 6B66 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6B68 FEFF 
0385 6B6A 045B  20         b     *r11                  ; Return
0386               
0387               
0388               
0389               *//////////////////////////////////////////////////////////////
0390               *                    RUNLIB INITIALISATION
0391               *//////////////////////////////////////////////////////////////
0392               
0393               ***************************************************************
0394               *  RUNLIB - Runtime library initalisation
0395               ***************************************************************
0396               *  B  @RUNLIB
0397               *--------------------------------------------------------------
0398               *  REMARKS
0399               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0400               *  after clearing scratchpad memory.
0401               *  Use 'B @RUNLI1' to exit your program.
0402               ********@*****@*********************@**************************
0403 6B6C 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6B6E 8302 
0404               *--------------------------------------------------------------
0405               * Alternative entry point
0406               *--------------------------------------------------------------
0407 6B70 0300  24 runli1  limi  0                     ; Turn off interrupts
     6B72 0000 
0408 6B74 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6B76 8300 
0409 6B78 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6B7A 83C0 
0410               
0411               *--------------------------------------------------------------
0412               * Clear scratch-pad memory from R4 upwards
0413               *--------------------------------------------------------------
0414 6B7C 0202  20 runli2  li    r2,>8308
     6B7E 8308 
0415 6B80 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0416 6B82 0282  22         ci    r2,>8400
     6B84 8400 
0417 6B86 16FC  14         jne   runli3
0418               *--------------------------------------------------------------
0419               * Exit to TI-99/4A title screen ?
0420               *--------------------------------------------------------------
0421 6B88 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6B8A FFFF 
0422 6B8C 1602  14         jne   runli4                ; No, continue
0423 6B8E 0420  54         blwp  @0                    ; Yes, bye bye
     6B90 0000 
0424               *--------------------------------------------------------------
0425               * Determine if VDP is PAL or NTSC
0426               *--------------------------------------------------------------
0427 6B92 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6B94 833C 
0428 6B96 04C1  14         clr   r1                    ; Reset counter
0429 6B98 0202  20         li    r2,10                 ; We test 10 times
     6B9A 000A 
0430 6B9C C0E0  34 runli5  mov   @vdps,r3
     6B9E 8802 
0431 6BA0 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6BA2 6020 
0432 6BA4 1302  14         jeq   runli6
0433 6BA6 0581  14         inc   r1                    ; Increase counter
0434 6BA8 10F9  14         jmp   runli5
0435 6BAA 0602  14 runli6  dec   r2                    ; Next test
0436 6BAC 16F7  14         jne   runli5
0437 6BAE 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6BB0 1250 
0438 6BB2 1202  14         jle   runli7                ; No, so it must be NTSC
0439 6BB4 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6BB6 6024 
0440               *--------------------------------------------------------------
0441               * Copy machine code to scratchpad (prepare tight loop)
0442               *--------------------------------------------------------------
0443 6BB8 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6BBA 607A 
0444 6BBC 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6BBE 8322 
0445 6BC0 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0446 6BC2 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0447 6BC4 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0448               *--------------------------------------------------------------
0449               * Initialize registers, memory, ...
0450               *--------------------------------------------------------------
0451 6BC6 04C1  14 runli9  clr   r1
0452 6BC8 04C2  14         clr   r2
0453 6BCA 04C3  14         clr   r3
0454 6BCC 0209  20         li    stack,>8400           ; Set stack
     6BCE 8400 
0455 6BD0 020F  20         li    r15,vdpw              ; Set VDP write address
     6BD2 8C00 
0459               *--------------------------------------------------------------
0460               * Setup video memory
0461               *--------------------------------------------------------------
0462 6BD4 06A0  32         bl    @filv
     6BD6 60B4 
0463 6BD8 0000             data  >0000,>00,16000       ; Clear VDP memory
     6BDA 0000 
     6BDC 3E80 
0464 6BDE 06A0  32         bl    @filv
     6BE0 60B4 
0465 6BE2 0FC0             data  pctadr,spfclr,16      ; Load color table
     6BE4 00C1 
     6BE6 0010 
0466               *--------------------------------------------------------------
0467               * Check if there is a F18A present
0468               *--------------------------------------------------------------
0472 6BE8 06A0  32         bl    @f18unl               ; Unlock the F18A
     6BEA 632A 
0473 6BEC 06A0  32         bl    @f18chk               ; Check if F18A is there
     6BEE 6344 
0474 6BF0 06A0  32         bl    @f18lck               ; Lock the F18A again
     6BF2 633A 
0476               *--------------------------------------------------------------
0477               * Check if there is a speech synthesizer attached
0478               *--------------------------------------------------------------
0480               *       <<skipped>>
0484               *--------------------------------------------------------------
0485               * Load video mode table & font
0486               *--------------------------------------------------------------
0487 6BF4 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6BF6 610E 
0488 6BF8 6070             data  spvmod                ; Equate selected video mode table
0489 6BFA 0204  20         li    tmp0,spfont           ; Get font option
     6BFC 000C 
0490 6BFE 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0491 6C00 1304  14         jeq   runlid                ; Yes, skip it
0492 6C02 06A0  32         bl    @ldfnt
     6C04 6176 
0493 6C06 1100             data  fntadr,spfont         ; Load specified font
     6C08 000C 
0494               *--------------------------------------------------------------
0495               * Branch to main program
0496               *--------------------------------------------------------------
0497 6C0A 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6C0C 0040 
0498 6C0E 0460  28         b     @main                 ; Give control to main program
     6C10 6C12 
**** **** ****     > hello_world.asm.10853
0064               *--------------------------------------------------------------
0065               * SPECTRA2 startup options
0066               *--------------------------------------------------------------
0067      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0068      0001     spfbck  equ   >01                   ; Screen background color.
0069               ;--------------------------------------------------------------
0070               ; Video mode configuration
0071               ;--------------------------------------------------------------
0072      6070     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0073      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0074      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0075      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0076               
0077               ***************************************************************
0078               * Main
0079               ********@*****@*********************@**************************
0080 6C12 06A0  32 main    bl    @putat
     6C14 6246 
0081 6C16 081F             data  >081f,hello_world
     6C18 6C1E 
0082               
0083 6C1A 0460  28         b     @tmgr                 ;
     6C1C 6AAA 
0084               
0085               
0086               hello_world:
0087               
0088 6C1E 0C48             byte  12
0089 6C1F ....             text  'Hello World!'
0090                       even
0091               
