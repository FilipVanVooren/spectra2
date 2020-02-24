XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > hello_world.asm.10219
0001               ***************************************************************
0002               *
0003               *                          Hello World
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: hello_world.asm             ; Version 200224-10219
0009               *--------------------------------------------------------------
0010               * TI-99/4a DSR scan utility
0011               *--------------------------------------------------------------
0012               * 2018-11-01   Development started
0013               ********|*****|*********************|**************************
0014                       aorg  >6000
0015                       bank  0
0016                       save  >6000,>7fff
0017               *--------------------------------------------------------------
0018               *debug                  equ  1      ; Turn on debugging
0019               ;--------------------------------------------------------------
0020               ; Equates for spectra2 DSRLNK
0021               ;--------------------------------------------------------------
0022      B000     dsrlnk.dsrlws             equ >b000 ; Address of dsrlnk workspace
0023      2100     dsrlnk.namsto             equ >2100 ; 8-byte RAM buffer for storing device name
0024      0001     startup_backup_scrpad     equ  1    ; Backup scratchpad @>8300:>83ff to @>2000
0025      0001     startup_keep_vdpdiskbuf   equ  1    ; Keep VDP memory reserved for 3 VDP disk buffers
0026      270F     file.pab.ptr              equ  9999
0027               *--------------------------------------------------------------
0028               * Cartridge header
0029               *--------------------------------------------------------------
0030 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0031 6006 6010             data  prog0
0032 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0033 6010 0000     prog0   data  0                     ; No more items following
0034 6012 7604             data  runlib
0042               
0043 6014 0B48             byte  11
0044 6015 ....             text  'HELLO WORLD'
0045                       even
0046               
0048               *--------------------------------------------------------------
0049               * Include required files
0050               *--------------------------------------------------------------
0051                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *
0007               *                TMS9900 Monitor with Arcade Game support
0008               *                                  for
0009               *              the Texas Instruments TI-99/4A Home Computer
0010               *
0011               *                      2010-2020 by Filip Van Vooren
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
0027               * skip_sams                 equ  1  ; Skip CPU support for SAMS memory expansion
0028               *
0029               * == VDP
0030               * skip_textmode_support     equ  1  ; Skip 40x24 textmode support
0031               * skip_vdp_f18a_support     equ  1  ; Skip f18a support
0032               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0033               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0034               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0035               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0036               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0037               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0038               * skip_vdp_viewport         equ  1  ; Skip viewport functions
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
0055               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0056               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0057               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0058               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0059               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0060               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0061               *
0062               * == Kernel/Multitasking
0063               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0064               * skip_mem_paging           equ  1  ; Skip support for memory paging
0065               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0066               *
0067               * == Startup behaviour
0068               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0069               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0070               *******************************************************************************
0071               
0072               *//////////////////////////////////////////////////////////////
0073               *                       RUNLIB SETUP
0074               *//////////////////////////////////////////////////////////////
0075               
0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
**** **** ****     > equ_memsetup.asm
0001               * FILE......: memsetup.asm
0002               * Purpose...: Equates for spectra2 memory layout
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
0077                       copy  "equ_registers.asm"        ; Equates runlib registers
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
0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
**** **** ****     > equ_portaddr.asm
0001               * FILE......: portaddr.asm
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
0079                       copy  "equ_param.asm"            ; Equates runlib parameters
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
0080               
0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
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
0084               
0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
**** **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               ---------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 602A 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 602C 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 602E 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 6030 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 6032 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 6034 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 6036 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 6038 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 603A 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 603C 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 603E 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 6040 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 6042 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 6044 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 6046 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 6048 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 604A 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 604C FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 604E D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      602A     hb$00   equ   w$0000                ; >0000
0035      603C     hb$01   equ   w$0100                ; >0100
0036      603E     hb$02   equ   w$0200                ; >0200
0037      6040     hb$04   equ   w$0400                ; >0400
0038      6042     hb$08   equ   w$0800                ; >0800
0039      6044     hb$10   equ   w$1000                ; >1000
0040      6046     hb$20   equ   w$2000                ; >2000
0041      6048     hb$40   equ   w$4000                ; >4000
0042      604A     hb$80   equ   w$8000                ; >8000
0043      604E     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      602A     lb$00   equ   w$0000                ; >0000
0048      602C     lb$01   equ   w$0001                ; >0001
0049      602E     lb$02   equ   w$0002                ; >0002
0050      6030     lb$04   equ   w$0004                ; >0004
0051      6032     lb$08   equ   w$0008                ; >0008
0052      6034     lb$10   equ   w$0010                ; >0010
0053      6036     lb$20   equ   w$0020                ; >0020
0054      6038     lb$40   equ   w$0040                ; >0040
0055      603A     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      602C     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      602E     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      6030     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      6032     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      6034     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      6036     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      6038     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      603A     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      603C     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      603E     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      6040     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      6042     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      6044     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      6046     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      6048     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      604A     wbit0   equ   w$8000                ; >8000 1000000000000000
**** **** ****     > runlib.asm
0086                       copy  "equ_config.asm"           ; Equates for bits in config register
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
0026               ********|*****|*********************|**************************
0027      6046     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      603C     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6038     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6034     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
0032               
**** **** ****     > runlib.asm
0087                       copy  "cpu_crash.asm"            ; CPU crash handler
**** **** ****     > cpu_crash.asm
0001               * FILE......: cpu_crash.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               ***************************************************************
0006               * cpu.crash - CPU program crashed handler
0007               ***************************************************************
0008               *  bl   @cpu.crash
0009               *--------------------------------------------------------------
0010               * Crash and halt system. Upon crash entry register contents are
0011               * copied to the memory region >ffe0 - >fffe and displayed after
0012               * resetting the spectra2 runtime library, video modes, etc.
0013               *
0014               * Diagnostics
0015               * >ffce  caller address
0016               *
0017               * Register contents
0018               * >ffdc  wp
0019               * >ffde  st
0020               * >ffe0  r0
0021               * >ffe2  r1
0022               * >ffe4  r2  (config)
0023               * >ffe6  r3
0024               * >ffe8  r4  (tmp0)
0025               * >ffea  r5  (tmp1)
0026               * >ffec  r6  (tmp2)
0027               * >ffee  r7  (tmp3)
0028               * >fff0  r8  (tmp4)
0029               * >fff2  r9  (stack)
0030               * >fff4  r10
0031               * >fff6  r11
0032               * >fff8  r12
0033               * >fffa  r13
0034               * >fffc  r14
0035               * >fffe  r15
0036               ********|*****|*********************|**************************
0037               cpu.crash:
0038 6050 022B  22         ai    r11,-4                ; Remove opcode offset
     6052 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 6054 C800  38         mov   r0,@>ffe0
     6056 FFE0 
0043 6058 C801  38         mov   r1,@>ffe2
     605A FFE2 
0044 605C C802  38         mov   r2,@>ffe4
     605E FFE4 
0045 6060 C803  38         mov   r3,@>ffe6
     6062 FFE6 
0046 6064 C804  38         mov   r4,@>ffe8
     6066 FFE8 
0047 6068 C805  38         mov   r5,@>ffea
     606A FFEA 
0048 606C C806  38         mov   r6,@>ffec
     606E FFEC 
0049 6070 C807  38         mov   r7,@>ffee
     6072 FFEE 
0050 6074 C808  38         mov   r8,@>fff0
     6076 FFF0 
0051 6078 C809  38         mov   r9,@>fff2
     607A FFF2 
0052 607C C80A  38         mov   r10,@>fff4
     607E FFF4 
0053 6080 C80B  38         mov   r11,@>fff6
     6082 FFF6 
0054 6084 C80C  38         mov   r12,@>fff8
     6086 FFF8 
0055 6088 C80D  38         mov   r13,@>fffa
     608A FFFA 
0056 608C C80E  38         mov   r14,@>fffc
     608E FFFC 
0057 6090 C80F  38         mov   r15,@>ffff
     6092 FFFF 
0058 6094 02A0  12         stwp  r0
0059 6096 C800  38         mov   r0,@>ffdc
     6098 FFDC 
0060 609A 02C0  12         stst  r0
0061 609C C800  38         mov   r0,@>ffde
     609E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 60A0 02E0  18         lwpi  ws1                   ; Activate workspace 1
     60A2 8300 
0067 60A4 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     60A6 8302 
0068 60A8 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     60AA 4A4A 
0069 60AC 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60AE 760C 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 60B0 06A0  32         bl    @putat                ; Show crash message
     60B2 6434 
0078 60B4 0000                   data >0000,cpu.crash.msg.crashed
     60B6 618A 
0079               
0080 60B8 06A0  32         bl    @puthex               ; Put hex value on screen
     60BA 6E7A 
0081 60BC 0015                   byte 0,21             ; \ i  p0 = YX position
0082 60BE FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 60C0 8350                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 60C2 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 60C4 06A0  32         bl    @putat                ; Show caller message
     60C6 6434 
0090 60C8 0100                   data >0100,cpu.crash.msg.caller
     60CA 61A0 
0091               
0092 60CC 06A0  32         bl    @puthex               ; Put hex value on screen
     60CE 6E7A 
0093 60D0 0115                   byte 1,21             ; \ i  p0 = YX position
0094 60D2 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 60D4 8350                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 60D6 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 60D8 06A0  32         bl    @putat
     60DA 6434 
0102 60DC 0300                   byte 3,0
0103 60DE 61BA                   data cpu.crash.msg.wp
0104 60E0 06A0  32         bl    @putat
     60E2 6434 
0105 60E4 0400                   byte 4,0
0106 60E6 61C0                   data cpu.crash.msg.st
0107 60E8 06A0  32         bl    @putat
     60EA 6434 
0108 60EC 1600                   byte 22,0
0109 60EE 61C6                   data cpu.crash.msg.source
0110 60F0 06A0  32         bl    @putat
     60F2 6434 
0111 60F4 1700                   byte 23,0
0112 60F6 61E4                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 60F8 06A0  32         bl    @at                   ; Put cursor at YX
     60FA 66C6 
0117 60FC 0304                   byte 3,4              ; \ i p0 = YX position
0118                                                   ; /
0119               
0120 60FE 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     6100 FFDC 
0121 6102 04C6  14         clr   tmp2                  ; Loop counter
0122               
0123               cpu.crash.showreg:
0124 6104 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0125               
0126 6106 0649  14         dect  stack
0127 6108 C644  30         mov   tmp0,*stack           ; Push tmp0
0128 610A 0649  14         dect  stack
0129 610C C645  30         mov   tmp1,*stack           ; Push tmp1
0130 610E 0649  14         dect  stack
0131 6110 C646  30         mov   tmp2,*stack           ; Push tmp2
0132                       ;------------------------------------------------------
0133                       ; Display crash register number
0134                       ;------------------------------------------------------
0135               cpu.crash.showreg.label:
0136 6112 C046  18         mov   tmp2,r1               ; Save register number
0137 6114 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     6116 0001 
0138 6118 121C  14         jle   cpu.crash.showreg.content
0139                                                   ; Yes, skip
0140               
0141 611A 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0142 611C 06A0  32         bl    @mknum
     611E 6E84 
0143 6120 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 6122 8350                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 6124 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 6126 06A0  32         bl    @setx                 ; Set cursor X position
     6128 66DC 
0149 612A 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 612C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     612E 6422 
0153 6130 8350                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 6132 06A0  32         bl    @setx                 ; Set cursor X position
     6134 66DC 
0157 6136 0002                   data 2                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 6138 0281  22         ci    r1,10
     613A 000A 
0161 613C 1102  14         jlt   !
0162 613E 0620  34         dec   @wyx                  ; x=x-1
     6140 832A 
0163               
0164 6142 06A0  32 !       bl    @putstr
     6144 6422 
0165 6146 61B6                   data cpu.crash.msg.r
0166               
0167 6148 06A0  32         bl    @mknum
     614A 6E84 
0168 614C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 614E 8350                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 6150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 6152 06A0  32         bl    @mkhex                ; Convert hex word to string
     6154 6DF6 
0177 6156 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 6158 8350                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 615A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 615C 06A0  32         bl    @setx                 ; Set cursor X position
     615E 66DC 
0183 6160 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 6162 06A0  32         bl    @putstr
     6164 6422 
0187 6166 61B8                   data cpu.crash.msg.marker
0188               
0189 6168 06A0  32         bl    @setx                 ; Set cursor X position
     616A 66DC 
0190 616C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 616E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     6170 6422 
0194 6172 8350                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 6174 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 6176 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 6178 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 617A 06A0  32         bl    @down                 ; y=y+1
     617C 66CC 
0202               
0203 617E 0586  14         inc   tmp2
0204 6180 0286  22         ci    tmp2,17
     6182 0011 
0205 6184 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 6186 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     6188 7502 
0210               
0211               
0212               cpu.crash.msg.crashed
0213 618A 1553             byte  21
0214 618B ....             text  'System crashed near >'
0215                       even
0216               
0217               cpu.crash.msg.caller
0218 61A0 1543             byte  21
0219 61A1 ....             text  'Caller address near >'
0220                       even
0221               
0222               cpu.crash.msg.r
0223 61B6 0152             byte  1
0224 61B7 ....             text  'R'
0225                       even
0226               
0227               cpu.crash.msg.marker
0228 61B8 013E             byte  1
0229 61B9 ....             text  '>'
0230                       even
0231               
0232               cpu.crash.msg.wp
0233 61BA 042A             byte  4
0234 61BB ....             text  '**WP'
0235                       even
0236               
0237               cpu.crash.msg.st
0238 61C0 042A             byte  4
0239 61C1 ....             text  '**ST'
0240                       even
0241               
0242               cpu.crash.msg.source
0243 61C6 1D53             byte  29
0244 61C7 ....             text  'Source    hello_world.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 61E4 1642             byte  22
0249 61E5 ....             text  'Build-ID  200224-10219'
0250                       even
0251               
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 61FC 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     61FE 000E 
     6200 0106 
     6202 0201 
     6204 0020 
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
0032 6206 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6208 000E 
     620A 0106 
     620C 00C1 
     620E 0028 
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
0058 6210 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6212 003F 
     6214 0240 
     6216 03C1 
     6218 0050 
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
0084 621A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     621C 003F 
     621E 0240 
     6220 03C1 
     6222 0050 
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
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0099               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0100               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0101               * ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
0102               * ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
0103               * ; VDP#7 Set foreground/background color
0104               ***************************************************************
**** **** ****     > runlib.asm
0089                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 6224 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6226 16FD             data  >16fd                 ; |         jne   mcloop
0015 6228 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 622A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 622C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 622E C0F9  30 popr3   mov   *stack+,r3
0039 6230 C0B9  30 popr2   mov   *stack+,r2
0040 6232 C079  30 popr1   mov   *stack+,r1
0041 6234 C039  30 popr0   mov   *stack+,r0
0042 6236 C2F9  30 poprt   mov   *stack+,r11
0043 6238 045B  20         b     *r11
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
0067 623A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 623C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 623E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 6240 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 6242 1604  14         jne   filchk                ; No, continue checking
0075               
0076 6244 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6246 FFCE 
0077 6248 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     624A 6050 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 624C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     624E 830B 
     6250 830A 
0082               
0083 6252 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     6254 0001 
0084 6256 1602  14         jne   filchk2
0085 6258 DD05  32         movb  tmp1,*tmp0+
0086 625A 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 625C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     625E 0002 
0091 6260 1603  14         jne   filchk3
0092 6262 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 6264 DD05  32         movb  tmp1,*tmp0+
0094 6266 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 6268 C1C4  18 filchk3 mov   tmp0,tmp3
0099 626A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     626C 0001 
0100 626E 1605  14         jne   fil16b
0101 6270 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 6272 0606  14         dec   tmp2
0103 6274 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6276 0002 
0104 6278 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 627A C1C6  18 fil16b  mov   tmp2,tmp3
0109 627C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     627E 0001 
0110 6280 1301  14         jeq   dofill
0111 6282 0606  14         dec   tmp2                  ; Make TMP2 even
0112 6284 CD05  34 dofill  mov   tmp1,*tmp0+
0113 6286 0646  14         dect  tmp2
0114 6288 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 628A C1C7  18         mov   tmp3,tmp3
0119 628C 1301  14         jeq   fil.$$
0120 628E DD05  32         movb  tmp1,*tmp0+
0121 6290 045B  20 fil.$$  b     *r11
0122               
0123               
0124               ***************************************************************
0125               * FILV - Fill VRAM with byte
0126               ***************************************************************
0127               *  BL   @FILV
0128               *  DATA P0,P1,P2
0129               *--------------------------------------------------------------
0130               *  P0 = VDP start address
0131               *  P1 = Byte to fill
0132               *  P2 = Number of bytes to fill
0133               *--------------------------------------------------------------
0134               *  BL   @XFILV
0135               *
0136               *  TMP0 = VDP start address
0137               *  TMP1 = Byte to fill
0138               *  TMP2 = Number of bytes to fill
0139               ********|*****|*********************|**************************
0140 6292 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 6294 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 6296 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 6298 0264  22 xfilv   ori   tmp0,>4000
     629A 4000 
0147 629C 06C4  14         swpb  tmp0
0148 629E D804  38         movb  tmp0,@vdpa
     62A0 8C02 
0149 62A2 06C4  14         swpb  tmp0
0150 62A4 D804  38         movb  tmp0,@vdpa
     62A6 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 62A8 020F  20         li    r15,vdpw              ; Set VDP write address
     62AA 8C00 
0155 62AC 06C5  14         swpb  tmp1
0156 62AE C820  54         mov   @filzz,@mcloop        ; Setup move command
     62B0 62B8 
     62B2 8320 
0157 62B4 0460  28         b     @mcloop               ; Write data to VDP
     62B6 8320 
