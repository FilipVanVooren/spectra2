XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > hello_world.asm.31024
0001               ***************************************************************
0002               *
0003               *                          Device scan
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: hello_world.asm             ; Version 191020-31024
0009               *--------------------------------------------------------------
0010               * TI-99/4a DSR scan utility
0011               *--------------------------------------------------------------
0012               * 2018-11-01   Development started
0013               ********|*****|*********************|**************************
0014                       save  >6000,>7fff
0015                       aorg  >6000
0016               *--------------------------------------------------------------
0017               *debug                  equ  1      ; Turn on debugging
0018               ;--------------------------------------------------------------
0019               ; Equates for spectra2 DSRLNK
0020               ;--------------------------------------------------------------
0021      B000     dsrlnk.dsrlws             equ >b000 ; Address of dsrlnk workspace
0022      2100     dsrlnk.namsto             equ >2100 ; 8-byte RAM buffer for storing device name
0023      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0024      0001     startup_keep_vdpdiskbuf   equ  1    ; Keep VDP memory reserved for 3 VDP disk buffers
0025               *--------------------------------------------------------------
0026               * Skip unused spectra2 code modules for reduced code size
0027               *--------------------------------------------------------------
0028               ;skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0029               ;skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0030               ;skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0031               ;skip_vdp_hchar          equ  1      ; Skip hchar, xchar
0032               ;skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0033               ;skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0034               ;skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0035               ;skip_vdp_viewport       equ  1      ; Skip viewport functions
0036               ;skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0037               ;skip_vdp_yx2px_calc     equ  1      ; Skip YX to pixel calculation
0038               ;skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0039               ;skip_vdp_sprites        equ  1      ; Skip sprites support
0040               ;skip_sound_player       equ  1      ; Skip inclusion of sound player code
0041               ;skip_tms52xx_detection  equ  1      ; Skip speech synthesizer detection
0042               ;skip_tms52xx_player     equ  1      ; Skip inclusion of speech player code
0043               ;skip_random_generator   equ  1      ; Skip random functions
0044               ;skip_timer_alloc        equ  1      ; Skip support for timers allocation
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
0053 6012 7690             data  runlib
0061               
0062 6014 0B48             byte  11
0063 6015 ....             text  'HELLO WORLD'
0064                       even
0065               
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
0006               ********|*****|*********************|**************************
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
0027               ********|*****|*********************|**************************
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
0046               ********|*****|*********************|**************************
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
0059               ********|*****|*********************|**************************
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
0092               ********|*****|*********************|**************************
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
0103               ********|*****|*********************|**************************
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
0006               ********|*****|*********************|**************************
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
0079                       copy  "rom_bankswitch.asm"       ; Bank switch routine
**** **** ****     > rom_bankswitch.asm
0001               * FILE......: rom_bankswitch.asm
0002               * Purpose...: ROM bankswitching Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                   BANKSWITCHING FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * SWBNK - Switch ROM bank
0010               ***************************************************************
0011               *  BL   @SWBNK
0012               *  DATA P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = Bank selection address (>600X)
0015               *  P1 = Vector address
0016               *--------------------------------------------------------------
0017               *  B    @SWBNKX
0018               *
0019               *  TMP0 = Bank selection address (>600X)
0020               *  TMP1 = Vector address
0021               *--------------------------------------------------------------
0022               *  Important! The bank-switch routine must be at the exact
0023               *  same location accross banks
0024               ********|*****|*********************|**************************
0025 6020 C13B  30 swbnk   mov   *r11+,tmp0
0026 6022 C17B  30         mov   *r11+,tmp1
0027 6024 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 6026 C155  26         mov   *tmp1,tmp1
0029 6028 0455  20         b     *tmp1                 ; Switch to routine in TMP1
**** **** ****     > runlib.asm
0081               
0082                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Constants and equates used by runlib modules
0003               
0004               
0005               ***************************************************************
0006               *                      Some constants
0007               ********|*****|*********************|**************************
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
0026               ********|*****|*********************|**************************
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
0017               ********|*****|*********************|**************************
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
0037               ********|*****|*********************|**************************
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
0066               ********|*****|*********************|**************************
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
0106               ********|*****|*********************|**************************
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
0148               ********|*****|*********************|**************************
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
0164               ********|*****|*********************|**************************
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
0182               ********|*****|*********************|**************************
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
0208               ********|*****|*********************|**************************
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
0250               ********|*****|*********************|**************************
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
0264               ********|*****|*********************|**************************
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
0285               ********|*****|*********************|**************************
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
0370               ********|*****|*********************|**************************
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
0403               ********|*****|*********************|**************************
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
0424               ********|*****|*********************|**************************
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
0019               ********|*****|*********************|**************************
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
0019               ********|*****|*********************|**************************
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
0023               ********|*****|*********************|**************************
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
0101                       copy  "copy_grom_cpu.asm"        ; GROM to CPU copy functions
**** **** ****     > copy_grom_cpu.asm
0001               * FILE......: copy_grom_cpu.asm
0002               * Purpose...: GROM -> CPU copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       GROM COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * CPYG2M - Copy GROM memory to CPU memory
0011               ***************************************************************
0012               *  BL   @CPYG2M
0013               *  DATA P0,P1,P2
0014               *--------------------------------------------------------------
0015               *  P0 = GROM source address
0016               *  P1 = CPU target address
0017               *  P2 = Number of bytes to copy
0018               *--------------------------------------------------------------
0019               *  BL @CPYG2M
0020               *
0021               *  TMP0 = GROM source address
0022               *  TMP1 = CPU target address
0023               *  TMP2 = Number of bytes to copy
0024               ********|*****|*********************|**************************
0025 62EA C13B  30 cpyg2m  mov   *r11+,tmp0            ; Memory source address
0026 62EC C17B  30         mov   *r11+,tmp1            ; Memory target address
0027 62EE C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0028               *--------------------------------------------------------------
0029               * Setup GROM source address
0030               *--------------------------------------------------------------
0031 62F0 D804  38 xpyg2m  movb  tmp0,@grmwa
     62F2 9C02 
0032 62F4 06C4  14         swpb  tmp0
0033 62F6 D804  38         movb  tmp0,@grmwa
     62F8 9C02 
0034               *--------------------------------------------------------------
0035               *    Copy bytes from GROM to CPU memory
0036               *--------------------------------------------------------------
0037 62FA 0204  20         li    tmp0,grmrd            ; Set TMP0 to GROM data port
     62FC 9800 
0038 62FE C820  54         mov   @tmp003,@mcloop       ; Setup copy command
     6300 6308 
     6302 8320 
0039 6304 0460  28         b     @mcloop               ; Copy bytes
     6306 8320 
0040 6308 DD54     tmp003  data  >dd54                 ; MOVB *TMP0,*TMP1+
**** **** ****     > runlib.asm
0103               
0105                       copy  "copy_grom_vram.asm"       ; GROM to VRAM copy functions
**** **** ****     > copy_grom_vram.asm
0001               * FILE......: copy_grom_vram.asm
0002               * Purpose...: GROM to VDP vram copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       GROM COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * CPYG2V - Copy GROM memory to VRAM memory
0010               ***************************************************************
0011               *  BL   @CPYG2V
0012               *  DATA P0,P1,P2
0013               *--------------------------------------------------------------
0014               *  P0 = GROM source address
0015               *  P1 = VDP target address
0016               *  P2 = Number of bytes to copy
0017               *--------------------------------------------------------------
0018               *  BL @CPYG2V
0019               *
0020               *  TMP0 = GROM source address
0021               *  TMP1 = VDP target address
0022               *  TMP2 = Number of bytes to copy
0023               ********|*****|*********************|**************************
0024 630A C13B  30 cpyg2v  mov   *r11+,tmp0            ; Memory source address
0025 630C C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 630E C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Setup GROM source address
0029               *--------------------------------------------------------------
0030 6310 D804  38 xpyg2v  movb  tmp0,@grmwa
     6312 9C02 
0031 6314 06C4  14         swpb  tmp0
0032 6316 D804  38         movb  tmp0,@grmwa
     6318 9C02 
0033               *--------------------------------------------------------------
0034               * Setup VDP target address
0035               *--------------------------------------------------------------
0036 631A 0265  22         ori   tmp1,>4000
     631C 4000 
0037 631E 06C5  14         swpb  tmp1
0038 6320 D805  38         movb  tmp1,@vdpa
     6322 8C02 
0039 6324 06C5  14         swpb  tmp1
0040 6326 D805  38         movb  tmp1,@vdpa            ; Set VDP target address
     6328 8C02 
0041               *--------------------------------------------------------------
0042               *    Copy bytes from GROM to VDP memory
0043               *--------------------------------------------------------------
0044 632A 0207  20         li    tmp3,grmrd            ; Set TMP3 to GROM data port
     632C 9800 
0045 632E 020F  20         li    r15,vdpw              ; Set VDP write address
     6330 8C00 
0046 6332 C820  54         mov   @tmp002,@mcloop       ; Setup copy command
     6334 633C 
     6336 8320 
0047 6338 0460  28         b     @mcloop               ; Copy bytes
     633A 8320 
0048 633C D7D7     tmp002  data  >d7d7                 ; MOVB *TMP3,*R15
**** **** ****     > runlib.asm
0107               
0109                       copy  "vdp_rle_decompr.asm"      ; RLE decompress to VRAM
**** **** ****     > vdp_rle_decompr.asm
0001               * FILE......: vdp_rle_decompr.asm
0002               * Purpose...: RLE decompress to VRAM support module
0003               
0004               ***************************************************************
0005               * RLE2V - RLE decompress to VRAM memory
0006               ***************************************************************
0007               *  BL   @RLE2V
0008               *  DATA P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = ROM/RAM source address
0011               *  P1 = VDP target address
0012               *  P2 = Length of RLE encoded data
0013               *--------------------------------------------------------------
0014               *  BL @RLE2VX
0015               *
0016               *  TMP0     = VDP target address
0017               *  TMP2 (!) = ROM/RAM source address
0018               *  TMP3 (!) = Length of RLE encoded data
0019               *--------------------------------------------------------------
0020               *  Detail on RLE compression format:
0021               *  - If high bit is set, remaining 7 bits indicate to copy
0022               *    the next byte that many times.
0023               *  - If high bit is clear, remaining 7 bits indicate how many
0024               *    data bytes (non-repeated) follow.
0025               ********|*****|*********************|**************************
0026 633E C1BB  30 rle2v   mov   *r11+,tmp2            ; ROM/RAM source address
0027 6340 C13B  30         mov   *r11+,tmp0            ; VDP target address
0028 6342 C1FB  30         mov   *r11+,tmp3            ; Length of RLE encoded data
0029 6344 C80B  38         mov   r11,@waux1            ; Save return address
     6346 833C 
0030 6348 06A0  32 rle2vx  bl    @vdwa                 ; Setup VDP address from TMP0
     634A 60DE 
0031 634C C106  18         mov   tmp2,tmp0             ; We can safely reuse TMP0 now
0032 634E D1B4  28 rle2v0  movb  *tmp0+,tmp2           ; Get control byte into TMP2
0033 6350 0607  14         dec   tmp3                  ; Update length
0034 6352 1314  14         jeq   rle2vz                ; End of list
0035 6354 0A16  56         sla   tmp2,1                ; Check bit 0 of control byte
0036 6356 1808  14         joc   rle2v2                ; Yes, next byte is compressed
0037               *--------------------------------------------------------------
0038               *    Dump uncompressed bytes
0039               *--------------------------------------------------------------
0040 6358 C820  54 rle2v1  mov   @rledat,@mcloop       ; Setup machine code (MOVB *TMP0+,*R15)
     635A 6382 
     635C 8320 
0041 635E 0996  56         srl   tmp2,9                ; Use control byte as counter
0042 6360 61C6  18         s     tmp2,tmp3             ; Update length
0043 6362 06A0  32         bl    @mcloop               ; Write data to VDP
     6364 8320 
0044 6366 1008  14         jmp   rle2v3
0045               *--------------------------------------------------------------
0046               *    Dump compressed bytes
0047               *--------------------------------------------------------------
0048 6368 C820  54 rle2v2  mov   @filzz,@mcloop        ; Setup machine code(MOVB TMP1,*R15)
     636A 60DC 
     636C 8320 
0049 636E 0996  56         srl   tmp2,9                ; Use control byte as counter
0050 6370 0607  14         dec   tmp3                  ; Update length
0051 6372 D174  28         movb  *tmp0+,tmp1           ; Byte to fill
0052 6374 06A0  32         bl    @mcloop               ; Write data to VDP
     6376 8320 
0053               *--------------------------------------------------------------
0054               *    Check if more data to decompress
0055               *--------------------------------------------------------------
0056 6378 C1C7  18 rle2v3  mov   tmp3,tmp3             ; Length counter = 0 ?
0057 637A 16E9  14         jne   rle2v0                ; Not yet, process data
0058               *--------------------------------------------------------------
0059               *    Exit
0060               *--------------------------------------------------------------
0061 637C C2E0  34 rle2vz  mov   @waux1,r11
     637E 833C 
0062 6380 045B  20         b     *r11                  ; Return
0063 6382 D7F4     rledat  data  >d7f4                 ; MOVB *TMP0+,*R15
**** **** ****     > runlib.asm
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
0008               ********|*****|*********************|**************************
0009 6384 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6386 FFBF 
0010 6388 0460  28         b     @putv01
     638A 615E 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 638C 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     638E 0040 
0018 6390 0460  28         b     @putv01
     6392 615E 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 6394 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6396 FFDF 
0026 6398 0460  28         b     @putv01
     639A 615E 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 639C 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     639E 0020 
0034 63A0 0460  28         b     @putv01
     63A2 615E 
**** **** ****     > runlib.asm
0115               
0117                       copy  "vdp_sprites.asm"          ; VDP sprites
**** **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********|*****|*********************|**************************
0010 63A4 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     63A6 FFFE 
0011 63A8 0460  28         b     @putv01
     63AA 615E 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 63AC 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     63AE 0001 
0019 63B0 0460  28         b     @putv01
     63B2 615E 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 63B4 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     63B6 FFFD 
0027 63B8 0460  28         b     @putv01
     63BA 615E 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 63BC 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     63BE 0002 
0035 63C0 0460  28         b     @putv01
     63C2 615E 
**** **** ****     > runlib.asm
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
0017               ********|*****|*********************|**************************
0018 63C4 C83B  50 at      mov   *r11+,@wyx
     63C6 832A 
0019 63C8 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 63CA B820  54 down    ab    @hb$01,@wyx
     63CC 603C 
     63CE 832A 
0028 63D0 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 63D2 7820  54 up      sb    @hb$01,@wyx
     63D4 603C 
     63D6 832A 
0037 63D8 045B  20         b     *r11
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
0048               ********|*****|*********************|**************************
0049 63DA C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 63DC D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     63DE 832A 
0051 63E0 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     63E2 832A 
0052 63E4 045B  20         b     *r11
**** **** ****     > runlib.asm
0123               
0125                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
**** **** ****     > vdp_yx2px_calc.asm
0001               * FILE......: vdp_yx2px_calc.asm
0002               * Purpose...: Calculate pixel position for YX coordinate
0003               
0004               ***************************************************************
0005               * YX2PX - Get pixel position for cursor YX position
0006               ***************************************************************
0007               *  BL   @YX2PX
0008               *
0009               *  (CONFIG:0 = 1) = Skip sprite adjustment
0010               *--------------------------------------------------------------
0011               *  INPUT
0012               *  @WYX   = Cursor YX position
0013               *--------------------------------------------------------------
0014               *  OUTPUT
0015               *  TMP0HB = Y pixel position
0016               *  TMP0LB = X pixel position
0017               *--------------------------------------------------------------
0018               *  Remarks
0019               *  This subroutine does not support multicolor mode
0020               ********|*****|*********************|**************************
0021 63E6 C120  34 yx2px   mov   @wyx,tmp0
     63E8 832A 
0022 63EA C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 63EC 06C4  14         swpb  tmp0                  ; Y<->X
0024 63EE 04C5  14         clr   tmp1                  ; Clear before copy
0025 63F0 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 63F2 20A0  38         coc   @wbit1,config         ; f18a present ?
     63F4 6048 
0030 63F6 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 63F8 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     63FA 833A 
     63FC 6426 
