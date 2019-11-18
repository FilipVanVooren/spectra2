XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > fio.asm.927
0001               ***************************************************************
0002               *
0003               *                          File I/O test
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: fio.asm                     ; Version 191118-927
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
0040      0001     skip_tms52xx_detection    equ  1    ; Skip speech synthesizer detection
0041      0001     skip_tms52xx_player       equ  1    ; Skip inclusion of speech player code
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
0053 6012 6FC0             data  runlib
0055               
0056 6014 0F46             byte  15
0057 6015 ....             text  'FIOT 191118-927'
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
0066               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0067               *******************************************************************************
0068               
0069               *//////////////////////////////////////////////////////////////
0070               *                       RUNLIB SETUP
0071               *//////////////////////////////////////////////////////////////
0072               
0073                       copy  "memsetup.asm"             ; runlib scratchpad memory setup
**** **** ****     > memsetup.asm
0001               * FILE......: memsetup.asm
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
0074                       copy  "registers.asm"            ; runlib registers
**** **** ****     > registers.asm
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
0075                       copy  "portaddr.asm"             ; runlib hardware port addresses
**** **** ****     > portaddr.asm
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
0076                       copy  "param.asm"                ; runlib parameters
**** **** ****     > param.asm
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
0013 6024 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0014 6026 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0015 6028 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0016 602A 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0017 602C 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0018 602E 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0019 6030 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0020 6032 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0021 6034 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0022 6036 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0023 6038 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0024 603A 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0025 603C 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0026 603E 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0027 6040 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0028 6042 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0029 6044 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0030 6046 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0031 6048 D000     w$d000  data  >d000                 ; >d000
0032               *--------------------------------------------------------------
0033               * Byte values - High byte (=MSB) for byte operations
0034               *--------------------------------------------------------------
0035      6024     hb$00   equ   w$0000                ; >0000
0036      6036     hb$01   equ   w$0100                ; >0100
0037      6038     hb$02   equ   w$0200                ; >0200
0038      603A     hb$04   equ   w$0400                ; >0400
0039      603C     hb$08   equ   w$0800                ; >0800
0040      603E     hb$10   equ   w$1000                ; >1000
0041      6040     hb$20   equ   w$2000                ; >2000
0042      6042     hb$40   equ   w$4000                ; >4000
0043      6044     hb$80   equ   w$8000                ; >8000
0044      6048     hb$d0   equ   w$d000                ; >d000
0045               *--------------------------------------------------------------
0046               * Byte values - Low byte (=LSB) for byte operations
0047               *--------------------------------------------------------------
0048      6024     lb$00   equ   w$0000                ; >0000
0049      6026     lb$01   equ   w$0001                ; >0001
0050      6028     lb$02   equ   w$0002                ; >0002
0051      602A     lb$04   equ   w$0004                ; >0004
0052      602C     lb$08   equ   w$0008                ; >0008
0053      602E     lb$10   equ   w$0010                ; >0010
0054      6030     lb$20   equ   w$0020                ; >0020
0055      6032     lb$40   equ   w$0040                ; >0040
0056      6034     lb$80   equ   w$0080                ; >0080
0057               *--------------------------------------------------------------
0058               * Bit values
0059               *--------------------------------------------------------------
0060               ;                                   ;       0123456789ABCDEF
0061      6026     wbit15  equ   w$0001                ; >0001 0000000000000001
0062      6028     wbit14  equ   w$0002                ; >0002 0000000000000010
0063      602A     wbit13  equ   w$0004                ; >0004 0000000000000100
0064      602C     wbit12  equ   w$0008                ; >0008 0000000000001000
0065      602E     wbit11  equ   w$0010                ; >0010 0000000000010000
0066      6030     wbit10  equ   w$0020                ; >0020 0000000000100000
0067      6032     wbit9   equ   w$0040                ; >0040 0000000001000000
0068      6034     wbit8   equ   w$0080                ; >0080 0000000010000000
0069      6036     wbit7   equ   w$0100                ; >0100 0000000100000000
0070      6038     wbit6   equ   w$0200                ; >0200 0000001000000000
0071      603A     wbit5   equ   w$0400                ; >0400 0000010000000000
0072      603C     wbit4   equ   w$0800                ; >0800 0000100000000000
0073      603E     wbit3   equ   w$1000                ; >1000 0001000000000000
0074      6040     wbit2   equ   w$2000                ; >2000 0010000000000000
0075      6042     wbit1   equ   w$4000                ; >4000 0100000000000000
0076      6044     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0083                       copy  "config.asm"               ; Equates for bits in config register
**** **** ****     > config.asm
0001               * FILE......: config.asm
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
0027      6040     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6036     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6032     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6030     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      602E     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0012               *  b  @crash_handler
0013               ********@*****@*********************@**************************
0014               crash_handler:
0015 604A 02E0  18         lwpi  ws1                   ; Activate workspace 1
     604C 8300 
0016 604E 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6050 8302 
0017 6052 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     6054 4A4A 
0018 6056 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     6058 6FC8 
0019               
0020               crash_handler.main:
0021 605A 06A0  32         bl    @putat                ; Show crash message
     605C 6278 
0022 605E 0000             data  >0000,crash_handler.message
     6060 6064 
0023 6062 10FF  14         jmp   $
0024               
0025               crash_handler.message:
0026 6064 0F53             byte  15
0027 6065 ....             text  'System crashed.'
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
0007 6074 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6076 000E 
     6078 0106 
     607A 0201 
     607C 0020 
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
0032 607E 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6080 000E 
     6082 0106 
     6084 00C1 
     6086 0028 
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
0058 6088 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     608A 003F 
     608C 0240 
     608E 03C1 
     6090 0050 
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
0084 6092 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6094 003F 
     6096 0240 
     6098 03C1 
     609A 0050 
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
0013 609C 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 609E 16FD             data  >16fd                 ; |         jne   mcloop
0015 60A0 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 60A2 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 60A4 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 60A6 C0F9  30 popr3   mov   *stack+,r3
0039 60A8 C0B9  30 popr2   mov   *stack+,r2
0040 60AA C079  30 popr1   mov   *stack+,r1
0041 60AC C039  30 popr0   mov   *stack+,r0
0042 60AE C2F9  30 poprt   mov   *stack+,r11
0043 60B0 045B  20         b     *r11
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
0067 60B2 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 60B4 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 60B6 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 60B8 C1C6  18 xfilm   mov   tmp2,tmp3
0074 60BA 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60BC 0001 
0075               
0076 60BE 1301  14         jeq   film1
0077 60C0 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60C2 D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60C4 830B 
     60C6 830A 
0079 60C8 CD05  34 film2   mov   tmp1,*tmp0+
0080 60CA 0646  14         dect  tmp2
0081 60CC 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60CE C1C7  18         mov   tmp3,tmp3
0086 60D0 1301  14         jeq   filmz
0087 60D2 D505  30         movb  tmp1,*tmp0
0088 60D4 045B  20 filmz   b     *r11
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
0107 60D6 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60D8 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60DA C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60DC 0264  22 xfilv   ori   tmp0,>4000
     60DE 4000 
0114 60E0 06C4  14         swpb  tmp0
0115 60E2 D804  38         movb  tmp0,@vdpa
     60E4 8C02 
0116 60E6 06C4  14         swpb  tmp0
0117 60E8 D804  38         movb  tmp0,@vdpa
     60EA 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60EC 020F  20         li    r15,vdpw              ; Set VDP write address
     60EE 8C00 
0122 60F0 06C5  14         swpb  tmp1
0123 60F2 C820  54         mov   @filzz,@mcloop        ; Setup move command
     60F4 60FC 
     60F6 8320 
0124 60F8 0460  28         b     @mcloop               ; Write data to VDP
     60FA 8320 
0125               *--------------------------------------------------------------
0129 60FC D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60FE 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     6100 4000 
0150 6102 06C4  14 vdra    swpb  tmp0
0151 6104 D804  38         movb  tmp0,@vdpa
     6106 8C02 
0152 6108 06C4  14         swpb  tmp0
0153 610A D804  38         movb  tmp0,@vdpa            ; Set VDP address
     610C 8C02 
0154 610E 045B  20         b     *r11                  ; Exit
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
0165 6110 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 6112 C17B  30         mov   *r11+,tmp1            ; Get byte to write
0167               *--------------------------------------------------------------
0168               * Set VDP write address
0169               *--------------------------------------------------------------
0170 6114 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     6116 4000 
0171 6118 06C4  14         swpb  tmp0                  ; \
0172 611A D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     611C 8C02 
0173 611E 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0174 6120 D804  38         movb  tmp0,@vdpa            ; /
     6122 8C02 
0175               *--------------------------------------------------------------
0176               * Write byte
0177               *--------------------------------------------------------------
0178 6124 06C5  14         swpb  tmp1                  ; LSB to MSB
0179 6126 D7C5  30         movb  tmp1,*r15             ; Write byte
0180 6128 045B  20         b     *r11                  ; Exit
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
0199 612A C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0200               *--------------------------------------------------------------
0201               * Set VDP read address
0202               *--------------------------------------------------------------
0203 612C 06C4  14 xvgetb  swpb  tmp0                  ; \
0204 612E D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     6130 8C02 
0205 6132 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0206 6134 D804  38         movb  tmp0,@vdpa            ; /
     6136 8C02 
0207               *--------------------------------------------------------------
0208               * Read byte
0209               *--------------------------------------------------------------
0210 6138 D120  34         movb  @vdpr,tmp0            ; Read byte
     613A 8800 
0211 613C 0984  56         srl   tmp0,8                ; Right align
0212 613E 045B  20         b     *r11                  ; Exit
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
0231 6140 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0232 6142 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0233               *--------------------------------------------------------------
0234               * Calculate PNT base address
0235               *--------------------------------------------------------------
0236 6144 C144  18         mov   tmp0,tmp1
0237 6146 05C5  14         inct  tmp1
0238 6148 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0239 614A 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     614C FF00 
0240 614E 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0241 6150 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6152 8328 
0242               *--------------------------------------------------------------
0243               * Dump VDP shadow registers
0244               *--------------------------------------------------------------
0245 6154 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6156 8000 
0246 6158 0206  20         li    tmp2,8
     615A 0008 
0247 615C D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     615E 830B 
0248 6160 06C5  14         swpb  tmp1
0249 6162 D805  38         movb  tmp1,@vdpa
     6164 8C02 
0250 6166 06C5  14         swpb  tmp1
0251 6168 D805  38         movb  tmp1,@vdpa
     616A 8C02 
0252 616C 0225  22         ai    tmp1,>0100
     616E 0100 
0253 6170 0606  14         dec   tmp2
0254 6172 16F4  14         jne   vidta1                ; Next register
0255 6174 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6176 833A 
0256 6178 045B  20         b     *r11
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
0273 617A C13B  30 putvr   mov   *r11+,tmp0
0274 617C 0264  22 putvrx  ori   tmp0,>8000
     617E 8000 
0275 6180 06C4  14         swpb  tmp0
0276 6182 D804  38         movb  tmp0,@vdpa
     6184 8C02 
0277 6186 06C4  14         swpb  tmp0
0278 6188 D804  38         movb  tmp0,@vdpa
     618A 8C02 
