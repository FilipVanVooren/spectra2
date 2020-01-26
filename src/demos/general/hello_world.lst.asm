XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > hello_world.asm.20059
0001               ***************************************************************
0002               *
0003               *                          Device scan
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: hello_world.asm             ; Version 200126-20059
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
0028      0001     skip_fio                  equ 1     ; Skip file I/O
0029               *--------------------------------------------------------------
0030               * Cartridge header
0031               *--------------------------------------------------------------
0032 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0033 6006 6010             data  prog0
0034 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0035 6010 0000     prog0   data  0                     ; No more items following
0036 6012 721C             data  runlib
0044               
0045 6014 0B48             byte  11
0046 6015 ....             text  'HELLO WORLD'
0047                       even
0048               
0050               *--------------------------------------------------------------
0051               * Include required files
0052               *--------------------------------------------------------------
0053                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0038               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0039               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0040               * skip_vdp_sprites          equ  1  ; Skip sprites support
0041               * skip_vdp_cursor           equ  1  ; Skip cursor support
0042               *
0043               * == Sound & speech
0044               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0045               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0046               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0047               *
0048               * ==  Keyboard
0049               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0050               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0051               *
0052               * == Utilities
0053               * skip_random_generator     equ  1  ; Skip random generator functions
0054               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0055               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0056               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0057               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0058               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0059               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0060               *
0061               * == Kernel/Multitasking
0062               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0063               * skip_mem_paging           equ  1  ; Skip support for memory paging
0064               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0065               *
0066               * == Startup behaviour
0067               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0068               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0069               *******************************************************************************
0070               
0071               *//////////////////////////////////////////////////////////////
0072               *                       RUNLIB SETUP
0073               *//////////////////////////////////////////////////////////////
0074               
0075                       copy  "equ_memsetup.asm"         ; Equates for runlib scratchpad memory setup
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
0076                       copy  "equ_registers.asm"        ; Equates for runlib registers
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
0077                       copy  "equ_portaddr.asm"         ; Equates for runlib hardware port addresses
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
0078                       copy  "equ_param.asm"            ; Equates for runlib parameters
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
0079               
0081                       copy  "rom_bankswitch.asm"       ; Bank switch routine
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
0083               
0084                       copy  "constants.asm"            ; Define constants & equates for word/MSB/LSB
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
0085                       copy  "equ_config.asm"           ; Equates for bits in config register
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
0086                       copy  "cpu_crash.asm"            ; CPU crash handler
**** **** ****     > cpu_crash.asm
0001               * FILE......: cpu_crash.asm
0002               * Purpose...: Custom crash handler module
0003               
0004               
0005               ***************************************************************
0006               * crash - CPU program crashed handler
0007               ***************************************************************
0008               *  bl   @crash
0009               *--------------------------------------------------------------
0010               * Crash and halt system. Upon crash entry register contents are
0011               * copied to the memory region >ffe0 - >fffe and displayed after
0012               * resetting the spectra2 runtime library, video modes, etc.
0013               *
0014               * Diagnostics
0015               * >ffce  caller address
0016               *
0017               * Register contents
0018               * >ffe0  r0               >fff0  r8  (tmp4)
0019               * >ffe2  r1               >fff2  r9  (stack)
0020               * >ffe4  r2 (config)      >fff4  r10
0021               * >ffe6  r3               >fff6  r11
0022               * >ffe8  r4 (tmp0)        >fff8  r12
0023               * >ffea  r5 (tmp1)        >fffa  r13
0024               * >ffec  r6 (tmp2)        >fffc  r14
0025               * >ffee  r7 (tmp3)        >fffe  r15
0026               ********|*****|*********************|**************************
0027 6050 022B  22 crash:  ai    r11,-4                ; Remove opcode offset
     6052 FFFC 
0028               *--------------------------------------------------------------
0029               *    Save registers to high memory
0030               *--------------------------------------------------------------
0031 6054 C800  38         mov   r0,@>ffe0
     6056 FFE0 
0032 6058 C801  38         mov   r1,@>ffe2
     605A FFE2 
0033 605C C802  38         mov   r2,@>ffe4
     605E FFE4 
0034 6060 C803  38         mov   r3,@>ffe6
     6062 FFE6 
0035 6064 C804  38         mov   r4,@>ffe8
     6066 FFE8 
0036 6068 C805  38         mov   r5,@>ffea
     606A FFEA 
0037 606C C806  38         mov   r6,@>ffec
     606E FFEC 
0038 6070 C807  38         mov   r7,@>ffee
     6072 FFEE 
0039 6074 C808  38         mov   r8,@>fff0
     6076 FFF0 
0040 6078 C809  38         mov   r9,@>fff2
     607A FFF2 
0041 607C C80A  38         mov   r10,@>fff4
     607E FFF4 
0042 6080 C80B  38         mov   r11,@>fff6
     6082 FFF6 
0043 6084 C80C  38         mov   r12,@>fff8
     6086 FFF8 
0044 6088 C80D  38         mov   r13,@>fffa
     608A FFFA 
0045 608C C80E  38         mov   r14,@>fffc
     608E FFFC 
0046 6090 C80F  38         mov   r15,@>ffff
     6092 FFFF 
0047               *--------------------------------------------------------------
0048               *    Reset system
0049               *--------------------------------------------------------------
0050               crash.reset:
0051 6094 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6096 8300 
0052 6098 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     609A 8302 
0053 609C 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     609E 4A4A 
0054 60A0 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     60A2 7224 
0055               *--------------------------------------------------------------
0056               *    Show diagnostics after system reset
0057               *--------------------------------------------------------------
0058               crash.main:
0059                       ;------------------------------------------------------
0060                       ; Show crashed message
0061                       ;------------------------------------------------------
0062 60A4 06A0  32         bl    @putat                ; Show crash message
     60A6 6334 
0063 60A8 0000                   data >0000,crash.msg.crashed
     60AA 60D0 
0064               
0065 60AC 06A0  32         bl    @puthex               ; Put hex value on screen
     60AE 6C2E 
0066 60B0 0015                   byte 0,21             ; \ .  p0 = YX position
0067 60B2 FFF6                   data >fff6            ; | .  p1 = Pointer to 16 bit word
0068 60B4 8350                   data rambuf           ; | .  p2 = Pointer to ram buffer
0069 60B6 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0070                                                   ; /         LSB offset for ASCII digit 0-9
0071                       ;------------------------------------------------------
0072                       ; Show caller details
0073                       ;------------------------------------------------------
0074 60B8 06A0  32         bl    @putat                ; Show caller message
     60BA 6334 
0075 60BC 0100                   data >0100,crash.msg.caller
     60BE 60E6 
0076               
0077 60C0 06A0  32         bl    @puthex               ; Put hex value on screen
     60C2 6C2E 
0078 60C4 0115                   byte 1,21             ; \ .  p0 = YX position
0079 60C6 FFCE                   data >ffce            ; | .  p1 = Pointer to 16 bit word
0080 60C8 8350                   data rambuf           ; | .  p2 = Pointer to ram buffer
0081 60CA 4130                   byte 65,48            ; | .  p3 = MSB offset for ASCII digit a-f
0082                                                   ; /         LSB offset for ASCII digit 0-9
0083                       ;------------------------------------------------------
0084                       ; Kernel takes over
0085                       ;------------------------------------------------------
0086 60CC 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     60CE 711A 
0087               
0088 60D0 1553     crash.msg.crashed      byte 21
0089 60D1 ....                            text 'System crashed near >'
0090               
0091 60E6 1543     crash.msg.caller       byte 21
0092 60E7 ....                            text 'Caller address near >'
**** **** ****     > runlib.asm
0087                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 60FC 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     60FE 000E 
     6100 0106 
     6102 0201 
     6104 0020 
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
0032 6106 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6108 000E 
     610A 0106 
     610C 00C1 
     610E 0028 
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
0058 6110 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6112 003F 
     6114 0240 
     6116 03C1 
     6118 0050 
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
0084 611A 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     611C 003F 
     611E 0240 
     6120 03C1 
     6122 0050 
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
0088                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
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
0013 6124 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6126 16FD             data  >16fd                 ; |         jne   mcloop
0015 6128 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 612A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 612C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 612E C0F9  30 popr3   mov   *stack+,r3
0039 6130 C0B9  30 popr2   mov   *stack+,r2
0040 6132 C079  30 popr1   mov   *stack+,r1
0041 6134 C039  30 popr0   mov   *stack+,r0
0042 6136 C2F9  30 poprt   mov   *stack+,r11
0043 6138 045B  20         b     *r11
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
0067 613A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 613C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 613E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 6140 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 6142 1604  14         jne   filchk                ; No, continue checking
0075               
0076 6144 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6146 FFCE 
0077 6148 06A0  32         bl    @crash                ; / Crash and halt system
     614A 6050 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 614C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     614E 830B 
     6150 830A 
0082               
0083 6152 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     6154 0001 
0084 6156 1602  14         jne   filchk2
0085 6158 DD05  32         movb  tmp1,*tmp0+
0086 615A 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 615C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     615E 0002 
0091 6160 1603  14         jne   filchk3
0092 6162 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 6164 DD05  32         movb  tmp1,*tmp0+
0094 6166 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 6168 C1C4  18 filchk3 mov   tmp0,tmp3
0099 616A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     616C 0001 
0100 616E 1605  14         jne   fil16b
0101 6170 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 6172 0606  14         dec   tmp2
0103 6174 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     6176 0002 
0104 6178 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 617A C1C6  18 fil16b  mov   tmp2,tmp3
0109 617C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     617E 0001 
0110 6180 1301  14         jeq   dofill
0111 6182 0606  14         dec   tmp2                  ; Make TMP2 even
0112 6184 CD05  34 dofill  mov   tmp1,*tmp0+
0113 6186 0646  14         dect  tmp2
0114 6188 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 618A C1C7  18         mov   tmp3,tmp3
0119 618C 1301  14         jeq   fil.$$
0120 618E DD05  32         movb  tmp1,*tmp0+
0121 6190 045B  20 fil.$$  b     *r11
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
0140 6192 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 6194 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 6196 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 6198 0264  22 xfilv   ori   tmp0,>4000
     619A 4000 
0147 619C 06C4  14         swpb  tmp0
0148 619E D804  38         movb  tmp0,@vdpa
     61A0 8C02 
0149 61A2 06C4  14         swpb  tmp0
0150 61A4 D804  38         movb  tmp0,@vdpa
     61A6 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 61A8 020F  20         li    r15,vdpw              ; Set VDP write address
     61AA 8C00 
0155 61AC 06C5  14         swpb  tmp1
0156 61AE C820  54         mov   @filzz,@mcloop        ; Setup move command
     61B0 61B8 
     61B2 8320 
0157 61B4 0460  28         b     @mcloop               ; Write data to VDP
     61B6 8320 
0158               *--------------------------------------------------------------
0162 61B8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 61BA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     61BC 4000 
0183 61BE 06C4  14 vdra    swpb  tmp0
0184 61C0 D804  38         movb  tmp0,@vdpa
     61C2 8C02 
0185 61C4 06C4  14         swpb  tmp0
0186 61C6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     61C8 8C02 
0187 61CA 045B  20         b     *r11                  ; Exit
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
0198 61CC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 61CE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 61D0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     61D2 4000 
0204 61D4 06C4  14         swpb  tmp0                  ; \
0205 61D6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     61D8 8C02 
0206 61DA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 61DC D804  38         movb  tmp0,@vdpa            ; /
     61DE 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 61E0 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 61E2 D7C5  30         movb  tmp1,*r15             ; Write byte
0213 61E4 045B  20         b     *r11                  ; Exit
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
0232 61E6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 61E8 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 61EA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     61EC 8C02 
0238 61EE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 61F0 D804  38         movb  tmp0,@vdpa            ; /
     61F2 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 61F4 D120  34         movb  @vdpr,tmp0            ; Read byte
     61F6 8800 
0244 61F8 0984  56         srl   tmp0,8                ; Right align
0245 61FA 045B  20         b     *r11                  ; Exit
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
0264 61FC C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 61FE C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 6200 C144  18         mov   tmp0,tmp1
0270 6202 05C5  14         inct  tmp1
0271 6204 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 6206 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6208 FF00 
0273 620A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 620C C805  38         mov   tmp1,@wbase           ; Store calculated base
     620E 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 6210 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6212 8000 
0279 6214 0206  20         li    tmp2,8
     6216 0008 
0280 6218 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     621A 830B 
0281 621C 06C5  14         swpb  tmp1
0282 621E D805  38         movb  tmp1,@vdpa
     6220 8C02 
0283 6222 06C5  14         swpb  tmp1
0284 6224 D805  38         movb  tmp1,@vdpa
     6226 8C02 
0285 6228 0225  22         ai    tmp1,>0100
     622A 0100 
0286 622C 0606  14         dec   tmp2
0287 622E 16F4  14         jne   vidta1                ; Next register
0288 6230 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6232 833A 
0289 6234 045B  20         b     *r11
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
0306 6236 C13B  30 putvr   mov   *r11+,tmp0
0307 6238 0264  22 putvrx  ori   tmp0,>8000
     623A 8000 
0308 623C 06C4  14         swpb  tmp0
0309 623E D804  38         movb  tmp0,@vdpa
     6240 8C02 