0032 63FE 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6400 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6402 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6404 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6406 0500 
0037 6408 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 640A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 640C 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 640E 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6410 D105  18         movb  tmp1,tmp0
0051 6412 06C4  14         swpb  tmp0                  ; X<->Y
0052 6414 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6416 604A 
0053 6418 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 641A 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     641C 603C 
0059 641E 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6420 604E 
0060 6422 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6424 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6426 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0127               
0129                       copy  "vdp_px2yx_calc.asm"       ; VDP calculate YX coordinate for pixel pos
**** **** ****     > vdp_px2yx_calc.asm
0001               * FILE......: vdp_px2yx_calc.asm
0002               * Purpose...: Calculate YX coordinate for pixel position
0003               
0004               ***************************************************************
0005               * PX2YX - Get YX tile position for specified YX pixel position
0006               ***************************************************************
0007               *  BL   @PX2YX
0008               *--------------------------------------------------------------
0009               *  INPUT
0010               *  TMP0   = Pixel YX position
0011               *
0012               *  (CONFIG:0 = 1) = Skip sprite adjustment
0013               *--------------------------------------------------------------
0014               *  OUTPUT
0015               *  TMP0HB = Y tile position
0016               *  TMP0LB = X tile position
0017               *  TMP1HB = Y pixel offset
0018               *  TMP1LB = X pixel offset
0019               *--------------------------------------------------------------
0020               *  Remarks
0021               *  This subroutine does not support multicolor or text mode
0022               ********|*****|*********************|**************************
0023 6428 20A0  38 px2yx   coc   @wbit0,config         ; Skip sprite adjustment ?
     642A 604A 
0024 642C 1302  14         jeq   px2yx1
0025 642E 0224  22         ai    tmp0,>0100            ; Adjust Y. Top of screen is at >FF
     6430 0100 
0026 6432 C144  18 px2yx1  mov   tmp0,tmp1             ; Copy YX
0027 6434 C184  18         mov   tmp0,tmp2             ; Copy YX
0028               *--------------------------------------------------------------
0029               * Calculate Y tile position
0030               *--------------------------------------------------------------
0031 6436 09B4  56         srl   tmp0,11               ; Y: Move to TMP0LB & (Y = Y / 8)
0032               *--------------------------------------------------------------
0033               * Calculate Y pixel offset
0034               *--------------------------------------------------------------
0035 6438 C1C4  18         mov   tmp0,tmp3             ; Y: Copy Y tile to TMP3LB
0036 643A 0AB7  56         sla   tmp3,11               ; Y: Move to TMP3HB & (Y = Y * 8)
0037 643C 0507  16         neg   tmp3
0038 643E B1C5  18         ab    tmp1,tmp3             ; Y: offset = Y pixel old + (-Y) pixel new
0039               *--------------------------------------------------------------
0040               * Calculate X tile position
0041               *--------------------------------------------------------------
0042 6440 0245  22         andi  tmp1,>00ff            ; Clear TMP1HB
     6442 00FF 
0043 6444 0A55  56         sla   tmp1,5                ; X: Move to TMP1HB & (X = X / 8)
0044 6446 D105  18         movb  tmp1,tmp0             ; X: TMP0 <-- XY tile position
0045 6448 06C4  14         swpb  tmp0                  ; XY tile position <-> YX tile position
0046               *--------------------------------------------------------------
0047               * Calculate X pixel offset
0048               *--------------------------------------------------------------
0049 644A 0245  22         andi  tmp1,>ff00            ; X: Get rid of remaining junk in TMP1LB
     644C FF00 
0050 644E 0A35  56         sla   tmp1,3                ; X: (X = X * 8)
0051 6450 0505  16         neg   tmp1
0052 6452 06C6  14         swpb  tmp2                  ; YX <-> XY
0053 6454 B146  18         ab    tmp2,tmp1             ; offset X = X pixel old  + (-X) pixel new
0054 6456 06C5  14         swpb  tmp1                  ; X0 <-> 0X
0055 6458 D147  18         movb  tmp3,tmp1             ; 0X --> YX
0056 645A 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0131               
0133                       copy  "vdp_bitmap.asm"           ; VDP Bitmap functions
**** **** ****     > vdp_bitmap.asm
0001               * FILE......: vdp_bitmap.asm
0002               * Purpose...: VDP bitmap support module
0003               
0004               ***************************************************************
0005               * BITMAP - Set tiles for displaying bitmap picture
0006               ***************************************************************
0007               *  BL   @BITMAP
0008               ********|*****|*********************|**************************
0009 645C C1CB  18 bitmap  mov   r11,tmp3              ; Save R11
0010 645E C120  34         mov   @wbase,tmp0           ; Get PNT base address
     6460 8328 
0011 6462 06A0  32         bl    @vdwa                 ; Setup VDP write address
     6464 60DE 
0012 6466 04C5  14         clr   tmp1
0013 6468 0206  20         li    tmp2,768              ; Write 768 bytes
     646A 0300 
0014               *--------------------------------------------------------------
0015               * Repeat 3 times: write bytes >00 .. >FF
0016               *--------------------------------------------------------------
0017 646C D7C5  30 bitma1  movb  tmp1,*r15             ; Write byte
0018 646E 0225  22         ai    tmp1,>0100
     6470 0100 
0019 6472 0606  14         dec   tmp2
0020 6474 16FB  14         jne   bitma1
0021 6476 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
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
0012               ********|*****|*********************|**************************
0013 6478 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 647A 06A0  32         bl    @putvr                ; Write once
     647C 614A 
0015 647E 391C             data  >391c                 ; VR1/57, value 00011100
0016 6480 06A0  32         bl    @putvr                ; Write twice
     6482 614A 
0017 6484 391C             data  >391c                 ; VR1/57, value 00011100
0018 6486 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 6488 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 648A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     648C 614A 
0028 648E 391C             data  >391c
0029 6490 0458  20         b     *tmp4                 ; Exit
0030               
0031               
0032               ***************************************************************
0033               * f18chk - Check if F18A VDP present
0034               ***************************************************************
0035               *  bl   @f18chk
0036               *--------------------------------------------------------------
0037               *  REMARKS
0038               *  VDP memory >3f00->3f05 still has part of GPU code upon exit.
0039               ********|*****|*********************|**************************
0040 6492 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6494 06A0  32         bl    @cpym2v
     6496 6250 
0042 6498 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     649A 64D6 
     649C 0006 
0043 649E 06A0  32         bl    @putvr
     64A0 614A 
0044 64A2 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 64A4 06A0  32         bl    @putvr
     64A6 614A 
0046 64A8 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 64AA 0204  20         li    tmp0,>3f00
     64AC 3F00 
0052 64AE 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     64B0 60E2 
0053 64B2 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     64B4 8800 
0054 64B6 0984  56         srl   tmp0,8
0055 64B8 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     64BA 8800 
0056 64BC C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 64BE 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 64C0 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     64C2 BFFF 
0060 64C4 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 64C6 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     64C8 4000 
0063               f18chk_exit:
0064 64CA 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     64CC 60B6 
0065 64CE 3F00             data  >3f00,>00,6
     64D0 0000 
     64D2 0006 
0066 64D4 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 64D6 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 64D8 3F00             data  >3f00                 ; 3f02 / 3f00
0073 64DA 0340             data  >0340                 ; 3f04   0340  idle
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
0091               ********|*****|*********************|**************************
0092 64DC C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 64DE 06A0  32         bl    @putvr
     64E0 614A 
0097 64E2 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 64E4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     64E6 614A 
0100 64E8 391C             data  >391c                 ; Lock the F18a
0101 64EA 0458  20         b     *tmp4                 ; Exit
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
0119               ********|*****|*********************|**************************
0120 64EC C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 64EE 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     64F0 6048 
0122 64F2 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 64F4 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     64F6 8802 
0127 64F8 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     64FA 614A 
0128 64FC 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 64FE 04C4  14         clr   tmp0
0130 6500 D120  34         movb  @vdps,tmp0
     6502 8802 
0131 6504 0984  56         srl   tmp0,8
0132 6506 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0139               
0141                       copy  "vdp_hchar.asm"            ; VDP hchar functions
**** **** ****     > vdp_hchar.asm
0001               * FILE......: vdp_hchar.a99
0002               * Purpose...: VDP hchar module
0003               
0004               ***************************************************************
0005               * Repeat characters horizontally at YX
0006               ***************************************************************
0007               *  BL    @HCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 6508 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     650A 832A 
0018 650C D17B  28         movb  *r11+,tmp1
0019 650E 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6510 D1BB  28         movb  *r11+,tmp2
0021 6512 0986  56         srl   tmp2,8                ; Repeat count
0022 6514 C1CB  18         mov   r11,tmp3
0023 6516 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6518 6212 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 651A 020B  20         li    r11,hchar1
     651C 6522 
0028 651E 0460  28         b     @xfilv                ; Draw
     6520 60BC 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6522 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6524 604C 
0033 6526 1302  14         jeq   hchar2                ; Yes, exit
0034 6528 C2C7  18         mov   tmp3,r11
0035 652A 10EE  14         jmp   hchar                 ; Next one
0036 652C 05C7  14 hchar2  inct  tmp3
0037 652E 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0143               
0145                       copy  "vdp_vchar.asm"            ; VDP vchar functions
**** **** ****     > vdp_vchar.asm
0001               * FILE......: vdp_vchar.a99
0002               * Purpose...: VDP vchar module
0003               
0004               ***************************************************************
0005               * Repeat characters vertically at YX
0006               ***************************************************************
0007               *  BL    @VCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 6530 C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     6532 832A 
0018 6534 C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 6536 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     6538 833A 
0020 653A 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     653C 6212 
0021 653E D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 6540 D1B7  28         movb  *tmp3+,tmp2
0023 6542 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 6544 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     6546 60DE 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 6548 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 654A A108  18         a     tmp4,tmp0             ; Next row
0033 654C 0606  14         dec   tmp2
0034 654E 16FA  14         jne   vchar2
0035 6550 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6552 604C 
0036 6554 1303  14         jeq   vchar3                ; Yes, exit
0037 6556 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     6558 832A 
0038 655A 10ED  14         jmp   vchar1                ; Next one
0039 655C 05C7  14 vchar3  inct  tmp3
0040 655E 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 6560 C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 6562 C804  38         mov   tmp0,@wyx             ; Set cursor position
     6564 832A 
0051 6566 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 6568 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     656A 833A 
0053 656C 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     656E 6212 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 6570 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     6572 60DE 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 6574 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 6576 A120  34         a     @wcolmn,tmp0          ; Next row
     6578 833A 
0063 657A 0606  14         dec   tmp2
0064 657C 16F9  14         jne   xvcha1
0065 657E 0458  20         b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0147               
0149                       copy  "vdp_boxes.asm"            ; VDP box functions
**** **** ****     > vdp_boxes.asm
0001               * FILE......: vdp_boxes.a99
0002               * Purpose...: VDP Fillbox, Putbox module
0003               
0004               ***************************************************************
0005               * FILBOX - Fill box with character
0006               ***************************************************************
0007               *  BL   @FILBOX
0008               *  DATA P0,P1,P2
0009               *  ...
0010               *  DATA EOL
0011               *--------------------------------------------------------------
0012               *  P0HB = Upper left corner Y
0013               *  P0LB = Upper left corner X
0014               *  P1HB = Height
0015               *  P1LB = Width
0016               *  P2HB = >00
0017               *  P2LB = Character to fill
0018               ********|*****|*********************|**************************
0019 6580 C83B  50 filbox  mov   *r11+,@wyx            ; Upper left corner
     6582 832A 
0020 6584 D1FB  28         movb  *r11+,tmp3            ; Height in TMP3
0021 6586 D1BB  28         movb  *r11+,tmp2            ; Width in TMP2
0022 6588 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0023 658A C20B  18         mov   r11,tmp4              ; Save R11
0024 658C 0986  56         srl   tmp2,8                ; Right-align width
0025 658E 0987  56         srl   tmp3,8                ; Right-align height
0026               *--------------------------------------------------------------
0027               *  Do single row
0028               *--------------------------------------------------------------
0029 6590 06A0  32 filbo1  bl    @yx2pnt               ; Get VDP address into TMP0
     6592 6212 
0030 6594 020B  20         li    r11,filbo2            ; New return address
     6596 659C 
0031 6598 0460  28         b     @xfilv                ; Fill VRAM with byte
     659A 60BC 
0032               *--------------------------------------------------------------
0033               *  Recover width & character
0034               *--------------------------------------------------------------
0035 659C C108  18 filbo2  mov   tmp4,tmp0
0036 659E 0224  22         ai    tmp0,-3               ; R11 - 3
     65A0 FFFD 
0037 65A2 D1B4  28         movb  *tmp0+,tmp2           ; Get Width/Height
0038 65A4 0986  56         srl   tmp2,8                ; Right align
0039 65A6 C154  26         mov   *tmp0,tmp1            ; Get character to fill
0040               *--------------------------------------------------------------
0041               *  Housekeeping
0042               *--------------------------------------------------------------
0043 65A8 A820  54         a     @w$0100,@by           ; Y=Y+1
     65AA 603C 
     65AC 832A 
0044 65AE 0607  14         dec   tmp3
0045 65B0 15EF  14         jgt   filbo1                ; Process next row
0046 65B2 8818  46         c     *tmp4,@w$ffff         ; End-Of-List marker found ?
     65B4 604C 
0047 65B6 1302  14         jeq   filbo3                ; Yes, exit
0048 65B8 C2C8  18         mov   tmp4,r11
0049 65BA 10E2  14         jmp   filbox                ; Next one
0050 65BC 05C8  14 filbo3  inct  tmp4
0051 65BE 0458  20         b     *tmp4                 ; Exit
0052               
0053               
0054               ***************************************************************
0055               * PUTBOX - Put tiles in box
0056               ***************************************************************
0057               *  BL   @PUTBOX
0058               *  DATA P0,P1,P2,P3
0059               *  ...
0060               *  DATA EOL
0061               *--------------------------------------------------------------
0062               *  P0HB = Upper left corner Y
0063               *  P0LB = Upper left corner X
0064               *  P1HB = Box height
0065               *  P1LB = Box width
0066               *  P2   = Pointer to length-byte prefixed string
0067               *  P3HB = Repeat box A-times vertically
0068               *  P3LB = Repeat box B-times horizontally
0069               *--------------------------------------------------------------
0070               *  Register usage
0071               *  ; TMP0   = work copy of YX cursor position
0072               *  ; TMP1HB = Width  of box + X
0073               *  ; TMP2HB = Height of box + Y
0074               *  ; TMP3   = Pointer to string
0075               *  ; TMP4   = Counter for string
0076               *  ; @WAUX1 = Box AB repeat count
0077               *  ; @WAUX2 = Copy of R11
0078               *  ; @WAUX3 = YX position for next diagonal box
0079               *--------------------------------------------------------------
0080               *  ; Only byte operations on TMP1HB & TMP2HB.
0081               *  ; LO bytes of TMP1 and TMP2 reserved for future use.
0082               ********|*****|*********************|**************************
0083 65C0 C13B  30 putbox  mov   *r11+,tmp0            ; P0 - Upper left corner YX
0084 65C2 C15B  26         mov   *r11,tmp1             ; P1 - Height/Width in TMP1
0085 65C4 C1BB  30         mov   *r11+,tmp2            ; P1 - Height/Width in TMP2
0086 65C6 C1FB  30         mov   *r11+,tmp3            ; P2 - Pointer to string
0087 65C8 C83B  50         mov   *r11+,@waux1          ; P3 - Box repeat count AB
     65CA 833C 
0088 65CC C80B  38         mov   r11,@waux2            ; Save R11
     65CE 833E 
0089               *--------------------------------------------------------------
0090               *  Calculate some positions
0091               *--------------------------------------------------------------
0092 65D0 B184  18 putbo0  ab    tmp0,tmp2             ; TMP2HB = height + Y
0093 65D2 06C4  14         swpb  tmp0
0094 65D4 06C5  14         swpb  tmp1
0095 65D6 B144  18         ab    tmp0,tmp1             ; TMP1HB = width  + X
0096 65D8 06C4  14         swpb  tmp0
0097 65DA 0A12  56         sla   config,1              ; \ clear config bit 0
0098 65DC 0912  56         srl   config,1              ; / is only 4 bytes
0099 65DE C804  38         mov   tmp0,@waux3           ; Set additional work copy of YX cursor
     65E0 8340 
0100               *--------------------------------------------------------------
0101               *  Setup VDP write address
0102               *--------------------------------------------------------------
0103 65E2 C804  38 putbo1  mov   tmp0,@wyx             ; Set YX cursor
     65E4 832A 
0104 65E6 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     65E8 6212 
0105 65EA 06A0  32         bl    @vdwa                 ; Set VDP write address from TMP0
     65EC 60DE 
0106 65EE C120  34         mov   @wyx,tmp0
     65F0 832A 
0107               *--------------------------------------------------------------
0108               *  Prepare string for processing
0109               *--------------------------------------------------------------
0110 65F2 20A0  38         coc   @wbit0,config         ; state flag set ?
     65F4 604A 