0279 618C 045B  20         b     *r11
0280               
0281               
0282               ***************************************************************
0283               * PUTV01  - Put VDP registers #0 and #1
0284               ***************************************************************
0285               *  BL   @PUTV01
0286               ********@*****@*********************@**************************
0287 618E C20B  18 putv01  mov   r11,tmp4              ; Save R11
0288 6190 C10E  18         mov   r14,tmp0
0289 6192 0984  56         srl   tmp0,8
0290 6194 06A0  32         bl    @putvrx               ; Write VR#0
     6196 617C 
0291 6198 0204  20         li    tmp0,>0100
     619A 0100 
0292 619C D820  54         movb  @r14lb,@tmp0lb
     619E 831D 
     61A0 8309 
0293 61A2 06A0  32         bl    @putvrx               ; Write VR#1
     61A4 617C 
0294 61A6 0458  20         b     *tmp4                 ; Exit
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
0308 61A8 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0309 61AA 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0310 61AC C11B  26         mov   *r11,tmp0             ; Get P0
0311 61AE 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61B0 7FFF 
0312 61B2 2120  38         coc   @wbit0,tmp0
     61B4 6044 
0313 61B6 1604  14         jne   ldfnt1
0314 61B8 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     61BA 8000 
0315 61BC 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     61BE 7FFF 
0316               *--------------------------------------------------------------
0317               * Read font table address from GROM into tmp1
0318               *--------------------------------------------------------------
0319 61C0 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     61C2 622A 
0320 61C4 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     61C6 9C02 
0321 61C8 06C4  14         swpb  tmp0
0322 61CA D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     61CC 9C02 
0323 61CE D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61D0 9800 
0324 61D2 06C5  14         swpb  tmp1
0325 61D4 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61D6 9800 
0326 61D8 06C5  14         swpb  tmp1
0327               *--------------------------------------------------------------
0328               * Setup GROM source address from tmp1
0329               *--------------------------------------------------------------
0330 61DA D805  38         movb  tmp1,@grmwa
     61DC 9C02 
0331 61DE 06C5  14         swpb  tmp1
0332 61E0 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61E2 9C02 
0333               *--------------------------------------------------------------
0334               * Setup VDP target address
0335               *--------------------------------------------------------------
0336 61E4 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0337 61E6 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61E8 60FE 
0338 61EA 05C8  14         inct  tmp4                  ; R11=R11+2
0339 61EC C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0340 61EE 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61F0 7FFF 
0341 61F2 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61F4 622C 
0342 61F6 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61F8 622E 
0343               *--------------------------------------------------------------
0344               * Copy from GROM to VRAM
0345               *--------------------------------------------------------------
0346 61FA 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0347 61FC 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0348 61FE D120  34         movb  @grmrd,tmp0
     6200 9800 
0349               *--------------------------------------------------------------
0350               *   Make font fat
0351               *--------------------------------------------------------------
0352 6202 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     6204 6044 
0353 6206 1603  14         jne   ldfnt3                ; No, so skip
0354 6208 D1C4  18         movb  tmp0,tmp3
0355 620A 0917  56         srl   tmp3,1
0356 620C E107  18         soc   tmp3,tmp0
0357               *--------------------------------------------------------------
0358               *   Dump byte to VDP and do housekeeping
0359               *--------------------------------------------------------------
0360 620E D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     6210 8C00 
0361 6212 0606  14         dec   tmp2
0362 6214 16F2  14         jne   ldfnt2
0363 6216 05C8  14         inct  tmp4                  ; R11=R11+2
0364 6218 020F  20         li    r15,vdpw              ; Set VDP write address
     621A 8C00 
0365 621C 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     621E 7FFF 
0366 6220 0458  20         b     *tmp4                 ; Exit
0367 6222 D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     6224 6024 
     6226 8C00 
0368 6228 10E8  14         jmp   ldfnt2
0369               *--------------------------------------------------------------
0370               * Fonts pointer table
0371               *--------------------------------------------------------------
0372 622A 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     622C 0200 
     622E 0000 
0373 6230 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6232 01C0 
     6234 0101 
0374 6236 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6238 02A0 
     623A 0101 
0375 623C 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     623E 00E0 
     6240 0101 
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
0393 6242 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0394 6244 C3A0  34         mov   @wyx,r14              ; Get YX
     6246 832A 
0395 6248 098E  56         srl   r14,8                 ; Right justify (remove X)
0396 624A 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     624C 833A 
0397               *--------------------------------------------------------------
0398               * Do rest of calculation with R15 (16 bit part is there)
0399               * Re-use R14
0400               *--------------------------------------------------------------
0401 624E C3A0  34         mov   @wyx,r14              ; Get YX
     6250 832A 
0402 6252 024E  22         andi  r14,>00ff             ; Remove Y
     6254 00FF 
0403 6256 A3CE  18         a     r14,r15               ; pos = pos + X
0404 6258 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     625A 8328 
0405               *--------------------------------------------------------------
0406               * Clean up before exit
0407               *--------------------------------------------------------------
0408 625C C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0409 625E C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0410 6260 020F  20         li    r15,vdpw              ; VDP write address
     6262 8C00 
0411 6264 045B  20         b     *r11
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
0426 6266 C17B  30 putstr  mov   *r11+,tmp1
0427 6268 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0428 626A C1CB  18 xutstr  mov   r11,tmp3
0429 626C 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     626E 6242 
0430 6270 C2C7  18         mov   tmp3,r11
0431 6272 0986  56         srl   tmp2,8                ; Right justify length byte
0432 6274 0460  28         b     @xpym2v               ; Display string
     6276 6286 
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
0447 6278 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     627A 832A 
0448 627C 0460  28         b     @putstr
     627E 6266 
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
0020 6280 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6282 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6284 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6286 0264  22 xpym2v  ori   tmp0,>4000
     6288 4000 
0027 628A 06C4  14         swpb  tmp0
0028 628C D804  38         movb  tmp0,@vdpa
     628E 8C02 
0029 6290 06C4  14         swpb  tmp0
0030 6292 D804  38         movb  tmp0,@vdpa
     6294 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6296 020F  20         li    r15,vdpw              ; Set VDP write address
     6298 8C00 
0035 629A C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     629C 62A4 
     629E 8320 
0036 62A0 0460  28         b     @mcloop               ; Write data to VDP
     62A2 8320 
0037 62A4 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 62A6 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 62A8 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 62AA C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 62AC 06C4  14 xpyv2m  swpb  tmp0
0027 62AE D804  38         movb  tmp0,@vdpa
     62B0 8C02 
0028 62B2 06C4  14         swpb  tmp0
0029 62B4 D804  38         movb  tmp0,@vdpa
     62B6 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 62B8 020F  20         li    r15,vdpr              ; Set VDP read address
     62BA 8800 
0034 62BC C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     62BE 62C6 
     62C0 8320 
0035 62C2 0460  28         b     @mcloop               ; Read data from VDP
     62C4 8320 
0036 62C6 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 62C8 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 62CA C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 62CC C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 62CE C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 62D0 1602  14         jne   cpym0
0032 62D2 0460  28         b     @crash_handler        ; Yes, crash
     62D4 604A 
0033 62D6 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62D8 7FFF 
0034 62DA C1C4  18         mov   tmp0,tmp3
0035 62DC 0247  22         andi  tmp3,1
     62DE 0001 
0036 62E0 1618  14         jne   cpyodd                ; Odd source address handling
0037 62E2 C1C5  18 cpym1   mov   tmp1,tmp3
0038 62E4 0247  22         andi  tmp3,1
     62E6 0001 
0039 62E8 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62EA 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62EC 6044 
0044 62EE 1605  14         jne   cpym3
0045 62F0 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62F2 6318 
     62F4 8320 
0046 62F6 0460  28         b     @mcloop               ; Copy memory and exit
     62F8 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62FA C1C6  18 cpym3   mov   tmp2,tmp3
0051 62FC 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62FE 0001 
0052 6300 1301  14         jeq   cpym4
0053 6302 0606  14         dec   tmp2                  ; Make TMP2 even
0054 6304 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 6306 0646  14         dect  tmp2
0056 6308 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 630A C1C7  18         mov   tmp3,tmp3
0061 630C 1301  14         jeq   cpymz
0062 630E D554  38         movb  *tmp0,*tmp1
0063 6310 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 6312 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     6314 8000 
0068 6316 10E9  14         jmp   cpym2
0069 6318 DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
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
0009 631A 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     631C FFBF 
0010 631E 0460  28         b     @putv01
     6320 618E 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 6322 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6324 0040 
0018 6326 0460  28         b     @putv01
     6328 618E 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 632A 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     632C FFDF 
0026 632E 0460  28         b     @putv01
     6330 618E 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6332 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6334 0020 
0034 6336 0460  28         b     @putv01
     6338 618E 
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
0018 633A C83B  50 at      mov   *r11+,@wyx
     633C 832A 
0019 633E 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6340 B820  54 down    ab    @hb$01,@wyx
     6342 6036 
     6344 832A 
0028 6346 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 6348 7820  54 up      sb    @hb$01,@wyx
     634A 6036 
     634C 832A 
0037 634E 045B  20         b     *r11
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
0049 6350 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6352 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6354 832A 
0051 6356 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6358 832A 
0052 635A 045B  20         b     *r11
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
0013 635C C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 635E 06A0  32         bl    @putvr                ; Write once
     6360 617A 
0015 6362 391C             data  >391c                 ; VR1/57, value 00011100
0016 6364 06A0  32         bl    @putvr                ; Write twice
     6366 617A 
0017 6368 391C             data  >391c                 ; VR1/57, value 00011100
0018 636A 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 636C C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 636E 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6370 617A 
0028 6372 391C             data  >391c
0029 6374 0458  20         b     *tmp4                 ; Exit
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
0040 6376 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6378 06A0  32         bl    @cpym2v
     637A 6280 
0042 637C 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     637E 63BA 
     6380 0006 
0043 6382 06A0  32         bl    @putvr
     6384 617A 
0044 6386 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 6388 06A0  32         bl    @putvr
     638A 617A 
0046 638C 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 638E 0204  20         li    tmp0,>3f00
     6390 3F00 
0052 6392 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6394 6102 
0053 6396 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     6398 8800 
0054 639A 0984  56         srl   tmp0,8
0055 639C D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     639E 8800 
0056 63A0 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 63A2 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 63A4 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     63A6 BFFF 
0060 63A8 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 63AA 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     63AC 4000 
0063               f18chk_exit:
0064 63AE 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     63B0 60D6 
0065 63B2 3F00             data  >3f00,>00,6
     63B4 0000 
     63B6 0006 
0066 63B8 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 63BA 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 63BC 3F00             data  >3f00                 ; 3f02 / 3f00
0073 63BE 0340             data  >0340                 ; 3f04   0340  idle
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
0092 63C0 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 63C2 06A0  32         bl    @putvr
     63C4 617A 
0097 63C6 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 63C8 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63CA 617A 
0100 63CC 391C             data  >391c                 ; Lock the F18a
0101 63CE 0458  20         b     *tmp4                 ; Exit
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
0120 63D0 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 63D2 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     63D4 6042 
0122 63D6 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 63D8 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     63DA 8802 
0127 63DC 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     63DE 617A 
0128 63E0 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 63E2 04C4  14         clr   tmp0
0130 63E4 D120  34         movb  @vdps,tmp0
     63E6 8802 