0310 6242 06C4  14         swpb  tmp0
0311 6244 D804  38         movb  tmp0,@vdpa
     6246 8C02 
0312 6248 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 624A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 624C C10E  18         mov   r14,tmp0
0322 624E 0984  56         srl   tmp0,8
0323 6250 06A0  32         bl    @putvrx               ; Write VR#0
     6252 6238 
0324 6254 0204  20         li    tmp0,>0100
     6256 0100 
0325 6258 D820  54         movb  @r14lb,@tmp0lb
     625A 831D 
     625C 8309 
0326 625E 06A0  32         bl    @putvrx               ; Write VR#1
     6260 6238 
0327 6262 0458  20         b     *tmp4                 ; Exit
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
0341 6264 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 6266 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 6268 C11B  26         mov   *r11,tmp0             ; Get P0
0344 626A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     626C 7FFF 
0345 626E 2120  38         coc   @wbit0,tmp0
     6270 604A 
0346 6272 1604  14         jne   ldfnt1
0347 6274 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6276 8000 
0348 6278 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     627A 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 627C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     627E 62E6 
0353 6280 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6282 9C02 
0354 6284 06C4  14         swpb  tmp0
0355 6286 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6288 9C02 
0356 628A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     628C 9800 
0357 628E 06C5  14         swpb  tmp1
0358 6290 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     6292 9800 
0359 6294 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 6296 D805  38         movb  tmp1,@grmwa
     6298 9C02 
0364 629A 06C5  14         swpb  tmp1
0365 629C D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     629E 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 62A0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 62A2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     62A4 61BA 
0371 62A6 05C8  14         inct  tmp4                  ; R11=R11+2
0372 62A8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 62AA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     62AC 7FFF 
0374 62AE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     62B0 62E8 
0375 62B2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     62B4 62EA 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 62B6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 62B8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 62BA D120  34         movb  @grmrd,tmp0
     62BC 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 62BE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     62C0 604A 
0386 62C2 1603  14         jne   ldfnt3                ; No, so skip
0387 62C4 D1C4  18         movb  tmp0,tmp3
0388 62C6 0917  56         srl   tmp3,1
0389 62C8 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 62CA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     62CC 8C00 
0394 62CE 0606  14         dec   tmp2
0395 62D0 16F2  14         jne   ldfnt2
0396 62D2 05C8  14         inct  tmp4                  ; R11=R11+2
0397 62D4 020F  20         li    r15,vdpw              ; Set VDP write address
     62D6 8C00 
0398 62D8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     62DA 7FFF 
0399 62DC 0458  20         b     *tmp4                 ; Exit
0400 62DE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     62E0 602A 
     62E2 8C00 
0401 62E4 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 62E6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     62E8 0200 
     62EA 0000 
0406 62EC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     62EE 01C0 
     62F0 0101 
0407 62F2 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     62F4 02A0 
     62F6 0101 
0408 62F8 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     62FA 00E0 
     62FC 0101 
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
0426 62FE C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 6300 C3A0  34         mov   @wyx,r14              ; Get YX
     6302 832A 
0428 6304 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 6306 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6308 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 630A C3A0  34         mov   @wyx,r14              ; Get YX
     630C 832A 
0435 630E 024E  22         andi  r14,>00ff             ; Remove Y
     6310 00FF 
0436 6312 A3CE  18         a     r14,r15               ; pos = pos + X
0437 6314 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6316 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 6318 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 631A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 631C 020F  20         li    r15,vdpw              ; VDP write address
     631E 8C00 
0444 6320 045B  20         b     *r11
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
0459 6322 C17B  30 putstr  mov   *r11+,tmp1
0460 6324 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 6326 C1CB  18 xutstr  mov   r11,tmp3
0462 6328 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     632A 62FE 
0463 632C C2C7  18         mov   tmp3,r11
0464 632E 0986  56         srl   tmp2,8                ; Right justify length byte
0465 6330 0460  28         b     @xpym2v               ; Display string
     6332 6342 
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
0480 6334 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6336 832A 
0481 6338 0460  28         b     @putstr
     633A 6322 
**** **** ****     > runlib.asm
0089               
0091                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
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
0020 633C C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 633E C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6340 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6342 0264  22 xpym2v  ori   tmp0,>4000
     6344 4000 
0027 6346 06C4  14         swpb  tmp0
0028 6348 D804  38         movb  tmp0,@vdpa
     634A 8C02 
0029 634C 06C4  14         swpb  tmp0
0030 634E D804  38         movb  tmp0,@vdpa
     6350 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6352 020F  20         li    r15,vdpw              ; Set VDP write address
     6354 8C00 
0035 6356 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6358 6360 
     635A 8320 
0036 635C 0460  28         b     @mcloop               ; Write data to VDP
     635E 8320 
0037 6360 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
**** **** ****     > runlib.asm
0093               
0095                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
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
0020 6362 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6364 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6366 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6368 06C4  14 xpyv2m  swpb  tmp0
0027 636A D804  38         movb  tmp0,@vdpa
     636C 8C02 
0028 636E 06C4  14         swpb  tmp0
0029 6370 D804  38         movb  tmp0,@vdpa
     6372 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6374 020F  20         li    r15,vdpr              ; Set VDP read address
     6376 8800 
0034 6378 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     637A 6382 
     637C 8320 
0035 637E 0460  28         b     @mcloop               ; Read data from VDP
     6380 8320 
0036 6382 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
**** **** ****     > runlib.asm
0097               
0099                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
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
0024 6384 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6386 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6388 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 638A C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 638C 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 638E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6390 FFCE 
0034 6392 06A0  32         bl    @crash                ; / Crash and halt system
     6394 6050 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 6396 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     6398 0001 
0039 639A 1603  14         jne   cpym0                 ; No, continue checking
0040 639C DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 639E 04C6  14         clr   tmp2                  ; Reset counter
0042 63A0 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 63A2 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     63A4 7FFF 
0047 63A6 C1C4  18         mov   tmp0,tmp3
0048 63A8 0247  22         andi  tmp3,1
     63AA 0001 
0049 63AC 1618  14         jne   cpyodd                ; Odd source address handling
0050 63AE C1C5  18 cpym1   mov   tmp1,tmp3
0051 63B0 0247  22         andi  tmp3,1
     63B2 0001 
0052 63B4 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 63B6 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     63B8 604A 
0057 63BA 1605  14         jne   cpym3
0058 63BC C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     63BE 63E4 
     63C0 8320 
0059 63C2 0460  28         b     @mcloop               ; Copy memory and exit
     63C4 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 63C6 C1C6  18 cpym3   mov   tmp2,tmp3
0064 63C8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     63CA 0001 
0065 63CC 1301  14         jeq   cpym4
0066 63CE 0606  14         dec   tmp2                  ; Make TMP2 even
0067 63D0 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 63D2 0646  14         dect  tmp2
0069 63D4 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 63D6 C1C7  18         mov   tmp3,tmp3
0074 63D8 1301  14         jeq   cpymz
0075 63DA D554  38         movb  *tmp0,*tmp1
0076 63DC 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 63DE 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     63E0 8000 
0081 63E2 10E9  14         jmp   cpym2
0082 63E4 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0101               
0103                       copy  "copy_grom_cpu.asm"        ; GROM to CPU copy functions
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
0025 63E6 C13B  30 cpyg2m  mov   *r11+,tmp0            ; Memory source address
0026 63E8 C17B  30         mov   *r11+,tmp1            ; Memory target address
0027 63EA C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0028               *--------------------------------------------------------------
0029               * Setup GROM source address
0030               *--------------------------------------------------------------
0031 63EC D804  38 xpyg2m  movb  tmp0,@grmwa
     63EE 9C02 
0032 63F0 06C4  14         swpb  tmp0
0033 63F2 D804  38         movb  tmp0,@grmwa
     63F4 9C02 
0034               *--------------------------------------------------------------
0035               *    Copy bytes from GROM to CPU memory
0036               *--------------------------------------------------------------
0037 63F6 0204  20         li    tmp0,grmrd            ; Set TMP0 to GROM data port
     63F8 9800 
0038 63FA C820  54         mov   @tmp003,@mcloop       ; Setup copy command
     63FC 6404 
     63FE 8320 
0039 6400 0460  28         b     @mcloop               ; Copy bytes
     6402 8320 
0040 6404 DD54     tmp003  data  >dd54                 ; MOVB *TMP0,*TMP1+
**** **** ****     > runlib.asm
0105               
0107                       copy  "copy_grom_vram.asm"       ; GROM to VRAM copy functions
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
0024 6406 C13B  30 cpyg2v  mov   *r11+,tmp0            ; Memory source address
0025 6408 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 640A C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Setup GROM source address
0029               *--------------------------------------------------------------
0030 640C D804  38 xpyg2v  movb  tmp0,@grmwa
     640E 9C02 
0031 6410 06C4  14         swpb  tmp0
0032 6412 D804  38         movb  tmp0,@grmwa
     6414 9C02 
0033               *--------------------------------------------------------------
0034               * Setup VDP target address
0035               *--------------------------------------------------------------
0036 6416 0265  22         ori   tmp1,>4000
     6418 4000 
0037 641A 06C5  14         swpb  tmp1
0038 641C D805  38         movb  tmp1,@vdpa
     641E 8C02 
0039 6420 06C5  14         swpb  tmp1
0040 6422 D805  38         movb  tmp1,@vdpa            ; Set VDP target address
     6424 8C02 
0041               *--------------------------------------------------------------
0042               *    Copy bytes from GROM to VDP memory
0043               *--------------------------------------------------------------
0044 6426 0207  20         li    tmp3,grmrd            ; Set TMP3 to GROM data port
     6428 9800 
0045 642A 020F  20         li    r15,vdpw              ; Set VDP write address
     642C 8C00 
0046 642E C820  54         mov   @tmp002,@mcloop       ; Setup copy command
     6430 6438 
     6432 8320 
0047 6434 0460  28         b     @mcloop               ; Copy bytes
     6436 8320 
0048 6438 D7D7     tmp002  data  >d7d7                 ; MOVB *TMP3,*R15
**** **** ****     > runlib.asm
0109               
0111                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 643A 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     643C FFBF 
0010 643E 0460  28         b     @putv01
     6440 624A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 6442 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     6444 0040 
0018 6446 0460  28         b     @putv01
     6448 624A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 644A 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     644C FFDF 
0026 644E 0460  28         b     @putv01
     6450 624A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 6452 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6454 0020 
0034 6456 0460  28         b     @putv01
     6458 624A 
**** **** ****     > runlib.asm
0113               
0115                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 645A 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     645C FFFE 
0011 645E 0460  28         b     @putv01
     6460 624A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 6462 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6464 0001 
0019 6466 0460  28         b     @putv01
     6468 624A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 646A 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     646C FFFD 
0027 646E 0460  28         b     @putv01
     6470 624A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 6472 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6474 0002 
0035 6476 0460  28         b     @putv01
     6478 624A 
**** **** ****     > runlib.asm
0117               
0119                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 647A C83B  50 at      mov   *r11+,@wyx
     647C 832A 
0019 647E 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 6480 B820  54 down    ab    @hb$01,@wyx
     6482 603C 
     6484 832A 
0028 6486 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 6488 7820  54 up      sb    @hb$01,@wyx
     648A 603C 
     648C 832A 
0037 648E 045B  20         b     *r11
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
0049 6490 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6492 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6494 832A 
0051 6496 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6498 832A 
0052 649A 045B  20         b     *r11
**** **** ****     > runlib.asm
0121               
0123                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
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
0021 649C C120  34 yx2px   mov   @wyx,tmp0
     649E 832A 
0022 64A0 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 64A2 06C4  14         swpb  tmp0                  ; Y<->X
0024 64A4 04C5  14         clr   tmp1                  ; Clear before copy
0025 64A6 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 64A8 20A0  38         coc   @wbit1,config         ; f18a present ?
     64AA 6048 
0030 64AC 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 64AE 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     64B0 833A 
     64B2 64DC 
0032 64B4 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 64B6 0A15  56         sla   tmp1,1                ; X = X * 2
0035 64B8 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 64BA 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     64BC 0500 
0037 64BE 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 64C0 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 64C2 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 64C4 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 64C6 D105  18         movb  tmp1,tmp0
0051 64C8 06C4  14         swpb  tmp0                  ; X<->Y
0052 64CA 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     64CC 604A 
0053 64CE 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 64D0 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     64D2 603C 
0059 64D4 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     64D6 604E 
0060 64D8 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 64DA 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 64DC 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0125               
0127                       copy  "vdp_px2yx_calc.asm"       ; VDP calculate YX coordinate for pixel pos
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
0023 64DE 20A0  38 px2yx   coc   @wbit0,config         ; Skip sprite adjustment ?
     64E0 604A 
0024 64E2 1302  14         jeq   px2yx1
0025 64E4 0224  22         ai    tmp0,>0100            ; Adjust Y. Top of screen is at >FF
     64E6 0100 