0111 65F6 1302  14         jeq   putbo2                ; Yes, skip length byte
0112 65F8 D237  28         movb  *tmp3+,tmp4           ; Get length byte ...
0113 65FA 0988  56         srl   tmp4,8                ; ... and right justify
0114               *--------------------------------------------------------------
0115               *  Write line of tiles in box
0116               *--------------------------------------------------------------
0117 65FC D7F7  40 putbo2  movb  *tmp3+,*r15           ; Write to VDP
0118 65FE 0608  14         dec   tmp4
0119 6600 1310  14         jeq   putbo3                ; End of string. Repeat box ?
0120               *--------------------------------------------------------------
0121               *    Adjust cursor
0122               *--------------------------------------------------------------
0123 6602 0584  14         inc   tmp0                  ; X=X+1
0124 6604 06C4  14         swpb  tmp0
0125 6606 9144  18         cb    tmp0,tmp1             ; Right boundary reached ?
0126 6608 06C4  14         swpb  tmp0
0127 660A 11F8  14         jlt   putbo2                ; Not yet, continue
0128 660C 0224  22         ai    tmp0,>0100            ; Y=Y+1
     660E 0100 
0129 6610 D804  38         movb  tmp0,@wyx             ; Update Y cursor
     6612 832A 
0130 6614 9184  18         cb    tmp0,tmp2             ; Bottom boundary reached ?
0131 6616 1305  14         jeq   putbo3                ; Yes, exit
0132               *--------------------------------------------------------------
0133               *  Recover starting column
0134               *--------------------------------------------------------------
0135 6618 C120  34         mov   @wyx,tmp0             ; ... from YX cursor
     661A 832A 
0136 661C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     661E 8000 
0137 6620 10E0  14         jmp   putbo1                ; Draw next line
0138               *--------------------------------------------------------------
0139               *  Handling repeating of box
0140               *--------------------------------------------------------------
0141 6622 C120  34 putbo3  mov   @waux1,tmp0           ; Repeat box ?
     6624 833C 
0142 6626 1328  14         jeq   putbo9                ; No, move on to next list entry
0143               *--------------------------------------------------------------
0144               *     Repeat horizontally
0145               *--------------------------------------------------------------
0146 6628 06C4  14         swpb  tmp0                  ; BA
0147 662A D104  18         movb  tmp0,tmp0             ; B = 0 ?
0148 662C 130D  14         jeq   putbo4                ; Yes, repeat vertically
0149 662E 06C4  14         swpb  tmp0                  ; AB
0150 6630 0604  14         dec   tmp0                  ; B = B - 1
0151 6632 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     6634 833C 
0152 6636 D805  38         movb  tmp1,@waux3+1         ; New X position
     6638 8341 
0153 663A C120  34         mov   @waux3,tmp0           ; Get new YX position
     663C 8340 
0154 663E C1E0  34         mov   @waux2,tmp3
     6640 833E 
0155 6642 0227  22         ai    tmp3,-6               ; Back to P1
     6644 FFFA 
0156 6646 1014  14         jmp   putbo8
0157               *--------------------------------------------------------------
0158               *     Repeat vertically
0159               *--------------------------------------------------------------
0160 6648 06C4  14 putbo4  swpb  tmp0                  ; AB
0161 664A D104  18         movb  tmp0,tmp0             ; A = 0 ?
0162 664C 13EA  14         jeq   putbo3                ; Yes, check next entry in list
0163 664E 0224  22         ai    tmp0,->0100           ; A = A - 1
     6650 FF00 
0164 6652 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     6654 833C 
0165 6656 C1E0  34         mov   @waux2,tmp3           ; \
     6658 833E 
0166 665A 0607  14         dec   tmp3                  ; / Back to P3LB
0167 665C D817  46         movb  *tmp3,@waux1+1        ; Update B repeat count
     665E 833D 
0168 6660 D106  18         movb  tmp2,tmp0             ; New Y position
0169 6662 06C4  14         swpb  tmp0
0170 6664 0227  22         ai    tmp3,-6               ; Back to P0LB
     6666 FFFA 
0171 6668 D137  28         movb  *tmp3+,tmp0
0172 666A 06C4  14         swpb  tmp0
0173 666C C804  38         mov   tmp0,@waux3           ; Set new YX position
     666E 8340 
0174               *--------------------------------------------------------------
0175               *      Get Height, Width and reset string pointer
0176               *--------------------------------------------------------------
0177 6670 C157  26 putbo8  mov   *tmp3,tmp1            ; Get P1 into TMP1
0178 6672 C1B7  30         mov   *tmp3+,tmp2           ; Get P1 into TMP2
0179 6674 C1D7  26         mov   *tmp3,tmp3            ; Get P2 into TMP3
0180 6676 10AC  14         jmp   putbo0                ; Next box
0181               *--------------------------------------------------------------
0182               *  Next entry in list
0183               *--------------------------------------------------------------
0184 6678 C2E0  34 putbo9  mov   @waux2,r11            ; Restore R11
     667A 833E 
0185 667C 881B  46         c     *r11,@w$ffff          ; End-Of-List marker found ?
     667E 604C 
0186 6680 1301  14         jeq   putboa                ; Yes, exit
0187 6682 109E  14         jmp   putbox                ; Next one
0188 6684 0A22  56 putboa  sla   config,2              ; \ clear config bits 0 & 1
0189 6686 0922  56         srl   config,2              ; / is only 4 bytes
0190 6688 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0151               
0153                       copy  "vdp_viewport.asm"         ; VDP viewport functionality
**** **** ****     > vdp_viewport.asm
0001               * FILE......: vdp_viewport.asm
0002               * Purpose...: VDP viewport support module
0003               
0004               ***************************************************************
0005               * SCRDIM - Set (virtual) screen base and dimension
0006               ***************************************************************
0007               *  BL   @SCRDIM
0008               *--------------------------------------------------------------
0009               *  INPUT
0010               *  P0 = PNT base address
0011               *  P1 = Number of columns per row
0012               ********|*****|*********************|**************************
0013 668A C83B  50 scrdim  mov   *r11+,@wbase          ; VDP destination address
     668C 8328 
0014 668E C83B  50         mov   *r11+,@wcolmn         ; Number of columns per row
     6690 833A 
0015 6692 045B  20         b     *r11                  ; Exit
0016               
0017               
0018               ***************************************************************
0019               * VIEW - Viewport into virtual screen
0020               ***************************************************************
0021               *  BL   @VIEW
0022               *  DATA P0,P1,P2,P3,P4
0023               *--------------------------------------------------------------
0024               *  P0   = Pointer to RAM buffer
0025               *  P1   = Physical screen - upper left corner YX of viewport
0026               *  P2HB = Physical screen - Viewport height
0027               *  P2LB = Physical screen - Viewport width
0028               *  P3   = Virtual screen  - VRAM base address
0029               *  P4   = Virtual screen  - Number of columns
0030               *
0031               *  TMP0 must contain the YX offset in virtual screen
0032               *--------------------------------------------------------------
0033               * Memory usage
0034               * WAUX1 = Virtual screen VRAM base
0035               * WAUX2 = Virtual screen columns per row
0036               * WAUX3 = Virtual screen YX
0037               *
0038               * RAM buffer (offset)
0039               * 01  Physical screen VRAM base
0040               * 23  Physical screen columns per row
0041               * 45  Physical screen YX (viewport upper left corner)
0042               * 67  Height & width of viewport
0043               * 89  Return address
0044               ********|*****|*********************|**************************
0045 6694 C23B  30 view    mov   *r11+,tmp4            ; P0: Get pointer to RAM buffer
0046 6696 C620  46         mov   @wbase,*tmp4          ; RAM 01 - Save physical screen VRAM base
     6698 8328 
0047 669A CA20  54         mov   @wcolmn,@2(tmp4)      ; RAM 23 - Save physical screen size (columns per row)
     669C 833A 
     669E 0002 
0048 66A0 CA3B  50         mov   *r11+,@4(tmp4)        ; RAM 45 - P1: Get viewport upper left corner YX
     66A2 0004 
0049 66A4 C1FB  30         mov   *r11+,tmp3            ;
0050 66A6 CA07  38         mov   tmp3,@6(tmp4)         ; RAM 67 - P2: Get viewport height & width
     66A8 0006 
0051 66AA C83B  50         mov   *r11+,@waux1          ; P3: Get virtual screen VRAM base address
     66AC 833C 
0052 66AE C83B  50         mov   *r11+,@waux2          ; P4: Get virtual screen size (columns per row)
     66B0 833E 
0053 66B2 C804  38         mov   tmp0,@waux3           ; Get upper left corner YX in virtual screen
     66B4 8340 
0054 66B6 CA0B  38         mov   r11,@8(tmp4)          ; RAM 89 - Store R11 for exit
     66B8 0008 
0055 66BA 0A12  56         sla   config,1              ; \
0056 66BC 0912  56         srl   config,1              ; / Clear CONFIG bits 0
0057 66BE 0987  56         srl   tmp3,8                ; Row counter
0058               *--------------------------------------------------------------
0059               *    Set virtual screen dimension and position cursor
0060               *--------------------------------------------------------------
0061 66C0 C820  54 view1   mov   @waux1,@wbase         ; Set virtual screen base
     66C2 833C 
     66C4 8328 
0062 66C6 C820  54         mov   @waux2,@wcolmn        ; Set virtual screen width
     66C8 833E 
     66CA 833A 
0063 66CC C820  54         mov   @waux3,@wyx           ; Set cursor in virtual screen
     66CE 8340 
     66D0 832A 
0064               *--------------------------------------------------------------
0065               *    Prepare for copying a single line
0066               *--------------------------------------------------------------
0067 66D2 06A0  32 view2   bl    @yx2pnt               ; Get VRAM address in TMP0
     66D4 6212 
0068 66D6 C148  18         mov   tmp4,tmp1             ; RAM buffer + 10
0069 66D8 0225  22         ai    tmp1,10               ;
     66DA 000A 
0070 66DC C1A8  34         mov   @6(tmp4),tmp2         ; \ Get RAM buffer byte 1
     66DE 0006 
0071 66E0 0246  22         andi  tmp2,>00ff            ; / Clear MSB
     66E2 00FF 
0072 66E4 28A0  34         xor   @wbit0,config         ; Toggle bit 0
     66E6 604A 
0073 66E8 24A0  38         czc   @wbit0,config         ; Bit 0=0 ?
     66EA 604A 
0074 66EC 130B  14         jeq   view4                 ; Yes! So copy from RAM to VRAM
0075               *--------------------------------------------------------------
0076               *    Copy line from VRAM to RAM
0077               *--------------------------------------------------------------
0078 66EE 06A0  32 view3   bl    @xpyv2m               ; Copy block from VRAM (virtual screen) to RAM
     66F0 627C 
0079 66F2 C818  46         mov   *tmp4,@wbase          ; Set physical screen base
     66F4 8328 
0080 66F6 C828  54         mov   @2(tmp4),@wcolmn      ; Set physical screen columns per row
     66F8 0002 
     66FA 833A 
0081 66FC C828  54         mov   @4(tmp4),@wyx         ; Set cursor in physical screen
     66FE 0004 
     6700 832A 
0082 6702 10E7  14         jmp   view2
0083               *--------------------------------------------------------------
0084               *    Copy line from RAM to VRAM
0085               *--------------------------------------------------------------
0086 6704 06A0  32 view4   bl    @xpym2v               ; Copy block to VRAM
     6706 6256 
0087 6708 BA20  54         ab    @hb$01,@4(tmp4)       ; Physical screen Y=Y+1
     670A 603C 
     670C 0004 
0088 670E B820  54         ab    @hb$01,@waux3         ; Virtual screen  Y=Y+1
     6710 603C 
     6712 8340 
0089 6714 0607  14         dec   tmp3                  ; Update row counter
0090 6716 16D4  14         jne   view1                 ; Next line unless all rows process
0091               *--------------------------------------------------------------
0092               *    Exit
0093               *--------------------------------------------------------------
0094 6718 C2E8  34 viewz   mov   @8(tmp4),r11          ; \
     671A 0008 
0095 671C 045B  20         b     *r11                  ; / exit
**** **** ****     > runlib.asm
0155               
0157                       copy  "snd_player.asm"           ; Sound player
**** **** ****     > snd_player.asm
0001               * FILE......: snd_player.asm
0002               * Purpose...: Sound player support code
0003               
0004               
0005               ***************************************************************
0006               * MUTE - Mute all sound generators
0007               ***************************************************************
0008               *  BL  @MUTE
0009               *  Mute sound generators and clear sound pointer
0010               *
0011               *  BL  @MUTE2
0012               *  Mute sound generators without clearing sound pointer
0013               ********|*****|*********************|**************************
0014 671E 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     6720 8334 
0015 6722 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     6724 6030 
0016 6726 0204  20         li    tmp0,muttab
     6728 6738 
0017 672A 0205  20         li    tmp1,sound            ; Sound generator port >8400
     672C 8400 
0018 672E D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 6730 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 6732 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 6734 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 6736 045B  20         b     *r11
0023 6738 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     673A DFFF 
0024               
0025               
0026               ***************************************************************
0027               * SDPREP - Prepare for playing sound
0028               ***************************************************************
0029               *  BL   @SDPREP
0030               *  DATA P0,P1
0031               *
0032               *  P0 = Address where tune is stored
0033               *  P1 = Option flags for sound player
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  Use the below equates for P1:
0037               *
0038               *  SDOPT1 => Tune is in CPU memory + loop
0039               *  SDOPT2 => Tune is in CPU memory
0040               *  SDOPT3 => Tune is in VRAM + loop
0041               *  SDOPT4 => Tune is in VRAM
0042               ********|*****|*********************|**************************
0043 673C C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     673E 8334 
0044 6740 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     6742 8336 
0045 6744 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     6746 FFF8 
0046 6748 E0BB  30         soc   *r11+,config          ; Set options
0047 674A D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     674C 603C 
     674E 831B 
0048 6750 045B  20         b     *r11
0049               
0050               ***************************************************************
0051               * SDPLAY - Sound player for tune in VRAM or CPU memory
0052               ***************************************************************
0053               *  BL  @SDPLAY
0054               *--------------------------------------------------------------
0055               *  REMARKS
0056               *  Set config register bit13=0 to pause player.
0057               *  Set config register bit14=1 to repeat (or play next tune).
0058               ********|*****|*********************|**************************
0059 6752 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     6754 6030 
0060 6756 1301  14         jeq   sdpla1                ; Yes, play
0061 6758 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 675A 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 675C 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     675E 831B 
     6760 602A 
0067 6762 1301  14         jeq   sdpla3                ; Play next note
0068 6764 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6766 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6768 602C 
0070 676A 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 676C C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     676E 8336 
0075 6770 06C4  14         swpb  tmp0
0076 6772 D804  38         movb  tmp0,@vdpa
     6774 8C02 
0077 6776 06C4  14         swpb  tmp0
0078 6778 D804  38         movb  tmp0,@vdpa
     677A 8C02 
0079 677C 04C4  14         clr   tmp0
0080 677E D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     6780 8800 
0081 6782 131E  14         jeq   sdexit                ; Yes. exit
0082 6784 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 6786 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     6788 8336 
0084 678A D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     678C 8800 
     678E 8400 
0085 6790 0604  14         dec   tmp0
0086 6792 16FB  14         jne   vdpla2
0087 6794 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     6796 8800 
     6798 831B 
0088 679A 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     679C 8336 
0089 679E 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 67A0 C120  34 mmplay  mov   @wsdtmp,tmp0
     67A2 8336 
0094 67A4 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 67A6 130C  14         jeq   sdexit                ; Yes, exit
0096 67A8 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 67AA A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     67AC 8336 
0098 67AE D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     67B0 8400 
0099 67B2 0605  14         dec   tmp1
0100 67B4 16FC  14         jne   mmpla2
0101 67B6 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     67B8 831B 
0102 67BA 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     67BC 8336 
0103 67BE 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 67C0 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     67C2 602E 
0108 67C4 1607  14         jne   sdexi2                ; No, exit
0109 67C6 C820  54         mov   @wsdlst,@wsdtmp
     67C8 8334 
     67CA 8336 
0110 67CC D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     67CE 603C 
     67D0 831B 
0111 67D2 045B  20 sdexi1  b     *r11                  ; Exit
0112 67D4 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     67D6 FFF8 
0113 67D8 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > runlib.asm
0159               
0161                       copy  "tms52xx_detect.asm"       ; Detect speech synthesizer
**** **** ****     > tms52xx_detect.asm
0001               * FILE......: tms52xx_detect.asm
0002               * Purpose...: Check if speech synthesizer is connected
0003               
0004               
0005               ***************************************************************
0006               * SPSTAT - Read status register byte from speech synthesizer
0007               ***************************************************************
0008               *  LI  TMP2,@>....
0009               *  B   @SPSTAT
0010               *--------------------------------------------------------------
0011               * REMARKS
0012               * Destroys R11 !
0013               *
0014               * Register usage
0015               * TMP0HB = Status byte read from speech synth
0016               * TMP1   = Temporary use  (scratchpad machine code)
0017               * TMP2   = Return address for this subroutine
0018               * R11    = Return address (scratchpad machine code)
0019               ********|*****|*********************|**************************
0020 67DA 0204  20 spstat  li    tmp0,spchrd           ; (R4) = >9000
     67DC 9000 