0131 63E8 0984  56         srl   tmp0,8
0132 63EA 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0088 63EC 40A0  34         szc   @wbit11,config        ; Reset ANY key
     63EE 602E 
0089 63F0 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 63F2 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 63F4 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 63F6 0207  20         li    tmp3,kbmap0           ; Start with column 0
     63F8 6468 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 63FA 04CC  14         clr   r12
0097 63FC 1E15  20         sbz   >0015                 ; Set P5
0098 63FE 1F07  20         tb    7
0099 6400 1302  14         jeq   virtk1
0100 6402 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     6404 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 6406 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 6408 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     640A 0024 
0107 640C 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 640E 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     6410 0006 
0109 6412 0705  14         seto  tmp1                  ; >FFFF
0110 6414 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 6416 0545  14         inv   tmp1
0112 6418 1302  14         jeq   virtk2                ; >0000 ?
0113 641A E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     641C 602E 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 641E 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 6420 1601  14         jne   virtk3
0119 6422 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 6424 05C7  14 virtk3  inct  tmp3
0121 6426 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     6428 6474 
0122 642A 16F9  14         jne   virtk2                ; No, next entry
0123 642C 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 642E 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     6430 0700 
0128 6432 1309  14         jeq   virtk6                ; Yes, exit
0129 6434 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     6436 0200 
0130 6438 1303  14         jeq   virtk5                ; Yes, skip
0131 643A 0224  22         ai    tmp0,>0100
     643C 0100 
0132 643E 10E3  14         jmp   virtk1
0133 6440 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6442 0500 
0134 6444 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 6446 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 6448 C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     644A 8332 
0140 644C 1601  14         jne   virtk7
0141 644E 045B  20         b     *r11                  ; Exit
0142 6450 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6452 FFFF 
0143 6454 1603  14         jne   virtk8                ; No
0144 6456 0701  14         seto  r1                    ; Set exit flag
0145 6458 0460  28         b     @runli1               ; Yes, reset computer
     645A 6FC8 
0146 645C 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     645E 8000 
0147 6460 1602  14         jne   virtk9
0148 6462 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     6464 602E 
0149 6466 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 6468 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     646A FFFF 
0155 646C 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     646E 0020 
0156 6470 0400             data  >0400,kenter          ; >04 00000100  enter
     6472 4000 
0157 6474 FFFF     kbeoc   data  >ffff
0158               
0159 6476 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     6478 1000 
0160 647A 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     647C 0008 
0161 647E 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6480 0004 
0162 6482 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     6484 0200 
0163 6486 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     6488 0040 
0164 648A FFFF             data  >ffff
0165               
0166 648C 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     648E 2000 
0167 6490 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6492 0002 
0168 6494 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6496 0100 
0169 6498 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     649A 0080 
0170 649C 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     649E 0010 
0171 64A0 FFFF             data  >ffff
0172               
0173 64A2 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     64A4 0001 
0174 64A6 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     64A8 0800 
0175 64AA 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     64AC 0020 
0176 64AE FFFF             data  >ffff
0177               
0178 64B0 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     64B2 0020 
0179 64B4 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     64B6 0200 
0180 64B8 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     64BA 0100 
0181 64BC 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     64BE 0040 
0182 64C0 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     64C2 0080 
0183 64C4 FFFF             data  >ffff
0184               
0185 64C6 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     64C8 0001 
0186 64CA 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     64CC 0010 
0187 64CE 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     64D0 0008 
0188 64D2 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     64D4 0002 
0189 64D6 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     64D8 0004 
0190 64DA FFFF             data  >ffff
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
0016 64DC 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     64DE 6044 
0017 64E0 020C  20         li    r12,>0024
     64E2 0024 
0018 64E4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     64E6 6574 
0019 64E8 04C6  14         clr   tmp2
0020 64EA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 64EC 04CC  14         clr   r12
0025 64EE 1F08  20         tb    >0008                 ; Shift-key ?
0026 64F0 1302  14         jeq   realk1                ; No
0027 64F2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     64F4 65A4 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 64F6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 64F8 1302  14         jeq   realk2                ; No
0033 64FA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     64FC 65D4 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 64FE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6500 1302  14         jeq   realk3                ; No
0039 6502 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6504 6604 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6506 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6508 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 650A 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 650C E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     650E 6044 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6510 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6512 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6514 0006 
0052 6516 0606  14 realk5  dec   tmp2
0053 6518 020C  20         li    r12,>24               ; CRU address for P2-P4
     651A 0024 
0054 651C 06C6  14         swpb  tmp2
0055 651E 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6520 06C6  14         swpb  tmp2
0057 6522 020C  20         li    r12,6                 ; CRU read address
     6524 0006 
0058 6526 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6528 0547  14         inv   tmp3                  ;
0060 652A 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     652C FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 652E 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6530 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6532 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6534 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6536 0285  22         ci    tmp1,8
     6538 0008 
0069 653A 1AFA  14         jl    realk6
0070 653C C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 653E 1BEB  14         jh    realk5                ; No, next column
0072 6540 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6542 C206  18 realk8  mov   tmp2,tmp4
0077 6544 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6546 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6548 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 654A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 654C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 654E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6550 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6552 6044 
0087 6554 1608  14         jne   realka                ; No, continue saving key
0088 6556 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6558 659E 
0089 655A 1A05  14         jl    realka
0090 655C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     655E 659C 
0091 6560 1B02  14         jh    realka                ; No, continue
0092 6562 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6564 E000 
0093 6566 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6568 833C 
0094 656A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     656C 602E 
0095 656E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6570 8C00 
0096 6572 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6574 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6576 0000 
     6578 FF0D 
     657A 203D 
0099 657C ....             text  'xws29ol.'
0100 6584 ....             text  'ced38ik,'
0101 658C ....             text  'vrf47ujm'
0102 6594 ....             text  'btg56yhn'
0103 659C ....             text  'zqa10p;/'
0104 65A4 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     65A6 0000 
     65A8 FF0D 
     65AA 202B 
0105 65AC ....             text  'XWS@(OL>'
0106 65B4 ....             text  'CED#*IK<'
0107 65BC ....             text  'VRF$&UJM'
0108 65C4 ....             text  'BTG%^YHN'
0109 65CC ....             text  'ZQA!)P:-'
0110 65D4 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     65D6 0000 
     65D8 FF0D 
     65DA 2005 
0111 65DC 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     65DE 0804 
     65E0 0F27 
     65E2 C2B9 
0112 65E4 600B             data  >600b,>0907,>063f,>c1B8
     65E6 0907 
     65E8 063F 
     65EA C1B8 
0113 65EC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     65EE 7B02 
     65F0 015F 
     65F2 C0C3 
0114 65F4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     65F6 7D0E 
     65F8 0CC6 
     65FA BFC4 
0115 65FC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     65FE 7C03 
     6600 BC22 
     6602 BDBA 
0116 6604 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6606 0000 
     6608 FF0D 
     660A 209D 
0117 660C 9897             data  >9897,>93b2,>9f8f,>8c9B
     660E 93B2 
     6610 9F8F 
     6612 8C9B 
0118 6614 8385             data  >8385,>84b3,>9e89,>8b80
     6616 84B3 
     6618 9E89 
     661A 8B80 
0119 661C 9692             data  >9692,>86b4,>b795,>8a8D
     661E 86B4 
     6620 B795 
     6622 8A8D 
0120 6624 8294             data  >8294,>87b5,>b698,>888E
     6626 87B5 
     6628 B698 
     662A 888E 
0121 662C 9A91             data  >9a91,>81b1,>b090,>9cBB
     662E 81B1 
     6630 B090 
     6632 9CBB 
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
0016 6634 C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 6636 C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     6638 8340 
0018 663A 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     663C 833C 
0019 663E 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 6640 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 6642 0647  14         dect  tmp3                  ; Back to WAUX1
0022 6644 C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 6646 0205  20         li    tmp1,4
     6648 0004 
0027 664A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 664C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     664E 000F 
0029 6650 A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 6652 06C6  14 mkhex2  swpb  tmp2
0031 6654 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 6656 0944  56         srl   tmp0,4                ; Next nibble
0033 6658 0605  14         dec   tmp1
0034 665A 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 665C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     665E BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 6660 C160  34         mov   @waux3,tmp1           ; Get pointer
     6662 8340 
0040 6664 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 6666 0585  14         inc   tmp1                  ; Next byte, not word!
0042 6668 C120  34         mov   @waux2,tmp0
     666A 833E 
0043 666C 06C4  14         swpb  tmp0
0044 666E DD44  32         movb  tmp0,*tmp1+
0045 6670 06C4  14         swpb  tmp0
0046 6672 DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 6674 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6676 8340 
0051 6678 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     667A 603A 
0052 667C 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 667E C120  34         mov   @waux1,tmp0
     6680 833C 
0057 6682 06C4  14         swpb  tmp0
0058 6684 DD44  32         movb  tmp0,*tmp1+
0059 6686 06C4  14         swpb  tmp0
0060 6688 DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 668A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     668C 6044 
0065 668E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 6690 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 6692 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6694 7FFF 
0071 6696 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6698 8340 
0072 669A 0460  28         b     @xutst0               ; Display string
     669C 6268 
0073 669E 0610     prefix  data  >0610                 ; Length byte + blank
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
0087 66A0 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     66A2 832A 
0088 66A4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     66A6 8000 
0089 66A8 10C5  14         jmp   mkhex                 ; Convert number and display
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
0019 66AA 0207  20 mknum   li    tmp3,5                ; Digit counter
     66AC 0005 
0020 66AE C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 66B0 C155  26         mov   *tmp1,tmp1            ; /
0022 66B2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 66B4 0228  22         ai    tmp4,4                ; Get end of buffer
     66B6 0004 
0024 66B8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     66BA 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 66BC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 66BE 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 66C0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 66C2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 66C4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 66C6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 66C8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 66CA 0607  14         dec   tmp3                  ; Decrease counter
0036 66CC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 66CE 0207  20         li    tmp3,4                ; Check first 4 digits
     66D0 0004 
0041 66D2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 66D4 C11B  26         mov   *r11,tmp0
0043 66D6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 66D8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 66DA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 66DC 05CB  14 mknum3  inct  r11
0047 66DE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     66E0 6044 
0048 66E2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 66E4 045B  20         b     *r11                  ; Exit
0050 66E6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 66E8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 66EA 13F8  14         jeq   mknum3                ; Yes, exit
0053 66EC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 66EE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     66F0 7FFF 
0058 66F2 C10B  18         mov   r11,tmp0
0059 66F4 0224  22         ai    tmp0,-4
     66F6 FFFC 
0060 66F8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 66FA 0206  20         li    tmp2,>0500            ; String length = 5
     66FC 0500 
0062 66FE 0460  28         b     @xutstr               ; Display string
     6700 626A 
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
0092 6702 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6704 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6706 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6708 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 670A 0207  20         li    tmp3,5                ; Set counter
     670C 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 670E 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6710 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6712 0584  14         inc   tmp0                  ; Next character