0026 64E8 C144  18 px2yx1  mov   tmp0,tmp1             ; Copy YX
0027 64EA C184  18         mov   tmp0,tmp2             ; Copy YX
0028               *--------------------------------------------------------------
0029               * Calculate Y tile position
0030               *--------------------------------------------------------------
0031 64EC 09B4  56         srl   tmp0,11               ; Y: Move to TMP0LB & (Y = Y / 8)
0032               *--------------------------------------------------------------
0033               * Calculate Y pixel offset
0034               *--------------------------------------------------------------
0035 64EE C1C4  18         mov   tmp0,tmp3             ; Y: Copy Y tile to TMP3LB
0036 64F0 0AB7  56         sla   tmp3,11               ; Y: Move to TMP3HB & (Y = Y * 8)
0037 64F2 0507  16         neg   tmp3
0038 64F4 B1C5  18         ab    tmp1,tmp3             ; Y: offset = Y pixel old + (-Y) pixel new
0039               *--------------------------------------------------------------
0040               * Calculate X tile position
0041               *--------------------------------------------------------------
0042 64F6 0245  22         andi  tmp1,>00ff            ; Clear TMP1HB
     64F8 00FF 
0043 64FA 0A55  56         sla   tmp1,5                ; X: Move to TMP1HB & (X = X / 8)
0044 64FC D105  18         movb  tmp1,tmp0             ; X: TMP0 <-- XY tile position
0045 64FE 06C4  14         swpb  tmp0                  ; XY tile position <-> YX tile position
0046               *--------------------------------------------------------------
0047               * Calculate X pixel offset
0048               *--------------------------------------------------------------
0049 6500 0245  22         andi  tmp1,>ff00            ; X: Get rid of remaining junk in TMP1LB
     6502 FF00 
0050 6504 0A35  56         sla   tmp1,3                ; X: (X = X * 8)
0051 6506 0505  16         neg   tmp1
0052 6508 06C6  14         swpb  tmp2                  ; YX <-> XY
0053 650A B146  18         ab    tmp2,tmp1             ; offset X = X pixel old  + (-X) pixel new
0054 650C 06C5  14         swpb  tmp1                  ; X0 <-> 0X
0055 650E D147  18         movb  tmp3,tmp1             ; 0X --> YX
0056 6510 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0129               
0131                       copy  "vdp_bitmap.asm"           ; VDP Bitmap functions
**** **** ****     > vdp_bitmap.asm
0001               * FILE......: vdp_bitmap.asm
0002               * Purpose...: VDP bitmap support module
0003               
0004               ***************************************************************
0005               * BITMAP - Set tiles for displaying bitmap picture
0006               ***************************************************************
0007               *  BL   @BITMAP
0008               ********|*****|*********************|**************************
0009 6512 C1CB  18 bitmap  mov   r11,tmp3              ; Save R11
0010 6514 C120  34         mov   @wbase,tmp0           ; Get PNT base address
     6516 8328 
0011 6518 06A0  32         bl    @vdwa                 ; Setup VDP write address
     651A 61BA 
0012 651C 04C5  14         clr   tmp1
0013 651E 0206  20         li    tmp2,768              ; Write 768 bytes
     6520 0300 
0014               *--------------------------------------------------------------
0015               * Repeat 3 times: write bytes >00 .. >FF
0016               *--------------------------------------------------------------
0017 6522 D7C5  30 bitma1  movb  tmp1,*r15             ; Write byte
0018 6524 0225  22         ai    tmp1,>0100
     6526 0100 
0019 6528 0606  14         dec   tmp2
0020 652A 16FB  14         jne   bitma1
0021 652C 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0133               
0135                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0013 652E C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6530 06A0  32         bl    @putvr                ; Write once
     6532 6236 
0015 6534 391C             data  >391c                 ; VR1/57, value 00011100
0016 6536 06A0  32         bl    @putvr                ; Write twice
     6538 6236 
0017 653A 391C             data  >391c                 ; VR1/57, value 00011100
0018 653C 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 653E C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 6540 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6542 6236 
0028 6544 391C             data  >391c
0029 6546 0458  20         b     *tmp4                 ; Exit
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
0040 6548 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 654A 06A0  32         bl    @cpym2v
     654C 633C 
0042 654E 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     6550 658C 
     6552 0006 
0043 6554 06A0  32         bl    @putvr
     6556 6236 
0044 6558 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 655A 06A0  32         bl    @putvr
     655C 6236 
0046 655E 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 6560 0204  20         li    tmp0,>3f00
     6562 3F00 
0052 6564 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     6566 61BE 
0053 6568 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     656A 8800 
0054 656C 0984  56         srl   tmp0,8
0055 656E D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     6570 8800 
0056 6572 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 6574 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 6576 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     6578 BFFF 
0060 657A 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 657C 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     657E 4000 
0063               f18chk_exit:
0064 6580 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     6582 6192 
0065 6584 3F00             data  >3f00,>00,6
     6586 0000 
     6588 0006 
0066 658A 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 658C 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 658E 3F00             data  >3f00                 ; 3f02 / 3f00
0073 6590 0340             data  >0340                 ; 3f04   0340  idle
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
0092 6592 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 6594 06A0  32         bl    @putvr
     6596 6236 
0097 6598 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 659A 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     659C 6236 
0100 659E 391C             data  >391c                 ; Lock the F18a
0101 65A0 0458  20         b     *tmp4                 ; Exit
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
0120 65A2 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 65A4 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     65A6 6048 
0122 65A8 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 65AA C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     65AC 8802 
0127 65AE 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     65B0 6236 
0128 65B2 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 65B4 04C4  14         clr   tmp0
0130 65B6 D120  34         movb  @vdps,tmp0
     65B8 8802 
0131 65BA 0984  56         srl   tmp0,8
0132 65BC 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0137               
0139                       copy  "vdp_hchar.asm"            ; VDP hchar functions
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
0017 65BE C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     65C0 832A 
0018 65C2 D17B  28         movb  *r11+,tmp1
0019 65C4 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 65C6 D1BB  28         movb  *r11+,tmp2
0021 65C8 0986  56         srl   tmp2,8                ; Repeat count
0022 65CA C1CB  18         mov   r11,tmp3
0023 65CC 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     65CE 62FE 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 65D0 020B  20         li    r11,hchar1
     65D2 65D8 
0028 65D4 0460  28         b     @xfilv                ; Draw
     65D6 6198 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 65D8 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     65DA 604C 
0033 65DC 1302  14         jeq   hchar2                ; Yes, exit
0034 65DE C2C7  18         mov   tmp3,r11
0035 65E0 10EE  14         jmp   hchar                 ; Next one
0036 65E2 05C7  14 hchar2  inct  tmp3
0037 65E4 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0141               
0143                       copy  "vdp_vchar.asm"            ; VDP vchar functions
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
0017 65E6 C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     65E8 832A 
0018 65EA C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 65EC C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     65EE 833A 
0020 65F0 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     65F2 62FE 
0021 65F4 D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 65F6 D1B7  28         movb  *tmp3+,tmp2
0023 65F8 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 65FA 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     65FC 61BA 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 65FE D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 6600 A108  18         a     tmp4,tmp0             ; Next row
0033 6602 0606  14         dec   tmp2
0034 6604 16FA  14         jne   vchar2
0035 6606 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     6608 604C 
0036 660A 1303  14         jeq   vchar3                ; Yes, exit
0037 660C C837  50         mov   *tmp3+,@wyx           ; Save YX position
     660E 832A 
0038 6610 10ED  14         jmp   vchar1                ; Next one
0039 6612 05C7  14 vchar3  inct  tmp3
0040 6614 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 6616 C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 6618 C804  38         mov   tmp0,@wyx             ; Set cursor position
     661A 832A 
0051 661C 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 661E C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     6620 833A 
0053 6622 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     6624 62FE 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 6626 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     6628 61BA 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 662A D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 662C A120  34         a     @wcolmn,tmp0          ; Next row
     662E 833A 
0063 6630 0606  14         dec   tmp2
0064 6632 16F9  14         jne   xvcha1
0065 6634 0458  20         b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0145               
0147                       copy  "vdp_boxes.asm"            ; VDP box functions
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
0019 6636 C83B  50 filbox  mov   *r11+,@wyx            ; Upper left corner
     6638 832A 
0020 663A D1FB  28         movb  *r11+,tmp3            ; Height in TMP3
0021 663C D1BB  28         movb  *r11+,tmp2            ; Width in TMP2
0022 663E C17B  30         mov   *r11+,tmp1            ; Byte to fill
0023 6640 C20B  18         mov   r11,tmp4              ; Save R11
0024 6642 0986  56         srl   tmp2,8                ; Right-align width
0025 6644 0987  56         srl   tmp3,8                ; Right-align height
0026               *--------------------------------------------------------------
0027               *  Do single row
0028               *--------------------------------------------------------------
0029 6646 06A0  32 filbo1  bl    @yx2pnt               ; Get VDP address into TMP0
     6648 62FE 
0030 664A 020B  20         li    r11,filbo2            ; New return address
     664C 6652 
0031 664E 0460  28         b     @xfilv                ; Fill VRAM with byte
     6650 6198 
0032               *--------------------------------------------------------------
0033               *  Recover width & character
0034               *--------------------------------------------------------------
0035 6652 C108  18 filbo2  mov   tmp4,tmp0
0036 6654 0224  22         ai    tmp0,-3               ; R11 - 3
     6656 FFFD 
0037 6658 D1B4  28         movb  *tmp0+,tmp2           ; Get Width/Height
0038 665A 0986  56         srl   tmp2,8                ; Right align
0039 665C C154  26         mov   *tmp0,tmp1            ; Get character to fill
0040               *--------------------------------------------------------------
0041               *  Housekeeping
0042               *--------------------------------------------------------------
0043 665E A820  54         a     @w$0100,@by           ; Y=Y+1
     6660 603C 
     6662 832A 
0044 6664 0607  14         dec   tmp3
0045 6666 15EF  14         jgt   filbo1                ; Process next row
0046 6668 8818  46         c     *tmp4,@w$ffff         ; End-Of-List marker found ?
     666A 604C 
0047 666C 1302  14         jeq   filbo3                ; Yes, exit
0048 666E C2C8  18         mov   tmp4,r11
0049 6670 10E2  14         jmp   filbox                ; Next one
0050 6672 05C8  14 filbo3  inct  tmp4
0051 6674 0458  20         b     *tmp4                 ; Exit
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
0083 6676 C13B  30 putbox  mov   *r11+,tmp0            ; P0 - Upper left corner YX
0084 6678 C15B  26         mov   *r11,tmp1             ; P1 - Height/Width in TMP1
0085 667A C1BB  30         mov   *r11+,tmp2            ; P1 - Height/Width in TMP2
0086 667C C1FB  30         mov   *r11+,tmp3            ; P2 - Pointer to string
0087 667E C83B  50         mov   *r11+,@waux1          ; P3 - Box repeat count AB
     6680 833C 
0088 6682 C80B  38         mov   r11,@waux2            ; Save R11
     6684 833E 
0089               *--------------------------------------------------------------
0090               *  Calculate some positions
0091               *--------------------------------------------------------------
0092 6686 B184  18 putbo0  ab    tmp0,tmp2             ; TMP2HB = height + Y
0093 6688 06C4  14         swpb  tmp0
0094 668A 06C5  14         swpb  tmp1
0095 668C B144  18         ab    tmp0,tmp1             ; TMP1HB = width  + X
0096 668E 06C4  14         swpb  tmp0
0097 6690 0A12  56         sla   config,1              ; \ clear config bit 0
0098 6692 0912  56         srl   config,1              ; / is only 4 bytes
0099 6694 C804  38         mov   tmp0,@waux3           ; Set additional work copy of YX cursor
     6696 8340 
0100               *--------------------------------------------------------------
0101               *  Setup VDP write address
0102               *--------------------------------------------------------------
0103 6698 C804  38 putbo1  mov   tmp0,@wyx             ; Set YX cursor
     669A 832A 
0104 669C 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     669E 62FE 
0105 66A0 06A0  32         bl    @vdwa                 ; Set VDP write address from TMP0
     66A2 61BA 
0106 66A4 C120  34         mov   @wyx,tmp0
     66A6 832A 
0107               *--------------------------------------------------------------
0108               *  Prepare string for processing
0109               *--------------------------------------------------------------
0110 66A8 20A0  38         coc   @wbit0,config         ; state flag set ?
     66AA 604A 
0111 66AC 1302  14         jeq   putbo2                ; Yes, skip length byte
0112 66AE D237  28         movb  *tmp3+,tmp4           ; Get length byte ...
0113 66B0 0988  56         srl   tmp4,8                ; ... and right justify
0114               *--------------------------------------------------------------
0115               *  Write line of tiles in box
0116               *--------------------------------------------------------------
0117 66B2 D7F7  40 putbo2  movb  *tmp3+,*r15           ; Write to VDP
0118 66B4 0608  14         dec   tmp4
0119 66B6 1310  14         jeq   putbo3                ; End of string. Repeat box ?
0120               *--------------------------------------------------------------
0121               *    Adjust cursor
0122               *--------------------------------------------------------------
0123 66B8 0584  14         inc   tmp0                  ; X=X+1
0124 66BA 06C4  14         swpb  tmp0
0125 66BC 9144  18         cb    tmp0,tmp1             ; Right boundary reached ?
0126 66BE 06C4  14         swpb  tmp0
0127 66C0 11F8  14         jlt   putbo2                ; Not yet, continue
0128 66C2 0224  22         ai    tmp0,>0100            ; Y=Y+1
     66C4 0100 
0129 66C6 D804  38         movb  tmp0,@wyx             ; Update Y cursor
     66C8 832A 