0021 67DE C820  54         mov   @spcode,@mcsprd       ; \
     67E0 6082 
     67E2 8322 
0022 67E4 C820  54         mov   @spcode+2,@mcsprd+2   ; / Load speech read code
     67E6 6084 
     67E8 8324 
0023 67EA 020B  20         li    r11,spsta1            ; Return to SPSTA1
     67EC 67F2 
0024 67EE 0460  28         b     @mcsprd               ; Run scratchpad code
     67F0 8322 
0025 67F2 C820  54 spsta1  mov   @mccode,@mcsprd       ; \
     67F4 607C 
     67F6 8322 
0026 67F8 C820  54         mov   @mccode+2,@mcsprd+2   ; / Restore tight loop code
     67FA 607E 
     67FC 8324 
0027 67FE 0456  20         b     *tmp2                 ; Exit
0028               
0029               
0030               ***************************************************************
0031               * SPCONN - Check if speech synthesizer connected
0032               ***************************************************************
0033               * BL  @SPCONN
0034               *--------------------------------------------------------------
0035               * OUTPUT
0036               * TMP0HB = Byte read from speech synth
0037               *--------------------------------------------------------------
0038               * REMARKS
0039               * See Editor/Assembler manual, section 22.1.6 page 354.
0040               * Calls SPSTAT.
0041               *
0042               * Register usage
0043               * TMP0HB = Byte read from speech synth
0044               * TMP3   = Copy of R11
0045               * R12    = CONFIG register
0046               ********|*****|*********************|**************************
0047 6800 C1CB  18 spconn  mov   r11,tmp3              ; Save R11
0048               *--------------------------------------------------------------
0049               * Setup speech synthesizer memory address >0000
0050               *--------------------------------------------------------------
0051 6802 0204  20         li    tmp0,>4000            ; Load >40 (speech memory address command)
     6804 4000 
0052 6806 0205  20         li    tmp1,5                ; Process 5 nibbles in total
     6808 0005 
0053 680A D804  38 spcon1  movb  tmp0,@spchwt          ; Write nibble >40 (5x)
     680C 9400 
0054 680E 0605  14         dec   tmp1
0055 6810 16FC  14         jne   spcon1
0056               *--------------------------------------------------------------
0057               * Read first byte from speech synthesizer memory address >0000
0058               *--------------------------------------------------------------
0059 6812 0204  20         li    tmp0,>1000
     6814 1000 
0060 6816 D804  38         movb  tmp0,@spchwt          ; Load >10 (speech memory read command)
     6818 9400 
0061 681A 1000  14         nop                         ; \
0062 681C 1000  14         nop                         ; / 12 Microseconds delay
0063 681E 0206  20         li    tmp2,spcon2
     6820 6826 
0064 6822 0460  28         b     @spstat               ; Read status byte
     6824 67DA 
0065               *--------------------------------------------------------------
0066               * Update status bit 5 in CONFIG register
0067               *--------------------------------------------------------------
0068 6826 0984  56 spcon2  srl   tmp0,8                ; MSB to LSB
0069 6828 0284  22         ci    tmp0,>00aa            ; >aa means speech found
     682A 00AA 
0070 682C 1603  14         jne   spcon3
0071 682E E0A0  34         soc   @wbit5,config         ; Set config bit5=1
     6830 6040 
0072 6832 1002  14         jmp   spcon4
0073 6834 40A0  34 spcon3  szc   @wbit5,config         ; Set config bit5=0
     6836 6040 
0074 6838 0457  20 spcon4  b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0163               
0165                       copy  "tms52xx_player.asm"       ; Speech synthesizer player
**** **** ****     > tms52xx_player.asm
0001               ***************************************************************
0002               * FILE......: tms52xx_player.asm
0003               * Purpose...: Speech Synthesizer player
0004               
0005               *//////////////////////////////////////////////////////////////
0006               *                 Speech Synthesizer player
0007               *//////////////////////////////////////////////////////////////
0008               
0009               ***************************************************************
0010               * SPPREP - Prepare for playing speech
0011               ***************************************************************
0012               *  BL   @SPPREP
0013               *  DATA P0
0014               *
0015               *  P0 = Address of LPC data for external voice.
0016               ********|*****|*********************|**************************
0017 683A C83B  50 spprep  mov   *r11+,@wspeak         ; Set speech address
     683C 8338 
0018 683E E0A0  34         soc   @wbit3,config         ; Clear bit 3
     6840 6044 
0019 6842 045B  20         b     *r11
0020               
0021               ***************************************************************
0022               * SPPLAY - Speech player
0023               ***************************************************************
0024               * BL  @SPPLAY
0025               *--------------------------------------------------------------
0026               * Register usage
0027               * TMP3   = Copy of R11
0028               * R12    = CONFIG register
0029               ********|*****|*********************|**************************
0030 6844 24A0  38 spplay  czc   @wbit3,config         ; Player off ?
     6846 6044 
0031 6848 132F  14         jeq   spplaz                ; Yes, exit
0032 684A C1CB  18 sppla1  mov   r11,tmp3              ; Save R11
0033 684C 20A0  38         coc   @tmp010,config        ; Speech player enabled+busy ?
     684E 68AA 
0034 6850 1310  14         jeq   spkex3                ; Check FIFO buffer level
0035               *--------------------------------------------------------------
0036               * Speak external: Push LPC data to speech synthesizer
0037               *--------------------------------------------------------------
0038 6852 C120  34 spkext  mov   @wspeak,tmp0
     6854 8338 
0039 6856 D834  48         movb  *tmp0+,@spchwt        ; Send byte to speech synth
     6858 9400 
0040 685A 1000  14         jmp   $+2                   ; Delay
0041 685C 0206  20         li    tmp2,16
     685E 0010 
0042 6860 D834  48 spkex1  movb  *tmp0+,@spchwt        ; Send byte to speech synth
     6862 9400 
0043 6864 0606  14         dec   tmp2
0044 6866 16FC  14         jne   spkex1
0045 6868 0262  22         ori   config,>0800          ; bit 4=1 (busy)
     686A 0800 
0046 686C C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     686E 8338 
0047 6870 101B  14         jmp   spplaz                ; Exit
0048               *--------------------------------------------------------------
0049               * Speak external: Check synth FIFO buffer level
0050               *--------------------------------------------------------------
0051 6872 0206  20 spkex3  li    tmp2,spkex4           ; Set return address for SPSTAT
     6874 687A 
0052 6876 0460  28         b     @spstat               ; Get speech FIFO buffer status
     6878 67DA 
0053 687A 2120  38 spkex4  coc   @w$4000,tmp0          ; FIFO BL (buffer low) bit set?
     687C 6048 
0054 687E 1301  14         jeq   spkex5                ; Yes, refill
0055 6880 1013  14         jmp   spplaz                ; No, exit
0056               *--------------------------------------------------------------
0057               * Speak external: Refill synth with LPC data if FIFO buffer low
0058               *--------------------------------------------------------------
0059 6882 C120  34 spkex5  mov   @wspeak,tmp0
     6884 8338 
0060 6886 0206  20         li    tmp2,8                ; Bytes to send to speech synth
     6888 0008 
0061 688A D174  28 spkex6  movb  *tmp0+,tmp1
0062 688C D805  38         movb  tmp1,@spchwt          ; Send byte to speech synth
     688E 9400 
0063 6890 0285  22         ci    tmp1,spkoff           ; Speak off marker found ?
     6892 FF00 
0064 6894 1305  14         jeq   spkex8
0065 6896 0606  14         dec   tmp2
0066 6898 16F8  14         jne   spkex6                ; Send next byte
0067 689A C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     689C 8338 
0068 689E 1004  14 spkex7  jmp   spplaz                ; Exit
0069               *--------------------------------------------------------------
0070               * Speak external: Done with speaking
0071               *--------------------------------------------------------------
0072 68A0 40A0  34 spkex8  szc   @tmp010,config        ; bit 3,4,5=0
     68A2 68AA 
0073 68A4 04E0  34         clr   @wspeak               ; Reset pointer
     68A6 8338 
0074 68A8 0457  20 spplaz  b     *tmp3                 ; Exit
0075 68AA 1800     tmp010  data  >1800                 ; Binary 0001100000000000
0076                                                   ; Bit    0123456789ABCDEF
**** **** ****     > runlib.asm
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
0085               ********|*****|*********************|**************************
0086               virtkb
0087               *       szc   @wbit10,config        ; Reset alpha lock down key
0088 68AC 40A0  34         szc   @wbit11,config        ; Reset ANY key
     68AE 6034 
0089 68B0 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 68B2 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 68B4 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 68B6 0207  20         li    tmp3,kbmap0           ; Start with column 0
     68B8 6928 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 68BA 04CC  14         clr   r12
0097 68BC 1E15  20         sbz   >0015                 ; Set P5
0098 68BE 1F07  20         tb    7
0099 68C0 1302  14         jeq   virtk1
0100 68C2 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     68C4 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 68C6 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 68C8 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     68CA 0024 
0107 68CC 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 68CE 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     68D0 0006 
0109 68D2 0705  14         seto  tmp1                  ; >FFFF
0110 68D4 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 68D6 0545  14         inv   tmp1
0112 68D8 1302  14         jeq   virtk2                ; >0000 ?
0113 68DA E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     68DC 6034 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 68DE 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 68E0 1601  14         jne   virtk3
0119 68E2 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 68E4 05C7  14 virtk3  inct  tmp3
0121 68E6 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     68E8 6934 
0122 68EA 16F9  14         jne   virtk2                ; No, next entry
0123 68EC 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 68EE 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     68F0 0700 
0128 68F2 1309  14         jeq   virtk6                ; Yes, exit
0129 68F4 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     68F6 0200 
0130 68F8 1303  14         jeq   virtk5                ; Yes, skip
0131 68FA 0224  22         ai    tmp0,>0100
     68FC 0100 
0132 68FE 10E3  14         jmp   virtk1
0133 6900 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6902 0500 
0134 6904 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 6906 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 6908 C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     690A 8332 
0140 690C 1601  14         jne   virtk7
0141 690E 045B  20         b     *r11                  ; Exit
0142 6910 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6912 FFFF 
0143 6914 1603  14         jne   virtk8                ; No
0144 6916 0701  14         seto  r1                    ; Set exit flag
0145 6918 0460  28         b     @runli1               ; Yes, reset computer
     691A 7698 
0146 691C 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     691E 8000 
0147 6920 1602  14         jne   virtk9
0148 6922 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     6924 6034 
0149 6926 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 6928 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     692A FFFF 
0155 692C 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     692E 0020 
0156 6930 0400             data  >0400,kenter          ; >04 00000100  enter
     6932 4000 
0157 6934 FFFF     kbeoc   data  >ffff
0158               
0159 6936 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     6938 1000 
0160 693A 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     693C 0008 
0161 693E 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6940 0004 
0162 6942 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     6944 0200 
0163 6946 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     6948 0040 
0164 694A FFFF             data  >ffff
0165               
0166 694C 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     694E 2000 
0167 6950 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6952 0002 
0168 6954 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6956 0100 
0169 6958 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     695A 0080 
0170 695C 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     695E 0010 
0171 6960 FFFF             data  >ffff
0172               
0173 6962 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     6964 0001 
0174 6966 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     6968 0800 
0175 696A 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     696C 0020 
0176 696E FFFF             data  >ffff
0177               
0178 6970 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     6972 0020 
0179 6974 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     6976 0200 
0180 6978 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     697A 0100 
0181 697C 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     697E 0040 
0182 6980 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     6982 0080 
0183 6984 FFFF             data  >ffff
0184               
0185 6986 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     6988 0001 
0186 698A 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     698C 0010 
0187 698E 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     6990 0008 
0188 6992 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     6994 0002 
0189 6996 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     6998 0004 
0190 699A FFFF             data  >ffff
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
0015               ********|*****|*********************|**************************
0016 699C 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     699E 604A 
0017 69A0 020C  20         li    r12,>0024
     69A2 0024 
0018 69A4 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     69A6 6A34 
0019 69A8 04C6  14         clr   tmp2
0020 69AA 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 69AC 04CC  14         clr   r12
0025 69AE 1F08  20         tb    >0008                 ; Shift-key ?
0026 69B0 1302  14         jeq   realk1                ; No
0027 69B2 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     69B4 6A64 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 69B6 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 69B8 1302  14         jeq   realk2                ; No
0033 69BA 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     69BC 6A94 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 69BE 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 69C0 1302  14         jeq   realk3                ; No
0039 69C2 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     69C4 6AC4 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 69C6 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 69C8 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 69CA 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 69CC E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     69CE 604A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 69D0 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 69D2 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     69D4 0006 
0052 69D6 0606  14 realk5  dec   tmp2
0053 69D8 020C  20         li    r12,>24               ; CRU address for P2-P4
     69DA 0024 
0054 69DC 06C6  14         swpb  tmp2
0055 69DE 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 69E0 06C6  14         swpb  tmp2
0057 69E2 020C  20         li    r12,6                 ; CRU read address
     69E4 0006 
0058 69E6 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 69E8 0547  14         inv   tmp3                  ;
0060 69EA 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     69EC FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 69EE 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 69F0 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 69F2 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 69F4 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 69F6 0285  22         ci    tmp1,8
     69F8 0008 
0069 69FA 1AFA  14         jl    realk6
0070 69FC C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 69FE 1BEB  14         jh    realk5                ; No, next column
0072 6A00 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6A02 C206  18 realk8  mov   tmp2,tmp4
0077 6A04 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6A06 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6A08 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6A0A D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6A0C 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6A0E D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6A10 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6A12 604A 
0087 6A14 1608  14         jne   realka                ; No, continue saving key
0088 6A16 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6A18 6A5E 
0089 6A1A 1A05  14         jl    realka
0090 6A1C 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6A1E 6A5C 
0091 6A20 1B02  14         jh    realka                ; No, continue
0092 6A22 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6A24 E000 
0093 6A26 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6A28 833C 
0094 6A2A E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6A2C 6034 
0095 6A2E 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6A30 8C00 
0096 6A32 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 6A34 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6A36 0000 
     6A38 FF0D 
     6A3A 203D 
0099 6A3C ....             text  'xws29ol.'
0100 6A44 ....             text  'ced38ik,'
0101 6A4C ....             text  'vrf47ujm'
0102 6A54 ....             text  'btg56yhn'
0103 6A5C ....             text  'zqa10p;/'
0104 6A64 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6A66 0000 
     6A68 FF0D 
     6A6A 202B 
0105 6A6C ....             text  'XWS@(OL>'
0106 6A74 ....             text  'CED#*IK<'
0107 6A7C ....             text  'VRF$&UJM'
0108 6A84 ....             text  'BTG%^YHN'
0109 6A8C ....             text  'ZQA!)P:-'
0110 6A94 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6A96 0000 
     6A98 FF0D 
     6A9A 2005 
0111 6A9C 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6A9E 0804 
     6AA0 0F27 
     6AA2 C2B9 
0112 6AA4 600B             data  >600b,>0907,>063f,>c1B8
     6AA6 0907 
     6AA8 063F 
     6AAA C1B8 
0113 6AAC 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6AAE 7B02 
     6AB0 015F 
     6AB2 C0C3 
0114 6AB4 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6AB6 7D0E 
     6AB8 0CC6 
     6ABA BFC4 
0115 6ABC 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6ABE 7C03 
     6AC0 BC22 
     6AC2 BDBA 
0116 6AC4 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6AC6 0000 
     6AC8 FF0D 
     6ACA 209D 
0117 6ACC 9897             data  >9897,>93b2,>9f8f,>8c9B
     6ACE 93B2 
     6AD0 9F8F 
     6AD2 8C9B 
0118 6AD4 8385             data  >8385,>84b3,>9e89,>8b80
     6AD6 84B3 
     6AD8 9E89 
     6ADA 8B80 
0119 6ADC 9692             data  >9692,>86b4,>b795,>8a8D
     6ADE 86B4 
     6AE0 B795 
     6AE2 8A8D 
0120 6AE4 8294             data  >8294,>87b5,>b698,>888E
     6AE6 87B5 
     6AE8 B698 
     6AEA 888E 