0104 6714 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6716 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6718 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 671A 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 671C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 671E 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6720 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6722 0607  14         dec   tmp3                  ; Last character ?
0120 6724 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6726 045B  20         b     *r11                  ; Return
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
0138 6728 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     672A 832A 
0139 672C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     672E 8000 
0140 6730 10BC  14         jmp   mknum                 ; Convert number and display
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
0021 6732 C820  54         mov   @>8300,@>2000
     6734 8300 
     6736 2000 
0022 6738 C820  54         mov   @>8302,@>2002
     673A 8302 
     673C 2002 
0023 673E C820  54         mov   @>8304,@>2004
     6740 8304 
     6742 2004 
0024 6744 C820  54         mov   @>8306,@>2006
     6746 8306 
     6748 2006 
0025 674A C820  54         mov   @>8308,@>2008
     674C 8308 
     674E 2008 
0026 6750 C820  54         mov   @>830A,@>200A
     6752 830A 
     6754 200A 
0027 6756 C820  54         mov   @>830C,@>200C
     6758 830C 
     675A 200C 
0028 675C C820  54         mov   @>830E,@>200E
     675E 830E 
     6760 200E 
0029 6762 C820  54         mov   @>8310,@>2010
     6764 8310 
     6766 2010 
0030 6768 C820  54         mov   @>8312,@>2012
     676A 8312 
     676C 2012 
0031 676E C820  54         mov   @>8314,@>2014
     6770 8314 
     6772 2014 
0032 6774 C820  54         mov   @>8316,@>2016
     6776 8316 
     6778 2016 
0033 677A C820  54         mov   @>8318,@>2018
     677C 8318 
     677E 2018 
0034 6780 C820  54         mov   @>831A,@>201A
     6782 831A 
     6784 201A 
0035 6786 C820  54         mov   @>831C,@>201C
     6788 831C 
     678A 201C 
0036 678C C820  54         mov   @>831E,@>201E
     678E 831E 
     6790 201E 
0037 6792 C820  54         mov   @>8320,@>2020
     6794 8320 
     6796 2020 
0038 6798 C820  54         mov   @>8322,@>2022
     679A 8322 
     679C 2022 
0039 679E C820  54         mov   @>8324,@>2024
     67A0 8324 
     67A2 2024 
0040 67A4 C820  54         mov   @>8326,@>2026
     67A6 8326 
     67A8 2026 
0041 67AA C820  54         mov   @>8328,@>2028
     67AC 8328 
     67AE 2028 
0042 67B0 C820  54         mov   @>832A,@>202A
     67B2 832A 
     67B4 202A 
0043 67B6 C820  54         mov   @>832C,@>202C
     67B8 832C 
     67BA 202C 
0044 67BC C820  54         mov   @>832E,@>202E
     67BE 832E 
     67C0 202E 
0045 67C2 C820  54         mov   @>8330,@>2030
     67C4 8330 
     67C6 2030 
0046 67C8 C820  54         mov   @>8332,@>2032
     67CA 8332 
     67CC 2032 
0047 67CE C820  54         mov   @>8334,@>2034
     67D0 8334 
     67D2 2034 
0048 67D4 C820  54         mov   @>8336,@>2036
     67D6 8336 
     67D8 2036 
0049 67DA C820  54         mov   @>8338,@>2038
     67DC 8338 
     67DE 2038 
0050 67E0 C820  54         mov   @>833A,@>203A
     67E2 833A 
     67E4 203A 
0051 67E6 C820  54         mov   @>833C,@>203C
     67E8 833C 
     67EA 203C 
0052 67EC C820  54         mov   @>833E,@>203E
     67EE 833E 
     67F0 203E 
0053 67F2 C820  54         mov   @>8340,@>2040
     67F4 8340 
     67F6 2040 
0054 67F8 C820  54         mov   @>8342,@>2042
     67FA 8342 
     67FC 2042 
0055 67FE C820  54         mov   @>8344,@>2044
     6800 8344 
     6802 2044 
0056 6804 C820  54         mov   @>8346,@>2046
     6806 8346 
     6808 2046 
0057 680A C820  54         mov   @>8348,@>2048
     680C 8348 
     680E 2048 
0058 6810 C820  54         mov   @>834A,@>204A
     6812 834A 
     6814 204A 
0059 6816 C820  54         mov   @>834C,@>204C
     6818 834C 
     681A 204C 
0060 681C C820  54         mov   @>834E,@>204E
     681E 834E 
     6820 204E 
0061 6822 C820  54         mov   @>8350,@>2050
     6824 8350 
     6826 2050 
0062 6828 C820  54         mov   @>8352,@>2052
     682A 8352 
     682C 2052 
0063 682E C820  54         mov   @>8354,@>2054
     6830 8354 
     6832 2054 
0064 6834 C820  54         mov   @>8356,@>2056
     6836 8356 
     6838 2056 
0065 683A C820  54         mov   @>8358,@>2058
     683C 8358 
     683E 2058 
0066 6840 C820  54         mov   @>835A,@>205A
     6842 835A 
     6844 205A 
0067 6846 C820  54         mov   @>835C,@>205C
     6848 835C 
     684A 205C 
0068 684C C820  54         mov   @>835E,@>205E
     684E 835E 
     6850 205E 
0069 6852 C820  54         mov   @>8360,@>2060
     6854 8360 
     6856 2060 
0070 6858 C820  54         mov   @>8362,@>2062
     685A 8362 
     685C 2062 
0071 685E C820  54         mov   @>8364,@>2064
     6860 8364 
     6862 2064 
0072 6864 C820  54         mov   @>8366,@>2066
     6866 8366 
     6868 2066 
0073 686A C820  54         mov   @>8368,@>2068
     686C 8368 
     686E 2068 
0074 6870 C820  54         mov   @>836A,@>206A
     6872 836A 
     6874 206A 
0075 6876 C820  54         mov   @>836C,@>206C
     6878 836C 
     687A 206C 
0076 687C C820  54         mov   @>836E,@>206E
     687E 836E 
     6880 206E 
0077 6882 C820  54         mov   @>8370,@>2070
     6884 8370 
     6886 2070 
0078 6888 C820  54         mov   @>8372,@>2072
     688A 8372 
     688C 2072 
0079 688E C820  54         mov   @>8374,@>2074
     6890 8374 
     6892 2074 
0080 6894 C820  54         mov   @>8376,@>2076
     6896 8376 
     6898 2076 
0081 689A C820  54         mov   @>8378,@>2078
     689C 8378 
     689E 2078 
0082 68A0 C820  54         mov   @>837A,@>207A
     68A2 837A 
     68A4 207A 
0083 68A6 C820  54         mov   @>837C,@>207C
     68A8 837C 
     68AA 207C 
0084 68AC C820  54         mov   @>837E,@>207E
     68AE 837E 
     68B0 207E 
0085 68B2 C820  54         mov   @>8380,@>2080
     68B4 8380 
     68B6 2080 
0086 68B8 C820  54         mov   @>8382,@>2082
     68BA 8382 
     68BC 2082 
0087 68BE C820  54         mov   @>8384,@>2084
     68C0 8384 
     68C2 2084 
0088 68C4 C820  54         mov   @>8386,@>2086
     68C6 8386 
     68C8 2086 
0089 68CA C820  54         mov   @>8388,@>2088
     68CC 8388 
     68CE 2088 
0090 68D0 C820  54         mov   @>838A,@>208A
     68D2 838A 
     68D4 208A 
0091 68D6 C820  54         mov   @>838C,@>208C
     68D8 838C 
     68DA 208C 
0092 68DC C820  54         mov   @>838E,@>208E
     68DE 838E 
     68E0 208E 
0093 68E2 C820  54         mov   @>8390,@>2090
     68E4 8390 
     68E6 2090 
0094 68E8 C820  54         mov   @>8392,@>2092
     68EA 8392 
     68EC 2092 
0095 68EE C820  54         mov   @>8394,@>2094
     68F0 8394 
     68F2 2094 
0096 68F4 C820  54         mov   @>8396,@>2096
     68F6 8396 
     68F8 2096 
0097 68FA C820  54         mov   @>8398,@>2098
     68FC 8398 
     68FE 2098 
0098 6900 C820  54         mov   @>839A,@>209A
     6902 839A 
     6904 209A 
0099 6906 C820  54         mov   @>839C,@>209C
     6908 839C 
     690A 209C 
0100 690C C820  54         mov   @>839E,@>209E
     690E 839E 
     6910 209E 
0101 6912 C820  54         mov   @>83A0,@>20A0
     6914 83A0 
     6916 20A0 
0102 6918 C820  54         mov   @>83A2,@>20A2
     691A 83A2 
     691C 20A2 
0103 691E C820  54         mov   @>83A4,@>20A4
     6920 83A4 
     6922 20A4 
0104 6924 C820  54         mov   @>83A6,@>20A6
     6926 83A6 
     6928 20A6 
0105 692A C820  54         mov   @>83A8,@>20A8
     692C 83A8 
     692E 20A8 
0106 6930 C820  54         mov   @>83AA,@>20AA
     6932 83AA 
     6934 20AA 
0107 6936 C820  54         mov   @>83AC,@>20AC
     6938 83AC 
     693A 20AC 
0108 693C C820  54         mov   @>83AE,@>20AE
     693E 83AE 
     6940 20AE 
0109 6942 C820  54         mov   @>83B0,@>20B0
     6944 83B0 
     6946 20B0 
0110 6948 C820  54         mov   @>83B2,@>20B2
     694A 83B2 
     694C 20B2 
0111 694E C820  54         mov   @>83B4,@>20B4
     6950 83B4 
     6952 20B4 
0112 6954 C820  54         mov   @>83B6,@>20B6
     6956 83B6 
     6958 20B6 
0113 695A C820  54         mov   @>83B8,@>20B8
     695C 83B8 
     695E 20B8 
0114 6960 C820  54         mov   @>83BA,@>20BA
     6962 83BA 
     6964 20BA 
0115 6966 C820  54         mov   @>83BC,@>20BC
     6968 83BC 
     696A 20BC 
0116 696C C820  54         mov   @>83BE,@>20BE
     696E 83BE 
     6970 20BE 
0117 6972 C820  54         mov   @>83C0,@>20C0
     6974 83C0 
     6976 20C0 
0118 6978 C820  54         mov   @>83C2,@>20C2
     697A 83C2 
     697C 20C2 
0119 697E C820  54         mov   @>83C4,@>20C4
     6980 83C4 
     6982 20C4 
0120 6984 C820  54         mov   @>83C6,@>20C6
     6986 83C6 
     6988 20C6 
0121 698A C820  54         mov   @>83C8,@>20C8
     698C 83C8 
     698E 20C8 
0122 6990 C820  54         mov   @>83CA,@>20CA
     6992 83CA 
     6994 20CA 
0123 6996 C820  54         mov   @>83CC,@>20CC
     6998 83CC 
     699A 20CC 
0124 699C C820  54         mov   @>83CE,@>20CE
     699E 83CE 
     69A0 20CE 
0125 69A2 C820  54         mov   @>83D0,@>20D0
     69A4 83D0 
     69A6 20D0 
0126 69A8 C820  54         mov   @>83D2,@>20D2
     69AA 83D2 
     69AC 20D2 
0127 69AE C820  54         mov   @>83D4,@>20D4
     69B0 83D4 
     69B2 20D4 