0130 66CA 9184  18         cb    tmp0,tmp2             ; Bottom boundary reached ?
0131 66CC 1305  14         jeq   putbo3                ; Yes, exit
0132               *--------------------------------------------------------------
0133               *  Recover starting column
0134               *--------------------------------------------------------------
0135 66CE C120  34         mov   @wyx,tmp0             ; ... from YX cursor
     66D0 832A 
0136 66D2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     66D4 8000 
0137 66D6 10E0  14         jmp   putbo1                ; Draw next line
0138               *--------------------------------------------------------------
0139               *  Handling repeating of box
0140               *--------------------------------------------------------------
0141 66D8 C120  34 putbo3  mov   @waux1,tmp0           ; Repeat box ?
     66DA 833C 
0142 66DC 1328  14         jeq   putbo9                ; No, move on to next list entry
0143               *--------------------------------------------------------------
0144               *     Repeat horizontally
0145               *--------------------------------------------------------------
0146 66DE 06C4  14         swpb  tmp0                  ; BA
0147 66E0 D104  18         movb  tmp0,tmp0             ; B = 0 ?
0148 66E2 130D  14         jeq   putbo4                ; Yes, repeat vertically
0149 66E4 06C4  14         swpb  tmp0                  ; AB
0150 66E6 0604  14         dec   tmp0                  ; B = B - 1
0151 66E8 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     66EA 833C 
0152 66EC D805  38         movb  tmp1,@waux3+1         ; New X position
     66EE 8341 
0153 66F0 C120  34         mov   @waux3,tmp0           ; Get new YX position
     66F2 8340 
0154 66F4 C1E0  34         mov   @waux2,tmp3
     66F6 833E 
0155 66F8 0227  22         ai    tmp3,-6               ; Back to P1
     66FA FFFA 
0156 66FC 1014  14         jmp   putbo8
0157               *--------------------------------------------------------------
0158               *     Repeat vertically
0159               *--------------------------------------------------------------
0160 66FE 06C4  14 putbo4  swpb  tmp0                  ; AB
0161 6700 D104  18         movb  tmp0,tmp0             ; A = 0 ?
0162 6702 13EA  14         jeq   putbo3                ; Yes, check next entry in list
0163 6704 0224  22         ai    tmp0,->0100           ; A = A - 1
     6706 FF00 
0164 6708 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     670A 833C 
0165 670C C1E0  34         mov   @waux2,tmp3           ; \
     670E 833E 
0166 6710 0607  14         dec   tmp3                  ; / Back to P3LB
0167 6712 D817  46         movb  *tmp3,@waux1+1        ; Update B repeat count
     6714 833D 
0168 6716 D106  18         movb  tmp2,tmp0             ; New Y position
0169 6718 06C4  14         swpb  tmp0
0170 671A 0227  22         ai    tmp3,-6               ; Back to P0LB
     671C FFFA 
0171 671E D137  28         movb  *tmp3+,tmp0
0172 6720 06C4  14         swpb  tmp0
0173 6722 C804  38         mov   tmp0,@waux3           ; Set new YX position
     6724 8340 
0174               *--------------------------------------------------------------
0175               *      Get Height, Width and reset string pointer
0176               *--------------------------------------------------------------
0177 6726 C157  26 putbo8  mov   *tmp3,tmp1            ; Get P1 into TMP1
0178 6728 C1B7  30         mov   *tmp3+,tmp2           ; Get P1 into TMP2
0179 672A C1D7  26         mov   *tmp3,tmp3            ; Get P2 into TMP3
0180 672C 10AC  14         jmp   putbo0                ; Next box
0181               *--------------------------------------------------------------
0182               *  Next entry in list
0183               *--------------------------------------------------------------
0184 672E C2E0  34 putbo9  mov   @waux2,r11            ; Restore R11
     6730 833E 
0185 6732 881B  46         c     *r11,@w$ffff          ; End-Of-List marker found ?
     6734 604C 
0186 6736 1301  14         jeq   putboa                ; Yes, exit
0187 6738 109E  14         jmp   putbox                ; Next one
0188 673A 0A22  56 putboa  sla   config,2              ; \ clear config bits 0 & 1
0189 673C 0922  56         srl   config,2              ; / is only 4 bytes
0190 673E 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0149               
0151                       copy  "vdp_viewport.asm"         ; VDP viewport functionality
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
0013 6740 C83B  50 scrdim  mov   *r11+,@wbase          ; VDP destination address
     6742 8328 
0014 6744 C83B  50         mov   *r11+,@wcolmn         ; Number of columns per row
     6746 833A 
0015 6748 045B  20         b     *r11                  ; Exit
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
0045 674A C23B  30 view    mov   *r11+,tmp4            ; P0: Get pointer to RAM buffer
0046 674C C620  46         mov   @wbase,*tmp4          ; RAM 01 - Save physical screen VRAM base
     674E 8328 
0047 6750 CA20  54         mov   @wcolmn,@2(tmp4)      ; RAM 23 - Save physical screen size (columns per row)
     6752 833A 
     6754 0002 
0048 6756 CA3B  50         mov   *r11+,@4(tmp4)        ; RAM 45 - P1: Get viewport upper left corner YX
     6758 0004 
0049 675A C1FB  30         mov   *r11+,tmp3            ;
0050 675C CA07  38         mov   tmp3,@6(tmp4)         ; RAM 67 - P2: Get viewport height & width
     675E 0006 
0051 6760 C83B  50         mov   *r11+,@waux1          ; P3: Get virtual screen VRAM base address
     6762 833C 
0052 6764 C83B  50         mov   *r11+,@waux2          ; P4: Get virtual screen size (columns per row)
     6766 833E 
0053 6768 C804  38         mov   tmp0,@waux3           ; Get upper left corner YX in virtual screen
     676A 8340 
0054 676C CA0B  38         mov   r11,@8(tmp4)          ; RAM 89 - Store R11 for exit
     676E 0008 
0055 6770 0A12  56         sla   config,1              ; \
0056 6772 0912  56         srl   config,1              ; / Clear CONFIG bits 0
0057 6774 0987  56         srl   tmp3,8                ; Row counter
0058               *--------------------------------------------------------------
0059               *    Set virtual screen dimension and position cursor
0060               *--------------------------------------------------------------
0061 6776 C820  54 view1   mov   @waux1,@wbase         ; Set virtual screen base
     6778 833C 
     677A 8328 
0062 677C C820  54         mov   @waux2,@wcolmn        ; Set virtual screen width
     677E 833E 
     6780 833A 
0063 6782 C820  54         mov   @waux3,@wyx           ; Set cursor in virtual screen
     6784 8340 
     6786 832A 
0064               *--------------------------------------------------------------
0065               *    Prepare for copying a single line
0066               *--------------------------------------------------------------
0067 6788 06A0  32 view2   bl    @yx2pnt               ; Get VRAM address in TMP0
     678A 62FE 
0068 678C C148  18         mov   tmp4,tmp1             ; RAM buffer + 10
0069 678E 0225  22         ai    tmp1,10               ;
     6790 000A 
0070 6792 C1A8  34         mov   @6(tmp4),tmp2         ; \ Get RAM buffer byte 1
     6794 0006 
0071 6796 0246  22         andi  tmp2,>00ff            ; / Clear MSB
     6798 00FF 
0072 679A 28A0  34         xor   @wbit0,config         ; Toggle bit 0
     679C 604A 
0073 679E 24A0  38         czc   @wbit0,config         ; Bit 0=0 ?
     67A0 604A 
0074 67A2 130B  14         jeq   view4                 ; Yes! So copy from RAM to VRAM
0075               *--------------------------------------------------------------
0076               *    Copy line from VRAM to RAM
0077               *--------------------------------------------------------------
0078 67A4 06A0  32 view3   bl    @xpyv2m               ; Copy block from VRAM (virtual screen) to RAM
     67A6 6368 
0079 67A8 C818  46         mov   *tmp4,@wbase          ; Set physical screen base
     67AA 8328 
0080 67AC C828  54         mov   @2(tmp4),@wcolmn      ; Set physical screen columns per row
     67AE 0002 
     67B0 833A 
0081 67B2 C828  54         mov   @4(tmp4),@wyx         ; Set cursor in physical screen
     67B4 0004 
     67B6 832A 
0082 67B8 10E7  14         jmp   view2
0083               *--------------------------------------------------------------
0084               *    Copy line from RAM to VRAM
0085               *--------------------------------------------------------------
0086 67BA 06A0  32 view4   bl    @xpym2v               ; Copy block to VRAM
     67BC 6342 
0087 67BE BA20  54         ab    @hb$01,@4(tmp4)       ; Physical screen Y=Y+1
     67C0 603C 
     67C2 0004 
0088 67C4 B820  54         ab    @hb$01,@waux3         ; Virtual screen  Y=Y+1
     67C6 603C 
     67C8 8340 
0089 67CA 0607  14         dec   tmp3                  ; Update row counter
0090 67CC 16D4  14         jne   view1                 ; Next line unless all rows process
0091               *--------------------------------------------------------------
0092               *    Exit
0093               *--------------------------------------------------------------
0094 67CE C2E8  34 viewz   mov   @8(tmp4),r11          ; \
     67D0 0008 
0095 67D2 045B  20         b     *r11                  ; / exit
**** **** ****     > runlib.asm
0153               
0155                       copy  "snd_player.asm"           ; Sound player
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
0014 67D4 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     67D6 8334 
0015 67D8 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     67DA 6030 
0016 67DC 0204  20         li    tmp0,muttab
     67DE 67EE 
0017 67E0 0205  20         li    tmp1,sound            ; Sound generator port >8400
     67E2 8400 
0018 67E4 D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 67E6 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 67E8 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 67EA D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 67EC 045B  20         b     *r11
0023 67EE 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     67F0 DFFF 
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
0043 67F2 C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     67F4 8334 
0044 67F6 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     67F8 8336 
0045 67FA 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     67FC FFF8 
0046 67FE E0BB  30         soc   *r11+,config          ; Set options
0047 6800 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     6802 603C 
     6804 831B 
0048 6806 045B  20         b     *r11
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
0059 6808 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     680A 6030 
0060 680C 1301  14         jeq   sdpla1                ; Yes, play
0061 680E 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 6810 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 6812 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     6814 831B 
     6816 602A 
0067 6818 1301  14         jeq   sdpla3                ; Play next note
0068 681A 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 681C 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     681E 602C 
0070 6820 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 6822 C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     6824 8336 
0075 6826 06C4  14         swpb  tmp0
0076 6828 D804  38         movb  tmp0,@vdpa
     682A 8C02 
0077 682C 06C4  14         swpb  tmp0
0078 682E D804  38         movb  tmp0,@vdpa
     6830 8C02 
0079 6832 04C4  14         clr   tmp0
0080 6834 D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     6836 8800 
0081 6838 131E  14         jeq   sdexit                ; Yes. exit
0082 683A 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 683C A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     683E 8336 
0084 6840 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     6842 8800 
     6844 8400 
0085 6846 0604  14         dec   tmp0
0086 6848 16FB  14         jne   vdpla2
0087 684A D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     684C 8800 
     684E 831B 
0088 6850 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     6852 8336 
0089 6854 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 6856 C120  34 mmplay  mov   @wsdtmp,tmp0
     6858 8336 
0094 685A D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 685C 130C  14         jeq   sdexit                ; Yes, exit
0096 685E 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 6860 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     6862 8336 
0098 6864 D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     6866 8400 
0099 6868 0605  14         dec   tmp1
0100 686A 16FC  14         jne   mmpla2
0101 686C D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     686E 831B 
0102 6870 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     6872 8336 
0103 6874 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 6876 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     6878 602E 
0108 687A 1607  14         jne   sdexi2                ; No, exit
0109 687C C820  54         mov   @wsdlst,@wsdtmp
     687E 8334 
     6880 8336 
0110 6882 D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     6884 603C 
     6886 831B 
0111 6888 045B  20 sdexi1  b     *r11                  ; Exit
0112 688A 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     688C FFF8 
0113 688E 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > runlib.asm
0157               
0159                       copy  "speech_detect.asm"        ; Detect speech synthesizer
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
0020 6890 0204  20 spstat  li    tmp0,spchrd           ; (R4) = >9000
     6892 9000 
0021 6894 C820  54         mov   @spcode,@mcsprd       ; \
     6896 612A 
     6898 8322 
0022 689A C820  54         mov   @spcode+2,@mcsprd+2   ; / Load speech read code
     689C 612C 
     689E 8324 
0023 68A0 020B  20         li    r11,spsta1            ; Return to SPSTA1
     68A2 68A8 
0024 68A4 0460  28         b     @mcsprd               ; Run scratchpad code
     68A6 8322 
0025 68A8 C820  54 spsta1  mov   @mccode,@mcsprd       ; \
     68AA 6124 
     68AC 8322 
0026 68AE C820  54         mov   @mccode+2,@mcsprd+2   ; / Restore tight loop code
     68B0 6126 
     68B2 8324 
0027 68B4 0456  20         b     *tmp2                 ; Exit
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
0047 68B6 C1CB  18 spconn  mov   r11,tmp3              ; Save R11
0048               *--------------------------------------------------------------
0049               * Setup speech synthesizer memory address >0000
0050               *--------------------------------------------------------------
0051 68B8 0204  20         li    tmp0,>4000            ; Load >40 (speech memory address command)
     68BA 4000 