0121 6AEC 9A91             data  >9a91,>81b1,>b090,>9cBB
     6AEE 81B1 
     6AF0 B090 
     6AF2 9CBB 
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
0015               ********|*****|*********************|**************************
0016 6AF4 C13B  30 mkhex   mov   *r11+,tmp0            ; Address of word
0017 6AF6 C83B  50         mov   *r11+,@waux3          ; Pointer to string buffer
     6AF8 8340 
0018 6AFA 0207  20         li    tmp3,waux1            ; We store the result in WAUX1 and WAUX2
     6AFC 833C 
0019 6AFE 04F7  30         clr   *tmp3+                ; Clear WAUX1
0020 6B00 04D7  26         clr   *tmp3                 ; Clear WAUX2
0021 6B02 0647  14         dect  tmp3                  ; Back to WAUX1
0022 6B04 C114  26         mov   *tmp0,tmp0            ; Get word
0023               *--------------------------------------------------------------
0024               *    Convert nibbles to bytes (is in wrong order)
0025               *--------------------------------------------------------------
0026 6B06 0205  20         li    tmp1,4
     6B08 0004 
0027 6B0A C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0028 6B0C 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6B0E 000F 
0029 6B10 A19B  26         a     *r11,tmp2             ; Add ASCII-offset
0030 6B12 06C6  14 mkhex2  swpb  tmp2
0031 6B14 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0032 6B16 0944  56         srl   tmp0,4                ; Next nibble
0033 6B18 0605  14         dec   tmp1
0034 6B1A 16F7  14         jne   mkhex1                ; Repeat until all nibbles processed
0035 6B1C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6B1E BFFF 
0036               *--------------------------------------------------------------
0037               *    Build first 2 bytes in correct order
0038               *--------------------------------------------------------------
0039 6B20 C160  34         mov   @waux3,tmp1           ; Get pointer
     6B22 8340 
0040 6B24 04D5  26         clr   *tmp1                 ; Set length byte to 0
0041 6B26 0585  14         inc   tmp1                  ; Next byte, not word!
0042 6B28 C120  34         mov   @waux2,tmp0
     6B2A 833E 
0043 6B2C 06C4  14         swpb  tmp0
0044 6B2E DD44  32         movb  tmp0,*tmp1+
0045 6B30 06C4  14         swpb  tmp0
0046 6B32 DD44  32         movb  tmp0,*tmp1+
0047               *--------------------------------------------------------------
0048               *    Set length byte
0049               *--------------------------------------------------------------
0050 6B34 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6B36 8340 
0051 6B38 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6B3A 6040 
0052 6B3C 05CB  14         inct  r11                   ; Skip Parameter P2
0053               *--------------------------------------------------------------
0054               *    Build last 2 bytes in correct order
0055               *--------------------------------------------------------------
0056 6B3E C120  34         mov   @waux1,tmp0
     6B40 833C 
0057 6B42 06C4  14         swpb  tmp0
0058 6B44 DD44  32         movb  tmp0,*tmp1+
0059 6B46 06C4  14         swpb  tmp0
0060 6B48 DD44  32         movb  tmp0,*tmp1+
0061               *--------------------------------------------------------------
0062               *    Display hex number ?
0063               *--------------------------------------------------------------
0064 6B4A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6B4C 604A 
0065 6B4E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0066 6B50 045B  20         b     *r11                  ; Exit
0067               *--------------------------------------------------------------
0068               *  Display hex number on screen at current YX position
0069               *--------------------------------------------------------------
0070 6B52 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6B54 7FFF 
0071 6B56 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6B58 8340 
0072 6B5A 0460  28         b     @xutst0               ; Display string
     6B5C 6238 
0073 6B5E 0610     prefix  data  >0610                 ; Length byte + blank
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
0086               ********|*****|*********************|**************************
0087 6B60 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6B62 832A 
0088 6B64 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6B66 8000 
0089 6B68 10C5  14         jmp   mkhex                 ; Convert number and display
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
0018               ********|*****|*********************|**************************
0019 6B6A 0207  20 mknum   li    tmp3,5                ; Digit counter
     6B6C 0005 
0020 6B6E C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6B70 C155  26         mov   *tmp1,tmp1            ; /
0022 6B72 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6B74 0228  22         ai    tmp4,4                ; Get end of buffer
     6B76 0004 
0024 6B78 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6B7A 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6B7C 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6B7E 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6B80 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6B82 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6B84 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6B86 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6B88 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6B8A 0607  14         dec   tmp3                  ; Decrease counter
0036 6B8C 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6B8E 0207  20         li    tmp3,4                ; Check first 4 digits
     6B90 0004 
0041 6B92 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6B94 C11B  26         mov   *r11,tmp0
0043 6B96 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6B98 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6B9A 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6B9C 05CB  14 mknum3  inct  r11
0047 6B9E 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6BA0 604A 
0048 6BA2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6BA4 045B  20         b     *r11                  ; Exit
0050 6BA6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6BA8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6BAA 13F8  14         jeq   mknum3                ; Yes, exit
0053 6BAC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6BAE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6BB0 7FFF 
0058 6BB2 C10B  18         mov   r11,tmp0
0059 6BB4 0224  22         ai    tmp0,-4
     6BB6 FFFC 
0060 6BB8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6BBA 0206  20         li    tmp2,>0500            ; String length = 5
     6BBC 0500 
0062 6BBE 0460  28         b     @xutstr               ; Display string
     6BC0 623A 
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
0090               ********|*****|*********************|**************************
0091               trimnum:
0092 6BC2 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6BC4 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6BC6 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6BC8 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6BCA 0207  20         li    tmp3,5                ; Set counter
     6BCC 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6BCE 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6BD0 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6BD2 0584  14         inc   tmp0                  ; Next character
0104 6BD4 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6BD6 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6BD8 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6BDA 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6BDC DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6BDE 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6BE0 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6BE2 0607  14         dec   tmp3                  ; Last character ?
0120 6BE4 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6BE6 045B  20         b     *r11                  ; Return
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
0137               ********|*****|*********************|**************************
0138 6BE8 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6BEA 832A 
0139 6BEC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6BEE 8000 
0140 6BF0 10BC  14         jmp   mknum                 ; Convert number and display
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
0022               ********|*****|*********************|**************************
0023      0004     wmemory equ   tmp0                  ; Current memory address
0024      0005     wmemend equ   tmp1                  ; Highest memory address to process
0025      0008     wcrc    equ   tmp4                  ; Current CRC
0026               *--------------------------------------------------------------
0027               * Entry point
0028               *--------------------------------------------------------------
0029               calc_crc
0030 6BF2 C13B  30         mov   *r11+,wmemory         ; First memory address
0031 6BF4 C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx
0033 6BF6 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 6BF8 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * Next word
0037               *--------------------------------------------------------------
0038               calc_crc1
0039 6BFA 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2
0044 6BFC C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 6BFE 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 6C00 C1C8  18         mov   wcrc,tmp3
0048 6C02 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 6C04 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 6C06 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6C08 00FF 
0052               
0053 6C0A 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 6C0C 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 6C0E 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6C10 6C34 
0056               *--------------------------------------------------------------
0057               * Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3
0060 6C12 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 6C14 0246  22         andi  tmp2,>00ff            ; Clear MSB
     6C16 00FF 
0062               
0063 6C18 C1C8  18         mov   wcrc,tmp3
0064 6C1A 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 6C1C 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 6C1E 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6C20 00FF 
0068               
0069 6C22 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 6C24 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 6C26 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6C28 6C34 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 6C2A 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 6C2C 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 6C2E 04C7  14         clr   tmp3
0081 6C30 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082 6C32 045B  20         b     *r11                  ; Return
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
0095 6C34 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     6C36 1021 
     6C38 2042 
     6C3A 3063 
     6C3C 4084 
     6C3E 50A5 
     6C40 60C6 
     6C42 70E7 
0096 6C44 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     6C46 9129 
     6C48 A14A 
     6C4A B16B 
     6C4C C18C 
     6C4E D1AD 
     6C50 E1CE 
     6C52 F1EF 
0097 6C54 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     6C56 0210 
     6C58 3273 
     6C5A 2252 
     6C5C 52B5 
     6C5E 4294 
     6C60 72F7 
     6C62 62D6 
0098 6C64 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     6C66 8318 
     6C68 B37B 
     6C6A A35A 
     6C6C D3BD 
     6C6E C39C 
     6C70 F3FF 
     6C72 E3DE 
0099 6C74 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     6C76 3443 
     6C78 0420 
     6C7A 1401 
     6C7C 64E6 
     6C7E 74C7 
     6C80 44A4 
     6C82 5485 
0100 6C84 A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     6C86 B54B 
     6C88 8528 
     6C8A 9509 
     6C8C E5EE 
     6C8E F5CF 
     6C90 C5AC 
     6C92 D58D 
0101 6C94 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     6C96 2672 
     6C98 1611 
     6C9A 0630 
     6C9C 76D7 
     6C9E 66F6 
     6CA0 5695 
     6CA2 46B4 
0102 6CA4 B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     6CA6 A77A 
     6CA8 9719 
     6CAA 8738 
     6CAC F7DF 
     6CAE E7FE 
     6CB0 D79D 
     6CB2 C7BC 
0103 6CB4 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     6CB6 58E5 
     6CB8 6886 
     6CBA 78A7 
     6CBC 0840 
     6CBE 1861 
     6CC0 2802 
     6CC2 3823 
0104 6CC4 C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     6CC6 D9ED 
     6CC8 E98E 
     6CCA F9AF 
     6CCC 8948 
     6CCE 9969 
     6CD0 A90A 
     6CD2 B92B 
0105 6CD4 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     6CD6 4AD4 
     6CD8 7AB7 
     6CDA 6A96 
     6CDC 1A71 
     6CDE 0A50 
     6CE0 3A33 
     6CE2 2A12 
0106 6CE4 DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     6CE6 CBDC 
     6CE8 FBBF 
     6CEA EB9E 
     6CEC 9B79 
     6CEE 8B58 
     6CF0 BB3B 
     6CF2 AB1A 
0107 6CF4 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     6CF6 7C87 
     6CF8 4CE4 
     6CFA 5CC5 
     6CFC 2C22 
     6CFE 3C03 
     6D00 0C60 
     6D02 1C41 
0108 6D04 EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     6D06 FD8F 
     6D08 CDEC 
     6D0A DDCD 
     6D0C AD2A 
     6D0E BD0B 
     6D10 8D68 
     6D12 9D49 
0109 6D14 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     6D16 6EB6 
     6D18 5ED5 
     6D1A 4EF4 
     6D1C 3E13 
     6D1E 2E32 
     6D20 1E51 
     6D22 0E70 
0110 6D24 FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     6D26 EFBE 
     6D28 DFDD 
     6D2A CFFC 
     6D2C BF1B 
     6D2E AF3A 
     6D30 9F59 
     6D32 8F78 
0111 6D34 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     6D36 81A9 
     6D38 B1CA 
     6D3A A1EB 
     6D3C D10C 
     6D3E C12D 
     6D40 F14E 
     6D42 E16F 
0112 6D44 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     6D46 00A1 
     6D48 30C2 
     6D4A 20E3 
     6D4C 5004 
     6D4E 4025 
     6D50 7046 
     6D52 6067 
0113 6D54 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     6D56 9398 
     6D58 A3FB 
     6D5A B3DA 
     6D5C C33D 
     6D5E D31C 
     6D60 E37F 
     6D62 F35E 
0114 6D64 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     6D66 1290 
     6D68 22F3 
     6D6A 32D2 
     6D6C 4235 
     6D6E 5214 
     6D70 6277 
     6D72 7256 
0115 6D74 B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     6D76 A5CB 
     6D78 95A8 
     6D7A 8589 
     6D7C F56E 
     6D7E E54F 
     6D80 D52C 
     6D82 C50D 
0116 6D84 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     6D86 24C3 
     6D88 14A0 
     6D8A 0481 
     6D8C 7466 
     6D8E 6447 
     6D90 5424 
     6D92 4405 
0117 6D94 A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     6D96 B7FA 
     6D98 8799 
     6D9A 97B8 
     6D9C E75F 
     6D9E F77E 
     6DA0 C71D 
     6DA2 D73C 
0118 6DA4 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     6DA6 36F2 
     6DA8 0691 
     6DAA 16B0 
     6DAC 6657 
     6DAE 7676 
     6DB0 4615 
     6DB2 5634 
0119 6DB4 D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     6DB6 C96D 
     6DB8 F90E 
     6DBA E92F 
     6DBC 99C8 
     6DBE 89E9 
     6DC0 B98A 
     6DC2 A9AB 
0120 6DC4 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     6DC6 4865 
     6DC8 7806 
     6DCA 6827 
     6DCC 18C0 
     6DCE 08E1 
     6DD0 3882 
     6DD2 28A3 
0121 6DD4 CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     6DD6 DB5C 
     6DD8 EB3F 
     6DDA FB1E 
     6DDC 8BF9 
     6DDE 9BD8 
     6DE0 ABBB 
     6DE2 BB9A 
0122 6DE4 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     6DE6 5A54 
     6DE8 6A37 
     6DEA 7A16 
     6DEC 0AF1 
     6DEE 1AD0 
     6DF0 2AB3 
     6DF2 3A92 
0123 6DF4 FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     6DF6 ED0F 
     6DF8 DD6C 
     6DFA CD4D 
     6DFC BDAA 
     6DFE AD8B 
     6E00 9DE8 
     6E02 8DC9 
0124 6E04 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     6E06 6C07 
     6E08 5C64 
     6E0A 4C45 
     6E0C 3CA2 
     6E0E 2C83 
     6E10 1CE0 
     6E12 0CC1 
0125 6E14 EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     6E16 FF3E 
     6E18 CF5D 
     6E1A DF7C 
     6E1C AF9B 
     6E1E BFBA 
     6E20 8FD9 
     6E22 9FF8 
0126 6E24 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     6E26 7E36 
     6E28 4E55 
     6E2A 5E74 
     6E2C 2E93 
     6E2E 3EB2 
     6E30 0ED1 
     6E32 1EF0 
**** **** ****     > runlib.asm
0187               
0189                       copy  "rnd_support.asm"          ; Random number generator
**** **** ****     > rnd_support.asm
0001               * FILE......: rnd_support.asm
0002               * Purpose...: Random generators module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     MISC FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * RND - Generate random number
0011               ***************************************************************
0012               *  BL   @RND
0013               *  DATA P0,P1
0014               *--------------------------------------------------------------
0015               *  P0 = Highest random number allowed
0016               *  P1 = Address of random seed
0017               *--------------------------------------------------------------
0018               *  BL   @RNDX
0019               *
0020               *  TMP0 = Highest random number allowed
0021               *  TMP3 = Address of random seed
0022               *--------------------------------------------------------------
0023               *  OUTPUT
0024               *  TMP0 = The generated random number
0025               ********|*****|*********************|**************************
0026 6E34 C13B  30 rnd     mov   *r11+,tmp0            ; Highest number allowed
0027 6E36 C1FB  30         mov   *r11+,tmp3            ; Get address of random seed
0028 6E38 04C5  14 rndx    clr   tmp1
0029 6E3A C197  26         mov   *tmp3,tmp2            ; Get random seed
0030 6E3C 1601  14         jne   rnd1
0031 6E3E 0586  14         inc   tmp2                  ; May not be zero
0032 6E40 0916  56 rnd1    srl   tmp2,1
0033 6E42 1702  14         jnc   rnd2
0034 6E44 29A0  34         xor   @rnddat,tmp2
     6E46 6E50 
0035 6E48 C5C6  30 rnd2    mov   tmp2,*tmp3            ; Store new random seed
0036 6E4A 3D44  128         div   tmp0,tmp1
0037 6E4C C106  18         mov   tmp2,tmp0
0038 6E4E 045B  20         b     *r11                  ; Exit
0039 6E50 B400     rnddat  data  >0b400                ; The magic number
**** **** ****     > runlib.asm
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
0009               * cpu.scrpad.backup - Backup scratchpad memory to >2000
0010               ***************************************************************
0011               *  bl   @cpu.scrpad.backup
0012               *--------------------------------------------------------------
0013               *  Register usage
0014               *  None
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to the memory area >2000 - >20FF
0017               *  without using any registers.
0018               ********|*****|*********************|**************************
0019               cpu.scrpad.backup:
0020               ********|*****|*********************|**************************
0021 6E52 C820  54         mov   @>8300,@>2000
     6E54 8300 
     6E56 2000 
0022 6E58 C820  54         mov   @>8302,@>2002
     6E5A 8302 
     6E5C 2002 
0023 6E5E C820  54         mov   @>8304,@>2004
     6E60 8304 
     6E62 2004 
0024 6E64 C820  54         mov   @>8306,@>2006
     6E66 8306 
     6E68 2006 