0128 69B4 C820  54         mov   @>83D6,@>20D6
     69B6 83D6 
     69B8 20D6 
0129 69BA C820  54         mov   @>83D8,@>20D8
     69BC 83D8 
     69BE 20D8 
0130 69C0 C820  54         mov   @>83DA,@>20DA
     69C2 83DA 
     69C4 20DA 
0131 69C6 C820  54         mov   @>83DC,@>20DC
     69C8 83DC 
     69CA 20DC 
0132 69CC C820  54         mov   @>83DE,@>20DE
     69CE 83DE 
     69D0 20DE 
0133 69D2 C820  54         mov   @>83E0,@>20E0
     69D4 83E0 
     69D6 20E0 
0134 69D8 C820  54         mov   @>83E2,@>20E2
     69DA 83E2 
     69DC 20E2 
0135 69DE C820  54         mov   @>83E4,@>20E4
     69E0 83E4 
     69E2 20E4 
0136 69E4 C820  54         mov   @>83E6,@>20E6
     69E6 83E6 
     69E8 20E6 
0137 69EA C820  54         mov   @>83E8,@>20E8
     69EC 83E8 
     69EE 20E8 
0138 69F0 C820  54         mov   @>83EA,@>20EA
     69F2 83EA 
     69F4 20EA 
0139 69F6 C820  54         mov   @>83EC,@>20EC
     69F8 83EC 
     69FA 20EC 
0140 69FC C820  54         mov   @>83EE,@>20EE
     69FE 83EE 
     6A00 20EE 
0141 6A02 C820  54         mov   @>83F0,@>20F0
     6A04 83F0 
     6A06 20F0 
0142 6A08 C820  54         mov   @>83F2,@>20F2
     6A0A 83F2 
     6A0C 20F2 
0143 6A0E C820  54         mov   @>83F4,@>20F4
     6A10 83F4 
     6A12 20F4 
0144 6A14 C820  54         mov   @>83F6,@>20F6
     6A16 83F6 
     6A18 20F6 
0145 6A1A C820  54         mov   @>83F8,@>20F8
     6A1C 83F8 
     6A1E 20F8 
0146 6A20 C820  54         mov   @>83FA,@>20FA
     6A22 83FA 
     6A24 20FA 
0147 6A26 C820  54         mov   @>83FC,@>20FC
     6A28 83FC 
     6A2A 20FC 
0148 6A2C C820  54         mov   @>83FE,@>20FE
     6A2E 83FE 
     6A30 20FE 
0149 6A32 045B  20         b     *r11                  ; Return to caller
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
0164 6A34 C820  54         mov   @>2000,@>8300
     6A36 2000 
     6A38 8300 
0165 6A3A C820  54         mov   @>2002,@>8302
     6A3C 2002 
     6A3E 8302 
0166 6A40 C820  54         mov   @>2004,@>8304
     6A42 2004 
     6A44 8304 
0167 6A46 C820  54         mov   @>2006,@>8306
     6A48 2006 
     6A4A 8306 
0168 6A4C C820  54         mov   @>2008,@>8308
     6A4E 2008 
     6A50 8308 
0169 6A52 C820  54         mov   @>200A,@>830A
     6A54 200A 
     6A56 830A 
0170 6A58 C820  54         mov   @>200C,@>830C
     6A5A 200C 
     6A5C 830C 
0171 6A5E C820  54         mov   @>200E,@>830E
     6A60 200E 
     6A62 830E 
0172 6A64 C820  54         mov   @>2010,@>8310
     6A66 2010 
     6A68 8310 
0173 6A6A C820  54         mov   @>2012,@>8312
     6A6C 2012 
     6A6E 8312 
0174 6A70 C820  54         mov   @>2014,@>8314
     6A72 2014 
     6A74 8314 
0175 6A76 C820  54         mov   @>2016,@>8316
     6A78 2016 
     6A7A 8316 
0176 6A7C C820  54         mov   @>2018,@>8318
     6A7E 2018 
     6A80 8318 
0177 6A82 C820  54         mov   @>201A,@>831A
     6A84 201A 
     6A86 831A 
0178 6A88 C820  54         mov   @>201C,@>831C
     6A8A 201C 
     6A8C 831C 
0179 6A8E C820  54         mov   @>201E,@>831E
     6A90 201E 
     6A92 831E 
0180 6A94 C820  54         mov   @>2020,@>8320
     6A96 2020 
     6A98 8320 
0181 6A9A C820  54         mov   @>2022,@>8322
     6A9C 2022 
     6A9E 8322 
0182 6AA0 C820  54         mov   @>2024,@>8324
     6AA2 2024 
     6AA4 8324 
0183 6AA6 C820  54         mov   @>2026,@>8326
     6AA8 2026 
     6AAA 8326 
0184 6AAC C820  54         mov   @>2028,@>8328
     6AAE 2028 
     6AB0 8328 
0185 6AB2 C820  54         mov   @>202A,@>832A
     6AB4 202A 
     6AB6 832A 
0186 6AB8 C820  54         mov   @>202C,@>832C
     6ABA 202C 
     6ABC 832C 
0187 6ABE C820  54         mov   @>202E,@>832E
     6AC0 202E 
     6AC2 832E 
0188 6AC4 C820  54         mov   @>2030,@>8330
     6AC6 2030 
     6AC8 8330 
0189 6ACA C820  54         mov   @>2032,@>8332
     6ACC 2032 
     6ACE 8332 
0190 6AD0 C820  54         mov   @>2034,@>8334
     6AD2 2034 
     6AD4 8334 
0191 6AD6 C820  54         mov   @>2036,@>8336
     6AD8 2036 
     6ADA 8336 
0192 6ADC C820  54         mov   @>2038,@>8338
     6ADE 2038 
     6AE0 8338 
0193 6AE2 C820  54         mov   @>203A,@>833A
     6AE4 203A 
     6AE6 833A 
0194 6AE8 C820  54         mov   @>203C,@>833C
     6AEA 203C 
     6AEC 833C 
0195 6AEE C820  54         mov   @>203E,@>833E
     6AF0 203E 
     6AF2 833E 
0196 6AF4 C820  54         mov   @>2040,@>8340
     6AF6 2040 
     6AF8 8340 
0197 6AFA C820  54         mov   @>2042,@>8342
     6AFC 2042 
     6AFE 8342 
0198 6B00 C820  54         mov   @>2044,@>8344
     6B02 2044 
     6B04 8344 
0199 6B06 C820  54         mov   @>2046,@>8346
     6B08 2046 
     6B0A 8346 
0200 6B0C C820  54         mov   @>2048,@>8348
     6B0E 2048 
     6B10 8348 
0201 6B12 C820  54         mov   @>204A,@>834A
     6B14 204A 
     6B16 834A 
0202 6B18 C820  54         mov   @>204C,@>834C
     6B1A 204C 
     6B1C 834C 
0203 6B1E C820  54         mov   @>204E,@>834E
     6B20 204E 
     6B22 834E 
0204 6B24 C820  54         mov   @>2050,@>8350
     6B26 2050 
     6B28 8350 
0205 6B2A C820  54         mov   @>2052,@>8352
     6B2C 2052 
     6B2E 8352 
0206 6B30 C820  54         mov   @>2054,@>8354
     6B32 2054 
     6B34 8354 
0207 6B36 C820  54         mov   @>2056,@>8356
     6B38 2056 
     6B3A 8356 
0208 6B3C C820  54         mov   @>2058,@>8358
     6B3E 2058 
     6B40 8358 
0209 6B42 C820  54         mov   @>205A,@>835A
     6B44 205A 
     6B46 835A 
0210 6B48 C820  54         mov   @>205C,@>835C
     6B4A 205C 
     6B4C 835C 
0211 6B4E C820  54         mov   @>205E,@>835E
     6B50 205E 
     6B52 835E 
0212 6B54 C820  54         mov   @>2060,@>8360
     6B56 2060 
     6B58 8360 
0213 6B5A C820  54         mov   @>2062,@>8362
     6B5C 2062 
     6B5E 8362 
0214 6B60 C820  54         mov   @>2064,@>8364
     6B62 2064 
     6B64 8364 
0215 6B66 C820  54         mov   @>2066,@>8366
     6B68 2066 
     6B6A 8366 
0216 6B6C C820  54         mov   @>2068,@>8368
     6B6E 2068 
     6B70 8368 
0217 6B72 C820  54         mov   @>206A,@>836A
     6B74 206A 
     6B76 836A 
0218 6B78 C820  54         mov   @>206C,@>836C
     6B7A 206C 
     6B7C 836C 
0219 6B7E C820  54         mov   @>206E,@>836E
     6B80 206E 
     6B82 836E 
0220 6B84 C820  54         mov   @>2070,@>8370
     6B86 2070 
     6B88 8370 
0221 6B8A C820  54         mov   @>2072,@>8372
     6B8C 2072 
     6B8E 8372 
0222 6B90 C820  54         mov   @>2074,@>8374
     6B92 2074 
     6B94 8374 
0223 6B96 C820  54         mov   @>2076,@>8376
     6B98 2076 
     6B9A 8376 
0224 6B9C C820  54         mov   @>2078,@>8378
     6B9E 2078 
     6BA0 8378 
0225 6BA2 C820  54         mov   @>207A,@>837A
     6BA4 207A 
     6BA6 837A 
0226 6BA8 C820  54         mov   @>207C,@>837C
     6BAA 207C 
     6BAC 837C 
0227 6BAE C820  54         mov   @>207E,@>837E
     6BB0 207E 
     6BB2 837E 
0228 6BB4 C820  54         mov   @>2080,@>8380
     6BB6 2080 
     6BB8 8380 
0229 6BBA C820  54         mov   @>2082,@>8382
     6BBC 2082 
     6BBE 8382 
0230 6BC0 C820  54         mov   @>2084,@>8384
     6BC2 2084 
     6BC4 8384 
0231 6BC6 C820  54         mov   @>2086,@>8386
     6BC8 2086 
     6BCA 8386 
0232 6BCC C820  54         mov   @>2088,@>8388
     6BCE 2088 
     6BD0 8388 
0233 6BD2 C820  54         mov   @>208A,@>838A
     6BD4 208A 
     6BD6 838A 
0234 6BD8 C820  54         mov   @>208C,@>838C
     6BDA 208C 
     6BDC 838C 
0235 6BDE C820  54         mov   @>208E,@>838E
     6BE0 208E 
     6BE2 838E 
0236 6BE4 C820  54         mov   @>2090,@>8390
     6BE6 2090 
     6BE8 8390 
0237 6BEA C820  54         mov   @>2092,@>8392
     6BEC 2092 
     6BEE 8392 
0238 6BF0 C820  54         mov   @>2094,@>8394
     6BF2 2094 
     6BF4 8394 
0239 6BF6 C820  54         mov   @>2096,@>8396
     6BF8 2096 
     6BFA 8396 
0240 6BFC C820  54         mov   @>2098,@>8398
     6BFE 2098 
     6C00 8398 
0241 6C02 C820  54         mov   @>209A,@>839A
     6C04 209A 
     6C06 839A 
0242 6C08 C820  54         mov   @>209C,@>839C
     6C0A 209C 
     6C0C 839C 
0243 6C0E C820  54         mov   @>209E,@>839E
     6C10 209E 
     6C12 839E 