0052 68BC 0205  20         li    tmp1,5                ; Process 5 nibbles in total
     68BE 0005 
0053 68C0 D804  38 spcon1  movb  tmp0,@spchwt          ; Write nibble >40 (5x)
     68C2 9400 
0054 68C4 0605  14         dec   tmp1
0055 68C6 16FC  14         jne   spcon1
0056               *--------------------------------------------------------------
0057               * Read first byte from speech synthesizer memory address >0000
0058               *--------------------------------------------------------------
0059 68C8 0204  20         li    tmp0,>1000
     68CA 1000 
0060 68CC D804  38         movb  tmp0,@spchwt          ; Load >10 (speech memory read command)
     68CE 9400 
0061 68D0 1000  14         nop                         ; \
0062 68D2 1000  14         nop                         ; / 12 Microseconds delay
0063 68D4 0206  20         li    tmp2,spcon2
     68D6 68DC 
0064 68D8 0460  28         b     @spstat               ; Read status byte
     68DA 6890 
0065               *--------------------------------------------------------------
0066               * Update status bit 5 in CONFIG register
0067               *--------------------------------------------------------------
0068 68DC 0984  56 spcon2  srl   tmp0,8                ; MSB to LSB
0069 68DE 0284  22         ci    tmp0,>00aa            ; >aa means speech found
     68E0 00AA 
0070 68E2 1603  14         jne   spcon3
0071 68E4 E0A0  34         soc   @wbit5,config         ; Set config bit5=1
     68E6 6040 
0072 68E8 1002  14         jmp   spcon4
0073 68EA 40A0  34 spcon3  szc   @wbit5,config         ; Set config bit5=0
     68EC 6040 
0074 68EE 0457  20 spcon4  b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0161               
0163                       copy  "speech_player.asm"        ; Speech synthesizer player
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
0017 68F0 C83B  50 spprep  mov   *r11+,@wspeak         ; Set speech address
     68F2 8338 
0018 68F4 E0A0  34         soc   @wbit3,config         ; Clear bit 3
     68F6 6044 
0019 68F8 045B  20         b     *r11
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
0030 68FA 24A0  38 spplay  czc   @wbit3,config         ; Player off ?
     68FC 6044 
0031 68FE 132F  14         jeq   spplaz                ; Yes, exit
0032 6900 C1CB  18 sppla1  mov   r11,tmp3              ; Save R11
0033 6902 20A0  38         coc   @tmp010,config        ; Speech player enabled+busy ?
     6904 6960 
0034 6906 1310  14         jeq   spkex3                ; Check FIFO buffer level
0035               *--------------------------------------------------------------
0036               * Speak external: Push LPC data to speech synthesizer
0037               *--------------------------------------------------------------
0038 6908 C120  34 spkext  mov   @wspeak,tmp0
     690A 8338 
0039 690C D834  48         movb  *tmp0+,@spchwt        ; Send byte to speech synth
     690E 9400 
0040 6910 1000  14         jmp   $+2                   ; Delay
0041 6912 0206  20         li    tmp2,16
     6914 0010 
0042 6916 D834  48 spkex1  movb  *tmp0+,@spchwt        ; Send byte to speech synth
     6918 9400 
0043 691A 0606  14         dec   tmp2
0044 691C 16FC  14         jne   spkex1
0045 691E 0262  22         ori   config,>0800          ; bit 4=1 (busy)
     6920 0800 
0046 6922 C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     6924 8338 
0047 6926 101B  14         jmp   spplaz                ; Exit
0048               *--------------------------------------------------------------
0049               * Speak external: Check synth FIFO buffer level
0050               *--------------------------------------------------------------
0051 6928 0206  20 spkex3  li    tmp2,spkex4           ; Set return address for SPSTAT
     692A 6930 
0052 692C 0460  28         b     @spstat               ; Get speech FIFO buffer status
     692E 6890 
0053 6930 2120  38 spkex4  coc   @w$4000,tmp0          ; FIFO BL (buffer low) bit set?
     6932 6048 
0054 6934 1301  14         jeq   spkex5                ; Yes, refill
0055 6936 1013  14         jmp   spplaz                ; No, exit
0056               *--------------------------------------------------------------
0057               * Speak external: Refill synth with LPC data if FIFO buffer low
0058               *--------------------------------------------------------------
0059 6938 C120  34 spkex5  mov   @wspeak,tmp0
     693A 8338 
0060 693C 0206  20         li    tmp2,8                ; Bytes to send to speech synth
     693E 0008 
0061 6940 D174  28 spkex6  movb  *tmp0+,tmp1
0062 6942 D805  38         movb  tmp1,@spchwt          ; Send byte to speech synth
     6944 9400 
0063 6946 0285  22         ci    tmp1,spkoff           ; Speak off marker found ?
     6948 FF00 
0064 694A 1305  14         jeq   spkex8
0065 694C 0606  14         dec   tmp2
0066 694E 16F8  14         jne   spkex6                ; Send next byte
0067 6950 C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     6952 8338 
0068 6954 1004  14 spkex7  jmp   spplaz                ; Exit
0069               *--------------------------------------------------------------
0070               * Speak external: Done with speaking
0071               *--------------------------------------------------------------
0072 6956 40A0  34 spkex8  szc   @tmp010,config        ; bit 3,4,5=0
     6958 6960 
0073 695A 04E0  34         clr   @wspeak               ; Reset pointer
     695C 8338 
0074 695E 0457  20 spplaz  b     *tmp3                 ; Exit
0075 6960 1800     tmp010  data  >1800                 ; Binary 0001100000000000
0076                                                   ; Bit    0123456789ABCDEF
**** **** ****     > runlib.asm
0165               
0167                       copy  "keyb_virtual.asm"         ; Virtual keyboard scanning
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
0088 6962 40A0  34         szc   @wbit11,config        ; Reset ANY key
     6964 6034 
0089 6966 C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 6968 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 696A 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 696C 0207  20         li    tmp3,kbmap0           ; Start with column 0
     696E 69DE 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 6970 04CC  14         clr   r12
0097 6972 1E15  20         sbz   >0015                 ; Set P5
0098 6974 1F07  20         tb    7
0099 6976 1302  14         jeq   virtk1
0100 6978 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     697A 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 697C 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 697E 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     6980 0024 
0107 6982 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 6984 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     6986 0006 
0109 6988 0705  14         seto  tmp1                  ; >FFFF
0110 698A 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 698C 0545  14         inv   tmp1
0112 698E 1302  14         jeq   virtk2                ; >0000 ?
0113 6990 E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     6992 6034 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 6994 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 6996 1601  14         jne   virtk3
0119 6998 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 699A 05C7  14 virtk3  inct  tmp3
0121 699C 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     699E 69EA 
0122 69A0 16F9  14         jne   virtk2                ; No, next entry
0123 69A2 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 69A4 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     69A6 0700 
0128 69A8 1309  14         jeq   virtk6                ; Yes, exit
0129 69AA 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     69AC 0200 
0130 69AE 1303  14         jeq   virtk5                ; Yes, skip
0131 69B0 0224  22         ai    tmp0,>0100
     69B2 0100 
0132 69B4 10E3  14         jmp   virtk1
0133 69B6 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     69B8 0500 
0134 69BA 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 69BC C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 69BE C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     69C0 8332 
0140 69C2 1601  14         jne   virtk7
0141 69C4 045B  20         b     *r11                  ; Exit
0142 69C6 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     69C8 FFFF 
0143 69CA 1603  14         jne   virtk8                ; No
0144 69CC 0701  14         seto  r1                    ; Set exit flag
0145 69CE 0460  28         b     @runli1               ; Yes, reset computer
     69D0 7224 
0146 69D2 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     69D4 8000 
0147 69D6 1602  14         jne   virtk9
0148 69D8 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     69DA 6034 
0149 69DC 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 69DE 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     69E0 FFFF 
0155 69E2 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     69E4 0020 
0156 69E6 0400             data  >0400,kenter          ; >04 00000100  enter
     69E8 4000 
0157 69EA FFFF     kbeoc   data  >ffff
0158               
0159 69EC 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     69EE 1000 
0160 69F0 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     69F2 0008 
0161 69F4 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     69F6 0004 
0162 69F8 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     69FA 0200 
0163 69FC 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     69FE 0040 
0164 6A00 FFFF             data  >ffff
0165               
0166 6A02 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     6A04 2000 
0167 6A06 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     6A08 0002 
0168 6A0A 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     6A0C 0100 
0169 6A0E 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     6A10 0080 
0170 6A12 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     6A14 0010 
0171 6A16 FFFF             data  >ffff
0172               
0173 6A18 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     6A1A 0001 
0174 6A1C 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     6A1E 0800 
0175 6A20 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     6A22 0020 
0176 6A24 FFFF             data  >ffff
0177               
0178 6A26 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     6A28 0020 
0179 6A2A 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     6A2C 0200 
0180 6A2E 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     6A30 0100 
0181 6A32 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     6A34 0040 
0182 6A36 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     6A38 0080 
0183 6A3A FFFF             data  >ffff
0184               
0185 6A3C 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     6A3E 0001 
0186 6A40 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     6A42 0010 
0187 6A44 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     6A46 0008 
0188 6A48 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     6A4A 0002 
0189 6A4C 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     6A4E 0004 
0190 6A50 FFFF             data  >ffff
**** **** ****     > runlib.asm
0169               
0171                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 6A52 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6A54 604A 
0017 6A56 020C  20         li    r12,>0024
     6A58 0024 
0018 6A5A 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6A5C 6AEA 
0019 6A5E 04C6  14         clr   tmp2
0020 6A60 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6A62 04CC  14         clr   r12
0025 6A64 1F08  20         tb    >0008                 ; Shift-key ?
0026 6A66 1302  14         jeq   realk1                ; No
0027 6A68 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6A6A 6B1A 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6A6C 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6A6E 1302  14         jeq   realk2                ; No
0033 6A70 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6A72 6B4A 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6A74 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6A76 1302  14         jeq   realk3                ; No
0039 6A78 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6A7A 6B7A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6A7C 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6A7E 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6A80 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6A82 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6A84 604A 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6A86 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6A88 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6A8A 0006 
0052 6A8C 0606  14 realk5  dec   tmp2
0053 6A8E 020C  20         li    r12,>24               ; CRU address for P2-P4
     6A90 0024 
0054 6A92 06C6  14         swpb  tmp2
0055 6A94 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6A96 06C6  14         swpb  tmp2
0057 6A98 020C  20         li    r12,6                 ; CRU read address
     6A9A 0006 
0058 6A9C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6A9E 0547  14         inv   tmp3                  ;
0060 6AA0 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6AA2 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6AA4 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6AA6 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6AA8 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6AAA 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6AAC 0285  22         ci    tmp1,8
     6AAE 0008 
0069 6AB0 1AFA  14         jl    realk6
0070 6AB2 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6AB4 1BEB  14         jh    realk5                ; No, next column
0072 6AB6 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6AB8 C206  18 realk8  mov   tmp2,tmp4
0077 6ABA 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6ABC A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6ABE A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6AC0 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6AC2 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6AC4 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6AC6 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6AC8 604A 
0087 6ACA 1608  14         jne   realka                ; No, continue saving key
0088 6ACC 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6ACE 6B14 
0089 6AD0 1A05  14         jl    realka
0090 6AD2 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     6AD4 6B12 
0091 6AD6 1B02  14         jh    realka                ; No, continue
0092 6AD8 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     6ADA E000 
0093 6ADC C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     6ADE 833C 
0094 6AE0 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     6AE2 6034 
0095 6AE4 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     6AE6 8C00 
0096 6AE8 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 6AEA FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6AEC 0000 
     6AEE FF0D 
     6AF0 203D 
0099 6AF2 ....             text  'xws29ol.'
0100 6AFA ....             text  'ced38ik,'
0101 6B02 ....             text  'vrf47ujm'
0102 6B0A ....             text  'btg56yhn'
0103 6B12 ....             text  'zqa10p;/'
0104 6B1A FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6B1C 0000 
     6B1E FF0D 
     6B20 202B 
0105 6B22 ....             text  'XWS@(OL>'
0106 6B2A ....             text  'CED#*IK<'
0107 6B32 ....             text  'VRF$&UJM'
0108 6B3A ....             text  'BTG%^YHN'
0109 6B42 ....             text  'ZQA!)P:-'
0110 6B4A FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6B4C 0000 
     6B4E FF0D 
     6B50 2005 
0111 6B52 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6B54 0804 
     6B56 0F27 
     6B58 C2B9 
0112 6B5A 600B             data  >600b,>0907,>063f,>c1B8
     6B5C 0907 
     6B5E 063F 
     6B60 C1B8 
0113 6B62 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6B64 7B02 
     6B66 015F 
     6B68 C0C3 
0114 6B6A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6B6C 7D0E 
     6B6E 0CC6 
     6B70 BFC4 
0115 6B72 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6B74 7C03 
     6B76 BC22 
     6B78 BDBA 
0116 6B7A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6B7C 0000 
     6B7E FF0D 
     6B80 209D 
0117 6B82 9897             data  >9897,>93b2,>9f8f,>8c9B
     6B84 93B2 
     6B86 9F8F 
     6B88 8C9B 