0025 6E6A C820  54         mov   @>8308,@>2008
     6E6C 8308 
     6E6E 2008 
0026 6E70 C820  54         mov   @>830A,@>200A
     6E72 830A 
     6E74 200A 
0027 6E76 C820  54         mov   @>830C,@>200C
     6E78 830C 
     6E7A 200C 
0028 6E7C C820  54         mov   @>830E,@>200E
     6E7E 830E 
     6E80 200E 
0029 6E82 C820  54         mov   @>8310,@>2010
     6E84 8310 
     6E86 2010 
0030 6E88 C820  54         mov   @>8312,@>2012
     6E8A 8312 
     6E8C 2012 
0031 6E8E C820  54         mov   @>8314,@>2014
     6E90 8314 
     6E92 2014 
0032 6E94 C820  54         mov   @>8316,@>2016
     6E96 8316 
     6E98 2016 
0033 6E9A C820  54         mov   @>8318,@>2018
     6E9C 8318 
     6E9E 2018 
0034 6EA0 C820  54         mov   @>831A,@>201A
     6EA2 831A 
     6EA4 201A 
0035 6EA6 C820  54         mov   @>831C,@>201C
     6EA8 831C 
     6EAA 201C 
0036 6EAC C820  54         mov   @>831E,@>201E
     6EAE 831E 
     6EB0 201E 
0037 6EB2 C820  54         mov   @>8320,@>2020
     6EB4 8320 
     6EB6 2020 
0038 6EB8 C820  54         mov   @>8322,@>2022
     6EBA 8322 
     6EBC 2022 
0039 6EBE C820  54         mov   @>8324,@>2024
     6EC0 8324 
     6EC2 2024 
0040 6EC4 C820  54         mov   @>8326,@>2026
     6EC6 8326 
     6EC8 2026 
0041 6ECA C820  54         mov   @>8328,@>2028
     6ECC 8328 
     6ECE 2028 
0042 6ED0 C820  54         mov   @>832A,@>202A
     6ED2 832A 
     6ED4 202A 
0043 6ED6 C820  54         mov   @>832C,@>202C
     6ED8 832C 
     6EDA 202C 
0044 6EDC C820  54         mov   @>832E,@>202E
     6EDE 832E 
     6EE0 202E 
0045 6EE2 C820  54         mov   @>8330,@>2030
     6EE4 8330 
     6EE6 2030 
0046 6EE8 C820  54         mov   @>8332,@>2032
     6EEA 8332 
     6EEC 2032 
0047 6EEE C820  54         mov   @>8334,@>2034
     6EF0 8334 
     6EF2 2034 
0048 6EF4 C820  54         mov   @>8336,@>2036
     6EF6 8336 
     6EF8 2036 
0049 6EFA C820  54         mov   @>8338,@>2038
     6EFC 8338 
     6EFE 2038 
0050 6F00 C820  54         mov   @>833A,@>203A
     6F02 833A 
     6F04 203A 
0051 6F06 C820  54         mov   @>833C,@>203C
     6F08 833C 
     6F0A 203C 
0052 6F0C C820  54         mov   @>833E,@>203E
     6F0E 833E 
     6F10 203E 
0053 6F12 C820  54         mov   @>8340,@>2040
     6F14 8340 
     6F16 2040 
0054 6F18 C820  54         mov   @>8342,@>2042
     6F1A 8342 
     6F1C 2042 
0055 6F1E C820  54         mov   @>8344,@>2044
     6F20 8344 
     6F22 2044 
0056 6F24 C820  54         mov   @>8346,@>2046
     6F26 8346 
     6F28 2046 
0057 6F2A C820  54         mov   @>8348,@>2048
     6F2C 8348 
     6F2E 2048 
0058 6F30 C820  54         mov   @>834A,@>204A
     6F32 834A 
     6F34 204A 
0059 6F36 C820  54         mov   @>834C,@>204C
     6F38 834C 
     6F3A 204C 
0060 6F3C C820  54         mov   @>834E,@>204E
     6F3E 834E 
     6F40 204E 
0061 6F42 C820  54         mov   @>8350,@>2050
     6F44 8350 
     6F46 2050 
0062 6F48 C820  54         mov   @>8352,@>2052
     6F4A 8352 
     6F4C 2052 
0063 6F4E C820  54         mov   @>8354,@>2054
     6F50 8354 
     6F52 2054 
0064 6F54 C820  54         mov   @>8356,@>2056
     6F56 8356 
     6F58 2056 
0065 6F5A C820  54         mov   @>8358,@>2058
     6F5C 8358 
     6F5E 2058 
0066 6F60 C820  54         mov   @>835A,@>205A
     6F62 835A 
     6F64 205A 
0067 6F66 C820  54         mov   @>835C,@>205C
     6F68 835C 
     6F6A 205C 
0068 6F6C C820  54         mov   @>835E,@>205E
     6F6E 835E 
     6F70 205E 
0069 6F72 C820  54         mov   @>8360,@>2060
     6F74 8360 
     6F76 2060 
0070 6F78 C820  54         mov   @>8362,@>2062
     6F7A 8362 
     6F7C 2062 
0071 6F7E C820  54         mov   @>8364,@>2064
     6F80 8364 
     6F82 2064 
0072 6F84 C820  54         mov   @>8366,@>2066
     6F86 8366 
     6F88 2066 
0073 6F8A C820  54         mov   @>8368,@>2068
     6F8C 8368 
     6F8E 2068 
0074 6F90 C820  54         mov   @>836A,@>206A
     6F92 836A 
     6F94 206A 
0075 6F96 C820  54         mov   @>836C,@>206C
     6F98 836C 
     6F9A 206C 
0076 6F9C C820  54         mov   @>836E,@>206E
     6F9E 836E 
     6FA0 206E 
0077 6FA2 C820  54         mov   @>8370,@>2070
     6FA4 8370 
     6FA6 2070 
0078 6FA8 C820  54         mov   @>8372,@>2072
     6FAA 8372 
     6FAC 2072 
0079 6FAE C820  54         mov   @>8374,@>2074
     6FB0 8374 
     6FB2 2074 
0080 6FB4 C820  54         mov   @>8376,@>2076
     6FB6 8376 
     6FB8 2076 
0081 6FBA C820  54         mov   @>8378,@>2078
     6FBC 8378 
     6FBE 2078 
0082 6FC0 C820  54         mov   @>837A,@>207A
     6FC2 837A 
     6FC4 207A 
0083 6FC6 C820  54         mov   @>837C,@>207C
     6FC8 837C 
     6FCA 207C 
0084 6FCC C820  54         mov   @>837E,@>207E
     6FCE 837E 
     6FD0 207E 
0085 6FD2 C820  54         mov   @>8380,@>2080
     6FD4 8380 
     6FD6 2080 
0086 6FD8 C820  54         mov   @>8382,@>2082
     6FDA 8382 
     6FDC 2082 
0087 6FDE C820  54         mov   @>8384,@>2084
     6FE0 8384 
     6FE2 2084 
0088 6FE4 C820  54         mov   @>8386,@>2086
     6FE6 8386 
     6FE8 2086 
0089 6FEA C820  54         mov   @>8388,@>2088
     6FEC 8388 
     6FEE 2088 
0090 6FF0 C820  54         mov   @>838A,@>208A
     6FF2 838A 
     6FF4 208A 
0091 6FF6 C820  54         mov   @>838C,@>208C
     6FF8 838C 
     6FFA 208C 
0092 6FFC C820  54         mov   @>838E,@>208E
     6FFE 838E 
     7000 208E 
0093 7002 C820  54         mov   @>8390,@>2090
     7004 8390 
     7006 2090 
0094 7008 C820  54         mov   @>8392,@>2092
     700A 8392 
     700C 2092 
0095 700E C820  54         mov   @>8394,@>2094
     7010 8394 
     7012 2094 
0096 7014 C820  54         mov   @>8396,@>2096
     7016 8396 
     7018 2096 
0097 701A C820  54         mov   @>8398,@>2098
     701C 8398 
     701E 2098 
0098 7020 C820  54         mov   @>839A,@>209A
     7022 839A 
     7024 209A 
0099 7026 C820  54         mov   @>839C,@>209C
     7028 839C 
     702A 209C 
0100 702C C820  54         mov   @>839E,@>209E
     702E 839E 
     7030 209E 
0101 7032 C820  54         mov   @>83A0,@>20A0
     7034 83A0 
     7036 20A0 
0102 7038 C820  54         mov   @>83A2,@>20A2
     703A 83A2 
     703C 20A2 
0103 703E C820  54         mov   @>83A4,@>20A4
     7040 83A4 
     7042 20A4 
0104 7044 C820  54         mov   @>83A6,@>20A6
     7046 83A6 
     7048 20A6 
0105 704A C820  54         mov   @>83A8,@>20A8
     704C 83A8 
     704E 20A8 
0106 7050 C820  54         mov   @>83AA,@>20AA
     7052 83AA 
     7054 20AA 
0107 7056 C820  54         mov   @>83AC,@>20AC
     7058 83AC 
     705A 20AC 
0108 705C C820  54         mov   @>83AE,@>20AE
     705E 83AE 
     7060 20AE 
0109 7062 C820  54         mov   @>83B0,@>20B0
     7064 83B0 
     7066 20B0 
0110 7068 C820  54         mov   @>83B2,@>20B2
     706A 83B2 
     706C 20B2 
0111 706E C820  54         mov   @>83B4,@>20B4
     7070 83B4 
     7072 20B4 
0112 7074 C820  54         mov   @>83B6,@>20B6
     7076 83B6 
     7078 20B6 
0113 707A C820  54         mov   @>83B8,@>20B8
     707C 83B8 
     707E 20B8 
0114 7080 C820  54         mov   @>83BA,@>20BA
     7082 83BA 
     7084 20BA 
0115 7086 C820  54         mov   @>83BC,@>20BC
     7088 83BC 
     708A 20BC 
0116 708C C820  54         mov   @>83BE,@>20BE
     708E 83BE 
     7090 20BE 
0117 7092 C820  54         mov   @>83C0,@>20C0
     7094 83C0 
     7096 20C0 
0118 7098 C820  54         mov   @>83C2,@>20C2
     709A 83C2 
     709C 20C2 
0119 709E C820  54         mov   @>83C4,@>20C4
     70A0 83C4 
     70A2 20C4 
0120 70A4 C820  54         mov   @>83C6,@>20C6
     70A6 83C6 
     70A8 20C6 
0121 70AA C820  54         mov   @>83C8,@>20C8
     70AC 83C8 
     70AE 20C8 
0122 70B0 C820  54         mov   @>83CA,@>20CA
     70B2 83CA 
     70B4 20CA 
0123 70B6 C820  54         mov   @>83CC,@>20CC
     70B8 83CC 
     70BA 20CC 
0124 70BC C820  54         mov   @>83CE,@>20CE
     70BE 83CE 
     70C0 20CE 
0125 70C2 C820  54         mov   @>83D0,@>20D0
     70C4 83D0 
     70C6 20D0 
0126 70C8 C820  54         mov   @>83D2,@>20D2
     70CA 83D2 
     70CC 20D2 
0127 70CE C820  54         mov   @>83D4,@>20D4
     70D0 83D4 
     70D2 20D4 
0128 70D4 C820  54         mov   @>83D6,@>20D6
     70D6 83D6 
     70D8 20D6 
0129 70DA C820  54         mov   @>83D8,@>20D8
     70DC 83D8 
     70DE 20D8 
0130 70E0 C820  54         mov   @>83DA,@>20DA
     70E2 83DA 
     70E4 20DA 
0131 70E6 C820  54         mov   @>83DC,@>20DC
     70E8 83DC 
     70EA 20DC 
0132 70EC C820  54         mov   @>83DE,@>20DE
     70EE 83DE 
     70F0 20DE 
0133 70F2 C820  54         mov   @>83E0,@>20E0
     70F4 83E0 
     70F6 20E0 
0134 70F8 C820  54         mov   @>83E2,@>20E2
     70FA 83E2 
     70FC 20E2 
0135 70FE C820  54         mov   @>83E4,@>20E4
     7100 83E4 
     7102 20E4 
0136 7104 C820  54         mov   @>83E6,@>20E6
     7106 83E6 
     7108 20E6 
0137 710A C820  54         mov   @>83E8,@>20E8
     710C 83E8 
     710E 20E8 
0138 7110 C820  54         mov   @>83EA,@>20EA
     7112 83EA 
     7114 20EA 
0139 7116 C820  54         mov   @>83EC,@>20EC
     7118 83EC 
     711A 20EC 
0140 711C C820  54         mov   @>83EE,@>20EE
     711E 83EE 
     7120 20EE 
0141 7122 C820  54         mov   @>83F0,@>20F0
     7124 83F0 
     7126 20F0 
0142 7128 C820  54         mov   @>83F2,@>20F2
     712A 83F2 
     712C 20F2 
0143 712E C820  54         mov   @>83F4,@>20F4
     7130 83F4 
     7132 20F4 
0144 7134 C820  54         mov   @>83F6,@>20F6
     7136 83F6 
     7138 20F6 
0145 713A C820  54         mov   @>83F8,@>20F8
     713C 83F8 
     713E 20F8 
0146 7140 C820  54         mov   @>83FA,@>20FA
     7142 83FA 
     7144 20FA 
0147 7146 C820  54         mov   @>83FC,@>20FC
     7148 83FC 
     714A 20FC 
0148 714C C820  54         mov   @>83FE,@>20FE
     714E 83FE 
     7150 20FE 
0149 7152 045B  20         b     *r11                  ; Return to caller
0150               
0151               
0152               ***************************************************************
0153               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0154               ***************************************************************
0155               *  bl   @cpu.scrpad.restore
0156               *--------------------------------------------------------------
0157               *  Register usage
0158               *  None
0159               *--------------------------------------------------------------
0160               *  Restore scratchpad from memory area >2000 - >20FF
0161               *  without using any registers.
0162               ********|*****|*********************|**************************
0163               cpu.scrpad.restore:
0164 7154 C820  54         mov   @>2000,@>8300
     7156 2000 
     7158 8300 
0165 715A C820  54         mov   @>2002,@>8302
     715C 2002 
     715E 8302 
0166 7160 C820  54         mov   @>2004,@>8304
     7162 2004 
     7164 8304 
0167 7166 C820  54         mov   @>2006,@>8306
     7168 2006 
     716A 8306 
0168 716C C820  54         mov   @>2008,@>8308
     716E 2008 
     7170 8308 
0169 7172 C820  54         mov   @>200A,@>830A
     7174 200A 
     7176 830A 
0170 7178 C820  54         mov   @>200C,@>830C
     717A 200C 
     717C 830C 
0171 717E C820  54         mov   @>200E,@>830E
     7180 200E 
     7182 830E 
0172 7184 C820  54         mov   @>2010,@>8310
     7186 2010 
     7188 8310 
0173 718A C820  54         mov   @>2012,@>8312
     718C 2012 
     718E 8312 
0174 7190 C820  54         mov   @>2014,@>8314
     7192 2014 
     7194 8314 
0175 7196 C820  54         mov   @>2016,@>8316
     7198 2016 
     719A 8316 
0176 719C C820  54         mov   @>2018,@>8318
     719E 2018 
     71A0 8318 
0177 71A2 C820  54         mov   @>201A,@>831A
     71A4 201A 
     71A6 831A 
0178 71A8 C820  54         mov   @>201C,@>831C
     71AA 201C 
     71AC 831C 
0179 71AE C820  54         mov   @>201E,@>831E
     71B0 201E 
     71B2 831E 
0180 71B4 C820  54         mov   @>2020,@>8320
     71B6 2020 
     71B8 8320 
0181 71BA C820  54         mov   @>2022,@>8322
     71BC 2022 
     71BE 8322 
0182 71C0 C820  54         mov   @>2024,@>8324
     71C2 2024 
     71C4 8324 
0183 71C6 C820  54         mov   @>2026,@>8326
     71C8 2026 
     71CA 8326 
0184 71CC C820  54         mov   @>2028,@>8328
     71CE 2028 
     71D0 8328 
0185 71D2 C820  54         mov   @>202A,@>832A
     71D4 202A 
     71D6 832A 
0186 71D8 C820  54         mov   @>202C,@>832C
     71DA 202C 
     71DC 832C 
0187 71DE C820  54         mov   @>202E,@>832E
     71E0 202E 
     71E2 832E 
0188 71E4 C820  54         mov   @>2030,@>8330
     71E6 2030 
     71E8 8330 
0189 71EA C820  54         mov   @>2032,@>8332
     71EC 2032 
     71EE 8332 
0190 71F0 C820  54         mov   @>2034,@>8334
     71F2 2034 
     71F4 8334 
0191 71F6 C820  54         mov   @>2036,@>8336
     71F8 2036 
     71FA 8336 