0158               *--------------------------------------------------------------
0162 62B8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0164               
0165               
0166               
0167               *//////////////////////////////////////////////////////////////
0168               *                  VDP LOW LEVEL FUNCTIONS
0169               *//////////////////////////////////////////////////////////////
0170               
0171               ***************************************************************
0172               * VDWA / VDRA - Setup VDP write or read address
0173               ***************************************************************
0174               *  BL   @VDWA
0175               *
0176               *  TMP0 = VDP destination address for write
0177               *--------------------------------------------------------------
0178               *  BL   @VDRA
0179               *
0180               *  TMP0 = VDP source address for read
0181               ********|*****|*********************|**************************
0182 62BA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     62BC 4000 
0183 62BE 06C4  14 vdra    swpb  tmp0
0184 62C0 D804  38         movb  tmp0,@vdpa
     62C2 8C02 
0185 62C4 06C4  14         swpb  tmp0
0186 62C6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     62C8 8C02 
0187 62CA 045B  20         b     *r11                  ; Exit
0188               
0189               ***************************************************************
0190               * VPUTB - VDP put single byte
0191               ***************************************************************
0192               *  BL @VPUTB
0193               *  DATA P0,P1
0194               *--------------------------------------------------------------
0195               *  P0 = VDP target address
0196               *  P1 = Byte to write
0197               ********|*****|*********************|**************************
0198 62CC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 62CE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 62D0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     62D2 4000 
0204 62D4 06C4  14         swpb  tmp0                  ; \
0205 62D6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     62D8 8C02 
0206 62DA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 62DC D804  38         movb  tmp0,@vdpa            ; /
     62DE 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 62E0 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 62E2 D7C5  30         movb  tmp1,*r15             ; Write byte
0213 62E4 045B  20         b     *r11                  ; Exit
0214               
0215               
0216               ***************************************************************
0217               * VGETB - VDP get single byte
0218               ***************************************************************
0219               *  bl   @vgetb
0220               *  data p0
0221               *--------------------------------------------------------------
0222               *  P0 = VDP source address
0223               *--------------------------------------------------------------
0224               *  bl   @xvgetb
0225               *
0226               *  tmp0 = VDP source address
0227               *--------------------------------------------------------------
0228               *  Output:
0229               *  tmp0 MSB = >00
0230               *  tmp0 LSB = VDP byte read
0231               ********|*****|*********************|**************************
0232 62E6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 62E8 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 62EA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     62EC 8C02 
0238 62EE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 62F0 D804  38         movb  tmp0,@vdpa            ; /
     62F2 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 62F4 D120  34         movb  @vdpr,tmp0            ; Read byte
     62F6 8800 
0244 62F8 0984  56         srl   tmp0,8                ; Right align
0245 62FA 045B  20         b     *r11                  ; Exit
0246               
0247               
0248               ***************************************************************
0249               * VIDTAB - Dump videomode table
0250               ***************************************************************
0251               *  BL   @VIDTAB
0252               *  DATA P0
0253               *--------------------------------------------------------------
0254               *  P0 = Address of video mode table
0255               *--------------------------------------------------------------
0256               *  BL   @XIDTAB
0257               *
0258               *  TMP0 = Address of video mode table
0259               *--------------------------------------------------------------
0260               *  Remarks
0261               *  TMP1 = MSB is the VDP target register
0262               *         LSB is the value to write
0263               ********|*****|*********************|**************************
0264 62FC C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 62FE C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 6300 C144  18         mov   tmp0,tmp1
0270 6302 05C5  14         inct  tmp1
0271 6304 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 6306 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6308 FF00 
0273 630A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 630C C805  38         mov   tmp1,@wbase           ; Store calculated base
     630E 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 6310 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6312 8000 
0279 6314 0206  20         li    tmp2,8
     6316 0008 
0280 6318 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     631A 830B 
0281 631C 06C5  14         swpb  tmp1
0282 631E D805  38         movb  tmp1,@vdpa
     6320 8C02 
0283 6322 06C5  14         swpb  tmp1
0284 6324 D805  38         movb  tmp1,@vdpa
     6326 8C02 
0285 6328 0225  22         ai    tmp1,>0100
     632A 0100 
0286 632C 0606  14         dec   tmp2
0287 632E 16F4  14         jne   vidta1                ; Next register
0288 6330 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6332 833A 
0289 6334 045B  20         b     *r11
0290               
0291               
0292               ***************************************************************
0293               * PUTVR  - Put single VDP register
0294               ***************************************************************
0295               *  BL   @PUTVR
0296               *  DATA P0
0297               *--------------------------------------------------------------
0298               *  P0 = MSB is the VDP target register
0299               *       LSB is the value to write
0300               *--------------------------------------------------------------
0301               *  BL   @PUTVRX
0302               *
0303               *  TMP0 = MSB is the VDP target register
0304               *         LSB is the value to write
0305               ********|*****|*********************|**************************
0306 6336 C13B  30 putvr   mov   *r11+,tmp0
0307 6338 0264  22 putvrx  ori   tmp0,>8000
     633A 8000 
0308 633C 06C4  14         swpb  tmp0
0309 633E D804  38         movb  tmp0,@vdpa
     6340 8C02 
0310 6342 06C4  14         swpb  tmp0
0311 6344 D804  38         movb  tmp0,@vdpa
     6346 8C02 
0312 6348 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 634A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 634C C10E  18         mov   r14,tmp0
0322 634E 0984  56         srl   tmp0,8
0323 6350 06A0  32         bl    @putvrx               ; Write VR#0
     6352 6338 
0324 6354 0204  20         li    tmp0,>0100
     6356 0100 
0325 6358 D820  54         movb  @r14lb,@tmp0lb
     635A 831D 
     635C 8309 
0326 635E 06A0  32         bl    @putvrx               ; Write VR#1
     6360 6338 
0327 6362 0458  20         b     *tmp4                 ; Exit
0328               
0329               
0330               ***************************************************************
0331               * LDFNT - Load TI-99/4A font from GROM into VDP
0332               ***************************************************************
0333               *  BL   @LDFNT
0334               *  DATA P0,P1
0335               *--------------------------------------------------------------
0336               *  P0 = VDP Target address
0337               *  P1 = Font options
0338               *--------------------------------------------------------------
0339               * Uses registers tmp0-tmp4
0340               ********|*****|*********************|**************************
0341 6364 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 6366 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 6368 C11B  26         mov   *r11,tmp0             ; Get P0
0344 636A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     636C 7FFF 
0345 636E 2120  38         coc   @wbit0,tmp0
     6370 604A 
0346 6372 1604  14         jne   ldfnt1
0347 6374 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6376 8000 
0348 6378 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     637A 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 637C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     637E 63E6 
0353 6380 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6382 9C02 
0354 6384 06C4  14         swpb  tmp0
0355 6386 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6388 9C02 
0356 638A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     638C 9800 
0357 638E 06C5  14         swpb  tmp1
0358 6390 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6392 9800 
0359 6394 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 6396 D805  38         movb  tmp1,@grmwa
     6398 9C02 
0364 639A 06C5  14         swpb  tmp1
0365 639C D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     639E 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 63A0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 63A2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     63A4 62BA 
0371 63A6 05C8  14         inct  tmp4                  ; R11=R11+2
0372 63A8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 63AA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     63AC 7FFF 
0374 63AE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     63B0 63E8 
0375 63B2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     63B4 63EA 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 63B6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 63B8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 63BA D120  34         movb  @grmrd,tmp0
     63BC 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 63BE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     63C0 604A 
0386 63C2 1603  14         jne   ldfnt3                ; No, so skip
0387 63C4 D1C4  18         movb  tmp0,tmp3
0388 63C6 0917  56         srl   tmp3,1
0389 63C8 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 63CA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     63CC 8C00 
0394 63CE 0606  14         dec   tmp2
0395 63D0 16F2  14         jne   ldfnt2
0396 63D2 05C8  14         inct  tmp4                  ; R11=R11+2
0397 63D4 020F  20         li    r15,vdpw              ; Set VDP write address
     63D6 8C00 
0398 63D8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     63DA 7FFF 
0399 63DC 0458  20         b     *tmp4                 ; Exit
0400 63DE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     63E0 602A 
     63E2 8C00 
0401 63E4 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 63E6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     63E8 0200 
     63EA 0000 
0406 63EC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     63EE 01C0 
     63F0 0101 
0407 63F2 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     63F4 02A0 
     63F6 0101 
0408 63F8 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     63FA 00E0 
     63FC 0101 
0409               
0410               
0411               
0412               ***************************************************************
0413               * YX2PNT - Get VDP PNT address for current YX cursor position
0414               ***************************************************************
0415               *  BL   @YX2PNT
0416               *--------------------------------------------------------------
0417               *  INPUT
0418               *  @WYX = Cursor YX position
0419               *--------------------------------------------------------------
0420               *  OUTPUT
0421               *  TMP0 = VDP address for entry in Pattern Name Table
0422               *--------------------------------------------------------------
0423               *  Register usage
0424               *  TMP0, R14, R15
0425               ********|*****|*********************|**************************
0426 63FE C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 6400 C3A0  34         mov   @wyx,r14              ; Get YX
     6402 832A 
0428 6404 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 6406 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6408 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 640A C3A0  34         mov   @wyx,r14              ; Get YX
     640C 832A 
0435 640E 024E  22         andi  r14,>00ff             ; Remove Y
     6410 00FF 
0436 6412 A3CE  18         a     r14,r15               ; pos = pos + X
0437 6414 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6416 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 6418 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 641A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 641C 020F  20         li    r15,vdpw              ; VDP write address
     641E 8C00 
0444 6420 045B  20         b     *r11
0445               
0446               
0447               
0448               ***************************************************************
0449               * Put length-byte prefixed string at current YX
0450               ***************************************************************
0451               *  BL   @PUTSTR
0452               *  DATA P0
0453               *
0454               *  P0 = Pointer to string
0455               *--------------------------------------------------------------
0456               *  REMARKS
0457               *  First byte of string must contain length
0458               ********|*****|*********************|**************************
0459 6422 C17B  30 putstr  mov   *r11+,tmp1
0460 6424 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 6426 C1CB  18 xutstr  mov   r11,tmp3
0462 6428 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     642A 63FE 
0463 642C C2C7  18         mov   tmp3,r11
0464 642E 0986  56         srl   tmp2,8                ; Right justify length byte
0465 6430 0460  28         b     @xpym2v               ; Display string
     6432 6442 
0466               
0467               
0468               ***************************************************************
0469               * Put length-byte prefixed string at YX
0470               ***************************************************************
0471               *  BL   @PUTAT
0472               *  DATA P0,P1
0473               *
0474               *  P0 = YX position
0475               *  P1 = Pointer to string
0476               *--------------------------------------------------------------
0477               *  REMARKS
0478               *  First byte of string must contain length
0479               ********|*****|*********************|**************************
0480 6434 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6436 832A 
0481 6438 0460  28         b     @putstr
     643A 6422 
**** **** ****     > runlib.asm
0090               
0092                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 643C C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 643E C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6440 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6442 0264  22 xpym2v  ori   tmp0,>4000
     6444 4000 
0027 6446 06C4  14         swpb  tmp0
0028 6448 D804  38         movb  tmp0,@vdpa
     644A 8C02 
0029 644C 06C4  14         swpb  tmp0
0030 644E D804  38         movb  tmp0,@vdpa
     6450 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6452 020F  20         li    r15,vdpw              ; Set VDP write address
     6454 8C00 
0035 6456 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6458 6460 
     645A 8320 
0036 645C 0460  28         b     @mcloop               ; Write data to VDP
     645E 8320 
0037 6460 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0094               
0096                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 6462 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6464 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6466 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6468 06C4  14 xpyv2m  swpb  tmp0
0027 646A D804  38         movb  tmp0,@vdpa
     646C 8C02 
0028 646E 06C4  14         swpb  tmp0
0029 6470 D804  38         movb  tmp0,@vdpa
     6472 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6474 020F  20         li    r15,vdpr              ; Set VDP read address
     6476 8800 
0034 6478 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     647A 6482 
     647C 8320 
0035 647E 0460  28         b     @mcloop               ; Read data from VDP
     6480 8320 
0036 6482 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0098               
0100                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 6484 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6486 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6488 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 648A C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 648C 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 648E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6490 FFCE 
0034 6492 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6494 6050 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6496 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6498 0001 
0039 649A 1603  14         jne   cpym0                 ; No, continue checking
0040 649C DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 649E 04C6  14         clr   tmp2                  ; Reset counter
0042 64A0 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 64A2 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     64A4 7FFF 
0047 64A6 C1C4  18         mov   tmp0,tmp3
0048 64A8 0247  22         andi  tmp3,1
     64AA 0001 
0049 64AC 1618  14         jne   cpyodd                ; Odd source address handling
0050 64AE C1C5  18 cpym1   mov   tmp1,tmp3
0051 64B0 0247  22         andi  tmp3,1
     64B2 0001 
0052 64B4 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 64B6 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     64B8 604A 
0057 64BA 1605  14         jne   cpym3
0058 64BC C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     64BE 64E4 
     64C0 8320 
0059 64C2 0460  28         b     @mcloop               ; Copy memory and exit
     64C4 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 64C6 C1C6  18 cpym3   mov   tmp2,tmp3
0064 64C8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     64CA 0001 
0065 64CC 1301  14         jeq   cpym4
0066 64CE 0606  14         dec   tmp2                  ; Make TMP2 even
0067 64D0 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 64D2 0646  14         dect  tmp2
0069 64D4 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 64D6 C1C7  18         mov   tmp3,tmp3
0074 64D8 1301  14         jeq   cpymz
0075 64DA D554  38         movb  *tmp0,*tmp1
0076 64DC 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 64DE 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     64E0 8000 
0081 64E2 10E9  14         jmp   cpym2
0082 64E4 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0102               
0104                       copy  "copy_grom_cpu.asm"        ; GROM to CPU copy functions
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
0025 64E6 C13B  30 cpyg2m  mov   *r11+,tmp0            ; Memory source address
0026 64E8 C17B  30         mov   *r11+,tmp1            ; Memory target address
0027 64EA C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0028               *--------------------------------------------------------------
0029               * Setup GROM source address
0030               *--------------------------------------------------------------
0031 64EC D804  38 xpyg2m  movb  tmp0,@grmwa
     64EE 9C02 
0032 64F0 06C4  14         swpb  tmp0
0033 64F2 D804  38         movb  tmp0,@grmwa
     64F4 9C02 
0034               *--------------------------------------------------------------
0035               *    Copy bytes from GROM to CPU memory
0036               *--------------------------------------------------------------
0037 64F6 0204  20         li    tmp0,grmrd            ; Set TMP0 to GROM data port
     64F8 9800 
0038 64FA C820  54         mov   @tmp003,@mcloop       ; Setup copy command
     64FC 6504 
     64FE 8320 
0039 6500 0460  28         b     @mcloop               ; Copy bytes
     6502 8320 
0040 6504 DD54     tmp003  data  >dd54                 ; MOVB *TMP0,*TMP1+
**** **** ****     > runlib.asm
0106               
0108                       copy  "copy_grom_vram.asm"       ; GROM to VRAM copy functions
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
0024 6506 C13B  30 cpyg2v  mov   *r11+,tmp0            ; Memory source address
0025 6508 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 650A C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Setup GROM source address
0029               *--------------------------------------------------------------
0030 650C D804  38 xpyg2v  movb  tmp0,@grmwa
     650E 9C02 
0031 6510 06C4  14         swpb  tmp0
0032 6512 D804  38         movb  tmp0,@grmwa
     6514 9C02 
0033               *--------------------------------------------------------------
0034               * Setup VDP target address
0035               *--------------------------------------------------------------
0036 6516 0265  22         ori   tmp1,>4000
     6518 4000 
0037 651A 06C5  14         swpb  tmp1
0038 651C D805  38         movb  tmp1,@vdpa
     651E 8C02 
0039 6520 06C5  14         swpb  tmp1
0040 6522 D805  38         movb  tmp1,@vdpa            ; Set VDP target address
     6524 8C02 
0041               *--------------------------------------------------------------
0042               *    Copy bytes from GROM to VDP memory
0043               *--------------------------------------------------------------
0044 6526 0207  20         li    tmp3,grmrd            ; Set TMP3 to GROM data port
     6528 9800 
0045 652A 020F  20         li    r15,vdpw              ; Set VDP write address
     652C 8C00 
0046 652E C820  54         mov   @tmp002,@mcloop       ; Setup copy command
     6530 6538 
     6532 8320 
0047 6534 0460  28         b     @mcloop               ; Copy bytes
     6536 8320 