0118 6B8A 8385             data  >8385,>84b3,>9e89,>8b80
     6B8C 84B3 
     6B8E 9E89 
     6B90 8B80 
0119 6B92 9692             data  >9692,>86b4,>b795,>8a8D
     6B94 86B4 
     6B96 B795 
     6B98 8A8D 
0120 6B9A 8294             data  >8294,>87b5,>b698,>888E
     6B9C 87B5 
     6B9E B698 
     6BA0 888E 
0121 6BA2 9A91             data  >9a91,>81b1,>b090,>9cBB
     6BA4 81B1 
     6BA6 B090 
     6BA8 9CBB 
**** **** ****     > runlib.asm
0173               
0175                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
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
0023 6BAA C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 6BAC C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     6BAE 8340 
0025 6BB0 04E0  34         clr   @waux1
     6BB2 833C 
0026 6BB4 04E0  34         clr   @waux2
     6BB6 833E 
0027 6BB8 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     6BBA 833C 
0028 6BBC C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 6BBE 0205  20         li    tmp1,4                ; 4 nibbles
     6BC0 0004 
0033 6BC2 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 6BC4 0246  22         andi  tmp2,>000f            ; Only keep LSN
     6BC6 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 6BC8 0286  22         ci    tmp2,>000a
     6BCA 000A 
0039 6BCC 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 6BCE C21B  26         mov   *r11,tmp4
0045 6BD0 0988  56         srl   tmp4,8                ; Right justify
0046 6BD2 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     6BD4 FFF6 
0047 6BD6 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 6BD8 C21B  26         mov   *r11,tmp4
0054 6BDA 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     6BDC 00FF 
0055               
0056 6BDE A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 6BE0 06C6  14         swpb  tmp2
0058 6BE2 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 6BE4 0944  56         srl   tmp0,4                ; Next nibble
0060 6BE6 0605  14         dec   tmp1
0061 6BE8 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 6BEA 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     6BEC BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 6BEE C160  34         mov   @waux3,tmp1           ; Get pointer
     6BF0 8340 
0067 6BF2 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 6BF4 0585  14         inc   tmp1                  ; Next byte, not word!
0069 6BF6 C120  34         mov   @waux2,tmp0
     6BF8 833E 
0070 6BFA 06C4  14         swpb  tmp0
0071 6BFC DD44  32         movb  tmp0,*tmp1+
0072 6BFE 06C4  14         swpb  tmp0
0073 6C00 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 6C02 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     6C04 8340 
0078 6C06 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     6C08 6040 
0079 6C0A 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 6C0C C120  34         mov   @waux1,tmp0
     6C0E 833C 
0084 6C10 06C4  14         swpb  tmp0
0085 6C12 DD44  32         movb  tmp0,*tmp1+
0086 6C14 06C4  14         swpb  tmp0
0087 6C16 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 6C18 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6C1A 604A 
0092 6C1C 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 6C1E 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 6C20 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     6C22 7FFF 
0098 6C24 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     6C26 8340 
0099 6C28 0460  28         b     @xutst0               ; Display string
     6C2A 6324 
0100 6C2C 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 6C2E C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     6C30 832A 
0122 6C32 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6C34 8000 
0123 6C36 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
**** **** ****     > runlib.asm
0177               
0179                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 6C38 0207  20 mknum   li    tmp3,5                ; Digit counter
     6C3A 0005 
0020 6C3C C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6C3E C155  26         mov   *tmp1,tmp1            ; /
0022 6C40 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6C42 0228  22         ai    tmp4,4                ; Get end of buffer
     6C44 0004 
0024 6C46 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6C48 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6C4A 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6C4C 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6C4E 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6C50 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6C52 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6C54 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6C56 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6C58 0607  14         dec   tmp3                  ; Decrease counter
0036 6C5A 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6C5C 0207  20         li    tmp3,4                ; Check first 4 digits
     6C5E 0004 
0041 6C60 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 6C62 C11B  26         mov   *r11,tmp0
0043 6C64 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 6C66 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 6C68 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 6C6A 05CB  14 mknum3  inct  r11
0047 6C6C 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     6C6E 604A 
0048 6C70 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 6C72 045B  20         b     *r11                  ; Exit
0050 6C74 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 6C76 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6C78 13F8  14         jeq   mknum3                ; Yes, exit
0053 6C7A 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6C7C 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6C7E 7FFF 
0058 6C80 C10B  18         mov   r11,tmp0
0059 6C82 0224  22         ai    tmp0,-4
     6C84 FFFC 
0060 6C86 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6C88 0206  20         li    tmp2,>0500            ; String length = 5
     6C8A 0500 
0062 6C8C 0460  28         b     @xutstr               ; Display string
     6C8E 6326 
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
0092 6C90 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 6C92 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 6C94 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 6C96 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6C98 0207  20         li    tmp3,5                ; Set counter
     6C9A 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6C9C 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6C9E 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6CA0 0584  14         inc   tmp0                  ; Next character
0104 6CA2 0607  14         dec   tmp3                  ; Last digit reached ?
0105 6CA4 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 6CA6 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6CA8 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6CAA DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6CAC 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6CAE DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6CB0 0607  14         dec   tmp3                  ; Last character ?
0120 6CB2 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 6CB4 045B  20         b     *r11                  ; Return
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
0138 6CB6 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6CB8 832A 
0139 6CBA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6CBC 8000 
0140 6CBE 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0181               
0183                        copy  "cpu_crc16.asm"           ; CRC-16 checksum calculation
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
0030 6CC0 C13B  30         mov   *r11+,wmemory         ; First memory address
0031 6CC2 C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx:
0033 6CC4 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 6CC6 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * (1) Next word
0037               *--------------------------------------------------------------
0038               calc_crc1:
0039 6CC8 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * (2) Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2:
0044 6CCA C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 6CCC 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 6CCE C1C8  18         mov   wcrc,tmp3
0048 6CD0 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 6CD2 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 6CD4 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6CD6 00FF 
0052               
0053 6CD8 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 6CDA 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 6CDC 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6CDE 6D02 
0056               *--------------------------------------------------------------
0057               * (3) Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3:
0060 6CE0 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 6CE2 0246  22         andi  tmp2,>00ff            ; Clear MSB
     6CE4 00FF 
0062               
0063 6CE6 C1C8  18         mov   wcrc,tmp3
0064 6CE8 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 6CEA 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 6CEC 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     6CEE 00FF 
0068               
0069 6CF0 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 6CF2 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 6CF4 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     6CF6 6D02 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 6CF8 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 6CFA 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 6CFC 04C7  14         clr   tmp3
0081 6CFE 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082               calc_crc.exit:
0083 6D00 045B  20         b     *r11                  ; Return
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
0096 6D02 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     6D04 1021 
     6D06 2042 
     6D08 3063 
     6D0A 4084 
     6D0C 50A5 
     6D0E 60C6 
     6D10 70E7 
0097 6D12 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     6D14 9129 
     6D16 A14A 
     6D18 B16B 
     6D1A C18C 
     6D1C D1AD 
     6D1E E1CE 
     6D20 F1EF 
0098 6D22 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     6D24 0210 
     6D26 3273 
     6D28 2252 
     6D2A 52B5 
     6D2C 4294 
     6D2E 72F7 
     6D30 62D6 
0099 6D32 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     6D34 8318 
     6D36 B37B 
     6D38 A35A 
     6D3A D3BD 
     6D3C C39C 
     6D3E F3FF 
     6D40 E3DE 
0100 6D42 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     6D44 3443 
     6D46 0420 
     6D48 1401 
     6D4A 64E6 
     6D4C 74C7 
     6D4E 44A4 
     6D50 5485 
0101 6D52 A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     6D54 B54B 
     6D56 8528 
     6D58 9509 
     6D5A E5EE 
     6D5C F5CF 
     6D5E C5AC 
     6D60 D58D 
0102 6D62 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     6D64 2672 
     6D66 1611 
     6D68 0630 
     6D6A 76D7 
     6D6C 66F6 
     6D6E 5695 
     6D70 46B4 
0103 6D72 B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     6D74 A77A 
     6D76 9719 
     6D78 8738 
     6D7A F7DF 
     6D7C E7FE 
     6D7E D79D 
     6D80 C7BC 
0104 6D82 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     6D84 58E5 
     6D86 6886 
     6D88 78A7 
     6D8A 0840 
     6D8C 1861 
     6D8E 2802 
     6D90 3823 
0105 6D92 C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     6D94 D9ED 
     6D96 E98E 
     6D98 F9AF 
     6D9A 8948 
     6D9C 9969 
     6D9E A90A 
     6DA0 B92B 
0106 6DA2 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     6DA4 4AD4 
     6DA6 7AB7 
     6DA8 6A96 
     6DAA 1A71 
     6DAC 0A50 
     6DAE 3A33 
     6DB0 2A12 
0107 6DB2 DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     6DB4 CBDC 
     6DB6 FBBF 
     6DB8 EB9E 
     6DBA 9B79 
     6DBC 8B58 
     6DBE BB3B 
     6DC0 AB1A 
0108 6DC2 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     6DC4 7C87 
     6DC6 4CE4 
     6DC8 5CC5 
     6DCA 2C22 
     6DCC 3C03 
     6DCE 0C60 
     6DD0 1C41 
0109 6DD2 EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     6DD4 FD8F 
     6DD6 CDEC 
     6DD8 DDCD 
     6DDA AD2A 
     6DDC BD0B 
     6DDE 8D68 
     6DE0 9D49 
0110 6DE2 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     6DE4 6EB6 
     6DE6 5ED5 
     6DE8 4EF4 
     6DEA 3E13 
     6DEC 2E32 
     6DEE 1E51 
     6DF0 0E70 
0111 6DF2 FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     6DF4 EFBE 
     6DF6 DFDD 
     6DF8 CFFC 
     6DFA BF1B 
     6DFC AF3A 
     6DFE 9F59 
     6E00 8F78 
0112 6E02 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     6E04 81A9 
     6E06 B1CA 
     6E08 A1EB 
     6E0A D10C 
     6E0C C12D 
     6E0E F14E 
     6E10 E16F 
0113 6E12 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     6E14 00A1 
     6E16 30C2 
     6E18 20E3 
     6E1A 5004 
     6E1C 4025 
     6E1E 7046 
     6E20 6067 
0114 6E22 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     6E24 9398 
     6E26 A3FB 
     6E28 B3DA 
     6E2A C33D 
     6E2C D31C 
     6E2E E37F 
     6E30 F35E 
0115 6E32 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     6E34 1290 
     6E36 22F3 
     6E38 32D2 
     6E3A 4235 
     6E3C 5214 
     6E3E 6277 
     6E40 7256 
0116 6E42 B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     6E44 A5CB 
     6E46 95A8 
     6E48 8589 
     6E4A F56E 
     6E4C E54F 
     6E4E D52C 
     6E50 C50D 
0117 6E52 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     6E54 24C3 
     6E56 14A0 
     6E58 0481 
     6E5A 7466 
     6E5C 6447 
     6E5E 5424 
     6E60 4405 
0118 6E62 A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     6E64 B7FA 
     6E66 8799 
     6E68 97B8 
     6E6A E75F 
     6E6C F77E 
     6E6E C71D 
     6E70 D73C 
0119 6E72 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     6E74 36F2 
     6E76 0691 
     6E78 16B0 
     6E7A 6657 
     6E7C 7676 
     6E7E 4615 
     6E80 5634 
0120 6E82 D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     6E84 C96D 
     6E86 F90E 
     6E88 E92F 
     6E8A 99C8 
     6E8C 89E9 
     6E8E B98A 
     6E90 A9AB 
0121 6E92 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     6E94 4865 
     6E96 7806 
     6E98 6827 
     6E9A 18C0 
     6E9C 08E1 
     6E9E 3882 
     6EA0 28A3 
0122 6EA2 CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     6EA4 DB5C 
     6EA6 EB3F 
     6EA8 FB1E 
     6EAA 8BF9 
     6EAC 9BD8 
     6EAE ABBB 
     6EB0 BB9A 
0123 6EB2 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     6EB4 5A54 
     6EB6 6A37 
     6EB8 7A16 
     6EBA 0AF1 
     6EBC 1AD0 
     6EBE 2AB3 
     6EC0 3A92 
0124 6EC2 FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     6EC4 ED0F 
     6EC6 DD6C 
     6EC8 CD4D 
     6ECA BDAA 
     6ECC AD8B 
     6ECE 9DE8 
     6ED0 8DC9 
0125 6ED2 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     6ED4 6C07 
     6ED6 5C64 
     6ED8 4C45 
     6EDA 3CA2 
     6EDC 2C83 
     6EDE 1CE0 
     6EE0 0CC1 
0126 6EE2 EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     6EE4 FF3E 
     6EE6 CF5D 
     6EE8 DF7C 
     6EEA AF9B 
     6EEC BFBA 
     6EEE 8FD9 
     6EF0 9FF8 
0127 6EF2 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     6EF4 7E36 
     6EF6 4E55 
     6EF8 5E74 
     6EFA 2E93 
     6EFC 3EB2 
     6EFE 0ED1 
     6F00 1EF0 