0192 71FC C820  54         mov   @>2038,@>8338
     71FE 2038 
     7200 8338 
0193 7202 C820  54         mov   @>203A,@>833A
     7204 203A 
     7206 833A 
0194 7208 C820  54         mov   @>203C,@>833C
     720A 203C 
     720C 833C 
0195 720E C820  54         mov   @>203E,@>833E
     7210 203E 
     7212 833E 
0196 7214 C820  54         mov   @>2040,@>8340
     7216 2040 
     7218 8340 
0197 721A C820  54         mov   @>2042,@>8342
     721C 2042 
     721E 8342 
0198 7220 C820  54         mov   @>2044,@>8344
     7222 2044 
     7224 8344 
0199 7226 C820  54         mov   @>2046,@>8346
     7228 2046 
     722A 8346 
0200 722C C820  54         mov   @>2048,@>8348
     722E 2048 
     7230 8348 
0201 7232 C820  54         mov   @>204A,@>834A
     7234 204A 
     7236 834A 
0202 7238 C820  54         mov   @>204C,@>834C
     723A 204C 
     723C 834C 
0203 723E C820  54         mov   @>204E,@>834E
     7240 204E 
     7242 834E 
0204 7244 C820  54         mov   @>2050,@>8350
     7246 2050 
     7248 8350 
0205 724A C820  54         mov   @>2052,@>8352
     724C 2052 
     724E 8352 
0206 7250 C820  54         mov   @>2054,@>8354
     7252 2054 
     7254 8354 
0207 7256 C820  54         mov   @>2056,@>8356
     7258 2056 
     725A 8356 
0208 725C C820  54         mov   @>2058,@>8358
     725E 2058 
     7260 8358 
0209 7262 C820  54         mov   @>205A,@>835A
     7264 205A 
     7266 835A 
0210 7268 C820  54         mov   @>205C,@>835C
     726A 205C 
     726C 835C 
0211 726E C820  54         mov   @>205E,@>835E
     7270 205E 
     7272 835E 
0212 7274 C820  54         mov   @>2060,@>8360
     7276 2060 
     7278 8360 
0213 727A C820  54         mov   @>2062,@>8362
     727C 2062 
     727E 8362 
0214 7280 C820  54         mov   @>2064,@>8364
     7282 2064 
     7284 8364 
0215 7286 C820  54         mov   @>2066,@>8366
     7288 2066 
     728A 8366 
0216 728C C820  54         mov   @>2068,@>8368
     728E 2068 
     7290 8368 
0217 7292 C820  54         mov   @>206A,@>836A
     7294 206A 
     7296 836A 
0218 7298 C820  54         mov   @>206C,@>836C
     729A 206C 
     729C 836C 
0219 729E C820  54         mov   @>206E,@>836E
     72A0 206E 
     72A2 836E 
0220 72A4 C820  54         mov   @>2070,@>8370
     72A6 2070 
     72A8 8370 
0221 72AA C820  54         mov   @>2072,@>8372
     72AC 2072 
     72AE 8372 
0222 72B0 C820  54         mov   @>2074,@>8374
     72B2 2074 
     72B4 8374 
0223 72B6 C820  54         mov   @>2076,@>8376
     72B8 2076 
     72BA 8376 
0224 72BC C820  54         mov   @>2078,@>8378
     72BE 2078 
     72C0 8378 
0225 72C2 C820  54         mov   @>207A,@>837A
     72C4 207A 
     72C6 837A 
0226 72C8 C820  54         mov   @>207C,@>837C
     72CA 207C 
     72CC 837C 
0227 72CE C820  54         mov   @>207E,@>837E
     72D0 207E 
     72D2 837E 
0228 72D4 C820  54         mov   @>2080,@>8380
     72D6 2080 
     72D8 8380 
0229 72DA C820  54         mov   @>2082,@>8382
     72DC 2082 
     72DE 8382 
0230 72E0 C820  54         mov   @>2084,@>8384
     72E2 2084 
     72E4 8384 
0231 72E6 C820  54         mov   @>2086,@>8386
     72E8 2086 
     72EA 8386 
0232 72EC C820  54         mov   @>2088,@>8388
     72EE 2088 
     72F0 8388 
0233 72F2 C820  54         mov   @>208A,@>838A
     72F4 208A 
     72F6 838A 
0234 72F8 C820  54         mov   @>208C,@>838C
     72FA 208C 
     72FC 838C 
0235 72FE C820  54         mov   @>208E,@>838E
     7300 208E 
     7302 838E 
0236 7304 C820  54         mov   @>2090,@>8390
     7306 2090 
     7308 8390 
0237 730A C820  54         mov   @>2092,@>8392
     730C 2092 
     730E 8392 
0238 7310 C820  54         mov   @>2094,@>8394
     7312 2094 
     7314 8394 
0239 7316 C820  54         mov   @>2096,@>8396
     7318 2096 
     731A 8396 
0240 731C C820  54         mov   @>2098,@>8398
     731E 2098 
     7320 8398 
0241 7322 C820  54         mov   @>209A,@>839A
     7324 209A 
     7326 839A 
0242 7328 C820  54         mov   @>209C,@>839C
     732A 209C 
     732C 839C 
0243 732E C820  54         mov   @>209E,@>839E
     7330 209E 
     7332 839E 
0244 7334 C820  54         mov   @>20A0,@>83A0
     7336 20A0 
     7338 83A0 
0245 733A C820  54         mov   @>20A2,@>83A2
     733C 20A2 
     733E 83A2 
0246 7340 C820  54         mov   @>20A4,@>83A4
     7342 20A4 
     7344 83A4 
0247 7346 C820  54         mov   @>20A6,@>83A6
     7348 20A6 
     734A 83A6 
0248 734C C820  54         mov   @>20A8,@>83A8
     734E 20A8 
     7350 83A8 
0249 7352 C820  54         mov   @>20AA,@>83AA
     7354 20AA 
     7356 83AA 
0250 7358 C820  54         mov   @>20AC,@>83AC
     735A 20AC 
     735C 83AC 
0251 735E C820  54         mov   @>20AE,@>83AE
     7360 20AE 
     7362 83AE 
0252 7364 C820  54         mov   @>20B0,@>83B0
     7366 20B0 
     7368 83B0 
0253 736A C820  54         mov   @>20B2,@>83B2
     736C 20B2 
     736E 83B2 
0254 7370 C820  54         mov   @>20B4,@>83B4
     7372 20B4 
     7374 83B4 
0255 7376 C820  54         mov   @>20B6,@>83B6
     7378 20B6 
     737A 83B6 
0256 737C C820  54         mov   @>20B8,@>83B8
     737E 20B8 
     7380 83B8 
0257 7382 C820  54         mov   @>20BA,@>83BA
     7384 20BA 
     7386 83BA 
0258 7388 C820  54         mov   @>20BC,@>83BC
     738A 20BC 
     738C 83BC 
0259 738E C820  54         mov   @>20BE,@>83BE
     7390 20BE 
     7392 83BE 
0260 7394 C820  54         mov   @>20C0,@>83C0
     7396 20C0 
     7398 83C0 
0261 739A C820  54         mov   @>20C2,@>83C2
     739C 20C2 
     739E 83C2 
0262 73A0 C820  54         mov   @>20C4,@>83C4
     73A2 20C4 
     73A4 83C4 
0263 73A6 C820  54         mov   @>20C6,@>83C6
     73A8 20C6 
     73AA 83C6 
0264 73AC C820  54         mov   @>20C8,@>83C8
     73AE 20C8 
     73B0 83C8 
0265 73B2 C820  54         mov   @>20CA,@>83CA
     73B4 20CA 
     73B6 83CA 
0266 73B8 C820  54         mov   @>20CC,@>83CC
     73BA 20CC 
     73BC 83CC 
0267 73BE C820  54         mov   @>20CE,@>83CE
     73C0 20CE 
     73C2 83CE 
0268 73C4 C820  54         mov   @>20D0,@>83D0
     73C6 20D0 
     73C8 83D0 
0269 73CA C820  54         mov   @>20D2,@>83D2
     73CC 20D2 
     73CE 83D2 
0270 73D0 C820  54         mov   @>20D4,@>83D4
     73D2 20D4 
     73D4 83D4 
0271 73D6 C820  54         mov   @>20D6,@>83D6
     73D8 20D6 
     73DA 83D6 
0272 73DC C820  54         mov   @>20D8,@>83D8
     73DE 20D8 
     73E0 83D8 
0273 73E2 C820  54         mov   @>20DA,@>83DA
     73E4 20DA 
     73E6 83DA 
0274 73E8 C820  54         mov   @>20DC,@>83DC
     73EA 20DC 
     73EC 83DC 
0275 73EE C820  54         mov   @>20DE,@>83DE
     73F0 20DE 
     73F2 83DE 
0276 73F4 C820  54         mov   @>20E0,@>83E0
     73F6 20E0 
     73F8 83E0 
0277 73FA C820  54         mov   @>20E2,@>83E2
     73FC 20E2 
     73FE 83E2 
0278 7400 C820  54         mov   @>20E4,@>83E4
     7402 20E4 
     7404 83E4 
0279 7406 C820  54         mov   @>20E6,@>83E6
     7408 20E6 
     740A 83E6 
0280 740C C820  54         mov   @>20E8,@>83E8
     740E 20E8 
     7410 83E8 
0281 7412 C820  54         mov   @>20EA,@>83EA
     7414 20EA 
     7416 83EA 
0282 7418 C820  54         mov   @>20EC,@>83EC
     741A 20EC 
     741C 83EC 
0283 741E C820  54         mov   @>20EE,@>83EE
     7420 20EE 
     7422 83EE 
0284 7424 C820  54         mov   @>20F0,@>83F0
     7426 20F0 
     7428 83F0 
0285 742A C820  54         mov   @>20F2,@>83F2
     742C 20F2 
     742E 83F2 
0286 7430 C820  54         mov   @>20F4,@>83F4
     7432 20F4 
     7434 83F4 
0287 7436 C820  54         mov   @>20F6,@>83F6
     7438 20F6 
     743A 83F6 
0288 743C C820  54         mov   @>20F8,@>83F8
     743E 20F8 
     7440 83F8 
0289 7442 C820  54         mov   @>20FA,@>83FA
     7444 20FA 
     7446 83FA 
0290 7448 C820  54         mov   @>20FC,@>83FC
     744A 20FC 
     744C 83FC 
0291 744E C820  54         mov   @>20FE,@>83FE
     7450 20FE 
     7452 83FE 
0292 7454 045B  20         b     *r11                  ; Return to caller
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
0010               * cpu.scrpad.pgout - Page out scratchpad memory
0011               ***************************************************************
0012               *  bl   @cpu.scrpad.pgout
0013               *  DATA p0
0014               *  P0 = CPU memory destination
0015               *--------------------------------------------------------------
0016               *  bl   @memx.scrpad.pgout
0017               *  TMP1 = CPU memory destination
0018               *--------------------------------------------------------------
0019               *  Register usage
0020               *  tmp0-tmp2 = Used as temporary registers
0021               *  tmp3      = Copy of CPU memory destination
0022               ********|*****|*********************|**************************
0023               cpu.scrpad.pgout:
0024 7456 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xcpu.scrpad.pgout:
0029 7458 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     745A 8300 
0030 745C C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 745E 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     7460 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 7462 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 7464 0606  14         dec   tmp2
0037 7466 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 7468 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 746A 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     746C 7472 
0043                                                   ; R14=PC
0044 746E 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 7470 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               cpu.scrpad.pgout.after.rtwp:
0054 7472 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     7474 7154 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cpu.scrpad.pgout.$$:
0060 7476 045B  20         b     *r11                  ; Return to caller
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
0037               ********|*****|*********************|**************************
0038 7478 B000     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0039 747A 747C             data  dsrlnk.init           ; entry point
0040                       ;------------------------------------------------------
0041                       ; DSRLNK entry point
0042                       ;------------------------------------------------------
0043               dsrlnk.init:
0044 747C C17E  30         mov   *r14+,r5              ; get pgm type for link
0045 747E C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     7480 8322 
0046 7482 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     7484 6046 
0047 7486 C020  34         mov   @>8356,r0             ; get ptr to pab
     7488 8356 
0048 748A C240  18         mov   r0,r9                 ; save ptr
0049                       ;------------------------------------------------------
0050                       ; Fetch file descriptor length from PAB
0051                       ;------------------------------------------------------
0052 748C 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     748E FFF8 
0053               
0054                       ;---------------------------; Inline VSBR start
0055 7490 06C0  14         swpb  r0                    ;
0056 7492 D800  38         movb  r0,@vdpa              ; send low byte
     7494 8C02 
0057 7496 06C0  14         swpb  r0                    ;
0058 7498 D800  38         movb  r0,@vdpa              ; send high byte
     749A 8C02 
0059 749C D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     749E 8800 
0060                       ;---------------------------; Inline VSBR end
0061 74A0 0983  56         srl   r3,8                  ; Move to low byte
0062               
0063                       ;------------------------------------------------------
0064                       ; Fetch file descriptor device name from PAB
0065                       ;------------------------------------------------------
0066 74A2 0704  14         seto  r4                    ; init counter
0067 74A4 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     74A6 2100 
0068 74A8 0580  14 !       inc   r0                    ; point to next char of name
0069 74AA 0584  14         inc   r4                    ; incr char counter
0070 74AC 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     74AE 0007 
0071 74B0 1565  14         jgt   dsrlnk.error.devicename_invalid
0072                                                   ; yes, error
0073 74B2 80C4  18         c     r4,r3                 ; end of name?
0074 74B4 130C  14         jeq   dsrlnk.device_name.get_length
0075                                                   ; yes
0076               
0077                       ;---------------------------; Inline VSBR start
0078 74B6 06C0  14         swpb  r0                    ;
0079 74B8 D800  38         movb  r0,@vdpa              ; send low byte
     74BA 8C02 
0080 74BC 06C0  14         swpb  r0                    ;
0081 74BE D800  38         movb  r0,@vdpa              ; send high byte
     74C0 8C02 
0082 74C2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     74C4 8800 
0083                       ;---------------------------; Inline VSBR end
0084               
0085                       ;------------------------------------------------------
0086                       ; Look for end of device name, for example "DSK1."
0087                       ;------------------------------------------------------
0088 74C6 DC81  32         movb  r1,*r2+               ; move into buffer
0089 74C8 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     74CA 758C 
0090 74CC 16ED  14         jne   -!                    ; no, loop next char
0091                       ;------------------------------------------------------
0092                       ; Determine device name length
0093                       ;------------------------------------------------------
0094               dsrlnk.device_name.get_length:
0095 74CE C104  18         mov   r4,r4                 ; Check if length = 0
0096 74D0 1355  14         jeq   dsrlnk.error.devicename_invalid
0097                                                   ; yes, error
0098 74D2 04E0  34         clr   @>83d0
     74D4 83D0 
0099 74D6 C804  38         mov   r4,@>8354             ; save name length for search
     74D8 8354 
0100 74DA 0584  14         inc   r4                    ; adjust for dot
0101 74DC A804  38         a     r4,@>8356             ; point to position after name
     74DE 8356 
0102                       ;------------------------------------------------------
0103                       ; Prepare for DSR scan >1000 - >1f00
0104                       ;------------------------------------------------------
0105               dsrlnk.dsrscan.start:
0106 74E0 02E0  18         lwpi  >83e0                 ; Use GPL WS
     74E2 83E0 
0107 74E4 04C1  14         clr   r1                    ; version found of dsr
0108 74E6 020C  20         li    r12,>0f00             ; init cru addr
     74E8 0F00 
0109                       ;------------------------------------------------------
0110                       ; Turn off ROM on current card
0111                       ;------------------------------------------------------
0112               dsrlnk.dsrscan.cardoff:
0113 74EA C30C  18         mov   r12,r12               ; anything to turn off?
0114 74EC 1301  14         jeq   dsrlnk.dsrscan.cardloop
0115                                                   ; no, loop over cards
0116 74EE 1E00  20         sbz   0                     ; yes, turn off
0117                       ;------------------------------------------------------
0118                       ; Loop over cards and look if DSR present
0119                       ;------------------------------------------------------
0120               dsrlnk.dsrscan.cardloop:
0121 74F0 022C  22         ai    r12,>0100             ; next rom to turn on
     74F2 0100 
0122 74F4 04E0  34         clr   @>83d0                ; clear in case we are done
     74F6 83D0 
0123 74F8 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     74FA 2000 
0124 74FC 133D  14         jeq   dsrlnk.error.nodsr_found
0125                                                   ; yes, no matching DSR found
0126 74FE C80C  38         mov   r12,@>83d0            ; save addr of next cru
     7500 83D0 