0048 6538 D7D7     tmp002  data  >d7d7                 ; MOVB *TMP3,*R15
**** **** ****     > runlib.asm
0110               
0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
**** **** ****     > cpu_sams_support.asm
0001               * FILE......: cpu_sams_support.asm
0002               * Purpose...: Low level support for SAMS memory expansion card
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                SAMS Memory Expansion support
0006               *//////////////////////////////////////////////////////////////
0007               
0008               *--------------------------------------------------------------
0009               * ACCESS and MAPPING
0010               * (by the late Bruce Harisson):
0011               *
0012               * To use other than the default setup, you have to do two
0013               * things:
0014               *
0015               * 1. You have to "turn on" the card's memory in the
0016               *    >4000 block and write to the mapping registers there.
0017               *    (bl  @sams.page.set)
0018               *
0019               * 2. You have to "turn on" the mapper function to make what
0020               *    you've written into the >4000 block take effect.
0021               *    (bl  @sams.mapping.on)
0022               *--------------------------------------------------------------
0023               *  SAMS                          Default SAMS page
0024               *  Register     Memory bank      (system startup)
0025               *  =======      ===========      ================
0026               *  >4004        >2000-2fff          >002
0027               *  >4006        >3000-4fff          >003
0028               *  >4014        >a000-afff          >00a
0029               *  >4016        >b000-bfff          >00b
0030               *  >4018        >c000-cfff          >00c
0031               *  >401a        >d000-dfff          >00d
0032               *  >401c        >e000-efff          >00e
0033               *  >401e        >f000-ffff          >00f
0034               *  Others       Inactive
0035               *--------------------------------------------------------------
0036               
0037               
0038               
0039               
0040               ***************************************************************
0041               * sams.page.get - Get SAMS page number for memory address
0042               ***************************************************************
0043               * bl   @sams.page.get
0044               *      data P0
0045               *--------------------------------------------------------------
0046               * P0 = Memory address (e.g. address >a100 will map to SAMS
0047               *      register >4014 (bank >a000 - >afff)
0048               *--------------------------------------------------------------
0049               * bl   @xsams.page.get
0050               *
0051               * tmp0 = Memory address (e.g. address >a100 will map to SAMS
0052               *        register >4014 (bank >a000 - >afff)
0053               *--------------------------------------------------------------
0054               * OUTPUT
0055               * waux1 = SAMS page number
0056               * waux2 = Address of affected SAMS register
0057               *--------------------------------------------------------------
0058               * Register usage
0059               * r0, tmp0, r12
0060               ********|*****|*********************|**************************
0061               sams.page.get:
0062 653A C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 653C 0649  14         dect  stack
0065 653E C64B  30         mov   r11,*stack            ; Push return address
0066 6540 0649  14         dect  stack
0067 6542 C640  30         mov   r0,*stack             ; Push r0
0068 6544 0649  14         dect  stack
0069 6546 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 6548 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 654A 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 654C 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     654E 4000 
0077 6550 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     6552 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 6554 020C  20         li    r12,>1e00             ; SAMS CRU address
     6556 1E00 
0082 6558 04C0  14         clr   r0
0083 655A 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 655C D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 655E D100  18         movb  r0,tmp0
0086 6560 0984  56         srl   tmp0,8                ; Right align
0087 6562 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     6564 833C 
0088 6566 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 6568 C339  30         mov   *stack+,r12           ; Pop r12
0094 656A C039  30         mov   *stack+,r0            ; Pop r0
0095 656C C2F9  30         mov   *stack+,r11           ; Pop return address
0096 656E 045B  20         b     *r11                  ; Return to caller
0097               
0098               
0099               
0100               
0101               ***************************************************************
0102               * sams.page.set - Set SAMS memory page
0103               ***************************************************************
0104               * bl   sams.page.set
0105               *      data P0,P1
0106               *--------------------------------------------------------------
0107               * P0 = SAMS page number
0108               * P1 = Memory address (e.g. address >a100 will map to SAMS
0109               *      register >4014 (bank >a000 - >afff)
0110               *--------------------------------------------------------------
0111               * bl   @xsams.page.set
0112               *
0113               * tmp0 = SAMS page number
0114               * tmp1 = Memory address (e.g. address >a100 will map to SAMS
0115               *        register >4014 (bank >a000 - >afff)
0116               *--------------------------------------------------------------
0117               * Register usage
0118               * r0, tmp0, tmp1, r12
0119               *--------------------------------------------------------------
0120               * SAMS page number should be in range 0-255 (>00 to >ff)
0121               *
0122               *  Page         Memory
0123               *  ====         ======
0124               *  >00             32K
0125               *  >1f            128K
0126               *  >3f            256K
0127               *  >7f            512K
0128               *  >ff           1024K
0129               ********|*****|*********************|**************************
0130               sams.page.set:
0131 6570 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 6572 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 6574 0649  14         dect  stack
0135 6576 C64B  30         mov   r11,*stack            ; Push return address
0136 6578 0649  14         dect  stack
0137 657A C640  30         mov   r0,*stack             ; Push r0
0138 657C 0649  14         dect  stack
0139 657E C64C  30         mov   r12,*stack            ; Push r12
0140 6580 0649  14         dect  stack
0141 6582 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 6584 0649  14         dect  stack
0143 6586 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 6588 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 658A 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 658C 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     658E 001E 
0153 6590 150A  14         jgt   !
0154 6592 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     6594 0004 
0155 6596 1107  14         jlt   !
0156 6598 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     659A 0012 
0157 659C 1508  14         jgt   sams.page.set.switch_page
0158 659E 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     65A0 0006 
0159 65A2 1501  14         jgt   !
0160 65A4 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 65A6 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     65A8 FFCE 
0165 65AA 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     65AC 6050 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 65AE 020C  20         li    r12,>1e00             ; SAMS CRU address
     65B0 1E00 
0171 65B2 C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 65B4 06C0  14         swpb  r0                    ; LSB to MSB
0173 65B6 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 65B8 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     65BA 4000 
0175 65BC 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 65BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 65C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 65C2 C339  30         mov   *stack+,r12           ; Pop r12
0183 65C4 C039  30         mov   *stack+,r0            ; Pop r0
0184 65C6 C2F9  30         mov   *stack+,r11           ; Pop return address
0185 65C8 045B  20         b     *r11                  ; Return to caller
0186               
0187               
0188               
0189               
0190               ***************************************************************
0191               * sams.mapping.on - Enable SAMS mapping mode
0192               ***************************************************************
0193               *  bl   @sams.mapping.on
0194               *--------------------------------------------------------------
0195               *  Register usage
0196               *  r12
0197               ********|*****|*********************|**************************
0198               sams.mapping.on:
0199 65CA 020C  20         li    r12,>1e00             ; SAMS CRU address
     65CC 1E00 
0200 65CE 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 65D0 045B  20         b     *r11                  ; Return to caller
0206               
0207               
0208               
0209               
0210               ***************************************************************
0211               * sams.mapping.off - Disable SAMS mapping mode
0212               ***************************************************************
0213               * bl  @sams.mapping.off
0214               *--------------------------------------------------------------
0215               * OUTPUT
0216               * none
0217               *--------------------------------------------------------------
0218               * Register usage
0219               * r12
0220               ********|*****|*********************|**************************
0221               sams.mapping.off:
0222 65D2 020C  20         li    r12,>1e00             ; SAMS CRU address
     65D4 1E00 
0223 65D6 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 65D8 045B  20         b     *r11                  ; Return to caller
0229               
0230               
0231               
0232               
0233               
0234               ***************************************************************
0235               * sams.layout
0236               * Setup SAMS memory banks
0237               ***************************************************************
0238               * bl  @sams.layout
0239               *     data P0
0240               *--------------------------------------------------------------
0241               * INPUT
0242               * P0 = Pointer to SAMS page layout table (16 words).
0243               *--------------------------------------------------------------
0244               * bl  @xsams.layout
0245               *
0246               * tmp0 = Pointer to SAMS page layout table (16 words).
0247               *--------------------------------------------------------------
0248               * OUTPUT
0249               * none
0250               *--------------------------------------------------------------
0251               * Register usage
0252               * tmp0, tmp1, tmp2, tmp3
0253               ********|*****|*********************|**************************
0254               sams.layout:
0255 65DA C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 65DC 0649  14         dect  stack
0258 65DE C64B  30         mov   r11,*stack            ; Save return address
0259 65E0 0649  14         dect  stack
0260 65E2 C644  30         mov   tmp0,*stack           ; Save tmp0
0261 65E4 0649  14         dect  stack
0262 65E6 C645  30         mov   tmp1,*stack           ; Save tmp1
0263 65E8 0649  14         dect  stack
0264 65EA C646  30         mov   tmp2,*stack           ; Save tmp2
0265 65EC 0649  14         dect  stack
0266 65EE C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 65F0 0206  20         li    tmp2,8                ; Set loop counter
     65F2 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 65F4 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 65F6 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 65F8 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     65FA 6574 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 65FC 0606  14         dec   tmp2                  ; Next iteration
0283 65FE 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 6600 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     6602 65CA 
0289                                                   ; / activating changes.
0290               
0291 6604 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 6606 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 6608 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 660A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 660C C2F9  30         mov   *stack+,r11           ; Pop r11
0296 660E 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               ***************************************************************
0301               * sams.reset.layout
0302               * Reset SAMS memory banks to standard layout
0303               ***************************************************************
0304               * bl  @sams.reset.layout
0305               *--------------------------------------------------------------
0306               * OUTPUT
0307               * none
0308               *--------------------------------------------------------------
0309               * Register usage
0310               * none
0311               ********|*****|*********************|**************************
0312               sams.reset.layout:
0313 6610 0649  14         dect  stack
0314 6612 C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 6614 06A0  32         bl    @sams.layout
     6616 65DA 
0319 6618 661E                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.layout.exit:
0324 661A C2F9  30         mov   *stack+,r11           ; Pop r11
0325 661C 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 661E 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     6620 0002 
0331 6622 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     6624 0003 
0332 6626 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     6628 000A 
0333 662A B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     662C 000B 
0334 662E C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     6630 000C 
0335 6632 D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     6634 000D 
0336 6636 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     6638 000E 
0337 663A F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     663C 000F 
0338               
0339               
0340               
0341               ***************************************************************
0342               * sams.copy.layout
0343               * Copy SAMS memory layout
0344               ***************************************************************
0345               * bl  @sams.copy.layout
0346               *     data P0
0347               *--------------------------------------------------------------
0348               * P0 = Pointer to 8 words RAM buffer for results
0349               *--------------------------------------------------------------
0350               * OUTPUT
0351               * RAM buffer will have the SAMS page number for each range
0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0353               *--------------------------------------------------------------
0354               * Register usage
0355               * tmp0, tmp1, tmp2, tmp3
0356               ***************************************************************
0357               sams.copy.layout:
0358 663E C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 6640 0649  14         dect  stack
0361 6642 C64B  30         mov   r11,*stack            ; Push return address
0362 6644 0649  14         dect  stack
0363 6646 C644  30         mov   tmp0,*stack           ; Push tmp0
0364 6648 0649  14         dect  stack
0365 664A C645  30         mov   tmp1,*stack           ; Push tmp1
0366 664C 0649  14         dect  stack
0367 664E C646  30         mov   tmp2,*stack           ; Push tmp2
0368 6650 0649  14         dect  stack
0369 6652 C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 6654 0205  20         li    tmp1,sams.copy.layout.data
     6656 6676 
0374 6658 0206  20         li    tmp2,8                ; Set loop counter
     665A 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.copy.layout.loop:
0379 665C C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 665E 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     6660 653C 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 6662 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     6664 833C 
0385               
0386 6666 0606  14         dec   tmp2                  ; Next iteration
0387 6668 16F9  14         jne   sams.copy.layout.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.copy.layout.exit:
0392 666A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 666C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 666E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 6670 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 6672 C2F9  30         mov   *stack+,r11           ; Pop r11
0397 6674 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.copy.layout.data:
0402 6676 2000             data  >2000                 ; >2000-2fff
0403 6678 3000             data  >3000                 ; >3000-3fff
0404 667A A000             data  >a000                 ; >a000-afff
0405 667C B000             data  >b000                 ; >b000-bfff
0406 667E C000             data  >c000                 ; >c000-cfff
0407 6680 D000             data  >d000                 ; >d000-dfff
0408 6682 E000             data  >e000                 ; >e000-efff
0409 6684 F000             data  >f000                 ; >f000-ffff
0410               
**** **** ****     > runlib.asm
0114               
0116                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 6686 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     6688 FFBF 
0010 668A 0460  28         b     @putv01
     668C 634A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 668E 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6690 0040 
0018 6692 0460  28         b     @putv01
     6694 634A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 6696 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6698 FFDF 
0026 669A 0460  28         b     @putv01
     669C 634A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 669E 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     66A0 0020 
0034 66A2 0460  28         b     @putv01
     66A4 634A 
**** **** ****     > runlib.asm
0118               
0120                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 66A6 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     66A8 FFFE 
0011 66AA 0460  28         b     @putv01
     66AC 634A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 66AE 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     66B0 0001 
0019 66B2 0460  28         b     @putv01
     66B4 634A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 66B6 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     66B8 FFFD 
0027 66BA 0460  28         b     @putv01
     66BC 634A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 66BE 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     66C0 0002 
0035 66C2 0460  28         b     @putv01
     66C4 634A 
**** **** ****     > runlib.asm
0122               
0124                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 66C6 C83B  50 at      mov   *r11+,@wyx
     66C8 832A 
0019 66CA 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 66CC B820  54 down    ab    @hb$01,@wyx
     66CE 603C 
     66D0 832A 
0028 66D2 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 66D4 7820  54 up      sb    @hb$01,@wyx
     66D6 603C 
     66D8 832A 
0037 66DA 045B  20         b     *r11
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
0049 66DC C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 66DE D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     66E0 832A 
0051 66E2 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     66E4 832A 
0052 66E6 045B  20         b     *r11
**** **** ****     > runlib.asm
0126               
0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 66E8 C120  34 yx2px   mov   @wyx,tmp0
     66EA 832A 
0022 66EC C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 66EE 06C4  14         swpb  tmp0                  ; Y<->X
0024 66F0 04C5  14         clr   tmp1                  ; Clear before copy
0025 66F2 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 66F4 20A0  38         coc   @wbit1,config         ; f18a present ?
     66F6 6048 
0030 66F8 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 66FA 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     66FC 833A 
     66FE 6728 
0032 6700 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6702 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6704 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6706 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6708 0500 
0037 670A 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 670C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 670E 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6710 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6712 D105  18         movb  tmp1,tmp0
0051 6714 06C4  14         swpb  tmp0                  ; X<->Y
0052 6716 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6718 604A 
0053 671A 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 671C 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     671E 603C 
0059 6720 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6722 604E 
0060 6724 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6726 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6728 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0130               
0132                       copy  "vdp_px2yx_calc.asm"       ; VDP calculate YX coord for pixel pos
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
0023 672A 20A0  38 px2yx   coc   @wbit0,config         ; Skip sprite adjustment ?
     672C 604A 
0024 672E 1302  14         jeq   px2yx1
0025 6730 0224  22         ai    tmp0,>0100            ; Adjust Y. Top of screen is at >FF
     6732 0100 
0026 6734 C144  18 px2yx1  mov   tmp0,tmp1             ; Copy YX
0027 6736 C184  18         mov   tmp0,tmp2             ; Copy YX
0028               *--------------------------------------------------------------
0029               * Calculate Y tile position
0030               *--------------------------------------------------------------
0031 6738 09B4  56         srl   tmp0,11               ; Y: Move to TMP0LB & (Y = Y / 8)
0032               *--------------------------------------------------------------
0033               * Calculate Y pixel offset
0034               *--------------------------------------------------------------
0035 673A C1C4  18         mov   tmp0,tmp3             ; Y: Copy Y tile to TMP3LB
0036 673C 0AB7  56         sla   tmp3,11               ; Y: Move to TMP3HB & (Y = Y * 8)
0037 673E 0507  16         neg   tmp3
0038 6740 B1C5  18         ab    tmp1,tmp3             ; Y: offset = Y pixel old + (-Y) pixel new
0039               *--------------------------------------------------------------
0040               * Calculate X tile position
0041               *--------------------------------------------------------------
0042 6742 0245  22         andi  tmp1,>00ff            ; Clear TMP1HB
     6744 00FF 
0043 6746 0A55  56         sla   tmp1,5                ; X: Move to TMP1HB & (X = X / 8)
0044 6748 D105  18         movb  tmp1,tmp0             ; X: TMP0 <-- XY tile position
0045 674A 06C4  14         swpb  tmp0                  ; XY tile position <-> YX tile position
0046               *--------------------------------------------------------------
0047               * Calculate X pixel offset
0048               *--------------------------------------------------------------
0049 674C 0245  22         andi  tmp1,>ff00            ; X: Get rid of remaining junk in TMP1LB
     674E FF00 
0050 6750 0A35  56         sla   tmp1,3                ; X: (X = X * 8)
0051 6752 0505  16         neg   tmp1
0052 6754 06C6  14         swpb  tmp2                  ; YX <-> XY
0053 6756 B146  18         ab    tmp2,tmp1             ; offset X = X pixel old  + (-X) pixel new
0054 6758 06C5  14         swpb  tmp1                  ; X0 <-> 0X
0055 675A D147  18         movb  tmp3,tmp1             ; 0X --> YX
0056 675C 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0134               
0136                       copy  "vdp_bitmap.asm"           ; VDP Bitmap functions
**** **** ****     > vdp_bitmap.asm
0001               * FILE......: vdp_bitmap.asm
0002               * Purpose...: VDP bitmap support module
0003               
0004               ***************************************************************
0005               * BITMAP - Set tiles for displaying bitmap picture
0006               ***************************************************************
0007               *  BL   @BITMAP
0008               ********|*****|*********************|**************************
0009 675E C1CB  18 bitmap  mov   r11,tmp3              ; Save R11
0010 6760 C120  34         mov   @wbase,tmp0           ; Get PNT base address
     6762 8328 
0011 6764 06A0  32         bl    @vdwa                 ; Setup VDP write address
     6766 62BA 
0012 6768 04C5  14         clr   tmp1
0013 676A 0206  20         li    tmp2,768              ; Write 768 bytes
     676C 0300 
0014               *--------------------------------------------------------------
0015               * Repeat 3 times: write bytes >00 .. >FF
0016               *--------------------------------------------------------------
0017 676E D7C5  30 bitma1  movb  tmp1,*r15             ; Write byte
0018 6770 0225  22         ai    tmp1,>0100
     6772 0100 
0019 6774 0606  14         dec   tmp2
0020 6776 16FB  14         jne   bitma1
0021 6778 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0138               
0140                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0013 677A C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 677C 06A0  32         bl    @putvr                ; Write once
     677E 6336 
0015 6780 391C             data  >391c                 ; VR1/57, value 00011100
0016 6782 06A0  32         bl    @putvr                ; Write twice
     6784 6336 
0017 6786 391C             data  >391c                 ; VR1/57, value 00011100
0018 6788 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 678A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 678C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     678E 6336 
0028 6790 391C             data  >391c
0029 6792 0458  20         b     *tmp4                 ; Exit
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
0040 6794 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 6796 06A0  32         bl    @cpym2v
     6798 643C 
0042 679A 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     679C 67D8 
     679E 0006 
0043 67A0 06A0  32         bl    @putvr
     67A2 6336 
0044 67A4 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 67A6 06A0  32         bl    @putvr
     67A8 6336 
0046 67AA 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 67AC 0204  20         li    tmp0,>3f00
     67AE 3F00 
0052 67B0 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     67B2 62BE 
0053 67B4 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     67B6 8800 
0054 67B8 0984  56         srl   tmp0,8
0055 67BA D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     67BC 8800 
0056 67BE C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 67C0 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 67C2 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     67C4 BFFF 
0060 67C6 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 67C8 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     67CA 4000 
0063               f18chk_exit:
0064 67CC 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     67CE 6292 
0065 67D0 3F00             data  >3f00,>00,6
     67D2 0000 
     67D4 0006 
0066 67D6 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 67D8 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 67DA 3F00             data  >3f00                 ; 3f02 / 3f00
0073 67DC 0340             data  >0340                 ; 3f04   0340  idle
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
0092 67DE C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 67E0 06A0  32         bl    @putvr
     67E2 6336 
0097 67E4 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 67E6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     67E8 6336 
0100 67EA 391C             data  >391c                 ; Lock the F18a
0101 67EC 0458  20         b     *tmp4                 ; Exit
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
0120 67EE C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 67F0 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     67F2 6048 
0122 67F4 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 67F6 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     67F8 8802 
0127 67FA 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     67FC 6336 
0128 67FE 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6800 04C4  14         clr   tmp0
0130 6802 D120  34         movb  @vdps,tmp0
     6804 8802 
0131 6806 0984  56         srl   tmp0,8
0132 6808 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0142               
0144                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 680A C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     680C 832A 
0018 680E D17B  28         movb  *r11+,tmp1
0019 6810 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 6812 D1BB  28         movb  *r11+,tmp2
0021 6814 0986  56         srl   tmp2,8                ; Repeat count
0022 6816 C1CB  18         mov   r11,tmp3
0023 6818 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     681A 63FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 681C 020B  20         li    r11,hchar1
     681E 6824 
0028 6820 0460  28         b     @xfilv                ; Draw
     6822 6298 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 6824 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6826 604C 
0033 6828 1302  14         jeq   hchar2                ; Yes, exit
0034 682A C2C7  18         mov   tmp3,r11
0035 682C 10EE  14         jmp   hchar                 ; Next one
0036 682E 05C7  14 hchar2  inct  tmp3
0037 6830 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0146               
0148                       copy  "vdp_vchar.asm"            ; VDP vchar functions
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
0017 6832 C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     6834 832A 
0018 6836 C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 6838 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     683A 833A 
0020 683C 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     683E 63FE 
0021 6840 D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 6842 D1B7  28         movb  *tmp3+,tmp2
0023 6844 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 6846 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     6848 62BA 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 684A D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 684C A108  18         a     tmp4,tmp0             ; Next row
0033 684E 0606  14         dec   tmp2
0034 6850 16FA  14         jne   vchar2
0035 6852 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6854 604C 
0036 6856 1303  14         jeq   vchar3                ; Yes, exit
0037 6858 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     685A 832A 
0038 685C 10ED  14         jmp   vchar1                ; Next one
0039 685E 05C7  14 vchar3  inct  tmp3
0040 6860 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 6862 C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 6864 C804  38         mov   tmp0,@wyx             ; Set cursor position
     6866 832A 
0051 6868 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 686A C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     686C 833A 
0053 686E 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6870 63FE 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 6872 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     6874 62BA 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 6876 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 6878 A120  34         a     @wcolmn,tmp0          ; Next row
     687A 833A 
0063 687C 0606  14         dec   tmp2
0064 687E 16F9  14         jne   xvcha1
0065 6880 0458  20         b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0150               
0152                       copy  "vdp_boxes.asm"            ; VDP box functions
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
0019 6882 C83B  50 filbox  mov   *r11+,@wyx            ; Upper left corner
     6884 832A 
0020 6886 D1FB  28         movb  *r11+,tmp3            ; Height in TMP3
0021 6888 D1BB  28         movb  *r11+,tmp2            ; Width in TMP2
0022 688A C17B  30         mov   *r11+,tmp1            ; Byte to fill
0023 688C C20B  18         mov   r11,tmp4              ; Save R11
0024 688E 0986  56         srl   tmp2,8                ; Right-align width
0025 6890 0987  56         srl   tmp3,8                ; Right-align height
0026               *--------------------------------------------------------------
0027               *  Do single row
0028               *--------------------------------------------------------------
0029 6892 06A0  32 filbo1  bl    @yx2pnt               ; Get VDP address into TMP0
     6894 63FE 
0030 6896 020B  20         li    r11,filbo2            ; New return address
     6898 689E 
0031 689A 0460  28         b     @xfilv                ; Fill VRAM with byte
     689C 6298 
0032               *--------------------------------------------------------------
0033               *  Recover width & character
0034               *--------------------------------------------------------------
0035 689E C108  18 filbo2  mov   tmp4,tmp0
0036 68A0 0224  22         ai    tmp0,-3               ; R11 - 3
     68A2 FFFD 
0037 68A4 D1B4  28         movb  *tmp0+,tmp2           ; Get Width/Height
0038 68A6 0986  56         srl   tmp2,8                ; Right align
0039 68A8 C154  26         mov   *tmp0,tmp1            ; Get character to fill
0040               *--------------------------------------------------------------
0041               *  Housekeeping
0042               *--------------------------------------------------------------
0043 68AA A820  54         a     @w$0100,@by           ; Y=Y+1
     68AC 603C 
     68AE 832A 
0044 68B0 0607  14         dec   tmp3
0045 68B2 15EF  14         jgt   filbo1                ; Process next row
0046 68B4 8818  46         c     *tmp4,@w$ffff         ; End-Of-List marker found ?
     68B6 604C 
0047 68B8 1302  14         jeq   filbo3                ; Yes, exit
0048 68BA C2C8  18         mov   tmp4,r11
0049 68BC 10E2  14         jmp   filbox                ; Next one
0050 68BE 05C8  14 filbo3  inct  tmp4
0051 68C0 0458  20         b     *tmp4                 ; Exit
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
0083 68C2 C13B  30 putbox  mov   *r11+,tmp0            ; P0 - Upper left corner YX
0084 68C4 C15B  26         mov   *r11,tmp1             ; P1 - Height/Width in TMP1
0085 68C6 C1BB  30         mov   *r11+,tmp2            ; P1 - Height/Width in TMP2
0086 68C8 C1FB  30         mov   *r11+,tmp3            ; P2 - Pointer to string
0087 68CA C83B  50         mov   *r11+,@waux1          ; P3 - Box repeat count AB
     68CC 833C 
0088 68CE C80B  38         mov   r11,@waux2            ; Save R11
     68D0 833E 
0089               *--------------------------------------------------------------
0090               *  Calculate some positions
0091               *--------------------------------------------------------------
0092 68D2 B184  18 putbo0  ab    tmp0,tmp2             ; TMP2HB = height + Y
0093 68D4 06C4  14         swpb  tmp0
0094 68D6 06C5  14         swpb  tmp1
0095 68D8 B144  18         ab    tmp0,tmp1             ; TMP1HB = width  + X
0096 68DA 06C4  14         swpb  tmp0
0097 68DC 0A12  56         sla   config,1              ; \ clear config bit 0
0098 68DE 0912  56         srl   config,1              ; / is only 4 bytes
0099 68E0 C804  38         mov   tmp0,@waux3           ; Set additional work copy of YX cursor
     68E2 8340 
0100               *--------------------------------------------------------------
0101               *  Setup VDP write address
0102               *--------------------------------------------------------------
0103 68E4 C804  38 putbo1  mov   tmp0,@wyx             ; Set YX cursor
     68E6 832A 
0104 68E8 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     68EA 63FE 
0105 68EC 06A0  32         bl    @vdwa                 ; Set VDP write address from TMP0
     68EE 62BA 
0106 68F0 C120  34         mov   @wyx,tmp0
     68F2 832A 
0107               *--------------------------------------------------------------
0108               *  Prepare string for processing
0109               *--------------------------------------------------------------
0110 68F4 20A0  38         coc   @wbit0,config         ; state flag set ?
     68F6 604A 
0111 68F8 1302  14         jeq   putbo2                ; Yes, skip length byte
0112 68FA D237  28         movb  *tmp3+,tmp4           ; Get length byte ...
0113 68FC 0988  56         srl   tmp4,8                ; ... and right justify
0114               *--------------------------------------------------------------
0115               *  Write line of tiles in box
0116               *--------------------------------------------------------------
0117 68FE D7F7  40 putbo2  movb  *tmp3+,*r15           ; Write to VDP
0118 6900 0608  14         dec   tmp4
0119 6902 1310  14         jeq   putbo3                ; End of string. Repeat box ?
0120               *--------------------------------------------------------------
0121               *    Adjust cursor
0122               *--------------------------------------------------------------
0123 6904 0584  14         inc   tmp0                  ; X=X+1
0124 6906 06C4  14         swpb  tmp0
0125 6908 9144  18         cb    tmp0,tmp1             ; Right boundary reached ?
0126 690A 06C4  14         swpb  tmp0
0127 690C 11F8  14         jlt   putbo2                ; Not yet, continue
0128 690E 0224  22         ai    tmp0,>0100            ; Y=Y+1
     6910 0100 
0129 6912 D804  38         movb  tmp0,@wyx             ; Update Y cursor
     6914 832A 
0130 6916 9184  18         cb    tmp0,tmp2             ; Bottom boundary reached ?
0131 6918 1305  14         jeq   putbo3                ; Yes, exit
0132               *--------------------------------------------------------------
0133               *  Recover starting column
0134               *--------------------------------------------------------------
0135 691A C120  34         mov   @wyx,tmp0             ; ... from YX cursor
     691C 832A 
0136 691E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6920 8000 
0137 6922 10E0  14         jmp   putbo1                ; Draw next line
0138               *--------------------------------------------------------------
0139               *  Handling repeating of box
0140               *--------------------------------------------------------------
0141 6924 C120  34 putbo3  mov   @waux1,tmp0           ; Repeat box ?
     6926 833C 
0142 6928 1328  14         jeq   putbo9                ; No, move on to next list entry
0143               *--------------------------------------------------------------
0144               *     Repeat horizontally
0145               *--------------------------------------------------------------
0146 692A 06C4  14         swpb  tmp0                  ; BA
0147 692C D104  18         movb  tmp0,tmp0             ; B = 0 ?
0148 692E 130D  14         jeq   putbo4                ; Yes, repeat vertically
0149 6930 06C4  14         swpb  tmp0                  ; AB
0150 6932 0604  14         dec   tmp0                  ; B = B - 1
0151 6934 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     6936 833C 
0152 6938 D805  38         movb  tmp1,@waux3+1         ; New X position
     693A 8341 
0153 693C C120  34         mov   @waux3,tmp0           ; Get new YX position
     693E 8340 
0154 6940 C1E0  34         mov   @waux2,tmp3
     6942 833E 
0155 6944 0227  22         ai    tmp3,-6               ; Back to P1
     6946 FFFA 
0156 6948 1014  14         jmp   putbo8
0157               *--------------------------------------------------------------
0158               *     Repeat vertically
0159               *--------------------------------------------------------------
0160 694A 06C4  14 putbo4  swpb  tmp0                  ; AB
0161 694C D104  18         movb  tmp0,tmp0             ; A = 0 ?
0162 694E 13EA  14         jeq   putbo3                ; Yes, check next entry in list
0163 6950 0224  22         ai    tmp0,->0100           ; A = A - 1
     6952 FF00 
0164 6954 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     6956 833C 
0165 6958 C1E0  34         mov   @waux2,tmp3           ; \
     695A 833E 
0166 695C 0607  14         dec   tmp3                  ; / Back to P3LB
0167 695E D817  46         movb  *tmp3,@waux1+1        ; Update B repeat count
     6960 833D 
0168 6962 D106  18         movb  tmp2,tmp0             ; New Y position
0169 6964 06C4  14         swpb  tmp0
0170 6966 0227  22         ai    tmp3,-6               ; Back to P0LB
     6968 FFFA 
0171 696A D137  28         movb  *tmp3+,tmp0
0172 696C 06C4  14         swpb  tmp0
0173 696E C804  38         mov   tmp0,@waux3           ; Set new YX position
     6970 8340 
0174               *--------------------------------------------------------------
0175               *      Get Height, Width and reset string pointer
0176               *--------------------------------------------------------------
0177 6972 C157  26 putbo8  mov   *tmp3,tmp1            ; Get P1 into TMP1
0178 6974 C1B7  30         mov   *tmp3+,tmp2           ; Get P1 into TMP2
0179 6976 C1D7  26         mov   *tmp3,tmp3            ; Get P2 into TMP3
0180 6978 10AC  14         jmp   putbo0                ; Next box
0181               *--------------------------------------------------------------
0182               *  Next entry in list
0183               *--------------------------------------------------------------
0184 697A C2E0  34 putbo9  mov   @waux2,r11            ; Restore R11
     697C 833E 
0185 697E 881B  46         c     *r11,@w$ffff          ; End-Of-List marker found ?
     6980 604C 
0186 6982 1301  14         jeq   putboa                ; Yes, exit
0187 6984 109E  14         jmp   putbox                ; Next one
0188 6986 0A22  56 putboa  sla   config,2              ; \ clear config bits 0 & 1
0189 6988 0922  56         srl   config,2              ; / is only 4 bytes
0190 698A 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0154               
0156                       copy  "vdp_viewport.asm"         ; VDP viewport functionality
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
0013 698C C83B  50 scrdim  mov   *r11+,@wbase          ; VDP destination address
     698E 8328 
0014 6990 C83B  50         mov   *r11+,@wcolmn         ; Number of columns per row
     6992 833A 
0015 6994 045B  20         b     *r11                  ; Exit
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
0045 6996 C23B  30 view    mov   *r11+,tmp4            ; P0: Get pointer to RAM buffer
0046 6998 C620  46         mov   @wbase,*tmp4          ; RAM 01 - Save physical screen VRAM base
     699A 8328 
0047 699C CA20  54         mov   @wcolmn,@2(tmp4)      ; RAM 23 - Save physical screen size (columns per row)
     699E 833A 
     69A0 0002 
0048 69A2 CA3B  50         mov   *r11+,@4(tmp4)        ; RAM 45 - P1: Get viewport upper left corner YX
     69A4 0004 
0049 69A6 C1FB  30         mov   *r11+,tmp3            ;
0050 69A8 CA07  38         mov   tmp3,@6(tmp4)         ; RAM 67 - P2: Get viewport height & width
     69AA 0006 
0051 69AC C83B  50         mov   *r11+,@waux1          ; P3: Get virtual screen VRAM base address
     69AE 833C 
0052 69B0 C83B  50         mov   *r11+,@waux2          ; P4: Get virtual screen size (columns per row)
     69B2 833E 
0053 69B4 C804  38         mov   tmp0,@waux3           ; Get upper left corner YX in virtual screen
     69B6 8340 
0054 69B8 CA0B  38         mov   r11,@8(tmp4)          ; RAM 89 - Store R11 for exit
     69BA 0008 
0055 69BC 0A12  56         sla   config,1              ; \
0056 69BE 0912  56         srl   config,1              ; / Clear CONFIG bits 0
0057 69C0 0987  56         srl   tmp3,8                ; Row counter
0058               *--------------------------------------------------------------
0059               *    Set virtual screen dimension and position cursor
0060               *--------------------------------------------------------------
0061 69C2 C820  54 view1   mov   @waux1,@wbase         ; Set virtual screen base
     69C4 833C 
     69C6 8328 
0062 69C8 C820  54         mov   @waux2,@wcolmn        ; Set virtual screen width
     69CA 833E 
     69CC 833A 
0063 69CE C820  54         mov   @waux3,@wyx           ; Set cursor in virtual screen
     69D0 8340 
     69D2 832A 
0064               *--------------------------------------------------------------
0065               *    Prepare for copying a single line
0066               *--------------------------------------------------------------
0067 69D4 06A0  32 view2   bl    @yx2pnt               ; Get VRAM address in TMP0
     69D6 63FE 
0068 69D8 C148  18         mov   tmp4,tmp1             ; RAM buffer + 10
0069 69DA 0225  22         ai    tmp1,10               ;
     69DC 000A 
0070 69DE C1A8  34         mov   @6(tmp4),tmp2         ; \ Get RAM buffer byte 1
     69E0 0006 
0071 69E2 0246  22         andi  tmp2,>00ff            ; / Clear MSB
     69E4 00FF 
0072 69E6 28A0  34         xor   @wbit0,config         ; Toggle bit 0
     69E8 604A 
0073 69EA 24A0  38         czc   @wbit0,config         ; Bit 0=0 ?
     69EC 604A 
0074 69EE 130B  14         jeq   view4                 ; Yes! So copy from RAM to VRAM
0075               *--------------------------------------------------------------
0076               *    Copy line from VRAM to RAM
0077               *--------------------------------------------------------------
0078 69F0 06A0  32 view3   bl    @xpyv2m               ; Copy block from VRAM (virtual screen) to RAM
     69F2 6468 
0079 69F4 C818  46         mov   *tmp4,@wbase          ; Set physical screen base
     69F6 8328 
0080 69F8 C828  54         mov   @2(tmp4),@wcolmn      ; Set physical screen columns per row
     69FA 0002 
     69FC 833A 
0081 69FE C828  54         mov   @4(tmp4),@wyx         ; Set cursor in physical screen
     6A00 0004 
     6A02 832A 
0082 6A04 10E7  14         jmp   view2
0083               *--------------------------------------------------------------
0084               *    Copy line from RAM to VRAM
0085               *--------------------------------------------------------------
0086 6A06 06A0  32 view4   bl    @xpym2v               ; Copy block to VRAM
     6A08 6442 
0087 6A0A BA20  54         ab    @hb$01,@4(tmp4)       ; Physical screen Y=Y+1
     6A0C 603C 
     6A0E 0004 
0088 6A10 B820  54         ab    @hb$01,@waux3         ; Virtual screen  Y=Y+1
     6A12 603C 
     6A14 8340 
0089 6A16 0607  14         dec   tmp3                  ; Update row counter
0090 6A18 16D4  14         jne   view1                 ; Next line unless all rows process
0091               *--------------------------------------------------------------
0092               *    Exit
0093               *--------------------------------------------------------------
0094 6A1A C2E8  34 viewz   mov   @8(tmp4),r11          ; \
     6A1C 0008 
0095 6A1E 045B  20         b     *r11                  ; / exit
**** **** ****     > runlib.asm
0158               
0160                       copy  "snd_player.asm"           ; Sound player
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
0014 6A20 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     6A22 8334 
0015 6A24 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     6A26 6030 
0016 6A28 0204  20         li    tmp0,muttab
     6A2A 6A3A 
0017 6A2C 0205  20         li    tmp1,sound            ; Sound generator port >8400
     6A2E 8400 
0018 6A30 D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 6A32 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 6A34 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 6A36 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 6A38 045B  20         b     *r11
0023 6A3A 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     6A3C DFFF 
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
0043 6A3E C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     6A40 8334 
0044 6A42 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     6A44 8336 
0045 6A46 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     6A48 FFF8 
0046 6A4A E0BB  30         soc   *r11+,config          ; Set options
0047 6A4C D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     6A4E 603C 
     6A50 831B 
0048 6A52 045B  20         b     *r11
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
0059 6A54 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     6A56 6030 
0060 6A58 1301  14         jeq   sdpla1                ; Yes, play
0061 6A5A 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 6A5C 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 6A5E 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     6A60 831B 
     6A62 602A 
0067 6A64 1301  14         jeq   sdpla3                ; Play next note
0068 6A66 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 6A68 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     6A6A 602C 
0070 6A6C 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 6A6E C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     6A70 8336 
0075 6A72 06C4  14         swpb  tmp0
0076 6A74 D804  38         movb  tmp0,@vdpa
     6A76 8C02 
0077 6A78 06C4  14         swpb  tmp0
0078 6A7A D804  38         movb  tmp0,@vdpa
     6A7C 8C02 
0079 6A7E 04C4  14         clr   tmp0
0080 6A80 D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     6A82 8800 
0081 6A84 131E  14         jeq   sdexit                ; Yes. exit
0082 6A86 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 6A88 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     6A8A 8336 
0084 6A8C D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     6A8E 8800 
     6A90 8400 
0085 6A92 0604  14         dec   tmp0
0086 6A94 16FB  14         jne   vdpla2
0087 6A96 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     6A98 8800 
     6A9A 831B 
0088 6A9C 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     6A9E 8336 
0089 6AA0 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 6AA2 C120  34 mmplay  mov   @wsdtmp,tmp0
     6AA4 8336 
0094 6AA6 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 6AA8 130C  14         jeq   sdexit                ; Yes, exit
0096 6AAA 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 6AAC A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     6AAE 8336 
0098 6AB0 D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     6AB2 8400 
0099 6AB4 0605  14         dec   tmp1
0100 6AB6 16FC  14         jne   mmpla2
0101 6AB8 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     6ABA 831B 
0102 6ABC 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     6ABE 8336 
0103 6AC0 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 6AC2 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     6AC4 602E 
0108 6AC6 1607  14         jne   sdexi2                ; No, exit
0109 6AC8 C820  54         mov   @wsdlst,@wsdtmp
     6ACA 8334 
     6ACC 8336 
0110 6ACE D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     6AD0 603C 
     6AD2 831B 
0111 6AD4 045B  20 sdexi1  b     *r11                  ; Exit
0112 6AD6 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     6AD8 FFF8 
0113 6ADA 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > runlib.asm
0162               
0164                       copy  "speech_detect.asm"        ; Detect speech synthesizer
**** **** ****     > speech_detect.asm
0001               * FILE......: speech_detect.asm
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
0020 6ADC 0204  20 spstat  li    tmp0,spchrd           ; (R4) = >9000
     6ADE 9000 
0021 6AE0 C820  54         mov   @spcode,@mcsprd       ; \
     6AE2 622A 
     6AE4 8322 
0022 6AE6 C820  54         mov   @spcode+2,@mcsprd+2   ; / Load speech read code
     6AE8 622C 
     6AEA 8324 
0023 6AEC 020B  20         li    r11,spsta1            ; Return to SPSTA1
     6AEE 6AF4 
0024 6AF0 0460  28         b     @mcsprd               ; Run scratchpad code
     6AF2 8322 
0025 6AF4 C820  54 spsta1  mov   @mccode,@mcsprd       ; \
     6AF6 6224 
     6AF8 8322 
0026 6AFA C820  54         mov   @mccode+2,@mcsprd+2   ; / Restore tight loop code
     6AFC 6226 
     6AFE 8324 
0027 6B00 0456  20         b     *tmp2                 ; Exit
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
0047 6B02 C1CB  18 spconn  mov   r11,tmp3              ; Save R11
0048               *--------------------------------------------------------------
0049               * Setup speech synthesizer memory address >0000
0050               *--------------------------------------------------------------
0051 6B04 0204  20         li    tmp0,>4000            ; Load >40 (speech memory address command)
     6B06 4000 
0052 6B08 0205  20         li    tmp1,5                ; Process 5 nibbles in total
     6B0A 0005 
0053 6B0C D804  38 spcon1  movb  tmp0,@spchwt          ; Write nibble >40 (5x)
     6B0E 9400 
0054 6B10 0605  14         dec   tmp1
0055 6B12 16FC  14         jne   spcon1
0056               *--------------------------------------------------------------
0057               * Read first byte from speech synthesizer memory address >0000
0058               *--------------------------------------------------------------
0059 6B14 0204  20         li    tmp0,>1000
     6B16 1000 
0060 6B18 D804  38         movb  tmp0,@spchwt          ; Load >10 (speech memory read command)
     6B1A 9400 
0061 6B1C 1000  14         nop                         ; \
0062 6B1E 1000  14         nop                         ; / 12 Microseconds delay
0063 6B20 0206  20         li    tmp2,spcon2
     6B22 6B28 
0064 6B24 0460  28         b     @spstat               ; Read status byte
     6B26 6ADC 
0065               *--------------------------------------------------------------
0066               * Update status bit 5 in CONFIG register
0067               *--------------------------------------------------------------
0068 6B28 0984  56 spcon2  srl   tmp0,8                ; MSB to LSB
0069 6B2A 0284  22         ci    tmp0,>00aa            ; >aa means speech found
     6B2C 00AA 
0070 6B2E 1603  14         jne   spcon3
0071 6B30 E0A0  34         soc   @wbit5,config         ; Set config bit5=1
     6B32 6040 
0072 6B34 1002  14         jmp   spcon4
0073 6B36 40A0  34 spcon3  szc   @wbit5,config         ; Set config bit5=0
     6B38 6040 
0074 6B3A 0457  20 spcon4  b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0166               
0168                       copy  "speech_player.asm"        ; Speech synthesizer player
**** **** ****     > speech_player.asm
0001               ***************************************************************
0002               * FILE......: speech_player.asm
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
0017 6B3C C83B  50 spprep  mov   *r11+,@wspeak         ; Set speech address
     6B3E 8338 
0018 6B40 E0A0  34         soc   @wbit3,config         ; Clear bit 3
     6B42 6044 
0019 6B44 045B  20         b     *r11
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
0030 6B46 24A0  38 spplay  czc   @wbit3,config         ; Player off ?
     6B48 6044 
0031 6B4A 132F  14         jeq   spplaz                ; Yes, exit
0032 6B4C C1CB  18 sppla1  mov   r11,tmp3              ; Save R11
0033 6B4E 20A0  38         coc   @tmp010,config        ; Speech player enabled+busy ?
     6B50 6BAC 
0034 6B52 1310  14         jeq   spkex3                ; Check FIFO buffer level
0035               *--------------------------------------------------------------
0036               * Speak external: Push LPC data to speech synthesizer
0037               *--------------------------------------------------------------
0038 6B54 C120  34 spkext  mov   @wspeak,tmp0
     6B56 8338 
0039 6B58 D834  48         movb  *tmp0+,@spchwt        ; Send byte to speech synth
     6B5A 9400 
0040 6B5C 1000  14         jmp   $+2                   ; Delay
0041 6B5E 0206  20         li    tmp2,16
     6B60 0010 
0042 6B62 D834  48 spkex1  movb  *tmp0+,@spchwt        ; Send byte to speech synth
     6B64 9400 
0043 6B66 0606  14         dec   tmp2
0044 6B68 16FC  14         jne   spkex1
0045 6B6A 0262  22         ori   config,>0800          ; bit 4=1 (busy)
     6B6C 0800 
0046 6B6E C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     6B70 8338 
0047 6B72 101B  14         jmp   spplaz                ; Exit
0048               *--------------------------------------------------------------
0049               * Speak external: Check synth FIFO buffer level
0050               *--------------------------------------------------------------
0051 6B74 0206  20 spkex3  li    tmp2,spkex4           ; Set return address for SPSTAT
     6B76 6B7C 
0052 6B78 0460  28         b     @spstat               ; Get speech FIFO buffer status
     6B7A 6ADC 
0053 6B7C 2120  38 spkex4  coc   @w$4000,tmp0          ; FIFO BL (buffer low) bit set?
     6B7E 6048 
0054 6B80 1301  14         jeq   spkex5                ; Yes, refill
0055 6B82 1013  14         jmp   spplaz                ; No, exit
0056               *--------------------------------------------------------------
0057               * Speak external: Refill synth with LPC data if FIFO buffer low
0058               *--------------------------------------------------------------
0059 6B84 C120  34 spkex5  mov   @wspeak,tmp0
     6B86 8338 
0060 6B88 0206  20         li    tmp2,8                ; Bytes to send to speech synth
     6B8A 0008 
0061 6B8C D174  28 spkex6  movb  *tmp0+,tmp1
0062 6B8E D805  38         movb  tmp1,@spchwt          ; Send byte to speech synth
     6B90 9400 
0063 6B92 0285  22         ci    tmp1,spkoff           ; Speak off marker found ?
     6B94 FF00 
0064 6B96 1305  14         jeq   spkex8
0065 6B98 0606  14         dec   tmp2
0066 6B9A 16F8  14         jne   spkex6                ; Send next byte
0067 6B9C C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     6B9E 8338 
0068 6BA0 1004  14 spkex7  jmp   spplaz                ; Exit
0069               *--------------------------------------------------------------
0070               * Speak external: Done with speaking
0071               *--------------------------------------------------------------
0072 6BA2 40A0  34 spkex8  szc   @tmp010,config        ; bit 3,4,5=0
     6BA4 6BAC 
0073 6BA6 04E0  34         clr   @wspeak               ; Reset pointer
     6BA8 8338 
0074 6BAA 0457  20 spplaz  b     *tmp3                 ; Exit
0075 6BAC 1800     tmp010  data  >1800                 ; Binary 0001100000000000
0076                                                   ; Bit    0123456789ABCDEF
**** **** ****     > runlib.asm
0170               
0172                       copy  "keyb_virtual.asm"         ; Virtual keyboard scanning
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
0088 6BAE 40A0  34         szc   @wbit11,config        ; Reset ANY key
     6BB0 6034 
0089 6BB2 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 6BB4 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 6BB6 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 6BB8 0207  20         li    tmp3,kbmap0           ; Start with column 0
     6BBA 6C2A 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 6BBC 04CC  14         clr   r12
0097 6BBE 1E15  20         sbz   >0015                 ; Set P5
0098 6BC0 1F07  20         tb    7
0099 6BC2 1302  14         jeq   virtk1
0100 6BC4 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     6BC6 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 6BC8 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 6BCA 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     6BCC 0024 
0107 6BCE 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 6BD0 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     6BD2 0006 
0109 6BD4 0705  14         seto  tmp1                  ; >FFFF
0110 6BD6 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 6BD8 0545  14         inv   tmp1
0112 6BDA 1302  14         jeq   virtk2                ; >0000 ?
0113 6BDC E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     6BDE 6034 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 6BE0 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 6BE2 1601  14         jne   virtk3
0119 6BE4 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 6BE6 05C7  14 virtk3  inct  tmp3
0121 6BE8 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     6BEA 6C36 
0122 6BEC 16F9  14         jne   virtk2                ; No, next entry
0123 6BEE 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 6BF0 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     6BF2 0700 
0128 6BF4 1309  14         jeq   virtk6                ; Yes, exit
0129 6BF6 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     6BF8 0200 
0130 6BFA 1303  14         jeq   virtk5                ; Yes, skip
0131 6BFC 0224  22         ai    tmp0,>0100
     6BFE 0100 
0132 6C00 10E3  14         jmp   virtk1
0133 6C02 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     6C04 0500 
0134 6C06 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 6C08 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 6C0A C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     6C0C 8332 
0140 6C0E 1601  14         jne   virtk7
0141 6C10 045B  20         b     *r11                  ; Exit
0142 6C12 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     6C14 FFFF 
0143 6C16 1603  14         jne   virtk8                ; No
0144 6C18 0701  14         seto  r1                    ; Set exit flag
0145 6C1A 0460  28         b     @runli1               ; Yes, reset computer
     6C1C 760C 
0146 6C1E 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     6C20 8000 
0147 6C22 1602  14         jne   virtk9
0148 6C24 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     6C26 6034 
0149 6C28 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 6C2A 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     6C2C FFFF 
0155 6C2E 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     6C30 0020 
0156 6C32 0400             data  >0400,kenter          ; >04 00000100  enter
     6C34 4000 
0157 6C36 FFFF     kbeoc   data  >ffff
0158               
0159 6C38 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     6C3A 1000 
0160 6C3C 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     6C3E 0008 
0161 6C40 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     6C42 0004 
0162 6C44 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     6C46 0200 
0163 6C48 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     6C4A 0040 
0164 6C4C FFFF             data  >ffff
0165               
0166 6C4E 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     6C50 2000 
0167 6C52 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6C54 0002 
0168 6C56 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6C58 0100 
0169 6C5A 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     6C5C 0080 
0170 6C5E 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     6C60 0010 
0171 6C62 FFFF             data  >ffff
0172               
0173 6C64 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     6C66 0001 
0174 6C68 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     6C6A 0800 
0175 6C6C 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     6C6E 0020 
0176 6C70 FFFF             data  >ffff
0177               
0178 6C72 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     6C74 0020 
0179 6C76 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     6C78 0200 
0180 6C7A 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     6C7C 0100 
0181 6C7E 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     6C80 0040 
0182 6C82 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     6C84 0080 
0183 6C86 FFFF             data  >ffff
0184               
0185 6C88 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     6C8A 0001 
0186 6C8C 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     6C8E 0010 
0187 6C90 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     6C92 0008 
0188 6C94 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     6C96 0002 
0189 6C98 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     6C9A 0004 
0190 6C9C FFFF             data  >ffff
**** **** ****     > runlib.asm
0174               
0176                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 6C9E 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6CA0 604A 
0017 6CA2 020C  20         li    r12,>0024
     6CA4 0024 
0018 6CA6 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6CA8 6D36 
0019 6CAA 04C6  14         clr   tmp2
0020 6CAC 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6CAE 04CC  14         clr   r12
0025 6CB0 1F08  20         tb    >0008                 ; Shift-key ?
0026 6CB2 1302  14         jeq   realk1                ; No
0027 6CB4 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6CB6 6D66 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6CB8 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6CBA 1302  14         jeq   realk2                ; No
0033 6CBC 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6CBE 6D96 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6CC0 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6CC2 1302  14         jeq   realk3                ; No
0039 6CC4 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6CC6 6DC6 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6CC8 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6CCA 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6CCC 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6CCE E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6CD0 604A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6CD2 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6CD4 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6CD6 0006 
0052 6CD8 0606  14 realk5  dec   tmp2
0053 6CDA 020C  20         li    r12,>24               ; CRU address for P2-P4
     6CDC 0024 
0054 6CDE 06C6  14         swpb  tmp2
0055 6CE0 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6CE2 06C6  14         swpb  tmp2
0057 6CE4 020C  20         li    r12,6                 ; CRU read address
     6CE6 0006 
0058 6CE8 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6CEA 0547  14         inv   tmp3                  ;
0060 6CEC 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6CEE FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6CF0 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6CF2 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6CF4 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6CF6 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6CF8 0285  22         ci    tmp1,8
     6CFA 0008 
0069 6CFC 1AFA  14         jl    realk6
0070 6CFE C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6D00 1BEB  14         jh    realk5                ; No, next column
0072 6D02 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6D04 C206  18 realk8  mov   tmp2,tmp4
0077 6D06 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6D08 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6D0A A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6D0C D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6D0E 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6D10 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6D12 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6D14 604A 
0087 6D16 1608  14         jne   realka                ; No, continue saving key
0088 6D18 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6D1A 6D60 
0089 6D1C 1A05  14         jl    realka
0090 6D1E 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6D20 6D5E 
0091 6D22 1B02  14         jh    realka                ; No, continue
0092 6D24 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6D26 E000 
0093 6D28 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6D2A 833C 
0094 6D2C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6D2E 6034 
0095 6D30 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6D32 8C00 
0096 6D34 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 6D36 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6D38 0000 
     6D3A FF0D 
     6D3C 203D 
0099 6D3E ....             text  'xws29ol.'
0100 6D46 ....             text  'ced38ik,'
0101 6D4E ....             text  'vrf47ujm'
0102 6D56 ....             text  'btg56yhn'
0103 6D5E ....             text  'zqa10p;/'
0104 6D66 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6D68 0000 
     6D6A FF0D 
     6D6C 202B 
0105 6D6E ....             text  'XWS@(OL>'
0106 6D76 ....             text  'CED#*IK<'
0107 6D7E ....             text  'VRF$&UJM'
0108 6D86 ....             text  'BTG%^YHN'
0109 6D8E ....             text  'ZQA!)P:-'
0110 6D96 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6D98 0000 
     6D9A FF0D 
     6D9C 2005 
0111 6D9E 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6DA0 0804 
     6DA2 0F27 
     6DA4 C2B9 
0112 6DA6 600B             data  >600b,>0907,>063f,>c1B8
     6DA8 0907 
     6DAA 063F 
     6DAC C1B8 
0113 6DAE 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6DB0 7B02 
     6DB2 015F 
     6DB4 C0C3 
0114 6DB6 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6DB8 7D0E 
     6DBA 0CC6 
     6DBC BFC4 
0115 6DBE 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6DC0 7C03 
     6DC2 BC22 
     6DC4 BDBA 
0116 6DC6 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6DC8 0000 
     6DCA FF0D 
     6DCC 209D 
0117 6DCE 9897             data  >9897,>93b2,>9f8f,>8c9B
     6DD0 93B2 
     6DD2 9F8F 
     6DD4 8C9B 
0118 6DD6 8385             data  >8385,>84b3,>9e89,>8b80
     6DD8 84B3 
     6DDA 9E89 
     6DDC 8B80 
0119 6DDE 9692             data  >9692,>86b4,>b795,>8a8D
     6DE0 86B4 
     6DE2 B795 
     6DE4 8A8D 
0120 6DE6 8294             data  >8294,>87b5,>b698,>888E
     6DE8 87B5 
     6DEA B698 
     6DEC 888E 
0121 6DEE 9A91             data  >9a91,>81b1,>b090,>9cBB
     6DF0 81B1 
     6DF2 B090 
     6DF4 9CBB 
**** **** ****     > runlib.asm
0178               
0180                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
**** **** ****     > cpu_hexsupport.asm
0001               * FILE......: cpu_hexsupport.asm
0002               * Purpose...: CPU create, display hex numbers module
0003               
0004               ***************************************************************
0005               * mkhex - Convert hex word to string
0006               ***************************************************************
0007               *  bl   @mkhex
0008               *       data P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = Pointer to 16 bit word
0011               *  P1 = Pointer to string buffer
0012               *  P2 = Offset for ASCII digit
0013               *       MSB determines offset for chars A-F
0014               *       LSB determines offset for chars 0-9
0015               *  (CONFIG#0 = 1) = Display number at cursor YX
0016               *--------------------------------------------------------------
0017               *  Memory usage:
0018               *  tmp0, tmp1, tmp2, tmp3, tmp4
0019               *  waux1, waux2, waux3
0020               *--------------------------------------------------------------
0021               *  Memory variables waux1-waux3 are used as temporary variables
0022               ********|*****|*********************|**************************
0023 6DF6 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6DF8 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6DFA 8340 
0025 6DFC 04E0  34         clr   @waux1
     6DFE 833C 
0026 6E00 04E0  34         clr   @waux2
     6E02 833E 
0027 6E04 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6E06 833C 
0028 6E08 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6E0A 0205  20         li    tmp1,4                ; 4 nibbles
     6E0C 0004 
0033 6E0E C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6E10 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6E12 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6E14 0286  22         ci    tmp2,>000a
     6E16 000A 
0039 6E18 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6E1A C21B  26         mov   *r11,tmp4
0045 6E1C 0988  56         srl   tmp4,8                ; Right justify
0046 6E1E 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6E20 FFF6 
0047 6E22 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6E24 C21B  26         mov   *r11,tmp4
0054 6E26 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6E28 00FF 
0055               
0056 6E2A A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6E2C 06C6  14         swpb  tmp2
0058 6E2E DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6E30 0944  56         srl   tmp0,4                ; Next nibble
0060 6E32 0605  14         dec   tmp1
0061 6E34 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6E36 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6E38 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6E3A C160  34         mov   @waux3,tmp1           ; Get pointer
     6E3C 8340 
0067 6E3E 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6E40 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6E42 C120  34         mov   @waux2,tmp0
     6E44 833E 
0070 6E46 06C4  14         swpb  tmp0
0071 6E48 DD44  32         movb  tmp0,*tmp1+
0072 6E4A 06C4  14         swpb  tmp0
0073 6E4C DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6E4E C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6E50 8340 
0078 6E52 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6E54 6040 
0079 6E56 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6E58 C120  34         mov   @waux1,tmp0
     6E5A 833C 
0084 6E5C 06C4  14         swpb  tmp0
0085 6E5E DD44  32         movb  tmp0,*tmp1+
0086 6E60 06C4  14         swpb  tmp0
0087 6E62 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6E64 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6E66 604A 
0092 6E68 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6E6A 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6E6C 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6E6E 7FFF 
0098 6E70 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6E72 8340 
0099 6E74 0460  28         b     @xutst0               ; Display string
     6E76 6424 
0100 6E78 0610     prefix  data  >0610                 ; Length byte + blank
0101               
0102               
0103               
0104               ***************************************************************
0105               * puthex - Put 16 bit word on screen
0106               ***************************************************************
0107               *  bl   @mkhex
0108               *       data P0,P1,P2,P3
0109               *--------------------------------------------------------------
0110               *  P0 = YX position
0111               *  P1 = Pointer to 16 bit word
0112               *  P2 = Pointer to string buffer
0113               *  P3 = Offset for ASCII digit
0114               *       MSB determines offset for chars A-F
0115               *       LSB determines offset for chars 0-9
0116               *--------------------------------------------------------------
0117               *  Memory usage:
0118               *  tmp0, tmp1, tmp2, tmp3
0119               *  waux1, waux2, waux3
0120               ********|*****|*********************|**************************
0121 6E7A C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6E7C 832A 
0122 6E7E 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6E80 8000 
0123 6E82 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0182               
0184                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 6E84 0207  20 mknum   li    tmp3,5                ; Digit counter
     6E86 0005 
0020 6E88 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6E8A C155  26         mov   *tmp1,tmp1            ; /
0022 6E8C C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6E8E 0228  22         ai    tmp4,4                ; Get end of buffer
     6E90 0004 
0024 6E92 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6E94 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6E96 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6E98 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6E9A 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6E9C B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6E9E D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6EA0 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6EA2 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6EA4 0607  14         dec   tmp3                  ; Decrease counter
0036 6EA6 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6EA8 0207  20         li    tmp3,4                ; Check first 4 digits
     6EAA 0004 
0041 6EAC 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6EAE C11B  26         mov   *r11,tmp0
0043 6EB0 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6EB2 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6EB4 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6EB6 05CB  14 mknum3  inct  r11
0047 6EB8 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6EBA 604A 
0048 6EBC 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6EBE 045B  20         b     *r11                  ; Exit
0050 6EC0 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6EC2 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6EC4 13F8  14         jeq   mknum3                ; Yes, exit
0053 6EC6 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6EC8 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6ECA 7FFF 
0058 6ECC C10B  18         mov   r11,tmp0
0059 6ECE 0224  22         ai    tmp0,-4
     6ED0 FFFC 
0060 6ED2 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6ED4 0206  20         li    tmp2,>0500            ; String length = 5
     6ED6 0500 
0062 6ED8 0460  28         b     @xutstr               ; Display string
     6EDA 6426 
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
0092 6EDC C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6EDE C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6EE0 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6EE2 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6EE4 0207  20         li    tmp3,5                ; Set counter
     6EE6 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6EE8 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6EEA 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6EEC 0584  14         inc   tmp0                  ; Next character
0104 6EEE 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6EF0 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6EF2 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6EF4 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6EF6 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6EF8 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6EFA DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6EFC 0607  14         dec   tmp3                  ; Last character ?
0120 6EFE 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6F00 045B  20         b     *r11                  ; Return
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
0138 6F02 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6F04 832A 
0139 6F06 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6F08 8000 
0140 6F0A 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0186               
0188                        copy  "cpu_crc16.asm"           ; CRC-16 checksum calculation
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
0029               calc_crc:
0030 6F0C C13B  30         mov   *r11+,wmemory         ; First memory address
0031 6F0E C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx:
0033 6F10 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 6F12 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * (1) Next word
0037               *--------------------------------------------------------------
0038               calc_crc1:
0039 6F14 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * (2) Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2:
0044 6F16 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 6F18 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 6F1A C1C8  18         mov   wcrc,tmp3
0048 6F1C 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 6F1E 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 6F20 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6F22 00FF 
0052               
0053 6F24 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 6F26 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 6F28 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6F2A 6F4E 
0056               *--------------------------------------------------------------
0057               * (3) Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3:
0060 6F2C C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 6F2E 0246  22         andi  tmp2,>00ff            ; Clear MSB
     6F30 00FF 
0062               
0063 6F32 C1C8  18         mov   wcrc,tmp3
0064 6F34 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 6F36 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 6F38 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6F3A 00FF 
0068               
0069 6F3C 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 6F3E 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 6F40 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6F42 6F4E 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 6F44 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 6F46 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 6F48 04C7  14         clr   tmp3
0081 6F4A 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082               calc_crc.exit:
0083 6F4C 045B  20         b     *r11                  ; Return
0084               
0085               
0086               
0087               ***************************************************************
0088               * CRC Lookup Table - 1024 bytes
0089               * http://www.sunshine2k.de/coding/javascript/crc/crc_js.html
0090               *--------------------------------------------------------------
0091               * Polynomial........: 0x1021
0092               * Initial value.....: 0x0
0093               * Final Xor value...: 0x0
0094               ***************************************************************
0095               crc_table
0096 6F4E 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     6F50 1021 
     6F52 2042 
     6F54 3063 
     6F56 4084 
     6F58 50A5 
     6F5A 60C6 
     6F5C 70E7 
0097 6F5E 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     6F60 9129 
     6F62 A14A 
     6F64 B16B 
     6F66 C18C 
     6F68 D1AD 
     6F6A E1CE 
     6F6C F1EF 
0098 6F6E 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     6F70 0210 
     6F72 3273 
     6F74 2252 
     6F76 52B5 
     6F78 4294 
     6F7A 72F7 
     6F7C 62D6 
0099 6F7E 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     6F80 8318 
     6F82 B37B 
     6F84 A35A 
     6F86 D3BD 
     6F88 C39C 
     6F8A F3FF 
     6F8C E3DE 
0100 6F8E 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     6F90 3443 
     6F92 0420 
     6F94 1401 
     6F96 64E6 
     6F98 74C7 
     6F9A 44A4 
     6F9C 5485 
0101 6F9E A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     6FA0 B54B 
     6FA2 8528 
     6FA4 9509 
     6FA6 E5EE 
     6FA8 F5CF 
     6FAA C5AC 
     6FAC D58D 
0102 6FAE 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     6FB0 2672 
     6FB2 1611 
     6FB4 0630 
     6FB6 76D7 
     6FB8 66F6 
     6FBA 5695 
     6FBC 46B4 
0103 6FBE B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     6FC0 A77A 
     6FC2 9719 
     6FC4 8738 
     6FC6 F7DF 
     6FC8 E7FE 
     6FCA D79D 
     6FCC C7BC 
0104 6FCE 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     6FD0 58E5 
     6FD2 6886 
     6FD4 78A7 
     6FD6 0840 
     6FD8 1861 
     6FDA 2802 
     6FDC 3823 
0105 6FDE C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     6FE0 D9ED 
     6FE2 E98E 
     6FE4 F9AF 
     6FE6 8948 
     6FE8 9969 
     6FEA A90A 
     6FEC B92B 
0106 6FEE 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     6FF0 4AD4 
     6FF2 7AB7 
     6FF4 6A96 
     6FF6 1A71 
     6FF8 0A50 
     6FFA 3A33 
     6FFC 2A12 
0107 6FFE DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     7000 CBDC 
     7002 FBBF 
     7004 EB9E 
     7006 9B79 
     7008 8B58 
     700A BB3B 
     700C AB1A 
0108 700E 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     7010 7C87 
     7012 4CE4 
     7014 5CC5 
     7016 2C22 
     7018 3C03 
     701A 0C60 
     701C 1C41 
0109 701E EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     7020 FD8F 
     7022 CDEC 
     7024 DDCD 
     7026 AD2A 
     7028 BD0B 
     702A 8D68 
     702C 9D49 
0110 702E 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     7030 6EB6 
     7032 5ED5 
     7034 4EF4 
     7036 3E13 
     7038 2E32 
     703A 1E51 
     703C 0E70 
0111 703E FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     7040 EFBE 
     7042 DFDD 
     7044 CFFC 
     7046 BF1B 
     7048 AF3A 
     704A 9F59 
     704C 8F78 
0112 704E 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     7050 81A9 
     7052 B1CA 
     7054 A1EB 
     7056 D10C 
     7058 C12D 
     705A F14E 
     705C E16F 
0113 705E 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     7060 00A1 
     7062 30C2 
     7064 20E3 
     7066 5004 
     7068 4025 
     706A 7046 
     706C 6067 
0114 706E 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     7070 9398 
     7072 A3FB 
     7074 B3DA 
     7076 C33D 
     7078 D31C 
     707A E37F 
     707C F35E 
0115 707E 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     7080 1290 
     7082 22F3 
     7084 32D2 
     7086 4235 
     7088 5214 
     708A 6277 
     708C 7256 
0116 708E B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     7090 A5CB 
     7092 95A8 
     7094 8589 
     7096 F56E 
     7098 E54F 
     709A D52C 
     709C C50D 
0117 709E 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     70A0 24C3 
     70A2 14A0 
     70A4 0481 
     70A6 7466 
     70A8 6447 
     70AA 5424 
     70AC 4405 
0118 70AE A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     70B0 B7FA 
     70B2 8799 
     70B4 97B8 
     70B6 E75F 
     70B8 F77E 
     70BA C71D 
     70BC D73C 
0119 70BE 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     70C0 36F2 
     70C2 0691 
     70C4 16B0 
     70C6 6657 
     70C8 7676 
     70CA 4615 
     70CC 5634 
0120 70CE D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     70D0 C96D 
     70D2 F90E 
     70D4 E92F 
     70D6 99C8 
     70D8 89E9 
     70DA B98A 
     70DC A9AB 
0121 70DE 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     70E0 4865 
     70E2 7806 
     70E4 6827 
     70E6 18C0 
     70E8 08E1 
     70EA 3882 
     70EC 28A3 
0122 70EE CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     70F0 DB5C 
     70F2 EB3F 
     70F4 FB1E 
     70F6 8BF9 
     70F8 9BD8 
     70FA ABBB 
     70FC BB9A 
0123 70FE 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     7100 5A54 
     7102 6A37 
     7104 7A16 
     7106 0AF1 
     7108 1AD0 
     710A 2AB3 
     710C 3A92 
0124 710E FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     7110 ED0F 
     7112 DD6C 
     7114 CD4D 
     7116 BDAA 
     7118 AD8B 
     711A 9DE8 
     711C 8DC9 
0125 711E 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     7120 6C07 
     7122 5C64 
     7124 4C45 
     7126 3CA2 
     7128 2C83 
     712A 1CE0 
     712C 0CC1 
0126 712E EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     7130 FF3E 
     7132 CF5D 
     7134 DF7C 
     7136 AF9B 
     7138 BFBA 
     713A 8FD9 
     713C 9FF8 
0127 713E 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     7140 7E36 
     7142 4E55 
     7144 5E74 
     7146 2E93 
     7148 3EB2 
     714A 0ED1 
     714C 1EF0 
**** **** ****     > runlib.asm
0190               
0192                       copy  "cpu_rle_compress.asm"     ; CPU RLE compression support
**** **** ****     > cpu_rle_compress.asm
0001               * FILE......: cpu_rle_compress.asm
0002               * Purpose...: RLE compression support
0003               
0004               ***************************************************************
0005               * cpu2rle - RLE compress CPU memory
0006               ***************************************************************
0007               *  bl   @cpu2rle
0008               *       data P0,P1,P2
0009               *--------------------------------------------------------------
0010               *  P0 = ROM/RAM source address
0011               *  P1 = RAM target address
0012               *  P2 = Length uncompressed data
0013               *
0014               *  Output:
0015               *  waux1 = Length of RLE encoded string
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu2rle
0018               *
0019               *  TMP0  = ROM/RAM source address
0020               *  TMP1  = RAM target address
0021               *  TMP2  = Length uncompressed data
0022               *
0023               *  Output:
0024               *  waux1 = Length of RLE encoded string
0025               *--------------------------------------------------------------
0026               *  Memory usage:
0027               *  tmp0, tmp1, tmp2, tmp3, tmp4
0028               *  waux1, waux2, waux3
0029               *--------------------------------------------------------------
0030               *  Detail on RLE compression format:
0031               *  - If high bit is set, remaining 7 bits indicate to copy
0032               *    the next byte that many times.
0033               *  - If high bit is clear, remaining 7 bits indicate how many
0034               *    data bytes (non-repeated) follow.
0035               *
0036               *  Part of string is considered for RLE compression as soon as
0037               *  the same char is repeated 3 times.
0038               *
0039               *  Implementation workflow:
0040               *  (1) Scan string from left to right:
0041               *      (1.1) Compare lookahead char with current char.
0042               *            - Jump to (1.2) if it's not a repeated character.
0043               *            - If repeated char count = 0 then check 2nd lookahead
0044               *              char. If it's a repeated char again then jump to (1.3)
0045               *              else handle as non-repeated char (1.2)
0046               *            - If repeated char count > 0 then handle as repeated char (1.3)
0047               *
0048               *      (1.2) It's not a repeated character:
0049               *            (1.2.1) Check if any pending repeated character
0050               *            (1.2.2) If yes, flush pending to output buffer (=RLE encode)
0051               *            (1.2.3) Track address of future encoding byte
0052               *            (1.2.4) Append data byte to output buffer and jump to (2)
0053               *
0054               *      (1.3) It's a repeated character:
0055               *            (1.3.1) Check if any pending non-repeated character
0056               *            (1.3.2) If yes, set encoding byte before first data byte
0057               *            (1.3.3) Increase repetition counter and jump to (2)
0058               *
0059               *  (2) Process next character
0060               *      (2.1) Jump back to (1.1) unless end of string reached
0061               *
0062               *  (3) End of string reached:
0063               *      (3.1) Check if pending repeated character
0064               *      (3.2) If yes, flush pending to output buffer (=RLE encode)
0065               *      (3.3) Check if pending non-repeated character
0066               *      (3.4) If yes, set encoding byte before first data byte
0067               *
0068               *  (4) Exit
0069               *--------------------------------------------------------------
0070               
0071               
0072               ********|*****|*********************|**************************
0073               cpu2rle:
0074 714E C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 7150 C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 7152 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 7154 0649  14         dect  stack
0079 7156 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 7158 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 715A 04C8  14         clr   tmp4                  ; Repeat counter
0086 715C 04E0  34         clr   @waux1                ; Length of RLE string
     715E 833C 
0087 7160 04E0  34         clr   @waux2                ; Address of encoding byte
     7162 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 7164 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 7166 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 7168 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 716A 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 716C C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 716E 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 7170 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     7172 0001 
0105 7174 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 7176 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 7178 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 717A 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 717C 06A0  32         bl    @cpu2rle.flush.duplicates
     717E 71C8 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 7180 C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     7182 833E 
     7184 833E 
0126 7186 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 7188 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     718A 833E 
0129 718C 0585  14         inc   tmp1                  ; Skip encoding byte
0130 718E 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     7190 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 7192 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 7194 05A0  34         inc   @waux1                ; RLE string length += 1
     7196 833C 
0136 7198 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 719A C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     719C 833E 
     719E 833E 
0145 71A0 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 71A2 06A0  32         bl    @cpu2rle.flush.encoding_byte
     71A4 71E2 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 71A6 0588  14         inc   tmp4                  ; Increase repeat counter
0155 71A8 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 71AA 0606  14         dec   tmp2
0162 71AC 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 71AE C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 71B0 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 71B2 06A0  32         bl    @cpu2rle.flush.duplicates
     71B4 71C8 
0175                                                   ; (3.2) Flush pending ...
0176 71B6 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 71B8 C820  54         mov   @waux2,@waux2
     71BA 833E 
     71BC 833E 
0182 71BE 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 71C0 06A0  32         bl    @cpu2rle.flush.encoding_byte
     71C2 71E2 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 71C4 0460  28         b     @poprt                ; Return
     71C6 6236 
0192               
0193               
0194               
0195               
0196               *****************************************************************
0197               * Helper routines called internally
0198               *****************************************************************
0199               
0200               *--------------------------------------------------------------
0201               * Flush duplicate to output buffer (=RLE encode)
0202               *--------------------------------------------------------------
0203               cpu2rle.flush.duplicates:
0204 71C8 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 71CA D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 71CC 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 71CE 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     71D0 8000 
0210 71D2 DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 71D4 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 71D6 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 71D8 05E0  34         inct  @waux1                ; RLE string length += 2
     71DA 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 71DC 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 71DE 04C8  14         clr   tmp4                  ; Clear repeat count
0220 71E0 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 71E2 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 71E4 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 71E6 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 71E8 61E0  34         s     @waux2,tmp3           ; | characters
     71EA 833E 
0232 71EC 0607  14         dec   tmp3                  ; /
0233               
0234 71EE 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 71F0 C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     71F2 833E 
0236 71F4 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 71F6 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 71F8 04E0  34         clr   @waux2                ; Reset address of encoding byte
     71FA 833E 
0240 71FC 04C8  14         clr   tmp4                  ; Clear before exit
0241 71FE 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0194               
0196                       copy  "cpu_rle_decompress.asm"   ; CPU RLE decompression support
**** **** ****     > cpu_rle_decompress.asm
0001               * FILE......: cpu_rle_decompress.asm
0002               * Purpose...: RLE decompression support
0003               
0004               
0005               ***************************************************************
0006               * rl2cpu - RLE decompress to CPU memory
0007               ***************************************************************
0008               *  bl   @rle2cpu
0009               *       data P0,P1,P2
0010               *--------------------------------------------------------------
0011               *  P0 = ROM/RAM source address
0012               *  P1 = RAM target address
0013               *  P2 = Length of RLE encoded data
0014               *--------------------------------------------------------------
0015               *  bl   @xrle2cpu
0016               *
0017               *  TMP0 = ROM/RAM source address
0018               *  TMP1 = RAM target address
0019               *  TMP2 = Length of RLE encoded data
0020               *--------------------------------------------------------------
0021               *  Detail on RLE compression format:
0022               *  - If high bit is set, remaining 7 bits indicate to copy
0023               *    the next byte that many times.
0024               *  - If high bit is clear, remaining 7 bits indicate how many
0025               *    data bytes (non-repeated) follow.
0026               *--------------------------------------------------------------
0027               
0028               
0029               ********|*****|*********************|**************************
0030               rle2cpu:
0031 7200 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 7202 C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 7204 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 7206 0649  14         dect  stack
0036 7208 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 720A D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 720C 0606  14         dec   tmp2                  ; Update length
0043 720E 131E  14         jeq   rle2cpu.exit          ; End of list
0044 7210 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 7212 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 7214 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 7216 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 7218 0649  14         dect  stack
0055 721A C646  30         mov   tmp2,*stack           ; Push tmp2
0056 721C C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 721E 06A0  32         bl    @xpym2m               ; Block copy to destination
     7220 648A 
0059                                                   ; \ i  tmp0 = Source address
0060                                                   ; | i  tmp1 = Target address
0061                                                   ; / i  tmp2 = Bytes to copy
0062               
0063 7222 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 7224 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 7226 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 7228 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 722A 0649  14         dect  stack
0073 722C C645  30         mov   tmp1,*stack           ; Push tmp1
0074 722E 0649  14         dect  stack
0075 7230 C646  30         mov   tmp2,*stack           ; Push tmp2
0076 7232 0649  14         dect  stack
0077 7234 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 7236 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 7238 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 723A 0985  56         srl   tmp1,8                ; Right align
0082               
0083 723C 06A0  32         bl    @xfilm                ; Block fill to destination
     723E 6240 
0084                                                   ; \ i  tmp0 = Target address
0085                                                   ; | i  tmp1 = Byte to fill
0086                                                   ; / i  tmp2 = Repeat count
0087               
0088 7240 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 7242 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 7244 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 7246 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 7248 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 724A 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 724C 0460  28         b     @poprt                ; Return
     724E 6236 
**** **** ****     > runlib.asm
0198               
0200                       copy  "vdp_rle_decompress.asm"   ; VDP RLE decompression support
**** **** ****     > vdp_rle_decompress.asm
0001               * FILE......: rle_decompress.asm
0002               * Purpose...: RLE decompression support
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
0026 7250 C1BB  30 rle2v   mov   *r11+,tmp2            ; ROM/RAM source address
0027 7252 C13B  30         mov   *r11+,tmp0            ; VDP target address
0028 7254 C1FB  30         mov   *r11+,tmp3            ; Length of RLE encoded data
0029 7256 C80B  38         mov   r11,@waux1            ; Save return address
     7258 833C 
0030 725A 06A0  32 rle2vx  bl    @vdwa                 ; Setup VDP address from TMP0
     725C 62BA 
0031 725E C106  18         mov   tmp2,tmp0             ; We can safely reuse TMP0 now
0032 7260 D1B4  28 rle2v0  movb  *tmp0+,tmp2           ; Get control byte into TMP2
0033 7262 0607  14         dec   tmp3                  ; Update length
0034 7264 1314  14         jeq   rle2vz                ; End of list
0035 7266 0A16  56         sla   tmp2,1                ; Check bit 0 of control byte
0036 7268 1808  14         joc   rle2v2                ; Yes, next byte is compressed
0037               *--------------------------------------------------------------
0038               *    Dump uncompressed bytes
0039               *--------------------------------------------------------------
0040 726A C820  54 rle2v1  mov   @rledat,@mcloop       ; Setup machine code (MOVB *TMP0+,*R15)
     726C 7294 
     726E 8320 
0041 7270 0996  56         srl   tmp2,9                ; Use control byte as counter
0042 7272 61C6  18         s     tmp2,tmp3             ; Update length
0043 7274 06A0  32         bl    @mcloop               ; Write data to VDP
     7276 8320 
0044 7278 1008  14         jmp   rle2v3
0045               *--------------------------------------------------------------
0046               *    Dump compressed bytes
0047               *--------------------------------------------------------------
0048 727A C820  54 rle2v2  mov   @filzz,@mcloop        ; Setup machine code(MOVB TMP1,*R15)
     727C 62B8 
     727E 8320 
0049 7280 0996  56         srl   tmp2,9                ; Use control byte as counter
0050 7282 0607  14         dec   tmp3                  ; Update length
0051 7284 D174  28         movb  *tmp0+,tmp1           ; Byte to fill
0052 7286 06A0  32         bl    @mcloop               ; Write data to VDP
     7288 8320 
0053               *--------------------------------------------------------------
0054               *    Check if more data to decompress
0055               *--------------------------------------------------------------
0056 728A C1C7  18 rle2v3  mov   tmp3,tmp3             ; Length counter = 0 ?
0057 728C 16E9  14         jne   rle2v0                ; Not yet, process data
0058               *--------------------------------------------------------------
0059               *    Exit
0060               *--------------------------------------------------------------
0061 728E C2E0  34 rle2vz  mov   @waux1,r11
     7290 833C 
0062 7292 045B  20         b     *r11                  ; Return
0063 7294 D7F4     rledat  data  >d7f4                 ; MOVB *TMP0+,*R15
**** **** ****     > runlib.asm
0202               
0204                       copy  "rnd_support.asm"          ; Random number generator
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
0026 7296 C13B  30 rnd     mov   *r11+,tmp0            ; Highest number allowed
0027 7298 C1FB  30         mov   *r11+,tmp3            ; Get address of random seed
0028 729A 04C5  14 rndx    clr   tmp1
0029 729C C197  26         mov   *tmp3,tmp2            ; Get random seed
0030 729E 1601  14         jne   rnd1
0031 72A0 0586  14         inc   tmp2                  ; May not be zero
0032 72A2 0916  56 rnd1    srl   tmp2,1
0033 72A4 1702  14         jnc   rnd2
0034 72A6 29A0  34         xor   @rnddat,tmp2
     72A8 72B2 
0035 72AA C5C6  30 rnd2    mov   tmp2,*tmp3            ; Store new random seed
0036 72AC 3D44  128         div   tmp0,tmp1
0037 72AE C106  18         mov   tmp2,tmp0
0038 72B0 045B  20         b     *r11                  ; Exit
0039 72B2 B400     rnddat  data  >0b400                ; The magic number
**** **** ****     > runlib.asm
0206               
0208                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
**** **** ****     > cpu_scrpad_backrest.asm
0001               * FILE......: cpu_scrpad_backrest.asm
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
0014               *  r0-r2, but values restored before exit
0015               *--------------------------------------------------------------
0016               *  Backup scratchpad memory to destination range
0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0018               *
0019               *  Expects current workspace to be in scratchpad memory.
0020               ********|*****|*********************|**************************
0021               cpu.scrpad.backup:
0022 72B4 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     72B6 2000 
0023 72B8 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     72BA 2002 
0024 72BC C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     72BE 2004 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 72C0 0200  20         li    r0,>8306              ; Scratpad source address
     72C2 8306 
0029 72C4 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     72C6 2006 
0030 72C8 0202  20         li    r2,62                 ; Loop counter
     72CA 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 72CC CC70  46         mov   *r0+,*r1+
0036 72CE CC70  46         mov   *r0+,*r1+
0037 72D0 0642  14         dect  r2
0038 72D2 16FC  14         jne   cpu.scrpad.backup.copy
0039 72D4 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     72D6 83FE 
     72D8 20FE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 72DA C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     72DC 2000 
0045 72DE C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     72E0 2002 
0046 72E2 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     72E4 2004 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 72E6 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               ***************************************************************
0055               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0056               ***************************************************************
0057               *  bl   @cpu.scrpad.restore
0058               *--------------------------------------------------------------
0059               *  Register usage
0060               *  r0-r2, but values restored before exit
0061               *--------------------------------------------------------------
0062               *  Restore scratchpad from memory area
0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0064               *  Current workspace can be outside scratchpad when called.
0065               ********|*****|*********************|**************************
0066               cpu.scrpad.restore:
0067                       ;------------------------------------------------------
0068                       ; Restore scratchpad >8300 - >8304
0069                       ;------------------------------------------------------
0070 72E8 C820  54         mov   @cpu.scrpad.tgt,@>8300
     72EA 2000 
     72EC 8300 
0071 72EE C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     72F0 2002 
     72F2 8302 
0072 72F4 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     72F6 2004 
     72F8 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 72FA C800  38         mov   r0,@cpu.scrpad.tgt
     72FC 2000 
0077 72FE C801  38         mov   r1,@cpu.scrpad.tgt + 2
     7300 2002 
0078 7302 C802  38         mov   r2,@cpu.scrpad.tgt + 4
     7304 2004 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 7306 0200  20         li    r0,cpu.scrpad.tgt + 6
     7308 2006 
0083 730A 0201  20         li    r1,>8306
     730C 8306 
0084 730E 0202  20         li    r2,62
     7310 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 7312 CC70  46         mov   *r0+,*r1+
0090 7314 CC70  46         mov   *r0+,*r1+
0091 7316 0642  14         dect  r2
0092 7318 16FC  14         jne   cpu.scrpad.restore.copy
0093 731A C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     731C 20FE 
     731E 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 7320 C020  34         mov   @cpu.scrpad.tgt,r0
     7322 2000 
0099 7324 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     7326 2002 
0100 7328 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     732A 2004 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 732C 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0209                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
**** **** ****     > cpu_scrpad_paging.asm
0001               * FILE......: cpu_scrpad_paging.asm
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
0013               *       DATA p0
0014               *
0015               *  P0 = CPU memory destination
0016               *--------------------------------------------------------------
0017               *  bl   @xcpu.scrpad.pgout
0018               *  TMP1 = CPU memory destination
0019               *--------------------------------------------------------------
0020               *  Register usage
0021               *  tmp0-tmp2 = Used as temporary registers
0022               *  tmp3      = Copy of CPU memory destination
0023               ********|*****|*********************|**************************
0024               cpu.scrpad.pgout:
0025 732E C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 7330 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     7332 8300 
0031 7334 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 7336 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     7338 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 733A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 733C 0606  14         dec   tmp2
0038 733E 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 7340 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 7342 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     7344 734A 
0044                                                   ; R14=PC
0045 7346 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 7348 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 734A 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     734C 72E8 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 734E 045B  20         b     *r11                  ; Return to caller
0062               
0063               
0064               ***************************************************************
0065               * cpu.scrpad.pgin - Page in scratchpad memory
0066               ***************************************************************
0067               *  bl   @cpu.scrpad.pgin
0068               *  DATA p0
0069               *  P0 = CPU memory source
0070               *--------------------------------------------------------------
0071               *  bl   @memx.scrpad.pgin
0072               *  TMP1 = CPU memory source
0073               *--------------------------------------------------------------
0074               *  Register usage
0075               *  tmp0-tmp2 = Used as temporary registers
0076               ********|*****|*********************|**************************
0077               cpu.scrpad.pgin:
0078 7350 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 7352 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     7354 8300 
0084 7356 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     7358 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 735A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 735C 0606  14         dec   tmp2
0090 735E 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 7360 02E0  18         lwpi  >8300                 ; Activate copied workspace
     7362 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 7364 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0211               
0213                       copy  "equ_fio.asm"              ; File I/O equates
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
0214                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
**** **** ****     > fio_dsrlnk.asm
0001               * FILE......: fio_dsrlnk.asm
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
0040               ********|*****|*********************|**************************
0041 7366 B000     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 7368 736A             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 736A C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 736C C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     736E 8322 
0049 7370 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     7372 6046 
0050 7374 C020  34         mov   @>8356,r0             ; get ptr to pab
     7376 8356 
0051 7378 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 737A 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     737C FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 737E 06C0  14         swpb  r0                    ;
0059 7380 D800  38         movb  r0,@vdpa              ; send low byte
     7382 8C02 
0060 7384 06C0  14         swpb  r0                    ;
0061 7386 D800  38         movb  r0,@vdpa              ; send high byte
     7388 8C02 
0062 738A D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     738C 8800 
0063                       ;---------------------------; Inline VSBR end
0064 738E 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 7390 0704  14         seto  r4                    ; init counter
0070 7392 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     7394 2100 
0071 7396 0580  14 !       inc   r0                    ; point to next char of name
0072 7398 0584  14         inc   r4                    ; incr char counter
0073 739A 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     739C 0007 
0074 739E 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 73A0 80C4  18         c     r4,r3                 ; end of name?
0077 73A2 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 73A4 06C0  14         swpb  r0                    ;
0082 73A6 D800  38         movb  r0,@vdpa              ; send low byte
     73A8 8C02 
0083 73AA 06C0  14         swpb  r0                    ;
0084 73AC D800  38         movb  r0,@vdpa              ; send high byte
     73AE 8C02 
0085 73B0 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     73B2 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 73B4 DC81  32         movb  r1,*r2+               ; move into buffer
0092 73B6 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     73B8 747A 
0093 73BA 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 73BC C104  18         mov   r4,r4                 ; Check if length = 0
0099 73BE 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 73C0 04E0  34         clr   @>83d0
     73C2 83D0 
0102 73C4 C804  38         mov   r4,@>8354             ; save name length for search
     73C6 8354 
0103 73C8 0584  14         inc   r4                    ; adjust for dot
0104 73CA A804  38         a     r4,@>8356             ; point to position after name
     73CC 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 73CE 02E0  18         lwpi  >83e0                 ; Use GPL WS
     73D0 83E0 
0110 73D2 04C1  14         clr   r1                    ; version found of dsr
0111 73D4 020C  20         li    r12,>0f00             ; init cru addr
     73D6 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 73D8 C30C  18         mov   r12,r12               ; anything to turn off?
0117 73DA 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 73DC 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 73DE 022C  22         ai    r12,>0100             ; next rom to turn on
     73E0 0100 
0125 73E2 04E0  34         clr   @>83d0                ; clear in case we are done
     73E4 83D0 
0126 73E6 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     73E8 2000 
0127 73EA 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 73EC C80C  38         mov   r12,@>83d0            ; save addr of next cru
     73EE 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 73F0 1D00  20         sbo   0                     ; turn on rom
0134 73F2 0202  20         li    r2,>4000              ; start at beginning of rom
     73F4 4000 
0135 73F6 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     73F8 7476 
0136 73FA 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 73FC A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     73FE B00A 
0146 7400 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 7402 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     7404 83D2 
0152                                                   ; subprogram
0153               
0154 7406 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 7408 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 740A 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 740C C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     740E 83D2 
0163                                                   ; subprogram
0164               
0165 7410 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 7412 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 7414 04C5  14         clr   r5                    ; Remove any old stuff
0174 7416 D160  34         movb  @>8355,r5             ; get length as counter
     7418 8355 
0175 741A 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 741C 9C85  32         cb    r5,*r2+               ; see if length matches
0180 741E 16F1  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 7420 0985  56         srl   r5,8                  ; yes, move to low byte
0185 7422 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     7424 2100 
0186 7426 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 7428 16EC  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 742A 0605  14         dec   r5                    ; loop until full length checked
0191 742C 16FC  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 742E C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     7430 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 7432 0581  14         inc   r1                    ; next version found
0203 7434 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 7436 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 7438 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 743A 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     743C B000 
0212 743E C009  18         mov   r9,r0                 ; point to flag in pab
0213 7440 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     7442 8322 
0214                                                   ; (8 or >a)
0215 7444 0281  22         ci    r1,8                  ; was it 8?
     7446 0008 
0216 7448 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 744A D060  34         movb  @>8350,r1             ; no, we have a data >a.
     744C 8350 
0218                                                   ; Get error byte from @>8350
0219 744E 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 7450 06C0  14         swpb  r0                    ;
0227 7452 D800  38         movb  r0,@vdpa              ; send low byte
     7454 8C02 
0228 7456 06C0  14         swpb  r0                    ;
0229 7458 D800  38         movb  r0,@vdpa              ; send high byte
     745A 8C02 
0230 745C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     745E 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 7460 09D1  56         srl   r1,13                 ; just keep error bits
0238 7462 1604  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 7464 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 7466 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     7468 B000 
0248               dsrlnk.error.devicename_invalid:
0249 746A 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 746C 06C1  14         swpb  r1                    ; put error in hi byte
0252 746E D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 7470 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     7472 6046 
0254 7474 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 7476 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 7478 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 747A ....     dsrlnk.period     text  '.'         ; For finding end of device name
0263               
0264                       even
**** **** ****     > runlib.asm
0215                       copy  "fio_level2.asm"           ; File I/O level 2 support
**** **** ****     > fio_level2.asm
0001               * FILE......: fio_level2.asm
0002               * Purpose...: File I/O level 2 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
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
0041               ********|*****|*********************|**************************
0042               file.open:
0043 747C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 747E C04B  18         mov   r11,r1                ; Save return address
0049 7480 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     7482 270F 
0050 7484 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 7486 04C5  14         clr   tmp1                  ; io.op.open
0052 7488 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     748A 62D0 
0053               file.open_init:
0054 748C 0220  22         ai    r0,9                  ; Move to file descriptor length
     748E 0009 
0055 7490 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     7492 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 7494 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     7496 7366 
0061 7498 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 749A 1029  14         jmp   file.record.pab.details
0067                                                   ; Get status and return to caller
0068                                                   ; Status register bits are unaffected
0069               
0070               
0071               
0072               ***************************************************************
0073               * file.close - Close currently open file
0074               ***************************************************************
0075               *  bl   @file.close
0076               *  data P0
0077               *--------------------------------------------------------------
0078               *  P0 = Address of PAB in VDP RAM
0079               *--------------------------------------------------------------
0080               *  bl   @xfile.close
0081               *
0082               *  R0 = Address of PAB in VDP RAM
0083               *--------------------------------------------------------------
0084               *  Output:
0085               *  tmp0 LSB = VDP PAB byte 1 (status)
0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0087               *  tmp2     = Status register contents upon DSRLNK return
0088               ********|*****|*********************|**************************
0089               file.close:
0090 749C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 749E C04B  18         mov   r11,r1                ; Save return address
0096 74A0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     74A2 270F 
0097 74A4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 74A6 0205  20         li    tmp1,io.op.close      ; io.op.close
     74A8 0001 
0099 74AA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     74AC 62D0 
0100               file.close_init:
0101 74AE 0220  22         ai    r0,9                  ; Move to file descriptor length
     74B0 0009 
0102 74B2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     74B4 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 74B6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     74B8 7366 
0108 74BA 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 74BC 1018  14         jmp   file.record.pab.details
0114                                                   ; Get status and return to caller
0115                                                   ; Status register bits are unaffected
0116               
0117               
0118               
0119               
0120               
0121               ***************************************************************
0122               * file.record.read - Read record from file
0123               ***************************************************************
0124               *  bl   @file.record.read
0125               *  data P0
0126               *--------------------------------------------------------------
0127               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0128               *--------------------------------------------------------------
0129               *  bl   @xfile.record.read
0130               *
0131               *  R0 = Address of PAB in VDP RAM
0132               *--------------------------------------------------------------
0133               *  Output:
0134               *  tmp0 LSB = VDP PAB byte 1 (status)
0135               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0136               *  tmp2     = Status register contents upon DSRLNK return
0137               ********|*****|*********************|**************************
0138               file.record.read:
0139 74BE C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 74C0 C04B  18         mov   r11,r1                ; Save return address
0145 74C2 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     74C4 270F 
0146 74C6 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 74C8 0205  20         li    tmp1,io.op.read       ; io.op.read
     74CA 0002 
0148 74CC 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     74CE 62D0 
0149               file.record.read_init:
0150 74D0 0220  22         ai    r0,9                  ; Move to file descriptor length
     74D2 0009 
0151 74D4 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     74D6 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 74D8 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     74DA 7366 
0157 74DC 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 74DE 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 74E0 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 74E2 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 74E4 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 74E6 1000  14         nop
0183               
0184               
0185               file.delete:
0186 74E8 1000  14         nop
0187               
0188               
0189               file.rename:
0190 74EA 1000  14         nop
0191               
0192               
0193               file.status:
0194 74EC 1000  14         nop
0195               
0196               
0197               
0198               ***************************************************************
0199               * file.record.pab.details - Return PAB details to caller
0200               ***************************************************************
0201               * Called internally via JMP/B by file operations
0202               *--------------------------------------------------------------
0203               *  Output:
0204               *  tmp0 LSB = VDP PAB byte 1 (status)
0205               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0206               *  tmp2     = Status register contents upon DSRLNK return
0207               ********|*****|*********************|**************************
0208               
0209               ********|*****|*********************|**************************
0210               file.record.pab.details:
0211 74EE 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 74F0 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     74F2 270F 
0219 74F4 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     74F6 0005 
0220 74F8 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     74FA 62E8 
0221 74FC C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 74FE C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0226                                                   ; as returned by DSRLNK
0227               *--------------------------------------------------------------
0228               * Exit
0229               *--------------------------------------------------------------
0230               ; If an error occured during the IO operation, then the
0231               ; equal bit in the saved status register (=tmp2) is set to 1.
0232               ;
0233               ; If no error occured during the IO operation, then the
0234               ; equal bit in the saved status register (=tmp2) is set to 0.
0235               ;
0236               ; Upon return from this IO call you should basically test with:
0237               ;       coc   @wbit2,tmp2           ; Equal bit set?
0238               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0239               ;
0240               ; Then look for further details in the copy of VDP PAB byte 1
0241               ; in register tmp0, bits 13-15
0242               ;
0243               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0244               ;                                   ; calls, skip for type >A subprograms!)
0245               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0246               ;       jeq   my_error_handler
0247               *--------------------------------------------------------------
0248               file.record.pab.details.exit:
0249 7500 0451  20         b     *r1                   ; Return to caller
**** **** ****     > runlib.asm
0217               
0218               *//////////////////////////////////////////////////////////////
0219               *                            TIMERS
0220               *//////////////////////////////////////////////////////////////
0221               
0222                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 7502 0300  24 tmgr    limi  0                     ; No interrupt processing
     7504 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 7506 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     7508 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 750A 2360  38         coc   @wbit2,r13            ; C flag on ?
     750C 6046 
0029 750E 1602  14         jne   tmgr1a                ; No, so move on
0030 7510 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     7512 6032 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 7514 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     7516 604A 
0035 7518 1316  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0040 751A 20A0  38         coc   @wbit3,config         ; Speech player on ?
     751C 6044 
0041 751E 1602  14         jne   tmgr2
0042 7520 06A0  32         bl    @sppla1               ; Run speech player
     7522 6B4C 
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 7524 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     7526 603A 
0048 7528 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 752A 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     752C 6038 
0050 752E 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 7530 0460  28         b     @kthread              ; Run kernel thread
     7532 75AA 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 7534 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     7536 603E 
0056 7538 13E6  14         jeq   tmgr1
0057 753A 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     753C 603C 
0058 753E 16E3  14         jne   tmgr1
0059 7540 C120  34         mov   @wtiusr,tmp0
     7542 832E 
0060 7544 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 7546 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     7548 75A8 
0065 754A C10A  18         mov   r10,tmp0
0066 754C 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     754E 00FF 
0067 7550 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     7552 6046 
0068 7554 1303  14         jeq   tmgr5
0069 7556 0284  22         ci    tmp0,60               ; 1 second reached ?
     7558 003C 
0070 755A 1002  14         jmp   tmgr6
0071 755C 0284  22 tmgr5   ci    tmp0,50
     755E 0032 
0072 7560 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 7562 1001  14         jmp   tmgr8
0074 7564 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 7566 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     7568 832C 
0079 756A 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     756C FF00 
0080 756E C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 7570 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 7572 05C4  14         inct  tmp0                  ; Second word of slot data
0086 7574 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 7576 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 7578 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     757A 830C 
     757C 830D 
0089 757E 1608  14         jne   tmgr10                ; No, get next slot
0090 7580 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     7582 FF00 
0091 7584 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 7586 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     7588 8330 
0096 758A 0697  24         bl    *tmp3                 ; Call routine in slot
0097 758C C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     758E 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 7590 058A  14 tmgr10  inc   r10                   ; Next slot
0102 7592 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     7594 8315 
     7596 8314 
0103 7598 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 759A 05C4  14         inct  tmp0                  ; Offset for next slot
0105 759C 10E8  14         jmp   tmgr9                 ; Process next slot
0106 759E 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 75A0 10F7  14         jmp   tmgr10                ; Process next slot
0108 75A2 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     75A4 FF00 
0109 75A6 10AF  14         jmp   tmgr1
0110 75A8 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0223                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 75AA E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     75AC 603A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 75AE 20A0  38         coc   @wbit13,config        ; Sound player on ?
     75B0 6030 
0023 75B2 1602  14         jne   kthread_kb
0024 75B4 06A0  32         bl    @sdpla1               ; Run sound player
     75B6 6A5C 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 75B8 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     75BA 6BAE 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 75BC 06A0  32         bl    @realkb               ; Scan full keyboard
     75BE 6C9E 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 75C0 0460  28         b     @tmgr3                ; Exit
     75C2 7534 
**** **** ****     > runlib.asm
0224                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 75C4 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     75C6 832E 
0018 75C8 E0A0  34         soc   @wbit7,config         ; Enable user hook
     75CA 603C 
0019 75CC 045B  20 mkhoo1  b     *r11                  ; Return
0020      7506     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 75CE 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     75D0 832E 
0029 75D2 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     75D4 FEFF 
0030 75D6 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0225               
0227                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 75D8 C13B  30 mkslot  mov   *r11+,tmp0
0018 75DA C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 75DC C184  18         mov   tmp0,tmp2
0023 75DE 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 75E0 A1A0  34         a     @wtitab,tmp2          ; Add table base
     75E2 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 75E4 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 75E6 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 75E8 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 75EA 881B  46         c     *r11,@w$ffff          ; End of list ?
     75EC 604C 
0035 75EE 1301  14         jeq   mkslo1                ; Yes, exit
0036 75F0 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 75F2 05CB  14 mkslo1  inct  r11
0041 75F4 045B  20         b     *r11                  ; Exit
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
0052 75F6 C13B  30 clslot  mov   *r11+,tmp0
0053 75F8 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 75FA A120  34         a     @wtitab,tmp0          ; Add table base
     75FC 832C 
0055 75FE 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7600 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 7602 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0229               
0230               
0231               
0232               *//////////////////////////////////////////////////////////////
0233               *                    RUNLIB INITIALISATION
0234               *//////////////////////////////////////////////////////////////
0235               
0236               ***************************************************************
0237               *  RUNLIB - Runtime library initalisation
0238               ***************************************************************
0239               *  B  @RUNLIB
0240               *--------------------------------------------------------------
0241               *  REMARKS
0242               *  if R0 in WS1 equals >4a4a we were called from the system
0243               *  crash handler so we return there after initialisation.
0244               
0245               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0246               *  after clearing scratchpad memory. This has higher priority
0247               *  as crash handler flag R0.
0248               ********|*****|*********************|**************************
0250 7604 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to
     7606 72B4 
0251                                                   ; @cpu.scrpad.tgt (>00..>ff)
0252               
0253 7608 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     760A 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 760C 0300  24 runli1  limi  0                     ; Turn off interrupts
     760E 0000 
0261 7610 02E0  18         lwpi  ws1                   ; Activate workspace 1
     7612 8300 
0262 7614 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     7616 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 7618 0202  20 runli2  li    r2,>8308
     761A 8308 
0267 761C 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 761E 0282  22         ci    r2,>8400
     7620 8400 
0269 7622 16FC  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 7624 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     7626 FFFF 
0274 7628 1602  14         jne   runli4                ; No, continue
0275 762A 0420  54         blwp  @0                    ; Yes, bye bye
     762C 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 762E C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7630 833C 
0280 7632 04C1  14         clr   r1                    ; Reset counter
0281 7634 0202  20         li    r2,10                 ; We test 10 times
     7636 000A 
0282 7638 C0E0  34 runli5  mov   @vdps,r3
     763A 8802 
0283 763C 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     763E 604A 
0284 7640 1302  14         jeq   runli6
0285 7642 0581  14         inc   r1                    ; Increase counter
0286 7644 10F9  14         jmp   runli5
0287 7646 0602  14 runli6  dec   r2                    ; Next test
0288 7648 16F7  14         jne   runli5
0289 764A 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     764C 1250 
0290 764E 1202  14         jle   runli7                ; No, so it must be NTSC
0291 7650 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     7652 6046 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 7654 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     7656 6224 
0296 7658 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     765A 8322 
0297 765C CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 765E CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 7660 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 7662 04C1  14 runli9  clr   r1
0304 7664 04C2  14         clr   r2
0305 7666 04C3  14         clr   r3
0306 7668 0209  20         li    stack,>8400           ; Set stack
     766A 8400 
0307 766C 020F  20         li    r15,vdpw              ; Set VDP write address
     766E 8C00 
0309 7670 06A0  32         bl    @mute                 ; Mute sound generators
     7672 6A20 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0320 7674 06A0  32         bl    @filv                 ; Clear 16K VDP memory
     7676 6292 
0321 7678 0000             data  >0000,>00,>3fff
     767A 0000 
     767C 3FFF 
0323 767E 06A0  32 runlia  bl    @filv
     7680 6292 
0324 7682 0FC0             data  pctadr,spfclr,16      ; Load color table
     7684 00C1 
     7686 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 7688 06A0  32         bl    @f18unl               ; Unlock the F18A
     768A 677A 
0332 768C 06A0  32         bl    @f18chk               ; Check if F18A is there
     768E 6794 
0333 7690 06A0  32         bl    @f18lck               ; Lock the F18A again
     7692 678A 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0341 7694 06A0  32         bl    @spconn
     7696 6B02 
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 7698 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     769A 62FC 
0347 769C 621A             data  spvmod                ; Equate selected video mode table
0348 769E 0204  20         li    tmp0,spfont           ; Get font option
     76A0 000C 
0349 76A2 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 76A4 1304  14         jeq   runlid                ; Yes, skip it
0351 76A6 06A0  32         bl    @ldfnt
     76A8 6364 
0352 76AA 1100             data  fntadr,spfont         ; Load specified font
     76AC 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 76AE 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     76B0 4A4A 
0357 76B2 1602  14         jne   runlie                ; No, continue
0358 76B4 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     76B6 60B0 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 76B8 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     76BA 0040 
0363 76BC 0460  28         b     @main                 ; Give control to main program
     76BE 76C0 
**** **** ****     > hello_world.asm.10219
0052               *--------------------------------------------------------------
0053               * SPECTRA2 startup options
0054               *--------------------------------------------------------------
0055      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0056      0001     spfbck  equ   >01                   ; Screen background color.
0057               ;--------------------------------------------------------------
0058               ; Video mode configuration
0059               ;--------------------------------------------------------------
0060      621A     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0061      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0062      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0063      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0064      8350     rambuf  equ   >8350
0065      2000     cpu.scrpad.tgt  equ >2000
0066               
0067               ***************************************************************
0068               * Main
0069               ********|*****|*********************|**************************
0070 76C0 06A0  32 main    bl    @putat
     76C2 6434 
0071 76C4 081F             data  >081f,hello_world
     76C6 76CC 
0072               
0073 76C8 0460  28         b     @tmgr                 ;
     76CA 7502 
0074               
0075               
0076               hello_world:
0077               
0078 76CC 0C48             byte  12
0079 76CD ....             text  'Hello World!'
0080                       even
0081               
0082               
0083               
0084               
0085               
0086                       aorg  >6000
0087                       bank  1
0088                       save  >6000,>7fff
0089               
0090 6000 9999     aaa     data  >9999,>9999,>9999,>9999
     6002 9999 
     6004 9999 
     6006 9999 
0091 6008 9999             data  >9999,>9999,>9999,>9999
     600A 9999 
     600C 9999 
     600E 9999 
0092 6010 9999             data  >9999,>9999,>9999,>9999
     6012 9999 
     6014 9999 
     6016 9999 
0093 6018 9999             data  >9999,>9999,>9999,>9999
     601A 9999 
     601C 9999 
     601E 9999 
0094 6020 9999             data  >9999,>9999,>9999,>9999
     6022 9999 
     6024 9999 
     6026 9999 
0095 6028 9999             data  >9999,>9999,>9999,>9999
     602A 9999 
     602C 9999 
     602E 9999 
0096 6030 9999             data  >9999,>9999,>9999,>9999
     6032 9999 
     6034 9999 
     6036 9999 