**** **** ****     > runlib.asm
0185               
0187                       copy  "cpu_rle_compress.asm"     ; CPU RLE compression support
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
0074 6F02 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 6F04 C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 6F06 C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 6F08 0649  14         dect  stack
0079 6F0A C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 6F0C 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 6F0E 04C8  14         clr   tmp4                  ; Repeat counter
0086 6F10 04E0  34         clr   @waux1                ; Length of RLE string
     6F12 833C 
0087 6F14 04E0  34         clr   @waux2                ; Address of encoding byte
     6F16 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 6F18 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 6F1A D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 6F1C 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 6F1E 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 6F20 C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 6F22 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 6F24 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     6F26 0001 
0105 6F28 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 6F2A 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 6F2C C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 6F2E 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 6F30 06A0  32         bl    @cpu2rle.flush.duplicates
     6F32 6F7C 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 6F34 C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     6F36 833E 
     6F38 833E 
0126 6F3A 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 6F3C C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     6F3E 833E 
0129 6F40 0585  14         inc   tmp1                  ; Skip encoding byte
0130 6F42 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     6F44 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 6F46 DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 6F48 05A0  34         inc   @waux1                ; RLE string length += 1
     6F4A 833C 
0136 6F4C 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 6F4E C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     6F50 833E 
     6F52 833E 
0145 6F54 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 6F56 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6F58 6F96 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 6F5A 0588  14         inc   tmp4                  ; Increase repeat counter
0155 6F5C 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 6F5E 0606  14         dec   tmp2
0162 6F60 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 6F62 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 6F64 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 6F66 06A0  32         bl    @cpu2rle.flush.duplicates
     6F68 6F7C 
0175                                                   ; (3.2) Flush pending ...
0176 6F6A 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 6F6C C820  54         mov   @waux2,@waux2
     6F6E 833E 
     6F70 833E 
0182 6F72 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 6F74 06A0  32         bl    @cpu2rle.flush.encoding_byte
     6F76 6F96 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 6F78 0460  28         b     @poprt                ; Return
     6F7A 6136 
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
0204 6F7C 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 6F7E D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 6F80 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 6F82 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     6F84 8000 
0210 6F86 DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 6F88 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 6F8A DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 6F8C 05E0  34         inct  @waux1                ; RLE string length += 2
     6F8E 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 6F90 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 6F92 04C8  14         clr   tmp4                  ; Clear repeat count
0220 6F94 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 6F96 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 6F98 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 6F9A C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 6F9C 61E0  34         s     @waux2,tmp3           ; | characters
     6F9E 833E 
0232 6FA0 0607  14         dec   tmp3                  ; /
0233               
0234 6FA2 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 6FA4 C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     6FA6 833E 
0236 6FA8 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 6FAA C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 6FAC 04E0  34         clr   @waux2                ; Reset address of encoding byte
     6FAE 833E 
0240 6FB0 04C8  14         clr   tmp4                  ; Clear before exit
0241 6FB2 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0189               
0191                       copy  "cpu_rle_decompress.asm"   ; CPU RLE decompression support
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
0016               
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
0031 6FB4 C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 6FB6 C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 6FB8 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 6FBA 0649  14         dect  stack
0036 6FBC C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 6FBE D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 6FC0 0606  14         dec   tmp2                  ; Update length
0043 6FC2 131E  14         jeq   rle2cpu.exit          ; End of list
0044 6FC4 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 6FC6 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 6FC8 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 6FCA 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 6FCC 0649  14         dect  stack
0055 6FCE C646  30         mov   tmp2,*stack           ; Push tmp2
0056 6FD0 C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 6FD2 06A0  32         bl    @xpym2m               ; Block copy to destination
     6FD4 638A 
0059                                                   ; \ .  tmp0 = Source address
0060                                                   ; | .  tmp1 = Target address
0061                                                   ; / .  tmp2 = Bytes to copy
0062               
0063 6FD6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 6FD8 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 6FDA 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 6FDC 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 6FDE 0649  14         dect  stack
0073 6FE0 C645  30         mov   tmp1,*stack           ; Push tmp1
0074 6FE2 0649  14         dect  stack
0075 6FE4 C646  30         mov   tmp2,*stack           ; Push tmp2
0076 6FE6 0649  14         dect  stack
0077 6FE8 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 6FEA C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 6FEC D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 6FEE 0985  56         srl   tmp1,8                ; Right align
0082               
0083 6FF0 06A0  32         bl    @xfilm                ; Block fill to destination
     6FF2 6140 
0084                                                   ; \ .  tmp0 = Target address
0085                                                   ; | .  tmp1 = Byte to fill
0086                                                   ; / .  tmp2 = Repeat count
0087               
0088 6FF4 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 6FF6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 6FF8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 6FFA A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 6FFC C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 6FFE 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 7000 0460  28         b     @poprt                ; Return
     7002 6136 
**** **** ****     > runlib.asm
0193               
0195                       copy  "vdp_rle_decompress.asm"   ; VDP RLE decompression support
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
0026 7004 C1BB  30 rle2v   mov   *r11+,tmp2            ; ROM/RAM source address
0027 7006 C13B  30         mov   *r11+,tmp0            ; VDP target address
0028 7008 C1FB  30         mov   *r11+,tmp3            ; Length of RLE encoded data
0029 700A C80B  38         mov   r11,@waux1            ; Save return address
     700C 833C 
0030 700E 06A0  32 rle2vx  bl    @vdwa                 ; Setup VDP address from TMP0
     7010 61BA 
0031 7012 C106  18         mov   tmp2,tmp0             ; We can safely reuse TMP0 now
0032 7014 D1B4  28 rle2v0  movb  *tmp0+,tmp2           ; Get control byte into TMP2
0033 7016 0607  14         dec   tmp3                  ; Update length
0034 7018 1314  14         jeq   rle2vz                ; End of list
0035 701A 0A16  56         sla   tmp2,1                ; Check bit 0 of control byte
0036 701C 1808  14         joc   rle2v2                ; Yes, next byte is compressed
0037               *--------------------------------------------------------------
0038               *    Dump uncompressed bytes
0039               *--------------------------------------------------------------
0040 701E C820  54 rle2v1  mov   @rledat,@mcloop       ; Setup machine code (MOVB *TMP0+,*R15)
     7020 7048 
     7022 8320 
0041 7024 0996  56         srl   tmp2,9                ; Use control byte as counter
0042 7026 61C6  18         s     tmp2,tmp3             ; Update length
0043 7028 06A0  32         bl    @mcloop               ; Write data to VDP
     702A 8320 
0044 702C 1008  14         jmp   rle2v3
0045               *--------------------------------------------------------------
0046               *    Dump compressed bytes
0047               *--------------------------------------------------------------
0048 702E C820  54 rle2v2  mov   @filzz,@mcloop        ; Setup machine code(MOVB TMP1,*R15)
     7030 61B8 
     7032 8320 
0049 7034 0996  56         srl   tmp2,9                ; Use control byte as counter
0050 7036 0607  14         dec   tmp3                  ; Update length
0051 7038 D174  28         movb  *tmp0+,tmp1           ; Byte to fill
0052 703A 06A0  32         bl    @mcloop               ; Write data to VDP
     703C 8320 
0053               *--------------------------------------------------------------
0054               *    Check if more data to decompress
0055               *--------------------------------------------------------------
0056 703E C1C7  18 rle2v3  mov   tmp3,tmp3             ; Length counter = 0 ?
0057 7040 16E9  14         jne   rle2v0                ; Not yet, process data
0058               *--------------------------------------------------------------
0059               *    Exit
0060               *--------------------------------------------------------------
0061 7042 C2E0  34 rle2vz  mov   @waux1,r11
     7044 833C 
0062 7046 045B  20         b     *r11                  ; Return
0063 7048 D7F4     rledat  data  >d7f4                 ; MOVB *TMP0+,*R15
**** **** ****     > runlib.asm
0197               
0199                       copy  "rnd_support.asm"          ; Random number generator
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
0026 704A C13B  30 rnd     mov   *r11+,tmp0            ; Highest number allowed
0027 704C C1FB  30         mov   *r11+,tmp3            ; Get address of random seed
0028 704E 04C5  14 rndx    clr   tmp1
0029 7050 C197  26         mov   *tmp3,tmp2            ; Get random seed
0030 7052 1601  14         jne   rnd1
0031 7054 0586  14         inc   tmp2                  ; May not be zero
0032 7056 0916  56 rnd1    srl   tmp2,1
0033 7058 1702  14         jnc   rnd2
0034 705A 29A0  34         xor   @rnddat,tmp2
     705C 7066 
0035 705E C5C6  30 rnd2    mov   tmp2,*tmp3            ; Store new random seed
0036 7060 3D44  128         div   tmp0,tmp1
0037 7062 C106  18         mov   tmp2,tmp0
0038 7064 045B  20         b     *r11                  ; Exit
0039 7066 B400     rnddat  data  >0b400                ; The magic number
**** **** ****     > runlib.asm
0201               
0203                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0016               *  Backup scratchpad memory to the memory area >2000 - >20FF.
0017               *  Expects current workspace to be in scratchpad memory.
0018               ********|*****|*********************|**************************
0019               cpu.scrpad.backup:
0020 7068 C800  38         mov   r0,@>2000             ; Save @>8300 (r0)
     706A 2000 
0021 706C C801  38         mov   r1,@>2002             ; Save @>8302 (r1)
     706E 2002 
0022 7070 C802  38         mov   r2,@>2004             ; Save @>8304 (r2)
     7072 2004 
0023                       ;------------------------------------------------------
0024                       ; Prepare for copy loop
0025                       ;------------------------------------------------------
0026 7074 0200  20         li    r0,>8306              ; Scratpad source address
     7076 8306 
0027 7078 0201  20         li    r1,>2006              ; RAM target address
     707A 2006 
0028 707C 0202  20         li    r2,62                 ; Loop counter
     707E 003E 
0029                       ;------------------------------------------------------
0030                       ; Copy memory range >8306 - >83ff
0031                       ;------------------------------------------------------
0032               cpu.scrpad.backup.copy:
0033 7080 CC70  46         mov   *r0+,*r1+
0034 7082 CC70  46         mov   *r0+,*r1+
0035 7084 0642  14         dect  r2
0036 7086 16FC  14         jne   cpu.scrpad.backup.copy
0037 7088 C820  54         mov   @>83fe,@>20fe         ; Copy last word
     708A 83FE 
     708C 20FE 
0038                       ;------------------------------------------------------
0039                       ; Restore register r0 - r2
0040                       ;------------------------------------------------------
0041 708E C020  34         mov   @>2000,r0             ; Restore r0
     7090 2000 
0042 7092 C060  34         mov   @>2002,r1             ; Restore r1
     7094 2002 
0043 7096 C0A0  34         mov   @>2004,r2             ; Restore r2
     7098 2004 
0044                       ;------------------------------------------------------
0045                       ; Exit
0046                       ;------------------------------------------------------
0047               cpu.scrpad.backup.exit:
0048 709A 045B  20         b     *r11                  ; Return to caller
0049               
0050               
0051               ***************************************************************
0052               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0053               ***************************************************************
0054               *  bl   @cpu.scrpad.restore
0055               *--------------------------------------------------------------
0056               *  Register usage
0057               *  r0-r2, but values restored before exit
0058               *--------------------------------------------------------------
0059               *  Restore scratchpad from memory area >2000 - >20FF
0060               *  Current workspace can be outside scratchpad when called.
0061               ********|*****|*********************|**************************
0062               cpu.scrpad.restore:
0063                       ;------------------------------------------------------
0064                       ; Restore scratchpad >8300 - >8304
0065                       ;------------------------------------------------------
0066 709C C820  54         mov   @>2000,@>8300
     709E 2000 
     70A0 8300 
0067 70A2 C820  54         mov   @>2002,@>8302
     70A4 2002 
     70A6 8302 
0068 70A8 C820  54         mov   @>2004,@>8304
     70AA 2004 
     70AC 8304 
0069                       ;------------------------------------------------------
0070                       ; save current r0 - r2 (WS can be outside scratchpad!)
0071                       ;------------------------------------------------------
0072 70AE C800  38         mov   r0,@>2000
     70B0 2000 
0073 70B2 C801  38         mov   r1,@>2002
     70B4 2002 
0074 70B6 C802  38         mov   r2,@>2004
     70B8 2004 
0075                       ;------------------------------------------------------
0076                       ; Prepare for copy loop, WS
0077                       ;------------------------------------------------------
0078 70BA 0200  20         li    r0,>2006
     70BC 2006 
0079 70BE 0201  20         li    r1,>8306
     70C0 8306 
0080 70C2 0202  20         li    r2,62
     70C4 003E 
0081                       ;------------------------------------------------------
0082                       ; Copy memory range >2006 - >20ff
0083                       ;------------------------------------------------------
0084               cpu.scrpad.restore.copy:
0085 70C6 CC70  46         mov   *r0+,*r1+
0086 70C8 CC70  46         mov   *r0+,*r1+
0087 70CA 0642  14         dect  r2
0088 70CC 16FC  14         jne   cpu.scrpad.restore.copy
0089 70CE C820  54         mov   @>20fe,@>83fe         ; Copy last word
     70D0 20FE 
     70D2 83FE 
0090                       ;------------------------------------------------------
0091                       ; Restore register r0 - r2
0092                       ;------------------------------------------------------
0093 70D4 C020  34         mov   @>2000,r0             ; Restore r0
     70D6 2000 