0244 6C14 C820  54         mov   @>20A0,@>83A0
     6C16 20A0 
     6C18 83A0 
0245 6C1A C820  54         mov   @>20A2,@>83A2
     6C1C 20A2 
     6C1E 83A2 
0246 6C20 C820  54         mov   @>20A4,@>83A4
     6C22 20A4 
     6C24 83A4 
0247 6C26 C820  54         mov   @>20A6,@>83A6
     6C28 20A6 
     6C2A 83A6 
0248 6C2C C820  54         mov   @>20A8,@>83A8
     6C2E 20A8 
     6C30 83A8 
0249 6C32 C820  54         mov   @>20AA,@>83AA
     6C34 20AA 
     6C36 83AA 
0250 6C38 C820  54         mov   @>20AC,@>83AC
     6C3A 20AC 
     6C3C 83AC 
0251 6C3E C820  54         mov   @>20AE,@>83AE
     6C40 20AE 
     6C42 83AE 
0252 6C44 C820  54         mov   @>20B0,@>83B0
     6C46 20B0 
     6C48 83B0 
0253 6C4A C820  54         mov   @>20B2,@>83B2
     6C4C 20B2 
     6C4E 83B2 
0254 6C50 C820  54         mov   @>20B4,@>83B4
     6C52 20B4 
     6C54 83B4 
0255 6C56 C820  54         mov   @>20B6,@>83B6
     6C58 20B6 
     6C5A 83B6 
0256 6C5C C820  54         mov   @>20B8,@>83B8
     6C5E 20B8 
     6C60 83B8 
0257 6C62 C820  54         mov   @>20BA,@>83BA
     6C64 20BA 
     6C66 83BA 
0258 6C68 C820  54         mov   @>20BC,@>83BC
     6C6A 20BC 
     6C6C 83BC 
0259 6C6E C820  54         mov   @>20BE,@>83BE
     6C70 20BE 
     6C72 83BE 
0260 6C74 C820  54         mov   @>20C0,@>83C0
     6C76 20C0 
     6C78 83C0 
0261 6C7A C820  54         mov   @>20C2,@>83C2
     6C7C 20C2 
     6C7E 83C2 
0262 6C80 C820  54         mov   @>20C4,@>83C4
     6C82 20C4 
     6C84 83C4 
0263 6C86 C820  54         mov   @>20C6,@>83C6
     6C88 20C6 
     6C8A 83C6 
0264 6C8C C820  54         mov   @>20C8,@>83C8
     6C8E 20C8 
     6C90 83C8 
0265 6C92 C820  54         mov   @>20CA,@>83CA
     6C94 20CA 
     6C96 83CA 
0266 6C98 C820  54         mov   @>20CC,@>83CC
     6C9A 20CC 
     6C9C 83CC 
0267 6C9E C820  54         mov   @>20CE,@>83CE
     6CA0 20CE 
     6CA2 83CE 
0268 6CA4 C820  54         mov   @>20D0,@>83D0
     6CA6 20D0 
     6CA8 83D0 
0269 6CAA C820  54         mov   @>20D2,@>83D2
     6CAC 20D2 
     6CAE 83D2 
0270 6CB0 C820  54         mov   @>20D4,@>83D4
     6CB2 20D4 
     6CB4 83D4 
0271 6CB6 C820  54         mov   @>20D6,@>83D6
     6CB8 20D6 
     6CBA 83D6 
0272 6CBC C820  54         mov   @>20D8,@>83D8
     6CBE 20D8 
     6CC0 83D8 
0273 6CC2 C820  54         mov   @>20DA,@>83DA
     6CC4 20DA 
     6CC6 83DA 
0274 6CC8 C820  54         mov   @>20DC,@>83DC
     6CCA 20DC 
     6CCC 83DC 
0275 6CCE C820  54         mov   @>20DE,@>83DE
     6CD0 20DE 
     6CD2 83DE 
0276 6CD4 C820  54         mov   @>20E0,@>83E0
     6CD6 20E0 
     6CD8 83E0 
0277 6CDA C820  54         mov   @>20E2,@>83E2
     6CDC 20E2 
     6CDE 83E2 
0278 6CE0 C820  54         mov   @>20E4,@>83E4
     6CE2 20E4 
     6CE4 83E4 
0279 6CE6 C820  54         mov   @>20E6,@>83E6
     6CE8 20E6 
     6CEA 83E6 
0280 6CEC C820  54         mov   @>20E8,@>83E8
     6CEE 20E8 
     6CF0 83E8 
0281 6CF2 C820  54         mov   @>20EA,@>83EA
     6CF4 20EA 
     6CF6 83EA 
0282 6CF8 C820  54         mov   @>20EC,@>83EC
     6CFA 20EC 
     6CFC 83EC 
0283 6CFE C820  54         mov   @>20EE,@>83EE
     6D00 20EE 
     6D02 83EE 
0284 6D04 C820  54         mov   @>20F0,@>83F0
     6D06 20F0 
     6D08 83F0 
0285 6D0A C820  54         mov   @>20F2,@>83F2
     6D0C 20F2 
     6D0E 83F2 
0286 6D10 C820  54         mov   @>20F4,@>83F4
     6D12 20F4 
     6D14 83F4 
0287 6D16 C820  54         mov   @>20F6,@>83F6
     6D18 20F6 
     6D1A 83F6 
0288 6D1C C820  54         mov   @>20F8,@>83F8
     6D1E 20F8 
     6D20 83F8 
0289 6D22 C820  54         mov   @>20FA,@>83FA
     6D24 20FA 
     6D26 83FA 
0290 6D28 C820  54         mov   @>20FC,@>83FC
     6D2A 20FC 
     6D2C 83FC 
0291 6D2E C820  54         mov   @>20FE,@>83FE
     6D30 20FE 
     6D32 83FE 
0292 6D34 045B  20         b     *r11                  ; Return to caller
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
0024 6D36 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6D38 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6D3A 8300 
0030 6D3C C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6D3E 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D40 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6D42 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6D44 0606  14         dec   tmp2
0037 6D46 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6D48 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6D4A 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6D4C 6D52 
0043                                                   ; R14=PC
0044 6D4E 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6D50 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6D52 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6D54 6A34 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6D56 045B  20         b     *r11                  ; Return to caller
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
0077 6D58 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6D5A 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6D5C 8300 
0083 6D5E 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6D60 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6D62 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6D64 0606  14         dec   tmp2
0089 6D66 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6D68 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6D6A 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6D6C 045B  20         b     *r11                  ; Return to caller
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
0017               *  Output:
0018               *  r0 LSB = Bit 13-15 from VDP PAB byte 1, right aligned
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
0041 6D6E B000     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6D70 6D72             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6D72 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6D74 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6D76 8322 
0049 6D78 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6D7A 6040 
0050 6D7C C020  34         mov   @>8356,r0             ; get ptr to pab
     6D7E 8356 
0051 6D80 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6D82 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6D84 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6D86 06C0  14         swpb  r0                    ;
0059 6D88 D800  38         movb  r0,@vdpa              ; send low byte
     6D8A 8C02 
0060 6D8C 06C0  14         swpb  r0                    ;
0061 6D8E D800  38         movb  r0,@vdpa              ; send high byte
     6D90 8C02 
0062 6D92 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6D94 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6D96 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6D98 0704  14         seto  r4                    ; init counter
0070 6D9A 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6D9C 2100 
0071 6D9E 0580  14 !       inc   r0                    ; point to next char of name
0072 6DA0 0584  14         inc   r4                    ; incr char counter
0073 6DA2 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6DA4 0007 
0074 6DA6 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6DA8 80C4  18         c     r4,r3                 ; end of name?
0077 6DAA 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6DAC 06C0  14         swpb  r0                    ;
0082 6DAE D800  38         movb  r0,@vdpa              ; send low byte
     6DB0 8C02 
0083 6DB2 06C0  14         swpb  r0                    ;
0084 6DB4 D800  38         movb  r0,@vdpa              ; send high byte
     6DB6 8C02 
0085 6DB8 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6DBA 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6DBC DC81  32         movb  r1,*r2+               ; move into buffer
0092 6DBE 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6DC0 6E82 
0093 6DC2 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6DC4 C104  18         mov   r4,r4                 ; Check if length = 0
0099 6DC6 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6DC8 04E0  34         clr   @>83d0
     6DCA 83D0 
0102 6DCC C804  38         mov   r4,@>8354             ; save name length for search
     6DCE 8354 
0103 6DD0 0584  14         inc   r4                    ; adjust for dot
0104 6DD2 A804  38         a     r4,@>8356             ; point to position after name
     6DD4 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6DD6 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6DD8 83E0 
0110 6DDA 04C1  14         clr   r1                    ; version found of dsr
0111 6DDC 020C  20         li    r12,>0f00             ; init cru addr
     6DDE 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6DE0 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6DE2 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6DE4 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6DE6 022C  22         ai    r12,>0100             ; next rom to turn on
     6DE8 0100 
0125 6DEA 04E0  34         clr   @>83d0                ; clear in case we are done
     6DEC 83D0 
0126 6DEE 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6DF0 2000 
0127 6DF2 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6DF4 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6DF6 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6DF8 1D00  20         sbo   0                     ; turn on rom
0134 6DFA 0202  20         li    r2,>4000              ; start at beginning of rom
     6DFC 4000 
0135 6DFE 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6E00 6E7E 
0136 6E02 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6E04 A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6E06 B00A 
0146 6E08 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6E0A C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6E0C 83D2 
0152 6E0E 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6E10 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6E12 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6E14 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6E16 83D2 
0161 6E18 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6E1A C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6E1C 04C5  14         clr   r5                    ; Remove any old stuff
0167 6E1E D160  34         movb  @>8355,r5             ; get length as counter
     6E20 8355 
0168 6E22 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6E24 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6E26 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6E28 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6E2A 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6E2C 2100 
0175 6E2E 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6E30 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6E32 0605  14         dec   r5                    ; loop until full length checked
0179 6E34 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6E36 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6E38 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6E3A 0581  14         inc   r1                    ; next version found
0191 6E3C 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6E3E 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6E40 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6E42 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6E44 B000 
0200 6E46 C009  18         mov   r9,r0                 ; point to flag in pab
0201 6E48 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6E4A 8322 
0202                                                   ; (8 or >a)
0203 6E4C 0281  22         ci    r1,8                  ; was it 8?
     6E4E 0008 
0204 6E50 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6E52 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6E54 8350 
0206                                                   ; Get error byte from @>8350
0207 6E56 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6E58 06C0  14         swpb  r0                    ;
0215 6E5A D800  38         movb  r0,@vdpa              ; send low byte
     6E5C 8C02 
0216 6E5E 06C0  14         swpb  r0                    ;
0217 6E60 D800  38         movb  r0,@vdpa              ; send high byte
     6E62 8C02 