0127                       ;------------------------------------------------------
0128                       ; Look at card ROM (@>4000 eq 'AA' ?)
0129                       ;------------------------------------------------------
0130 7502 1D00  20         sbo   0                     ; turn on rom
0131 7504 0202  20         li    r2,>4000              ; start at beginning of rom
     7506 4000 
0132 7508 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     750A 7588 
0133 750C 16EE  14         jne   dsrlnk.dsrscan.cardoff
0134                                                   ; no rom found on card
0135                       ;------------------------------------------------------
0136                       ; Valid DSR ROM found. Now loop over chain/subprograms
0137                       ;------------------------------------------------------
0138                       ; dstype is the address of R5 of the DSRLNK workspace,
0139                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0140                       ; is stored before the DSR ROM is searched.
0141                       ;------------------------------------------------------
0142 750E A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     7510 B00A 
0143 7512 1003  14         jmp   dsrlnk.dsrscan.getentry
0144                       ;------------------------------------------------------
0145                       ; Next DSR entry
0146                       ;------------------------------------------------------
0147               dsrlnk.dsrscan.nextentry:
0148 7514 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     7516 83D2 
0149 7518 1D00  20         sbo   0                     ; turn rom back on
0150                       ;------------------------------------------------------
0151                       ; Get DSR entry
0152                       ;------------------------------------------------------
0153               dsrlnk.dsrscan.getentry:
0154 751A C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0155 751C 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0156                                                   ; yes, no more DSRs or programs to check
0157 751E C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     7520 83D2 
0158 7522 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0159 7524 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0160                       ;------------------------------------------------------
0161                       ; Check file descriptor in DSR
0162                       ;------------------------------------------------------
0163 7526 04C5  14         clr   r5                    ; Remove any old stuff
0164 7528 D160  34         movb  @>8355,r5             ; get length as counter
     752A 8355 
0165 752C 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0166                                                   ; if zero, do not further check, call DSR program
0167 752E 9C85  32         cb    r5,*r2+               ; see if length matches
0168 7530 16F1  14         jne   dsrlnk.dsrscan.nextentry
0169                                                   ; no, length does not match. Go process next DSR entry
0170 7532 0985  56         srl   r5,8                  ; yes, move to low byte
0171 7534 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     7536 2100 
0172 7538 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0173 753A 16EC  14         jne   dsrlnk.dsrscan.nextentry
0174                                                   ; try next DSR entry if no match
0175 753C 0605  14         dec   r5                    ; loop until full length checked
0176 753E 16FC  14         jne   -!
0177                       ;------------------------------------------------------
0178                       ; Device name/Subprogram match
0179                       ;------------------------------------------------------
0180               dsrlnk.dsrscan.match:
0181 7540 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     7542 83D2 
0182               
0183                       ;------------------------------------------------------
0184                       ; Call DSR program in device card
0185                       ;------------------------------------------------------
0186               dsrlnk.dsrscan.call_dsr:
0187 7544 0581  14         inc   r1                    ; next version found
0188 7546 0699  24         bl    *r9                   ; go run routine
0189                       ;
0190                       ; Depending on IO result the DSR in card ROM does RET
0191                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0192                       ;
0193 7548 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0194                                                   ; (1) error return
0195 754A 1E00  20         sbz   0                     ; (2) turn off rom if good return
0196 754C 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     754E B000 
0197 7550 C009  18         mov   r9,r0                 ; point to flag in pab
0198 7552 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     7554 8322 
0199                                                   ; (8 or >a)
0200 7556 0281  22         ci    r1,8                  ; was it 8?
     7558 0008 
0201 755A 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0202 755C D060  34         movb  @>8350,r1             ; no, we have a data >a.
     755E 8350 
0203                                                   ; Get error byte from @>8350
0204 7560 1000  14         jmp   dsrlnk.dsrscan.dsr.8  ; go and return error byte to the caller
0205               
0206                       ;------------------------------------------------------
0207                       ; Read PAB status flag after DSR call completed
0208                       ;------------------------------------------------------
0209               dsrlnk.dsrscan.dsr.8:
0210                       ;---------------------------; Inline VSBR start
0211 7562 06C0  14         swpb  r0                    ;
0212 7564 D800  38         movb  r0,@vdpa              ; send low byte
     7566 8C02 
0213 7568 06C0  14         swpb  r0                    ;
0214 756A D800  38         movb  r0,@vdpa              ; send high byte
     756C 8C02 
0215 756E D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     7570 8800 
0216                       ;---------------------------; Inline VSBR end
0217               
0218                       ;------------------------------------------------------
0219                       ; Return DSR error to caller
0220                       ;------------------------------------------------------
0221               dsrlnk.dsrscan.dsr.a:
0222 7572 09D1  56         srl   r1,13                 ; just keep error bits
0223 7574 1604  14         jne   dsrlnk.error.io_error
0224                                                   ; handle IO error
0225 7576 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0226               
0227                       ;------------------------------------------------------
0228                       ; IO-error handler
0229                       ;------------------------------------------------------
0230               dsrlnk.error.nodsr_found:
0231 7578 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     757A B000 
0232               dsrlnk.error.devicename_invalid:
0233 757C 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0234               dsrlnk.error.io_error:
0235 757E 06C1  14         swpb  r1                    ; put error in hi byte
0236 7580 D741  30         movb  r1,*r13               ; store error flags in callers r0
0237 7582 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     7584 6046 
0238 7586 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0239               
0240               ****************************************************************************************
0241               
0242 7588 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0243 758A 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0244 758C ....     dsrlnk.period     text  '.'         ; For finding end of device name
0245                       even
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
0019               ********|*****|*********************|**************************
0020 758E 0300  24 tmgr    limi  0                     ; No interrupt processing
     7590 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 7592 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     7594 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 7596 2360  38         coc   @wbit2,r13            ; C flag on ?
     7598 6046 
0029 759A 1602  14         jne   tmgr1a                ; No, so move on
0030 759C E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     759E 6032 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 75A0 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     75A2 604A 
0035 75A4 1316  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0040 75A6 20A0  38         coc   @wbit3,config         ; Speech player on ?
     75A8 6044 
0041 75AA 1602  14         jne   tmgr2
0042 75AC 06A0  32         bl    @sppla1               ; Run speech player
     75AE 684A 
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 75B0 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     75B2 603A 
0048 75B4 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 75B6 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     75B8 6038 
0050 75BA 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 75BC 0460  28         b     @kthread              ; Run kernel thread
     75BE 7636 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 75C0 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     75C2 603E 
0056 75C4 13E6  14         jeq   tmgr1
0057 75C6 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     75C8 603C 
0058 75CA 16E3  14         jne   tmgr1
0059 75CC C120  34         mov   @wtiusr,tmp0
     75CE 832E 
0060 75D0 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 75D2 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     75D4 7634 
0065 75D6 C10A  18         mov   r10,tmp0
0066 75D8 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     75DA 00FF 
0067 75DC 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     75DE 6046 
0068 75E0 1303  14         jeq   tmgr5
0069 75E2 0284  22         ci    tmp0,60               ; 1 second reached ?
     75E4 003C 
0070 75E6 1002  14         jmp   tmgr6
0071 75E8 0284  22 tmgr5   ci    tmp0,50
     75EA 0032 
0072 75EC 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 75EE 1001  14         jmp   tmgr8
0074 75F0 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 75F2 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     75F4 832C 
0079 75F6 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     75F8 FF00 
0080 75FA C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 75FC 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 75FE 05C4  14         inct  tmp0                  ; Second word of slot data
0086 7600 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 7602 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 7604 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     7606 830C 
     7608 830D 
0089 760A 1608  14         jne   tmgr10                ; No, get next slot
0090 760C 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     760E FF00 
0091 7610 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 7612 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     7614 8330 
0096 7616 0697  24         bl    *tmp3                 ; Call routine in slot
0097 7618 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     761A 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 761C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 761E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     7620 8315 
     7622 8314 
0103 7624 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 7626 05C4  14         inct  tmp0                  ; Offset for next slot
0105 7628 10E8  14         jmp   tmgr9                 ; Process next slot
0106 762A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 762C 10F7  14         jmp   tmgr10                ; Process next slot
0108 762E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     7630 FF00 
0109 7632 10AF  14         jmp   tmgr1
0110 7634 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0014               ********|*****|*********************|**************************
0015 7636 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     7638 603A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 763A 20A0  38         coc   @wbit13,config        ; Sound player on ?
     763C 6030 
0023 763E 1602  14         jne   kthread_kb
0024 7640 06A0  32         bl    @sdpla1               ; Run sound player
     7642 675A 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 7644 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     7646 68AC 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 7648 06A0  32         bl    @realkb               ; Scan full keyboard
     764A 699C 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 764C 0460  28         b     @tmgr3                ; Exit
     764E 75C0 
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
0016               ********|*****|*********************|**************************
0017 7650 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     7652 832E 
0018 7654 E0A0  34         soc   @wbit7,config         ; Enable user hook
     7656 603C 
0019 7658 045B  20 mkhoo1  b     *r11                  ; Return
0020      7592     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 765A 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     765C 832E 
0029 765E 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     7660 FEFF 
0030 7662 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0211               
0213                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
**** **** ****     > timers_alloc.asm
0001               * FILE......: timer_alloc.asm
0002               * Purpose...: Timers / Timer allocation
0003               
0004               
0005               ***************************************************************
0006               * MKSLOT - Allocate timer slot(s)
0007               ***************************************************************
0008               *  BL    @MKSLOT
0009               *  BYTE  P0HB,P0LB
0010               *  DATA  P1
0011               *  ....
0012               *  DATA  EOL                        ; End-of-list
0013               *--------------------------------------------------------------
0014               *  P0 = Slot number, target count
0015               *  P1 = Subroutine to call via BL @xxxx if slot is fired
0016               ********|*****|*********************|**************************
0017 7664 C13B  30 mkslot  mov   *r11+,tmp0
0018 7666 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 7668 C184  18         mov   tmp0,tmp2
0023 766A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 766C A1A0  34         a     @wtitab,tmp2          ; Add table base
     766E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 7670 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 7672 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7674 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7676 881B  46         c     *r11,@w$ffff          ; End of list ?
     7678 604C 
0035 767A 1301  14         jeq   mkslo1                ; Yes, exit
0036 767C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 767E 05CB  14 mkslo1  inct  r11
0041 7680 045B  20         b     *r11                  ; Exit
0042               
0043               
0044               ***************************************************************
0045               * CLSLOT - Clear single timer slot
0046               ***************************************************************
0047               *  BL    @CLSLOT
0048               *  DATA  P0
0049               *--------------------------------------------------------------
0050               *  P0 = Slot number
0051               ********|*****|*********************|**************************
0052 7682 C13B  30 clslot  mov   *r11+,tmp0
0053 7684 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7686 A120  34         a     @wtitab,tmp0          ; Add table base
     7688 832C 
0055 768A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 768C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 768E 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
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
0231               ********|*****|*********************|**************************
0233 7690 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     7692 6E52 
0234 7694 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7696 8302 
0238               *--------------------------------------------------------------
0239               * Alternative entry point
0240               *--------------------------------------------------------------
0241 7698 0300  24 runli1  limi  0                     ; Turn off interrupts
     769A 0000 
0242 769C 02E0  18         lwpi  ws1                   ; Activate workspace 1
     769E 8300 
0243 76A0 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     76A2 83C0 
0244               *--------------------------------------------------------------
0245               * Clear scratch-pad memory from R4 upwards
0246               *--------------------------------------------------------------
0247 76A4 0202  20 runli2  li    r2,>8308
     76A6 8308 
0248 76A8 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0249 76AA 0282  22         ci    r2,>8400
     76AC 8400 
0250 76AE 16FC  14         jne   runli3
0251               *--------------------------------------------------------------
0252               * Exit to TI-99/4A title screen ?
0253               *--------------------------------------------------------------
0254 76B0 0281  22         ci    r1,>ffff              ; Exit flag set ?
     76B2 FFFF 
0255 76B4 1602  14         jne   runli4                ; No, continue
0256 76B6 0420  54         blwp  @0                    ; Yes, bye bye
     76B8 0000 
0257               *--------------------------------------------------------------
0258               * Determine if VDP is PAL or NTSC
0259               *--------------------------------------------------------------
0260 76BA C803  38 runli4  mov   r3,@waux1             ; Store random seed
     76BC 833C 
0261 76BE 04C1  14         clr   r1                    ; Reset counter
0262 76C0 0202  20         li    r2,10                 ; We test 10 times
     76C2 000A 
0263 76C4 C0E0  34 runli5  mov   @vdps,r3
     76C6 8802 
0264 76C8 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     76CA 604A 
0265 76CC 1302  14         jeq   runli6
0266 76CE 0581  14         inc   r1                    ; Increase counter
0267 76D0 10F9  14         jmp   runli5
0268 76D2 0602  14 runli6  dec   r2                    ; Next test
0269 76D4 16F7  14         jne   runli5
0270 76D6 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     76D8 1250 
0271 76DA 1202  14         jle   runli7                ; No, so it must be NTSC
0272 76DC 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     76DE 6046 
0273               *--------------------------------------------------------------
0274               * Copy machine code to scratchpad (prepare tight loop)
0275               *--------------------------------------------------------------
0276 76E0 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     76E2 607C 
0277 76E4 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     76E6 8322 
0278 76E8 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0279 76EA CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0280 76EC CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0281               *--------------------------------------------------------------
0282               * Initialize registers, memory, ...
0283               *--------------------------------------------------------------
0284 76EE 04C1  14 runli9  clr   r1
0285 76F0 04C2  14         clr   r2
0286 76F2 04C3  14         clr   r3
0287 76F4 0209  20         li    stack,>8400           ; Set stack
     76F6 8400 
0288 76F8 020F  20         li    r15,vdpw              ; Set VDP write address
     76FA 8C00 
0290 76FC 06A0  32         bl    @mute                 ; Mute sound generators
     76FE 671E 
0292               *--------------------------------------------------------------
0293               * Setup video memory
0294               *--------------------------------------------------------------
0296 7700 06A0  32         bl    @filv                 ; Clear most part of 16K VDP memory,
     7702 60B6 
0297 7704 0000             data  >0000,>00,>3fd8       ; Keep memory for 3 VDP disk buffers (>3fd8 - >3ff)
     7706 0000 
     7708 3FD8 
0302 770A 06A0  32         bl    @filv
     770C 60B6 
0303 770E 0FC0             data  pctadr,spfclr,16      ; Load color table
     7710 00C1 
     7712 0010 
0304               *--------------------------------------------------------------
0305               * Check if there is a F18A present
0306               *--------------------------------------------------------------
0310 7714 06A0  32         bl    @f18unl               ; Unlock the F18A
     7716 6478 
0311 7718 06A0  32         bl    @f18chk               ; Check if F18A is there
     771A 6492 
0312 771C 06A0  32         bl    @f18lck               ; Lock the F18A again
     771E 6488 
0314               *--------------------------------------------------------------
0315               * Check if there is a speech synthesizer attached
0316               *--------------------------------------------------------------
0320 7720 06A0  32         bl    @spconn
     7722 6800 
0322               *--------------------------------------------------------------
0323               * Load video mode table & font
0324               *--------------------------------------------------------------
0325 7724 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     7726 6110 
0326 7728 6072             data  spvmod                ; Equate selected video mode table
0327 772A 0204  20         li    tmp0,spfont           ; Get font option
     772C 000C 
0328 772E 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0329 7730 1304  14         jeq   runlid                ; Yes, skip it
0330 7732 06A0  32         bl    @ldfnt
     7734 6178 
0331 7736 1100             data  fntadr,spfont         ; Load specified font
     7738 000C 
0332               *--------------------------------------------------------------
0333               * Branch to main program
0334               *--------------------------------------------------------------
0335 773A 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     773C 0040 
0336 773E 0460  28         b     @main                 ; Give control to main program
     7740 7742 
**** **** ****     > hello_world.asm.31024
0071               *--------------------------------------------------------------
0072               * SPECTRA2 startup options
0073               *--------------------------------------------------------------
0074      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0075      0001     spfbck  equ   >01                   ; Screen background color.
0076               ;--------------------------------------------------------------
0077               ; Video mode configuration
0078               ;--------------------------------------------------------------
0079      6072     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0080      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0081      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0082      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0083               
0084               ***************************************************************
0085               * Main
0086               ********|*****|*********************|**************************
0087 7742 06A0  32 main    bl    @putat
     7744 6248 
0088 7746 081F             data  >081f,hello_world
     7748 774E 
0089               
0090 774A 0460  28         b     @tmgr                 ;
     774C 758E 
0091               
0092               
0093               hello_world:
0094               
0095 774E 0C48             byte  12
0096 774F ....             text  'Hello World!'
0097                       even
0098               