0094 70D8 C060  34         mov   @>2002,r1             ; Restore r1
     70DA 2002 
0095 70DC C0A0  34         mov   @>2004,r2             ; Restore r2
     70DE 2004 
0096                       ;------------------------------------------------------
0097                       ; Exit
0098                       ;------------------------------------------------------
0099               cpu.scrpad.restore.exit:
0100 70E0 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0204                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
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
0024 70E2 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xcpu.scrpad.pgout:
0029 70E4 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     70E6 8300 
0030 70E8 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 70EA 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     70EC 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 70EE CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 70F0 0606  14         dec   tmp2
0037 70F2 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 70F4 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 70F6 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     70F8 70FE 
0043                                                   ; R14=PC
0044 70FA 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 70FC 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               cpu.scrpad.pgout.after.rtwp:
0054 70FE 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     7100 709C 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               cpu.scrpad.pgout.$$:
0060 7102 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               ***************************************************************
0064               * cpu.scrpad.pgin - Page in scratchpad memory
0065               ***************************************************************
0066               *  bl   @cpu.scrpad.pgin
0067               *  DATA p0
0068               *  P0 = CPU memory source
0069               *--------------------------------------------------------------
0070               *  bl   @memx.scrpad.pgin
0071               *  TMP1 = CPU memory source
0072               *--------------------------------------------------------------
0073               *  Register usage
0074               *  tmp0-tmp2 = Used as temporary registers
0075               ********|*****|*********************|**************************
0076               cpu.scrpad.pgin:
0077 7104 C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xcpu.scrpad.pgin:
0082 7106 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     7108 8300 
0083 710A 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     710C 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 710E CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 7110 0606  14         dec   tmp2
0089 7112 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 7114 02E0  18         lwpi  >8300                 ; Activate copied workspace
     7116 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               cpu.scrpad.pgin.$$:
0098 7118 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0206               
0212               
0213               
0214               
0215               *//////////////////////////////////////////////////////////////
0216               *                            TIMERS
0217               *//////////////////////////////////////////////////////////////
0218               
0219                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 711A 0300  24 tmgr    limi  0                     ; No interrupt processing
     711C 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 711E D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     7120 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 7122 2360  38         coc   @wbit2,r13            ; C flag on ?
     7124 6046 
0029 7126 1602  14         jne   tmgr1a                ; No, so move on
0030 7128 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     712A 6032 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 712C 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     712E 604A 
0035 7130 1316  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0040 7132 20A0  38         coc   @wbit3,config         ; Speech player on ?
     7134 6044 
0041 7136 1602  14         jne   tmgr2
0042 7138 06A0  32         bl    @sppla1               ; Run speech player
     713A 6900 
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 713C 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     713E 603A 
0048 7140 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 7142 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     7144 6038 
0050 7146 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 7148 0460  28         b     @kthread              ; Run kernel thread
     714A 71C2 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 714C 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     714E 603E 
0056 7150 13E6  14         jeq   tmgr1
0057 7152 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     7154 603C 
0058 7156 16E3  14         jne   tmgr1
0059 7158 C120  34         mov   @wtiusr,tmp0
     715A 832E 
0060 715C 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 715E 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     7160 71C0 
0065 7162 C10A  18         mov   r10,tmp0
0066 7164 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     7166 00FF 
0067 7168 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     716A 6046 
0068 716C 1303  14         jeq   tmgr5
0069 716E 0284  22         ci    tmp0,60               ; 1 second reached ?
     7170 003C 
0070 7172 1002  14         jmp   tmgr6
0071 7174 0284  22 tmgr5   ci    tmp0,50
     7176 0032 
0072 7178 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 717A 1001  14         jmp   tmgr8
0074 717C 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 717E C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     7180 832C 
0079 7182 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     7184 FF00 
0080 7186 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 7188 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 718A 05C4  14         inct  tmp0                  ; Second word of slot data
0086 718C 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 718E C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 7190 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     7192 830C 
     7194 830D 
0089 7196 1608  14         jne   tmgr10                ; No, get next slot
0090 7198 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     719A FF00 
0091 719C C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 719E C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     71A0 8330 
0096 71A2 0697  24         bl    *tmp3                 ; Call routine in slot
0097 71A4 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     71A6 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 71A8 058A  14 tmgr10  inc   r10                   ; Next slot
0102 71AA 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     71AC 8315 
     71AE 8314 
0103 71B0 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 71B2 05C4  14         inct  tmp0                  ; Offset for next slot
0105 71B4 10E8  14         jmp   tmgr9                 ; Process next slot
0106 71B6 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 71B8 10F7  14         jmp   tmgr10                ; Process next slot
0108 71BA 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     71BC FF00 
0109 71BE 10AF  14         jmp   tmgr1
0110 71C0 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0220                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 71C2 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     71C4 603A 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 71C6 20A0  38         coc   @wbit13,config        ; Sound player on ?
     71C8 6030 
0023 71CA 1602  14         jne   kthread_kb
0024 71CC 06A0  32         bl    @sdpla1               ; Run sound player
     71CE 6810 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 71D0 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     71D2 6962 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 71D4 06A0  32         bl    @realkb               ; Scan full keyboard
     71D6 6A52 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 71D8 0460  28         b     @tmgr3                ; Exit
     71DA 714C 
**** **** ****     > runlib.asm
0221                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 71DC C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     71DE 832E 
0018 71E0 E0A0  34         soc   @wbit7,config         ; Enable user hook
     71E2 603C 
0019 71E4 045B  20 mkhoo1  b     *r11                  ; Return
0020      711E     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 71E6 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     71E8 832E 
0029 71EA 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     71EC FEFF 
0030 71EE 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0222               
0224                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 71F0 C13B  30 mkslot  mov   *r11+,tmp0
0018 71F2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 71F4 C184  18         mov   tmp0,tmp2
0023 71F6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 71F8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     71FA 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 71FC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 71FE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 7200 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 7202 881B  46         c     *r11,@w$ffff          ; End of list ?
     7204 604C 
0035 7206 1301  14         jeq   mkslo1                ; Yes, exit
0036 7208 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 720A 05CB  14 mkslo1  inct  r11
0041 720C 045B  20         b     *r11                  ; Exit
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
0052 720E C13B  30 clslot  mov   *r11+,tmp0
0053 7210 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 7212 A120  34         a     @wtitab,tmp0          ; Add table base
     7214 832C 
0055 7216 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 7218 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 721A 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0226               
0227               
0228               
0229               *//////////////////////////////////////////////////////////////
0230               *                    RUNLIB INITIALISATION
0231               *//////////////////////////////////////////////////////////////
0232               
0233               ***************************************************************
0234               *  RUNLIB - Runtime library initalisation
0235               ***************************************************************
0236               *  B  @RUNLIB
0237               *--------------------------------------------------------------
0238               *  REMARKS
0239               *  if R0 in WS1 equals >4a4a we were called from the system
0240               *  crash handler so we return there after initialisation.
0241               
0242               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0243               *  after clearing scratchpad memory. This has higher priority
0244               *  as crash handler flag R0.
0245               ********|*****|*********************|**************************
0247 721C 06A0  32 runlib  bl    @cpu.scrpad.backup    ; Backup scratchpad memory to @>2000
     721E 7068 
0248 7220 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     7222 8302 
0252               *--------------------------------------------------------------
0253               * Alternative entry point
0254               *--------------------------------------------------------------
0255 7224 0300  24 runli1  limi  0                     ; Turn off interrupts
     7226 0000 
0256 7228 02E0  18         lwpi  ws1                   ; Activate workspace 1
     722A 8300 
0257 722C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     722E 83C0 
0258               *--------------------------------------------------------------
0259               * Clear scratch-pad memory from R4 upwards
0260               *--------------------------------------------------------------
0261 7230 0202  20 runli2  li    r2,>8308
     7232 8308 
0262 7234 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0263 7236 0282  22         ci    r2,>8400
     7238 8400 
0264 723A 16FC  14         jne   runli3
0265               *--------------------------------------------------------------
0266               * Exit to TI-99/4A title screen ?
0267               *--------------------------------------------------------------
0268               runli3a
0269 723C 0281  22         ci    r1,>ffff              ; Exit flag set ?
     723E FFFF 
0270 7240 1602  14         jne   runli4                ; No, continue
0271 7242 0420  54         blwp  @0                    ; Yes, bye bye
     7244 0000 
0272               *--------------------------------------------------------------
0273               * Determine if VDP is PAL or NTSC
0274               *--------------------------------------------------------------
0275 7246 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     7248 833C 
0276 724A 04C1  14         clr   r1                    ; Reset counter
0277 724C 0202  20         li    r2,10                 ; We test 10 times
     724E 000A 
0278 7250 C0E0  34 runli5  mov   @vdps,r3
     7252 8802 
0279 7254 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     7256 604A 
0280 7258 1302  14         jeq   runli6
0281 725A 0581  14         inc   r1                    ; Increase counter
0282 725C 10F9  14         jmp   runli5
0283 725E 0602  14 runli6  dec   r2                    ; Next test
0284 7260 16F7  14         jne   runli5
0285 7262 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     7264 1250 
0286 7266 1202  14         jle   runli7                ; No, so it must be NTSC
0287 7268 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     726A 6046 
0288               *--------------------------------------------------------------
0289               * Copy machine code to scratchpad (prepare tight loop)
0290               *--------------------------------------------------------------
0291 726C 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     726E 6124 
0292 7270 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     7272 8322 
0293 7274 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0294 7276 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0295 7278 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0296               *--------------------------------------------------------------
0297               * Initialize registers, memory, ...
0298               *--------------------------------------------------------------
0299 727A 04C1  14 runli9  clr   r1
0300 727C 04C2  14         clr   r2
0301 727E 04C3  14         clr   r3
0302 7280 0209  20         li    stack,>8400           ; Set stack
     7282 8400 
0303 7284 020F  20         li    r15,vdpw              ; Set VDP write address
     7286 8C00 
0305 7288 06A0  32         bl    @mute                 ; Mute sound generators
     728A 67D4 
0307               *--------------------------------------------------------------
0308               * Setup video memory
0309               *--------------------------------------------------------------
0316 728C 06A0  32         bl    @filv                 ; Clear 16K VDP memory
     728E 6192 
0317 7290 0000             data  >0000,>00,>3fff
     7292 0000 
     7294 3FFF 
0319 7296 06A0  32 runlia  bl    @filv
     7298 6192 
0320 729A 0FC0             data  pctadr,spfclr,16      ; Load color table
     729C 00C1 
     729E 0010 
0321               *--------------------------------------------------------------
0322               * Check if there is a F18A present
0323               *--------------------------------------------------------------
0327 72A0 06A0  32         bl    @f18unl               ; Unlock the F18A
     72A2 652E 
0328 72A4 06A0  32         bl    @f18chk               ; Check if F18A is there
     72A6 6548 
0329 72A8 06A0  32         bl    @f18lck               ; Lock the F18A again
     72AA 653E 
0331               *--------------------------------------------------------------
0332               * Check if there is a speech synthesizer attached
0333               *--------------------------------------------------------------
0337 72AC 06A0  32         bl    @spconn
     72AE 68B6 
0339               *--------------------------------------------------------------
0340               * Load video mode table & font
0341               *--------------------------------------------------------------
0342 72B0 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     72B2 61FC 
0343 72B4 611A             data  spvmod                ; Equate selected video mode table
0344 72B6 0204  20         li    tmp0,spfont           ; Get font option
     72B8 000C 
0345 72BA 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0346 72BC 1304  14         jeq   runlid                ; Yes, skip it
0347 72BE 06A0  32         bl    @ldfnt
     72C0 6264 
0348 72C2 1100             data  fntadr,spfont         ; Load specified font
     72C4 000C 
0349               *--------------------------------------------------------------
0350               * Did a system crash occur before runlib was called?
0351               *--------------------------------------------------------------
0352 72C6 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     72C8 4A4A 
0353 72CA 1602  14         jne   runlie                ; No, continue
0354 72CC 0460  28         b     @crash.main           ; Yes, back to crash handler
     72CE 60A4 
0355               *--------------------------------------------------------------
0356               * Branch to main program
0357               *--------------------------------------------------------------
0358 72D0 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     72D2 0040 
0359 72D4 0460  28         b     @main                 ; Give control to main program
     72D6 72D8 
**** **** ****     > hello_world.asm.20059
0054               *--------------------------------------------------------------
0055               * SPECTRA2 startup options
0056               *--------------------------------------------------------------
0057      00C1     spfclr  equ   >c1                   ; Foreground/Background color for font.
0058      0001     spfbck  equ   >01                   ; Screen background color.
0059               ;--------------------------------------------------------------
0060               ; Video mode configuration
0061               ;--------------------------------------------------------------
0062      611A     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0063      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0064      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0065      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0066      8350     rambuf  equ   >8350
0067               
0068               ***************************************************************
0069               * Main
0070               ********|*****|*********************|**************************
0071 72D8 06A0  32 main    bl    @putat
     72DA 6334 
0072 72DC 081F             data  >081f,hello_world
     72DE 72E4 
0073               
0074 72E0 0460  28         b     @tmgr                 ;
     72E2 711A 
0075               
0076               
0077               hello_world:
0078               
0079 72E4 0C48             byte  12
0080 72E5 ....             text  'Hello World!'
0081                       even
0082               