0218 6E64 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6E66 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6E68 09D1  56         srl   r1,13                 ; just keep error bits
0226 6E6A 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6E6C 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6E6E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6E70 B000 
0235               dsrlnk.error.devicename_invalid:
0236 6E72 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6E74 06C1  14         swpb  r1                    ; put error in hi byte
0239 6E76 D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6E78 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6E7A 6040 
0241 6E7C 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6E7E AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6E80 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6E82 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0248               
0249                       even
**** **** ****     > runlib.asm
0199                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
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
0086               
0087               
0088               ***************************************************************
0089               * PAB  - Peripheral Access Block
0090               ********@*****@*********************@**************************
0091               ; my_pab:
0092               ;       byte  io.op.open            ;  0    - OPEN
0093               ;       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0094               ;                                   ;         Bit 13-15 used by DSR for returning
0095               ;                                   ;         file error details to DSRLNK
0096               ;       data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0097               ;       byte  80                    ;  4    - Record length (80 characters maximum)
0098               ;       byte  0                     ;  5    - Character count (bytes read)
0099               ;       data  >0000                 ;  6-7  - Seek record (only for fixed records)
0100               ;       byte  >00                   ;  8    - Screen offset (cassette DSR only)
0101               ; -------------------------------------------------------------
0102               ;       byte  11                    ;  9    - File descriptor length
0103               ;       text 'DSK1.MYFILE'          ; 10-.. - File descriptor name (Device + '.' + File name)
0104               ;       even
0105               ***************************************************************
0106               
0107               
0108               ***************************************************************
0109               * file.open - Open File for procesing
0110               ***************************************************************
0111               *  bl   @file.open
0112               *  data P0
0113               *--------------------------------------------------------------
0114               *  P0 = Address of PAB in VDP RAM
0115               *--------------------------------------------------------------
0116               *  bl   @xfile.open
0117               *
0118               *  R0 = Address of PAB in VDP RAM
0119               *--------------------------------------------------------------
0120               *  Output:
0121               *  tmp0 LSB = VDP PAB byte 1 (status)
0122               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0123               *  tmp2     = Status register contents upon DSRLNK return
0124               ********@*****@*********************@**************************
0125               file.open:
0126 6E84 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0127               *--------------------------------------------------------------
0128               * Initialisation
0129               *--------------------------------------------------------------
0130               xfile.open:
0131 6E86 C04B  18         mov   r11,r1                ; Save return address
0132 6E88 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0133 6E8A 04C5  14         clr   tmp1                  ; io.op.open
0134 6E8C 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6E8E 6114 
0135               file.open_init:
0136 6E90 0220  22         ai    r0,9                  ; Move to file descriptor length
     6E92 0009 
0137 6E94 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6E96 8356 
0138               *--------------------------------------------------------------
0139               * Main
0140               *--------------------------------------------------------------
0141               file.open_main:
0142 6E98 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6E9A 6D6E 
0143 6E9C 0008             data  8                     ; Level 2 IO call
0144               *--------------------------------------------------------------
0145               * Exit
0146               *--------------------------------------------------------------
0147               file.open_exit:
0148 6E9E 1025  14         jmp   file.record.pab.details
0149                                                   ; Get status and return to caller
0150                                                   ; Status register bits are unaffected
0151               
0152               
0153               
0154               ***************************************************************
0155               * file.close - Close currently open file
0156               ***************************************************************
0157               *  bl   @file.close
0158               *  data P0
0159               *--------------------------------------------------------------
0160               *  P0 = Address of PAB in VDP RAM
0161               *--------------------------------------------------------------
0162               *  bl   @xfile.close
0163               *
0164               *  R0 = Address of PAB in VD RAM
0165               *--------------------------------------------------------------
0166               *  Output:
0167               *  tmp0 LSB = VDP PAB byte 1 (status)
0168               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0169               *  tmp2     = Status register contents upon DSRLNK return
0170               ********@*****@*********************@**************************
0171               file.close:
0172 6EA0 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0173               *--------------------------------------------------------------
0174               * Initialisation
0175               *--------------------------------------------------------------
0176               xfile.close:
0177 6EA2 C04B  18         mov   r11,r1                ; Save return address
0178 6EA4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0179 6EA6 0205  20         li    tmp1,io.op.close      ; io.op.close
     6EA8 0001 
0180 6EAA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6EAC 6114 
0181               file.close_init:
0182 6EAE 0220  22         ai    r0,9                  ; Move to file descriptor length
     6EB0 0009 
0183 6EB2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6EB4 8356 
0184               *--------------------------------------------------------------
0185               * Main
0186               *--------------------------------------------------------------
0187               file.close_main:
0188 6EB6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6EB8 6D6E 
0189 6EBA 0008             data  8                     ;
0190               *--------------------------------------------------------------
0191               * Exit
0192               *--------------------------------------------------------------
0193               file.close_exit:
0194 6EBC 1016  14         jmp   file.record.pab.details
0195                                                   ; Get status and return to caller
0196                                                   ; Status register bits are unaffected
0197               
0198               
0199               
0200               
0201               
0202               ***************************************************************
0203               * file.record.read - Read record from file
0204               ***************************************************************
0205               *  bl   @file.record.read
0206               *  data P0
0207               *--------------------------------------------------------------
0208               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0209               *--------------------------------------------------------------
0210               *  bl   @xfile.record.read
0211               *
0212               *  R0 = Address of PAB in VDP RAM
0213               *--------------------------------------------------------------
0214               *  Output:
0215               *  tmp0 LSB = VDP PAB byte 1 (status)
0216               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0217               *  tmp2     = Status register contents upon DSRLNK return
0218               ********@*****@*********************@**************************
0219               file.record.read:
0220 6EBE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0221               *--------------------------------------------------------------
0222               * Initialisation
0223               *--------------------------------------------------------------
0224               xfile.record.read:
0225 6EC0 C04B  18         mov   r11,r1                ; Save return address
0226 6EC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0227 6EC4 0205  20         li    tmp1,io.op.read       ; io.op.read
     6EC6 0002 
0228 6EC8 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6ECA 6114 
0229               file.record.read_init:
0230 6ECC 0220  22         ai    r0,9                  ; Move to file descriptor length
     6ECE 0009 
0231 6ED0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6ED2 8356 
0232               *--------------------------------------------------------------
0233               * Main
0234               *--------------------------------------------------------------
0235               file.record.read_main:
0236 6ED4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6ED6 6D6E 
0237 6ED8 0008             data  8                     ;
0238               *--------------------------------------------------------------
0239               * Exit
0240               *--------------------------------------------------------------
0241               file.record.read_exit:
0242 6EDA 1007  14         jmp   file.record.pab.details
0243                                                   ; Get status and return to caller
0244                                                   ; Status register bits are unaffected
0245               
0246               
0247               
0248               
0249               file.record.write:
0250 6EDC 1000  14         nop
0251               
0252               
0253               file.record.seek:
0254 6EDE 1000  14         nop
0255               
0256               
0257               file.image.load:
0258 6EE0 1000  14         nop
0259               
0260               
0261               file.image.save:
0262 6EE2 1000  14         nop
0263               
0264               
0265               file.delete:
0266 6EE4 1000  14         nop
0267               
0268               
0269               file.rename:
0270 6EE6 1000  14         nop
0271               
0272               
0273               file.status:
0274 6EE8 1000  14         nop
0275               
0276               
0277               
0278               ***************************************************************
0279               * file.record.pab.details - Return PAB details to caller
0280               ***************************************************************
0281               * Called internally via JMP/B by file operations
0282               *--------------------------------------------------------------
0283               *  Output:
0284               *  tmp0 LSB = VDP PAB byte 1 (status)
0285               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0286               *  tmp2     = Status register contents upon DSRLNK return
0287               ********@*****@*********************@**************************
0288               
0289               ********@*****@*********************@**************************
0290               file.record.pab.details:
0291 6EEA 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0292                                                   ; Upon DSRLNK return status register EQ bit
0293                                                   ; 1 = No file error
0294                                                   ; 0 = File error occured
0295               *--------------------------------------------------------------
0296               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0297               *--------------------------------------------------------------
0298 6EEC C120  34         mov   @>8356,tmp0           ; Get PAB VDP address + 9
     6EEE 8356 
0299 6EF0 0224  22         ai    tmp0,-4               ; Get address of PAB + 5
     6EF2 FFFC 
0300 6EF4 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6EF6 612C 
0301 6EF8 C144  18         mov   tmp0,tmp1             ; Move to destination
0302               *--------------------------------------------------------------
0303               * Get PAB byte 1 from VDP ram into tmp0 (status)
0304               *--------------------------------------------------------------
0305 6EFA C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0306                                                   ; as returned by DSRLNK
0307               *--------------------------------------------------------------
0308               * Exit
0309               *--------------------------------------------------------------
0310               ; If an error occured during the IO operation, then the
0311               ; equal bit in the saved status register (=R2) is set to 1.
0312               ;
0313               ; If no error occured during the IO operation, then the
0314               ; equal bit in the saved status register (=R2) is set to 0.
0315               ;
0316               ; Upon return from this IO call you should basically test with:
0317               ;       coc   @wbit2,tmp2           ; Equal bit set?
0318               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0319               ;
0320               ; Then look for further details in the copy of VDP PAB byte 1
0321               ; in register tmp0, bits 13-15
0322               ;
0323               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0324               ;                                   ; calls, skip for type >A subprograms!)
0325               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0326               ;       jeq   my_error_handler
0327               *--------------------------------------------------------------
0328               file.record.pab.details.exit:
0329 6EFC 0451  20         b     *r1                   ; Return to caller
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
0020 6EFE 0300  24 tmgr    limi  0                     ; No interrupt processing
     6F00 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6F02 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6F04 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6F06 2360  38         coc   @wbit2,r13            ; C flag on ?
     6F08 6040 
0029 6F0A 1602  14         jne   tmgr1a                ; No, so move on
0030 6F0C E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6F0E 602C 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6F10 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6F12 6044 
0035 6F14 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6F16 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6F18 6034 
0048 6F1A 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6F1C 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6F1E 6032 
0050 6F20 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6F22 0460  28         b     @kthread              ; Run kernel thread
     6F24 6F9C 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6F26 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6F28 6038 
0056 6F2A 13EB  14         jeq   tmgr1
0057 6F2C 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6F2E 6036 
0058 6F30 16E8  14         jne   tmgr1
0059 6F32 C120  34         mov   @wtiusr,tmp0
     6F34 832E 
0060 6F36 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6F38 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6F3A 6F9A 
0065 6F3C C10A  18         mov   r10,tmp0
0066 6F3E 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6F40 00FF 
0067 6F42 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6F44 6040 
0068 6F46 1303  14         jeq   tmgr5
0069 6F48 0284  22         ci    tmp0,60               ; 1 second reached ?
     6F4A 003C 
0070 6F4C 1002  14         jmp   tmgr6
0071 6F4E 0284  22 tmgr5   ci    tmp0,50
     6F50 0032 
0072 6F52 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6F54 1001  14         jmp   tmgr8
0074 6F56 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6F58 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6F5A 832C 
0079 6F5C 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6F5E FF00 
0080 6F60 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6F62 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6F64 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6F66 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6F68 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6F6A 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6F6C 830C 
     6F6E 830D 
0089 6F70 1608  14         jne   tmgr10                ; No, get next slot
0090 6F72 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6F74 FF00 
0091 6F76 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6F78 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6F7A 8330 
0096 6F7C 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6F7E C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6F80 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6F82 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6F84 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6F86 8315 
     6F88 8314 
0103 6F8A 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6F8C 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6F8E 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6F90 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6F92 10F7  14         jmp   tmgr10                ; Process next slot
0108 6F94 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6F96 FF00 
0109 6F98 10B4  14         jmp   tmgr1
0110 6F9A 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6F9C E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6F9E 6034 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0020               *       <<skipped>>
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 6FA0 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     6FA2 63EC 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 6FA4 06A0  32         bl    @realkb               ; Scan full keyboard
     6FA6 64DC 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6FA8 0460  28         b     @tmgr3                ; Exit
     6FAA 6F26 
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
0017 6FAC C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6FAE 832E 
0018 6FB0 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6FB2 6036 
0019 6FB4 045B  20 mkhoo1  b     *r11                  ; Return
0020      6F02     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6FB6 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6FB8 832E 
0029 6FBA 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6FBC FEFF 
0030 6FBE 045B  20         b     *r11                  ; Return
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
0228               *  if R0 in WS1 equals >4a4a we were called from the system
0229               *  crash handler so we return there after initialisation.
0230               
0231               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0232               *  after clearing scratchpad memory. This has higher priority
0233               *  as crash handler flag R0.
0234               ********@*****@*********************@**************************
0236 6FC0 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     6FC2 6732 
0237 6FC4 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6FC6 8302 
0241               *--------------------------------------------------------------
0242               * Alternative entry point
0243               *--------------------------------------------------------------
0244 6FC8 0300  24 runli1  limi  0                     ; Turn off interrupts
     6FCA 0000 
0245 6FCC 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6FCE 8300 
0246 6FD0 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6FD2 83C0 
0247               *--------------------------------------------------------------
0248               * Clear scratch-pad memory from R4 upwards
0249               *--------------------------------------------------------------
0250 6FD4 0202  20 runli2  li    r2,>8308
     6FD6 8308 
0251 6FD8 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0252 6FDA 0282  22         ci    r2,>8400
     6FDC 8400 
0253 6FDE 16FC  14         jne   runli3
0254               *--------------------------------------------------------------
0255               * Exit to TI-99/4A title screen ?
0256               *--------------------------------------------------------------
0257               runli3a
0258 6FE0 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6FE2 FFFF 
0259 6FE4 1602  14         jne   runli4                ; No, continue
0260 6FE6 0420  54         blwp  @0                    ; Yes, bye bye
     6FE8 0000 
0261               *--------------------------------------------------------------
0262               * Determine if VDP is PAL or NTSC
0263               *--------------------------------------------------------------
0264 6FEA C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6FEC 833C 
0265 6FEE 04C1  14         clr   r1                    ; Reset counter
0266 6FF0 0202  20         li    r2,10                 ; We test 10 times
     6FF2 000A 
0267 6FF4 C0E0  34 runli5  mov   @vdps,r3
     6FF6 8802 
0268 6FF8 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6FFA 6044 
0269 6FFC 1302  14         jeq   runli6
0270 6FFE 0581  14         inc   r1                    ; Increase counter
0271 7000 10F9  14         jmp   runli5
0272 7002 0602  14 runli6  dec   r2                    ; Next test
0273 7004 16F7  14         jne   runli5
0274 7006 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7008 1250 
0275 700A 1202  14         jle   runli7                ; No, so it must be NTSC
0276 700C 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     700E 6040 
0277               *--------------------------------------------------------------
0278               * Copy machine code to scratchpad (prepare tight loop)
0279               *--------------------------------------------------------------
0280 7010 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     7012 609C 
0281 7014 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     7016 8322 
0282 7018 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0283 701A CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0284 701C CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0285               *--------------------------------------------------------------
0286               * Initialize registers, memory, ...
0287               *--------------------------------------------------------------
0288 701E 04C1  14 runli9  clr   r1
0289 7020 04C2  14         clr   r2
0290 7022 04C3  14         clr   r3
0291 7024 0209  20         li    stack,>8400           ; Set stack
     7026 8400 
0292 7028 020F  20         li    r15,vdpw              ; Set VDP write address
     702A 8C00 
0296               *--------------------------------------------------------------
0297               * Setup video memory
0298               *--------------------------------------------------------------
0300 702C 0280  22         ci    r0,>4a4a              ; Crash flag set?
     702E 4A4A 
0301 7030 1605  14         jne   runlia
0302 7032 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     7034 60D6 
0303 7036 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     7038 0000 
     703A 3FFF 
0308 703C 06A0  32 runlia  bl    @filv
     703E 60D6 
0309 7040 0FC0             data  pctadr,spfclr,16      ; Load color table
     7042 00C1 
     7044 0010 
0310               *--------------------------------------------------------------
0311               * Check if there is a F18A present
0312               *--------------------------------------------------------------
0316 7046 06A0  32         bl    @f18unl               ; Unlock the F18A
     7048 635C 
0317 704A 06A0  32         bl    @f18chk               ; Check if F18A is there
     704C 6376 
0318 704E 06A0  32         bl    @f18lck               ; Lock the F18A again
     7050 636C 
0320               *--------------------------------------------------------------
0321               * Check if there is a speech synthesizer attached
0322               *--------------------------------------------------------------
0324               *       <<skipped>>
0328               *--------------------------------------------------------------
0329               * Load video mode table & font
0330               *--------------------------------------------------------------
0331 7052 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     7054 6140 
0332 7056 6088             data  spvmod                ; Equate selected video mode table
0333 7058 0204  20         li    tmp0,spfont           ; Get font option
     705A 000C 
0334 705C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0335 705E 1304  14         jeq   runlid                ; Yes, skip it
0336 7060 06A0  32         bl    @ldfnt
     7062 61A8 
0337 7064 1100             data  fntadr,spfont         ; Load specified font
     7066 000C 
0338               *--------------------------------------------------------------
0339               * Did a system crash occur before runlib was called?
0340               *--------------------------------------------------------------
0341 7068 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     706A 4A4A 
0342 706C 1602  14         jne   runlie                ; No, continue
0343 706E 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     7070 605A 
0344               *--------------------------------------------------------------
0345               * Branch to main program
0346               *--------------------------------------------------------------
0347 7072 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     7074 0040 
0348 7076 0460  28         b     @main                 ; Give control to main program
     7078 707A 
**** **** ****     > fio.asm.927
0071               *--------------------------------------------------------------
0072               * SPECTRA2 startup options
0073               *--------------------------------------------------------------
0074      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0075      0001     spfbck  equ   >01                   ; Screen background color.
0076               ;--------------------------------------------------------------
0077               ; Video mode configuration
0078               ;--------------------------------------------------------------
0079      6088     spvmod  equ   tx8024                ; Video mode.   See VIDTAB for details.
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
0090               ***************************************************************
0091               * Main
0092               ********@*****@*********************@**************************
0093 707A 06A0  32 main    bl    @putat
     707C 6278 
0094 707E 0000             data  >0000,msg
     7080 7108 
0095               
0096 7082 06A0  32         bl    @putat
     7084 6278 
0097 7086 0100             data  >0100,fname
     7088 70F7 
0098               
0099 708A 0208  20         li    tmp4,>b000
     708C B000 
0100               
0101                       ;------------------------------------------------------
0102                       ; Prepare VDP for PAB and page out scratchpad
0103                       ;------------------------------------------------------
0104 708E 06A0  32         bl    @cpym2v
     7090 6280 
0105 7092 0200                   data vpab,pab,25      ; Copy PAB to VDP
     7094 70EE 
     7096 0019 
0106                       ;------------------------------------------------------
0107                       ; Load GPL scratchpad layout
0108                       ;------------------------------------------------------
0109 7098 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     709A 6D36 
0110 709C A000                   data >a000            ; / 8300->a000, 2000->8300
0111                       ;------------------------------------------------------
0112                       ; Open file
0113                       ;------------------------------------------------------
0114 709E 06A0  32         bl    @file.open
     70A0 6E84 
0115 70A2 0200                   data vpab             ; Pass file descriptor to DSRLNK
0116 70A4 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     70A6 6040 
0117 70A8 131A  14         jeq   file.error            ; Yes, IO error occured
0118                       ;------------------------------------------------------
0119                       ; Read file records
0120                       ;------------------------------------------------------
0121               readfile
0122 70AA 06A0  32         bl    @file.record.read     ; Read record
     70AC 6EBE 
0123 70AE 0200                   data vpab             ; tmp1=Status byte, tmp2=Bytes read
0124 70B0 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     70B2 6040 
0125 70B4 1314  14         jeq   file.error            ; Yes, so handle file error
0126                       ;------------------------------------------------------
0127                       ; Load spectra scratchpad layout
0128                       ;------------------------------------------------------
0129 70B6 06A0  32         bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     70B8 6732 
0130 70BA 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     70BC 6D58 
0131 70BE A000                   data >a000            ; / >a000->8300
0132                       ;------------------------------------------------------
0133                       ; Copy record to CPU memory
0134                       ;------------------------------------------------------
0135               ;        bl    @cpyv2m
0136               ;        data  vrecbuf,>c000,80
0137               
0138               
0139 70C0 0204  20         li    tmp0,vrecbuf          ; VDP source address
     70C2 0300 
0140 70C4 C148  18         mov   tmp4,tmp1             ; RAM target address
0141 70C6 0206  20         li    tmp2,80
     70C8 0050 
0142 70CA A206  18         a     tmp2,tmp4
0143 70CC 06A0  32         bl    @xpyv2m               ; Copy memory
     70CE 62AC 
0144               
0145                       ;------------------------------------------------------
0146                       ; Load GPL scratchpad layout again
0147                       ;------------------------------------------------------
0148 70D0 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     70D2 6D36 
0149 70D4 A000                   data >a000            ; / 8300->a000, 2000->8300
0150               
0151 70D6 10E9  14         jmp   readfile              ; Next record
0152                       ;------------------------------------------------------
0153                       ; Close file
0154                       ;------------------------------------------------------
0155               close_file
0156 70D8 06A0  32         bl    @file.close           ; Close file
     70DA 6EA0 
0157 70DC 0200                   data vpab
0158               
0159               
0160                       ;------------------------------------------------------
0161                       ; Error handler
0162                       ;------------------------------------------------------
0163               file.error
0164 70DE 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0165 70E0 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     70E2 0005 
0166 70E4 1302  14         jeq   exit_ok               ; All good. File closed by DSRLNK
0167 70E6 0460  28         b     @crash_handler        ; A File error occured. System crashed
     70E8 604A 
0168               
0169               
0170               exit_ok
0171 70EA 0420  54         blwp  @0
     70EC 0000 
0172               
0173               
0174               
0175               ***************************************************************
0176               * PAB for accessing file
0177               ********@*****@*********************@**************************
0178 70EE 0014     pab     byte  io.op.open            ;  0    - OPEN
0179                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0180 70F0 0300             data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0181 70F2 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0182                       byte  00                    ;  5    - Character count
0183 70F4 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0184 70F6 000F             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0185               
0186               ;fname   byte  12                    ;  9    - File descriptor length
0187               ;        text 'DSK2.XBEADOC'         ; 10-.. - File descriptor (Device + '.' + File name)
0188               
0189               fname   byte  15                    ;  9    - File descriptor length
0190 70F8 ....             text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
0191               
0192               
0193                       even
0194               
0195               
0196               msg
0197 7108 152A             byte  21
0198 7109 ....             text  '* File reading test *'
0199                       even
0200               
0201               
0202               
