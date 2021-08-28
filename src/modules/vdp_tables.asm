* FILE......: vdp_tables.a99
* Purpose...: Video mode tables

***************************************************************
* Graphics mode 1 (32 columns/24 rows)
*--------------------------------------------------------------
graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=0: M1 \ Graphics 1 mode
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=1: 16x16 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >1000  (>02 * >800)
* ; VDP#7 Set screen background color



***************************************************************
* TI Basic mode 1 (32 columns/24 rows)
*--------------------------------------------------------------
tibasic byte  >00,>e2,>00,>0c,>00,>06,>00,SPFBCK,0,32
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=0: M1 \ Graphics 1 mode
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=1: 16x16 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set screen background color




***************************************************************
* Textmode (40 columns/24 rows)
*--------------------------------------------------------------
tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=1: M1 \ TEXT MODE
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=1: 16x16 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set foreground/background color
***************************************************************


***************************************************************
* Textmode (80 columns, 24 rows) - F18A
*--------------------------------------------------------------
tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=1: M1 \ TEXT MODE
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=0: 8x8 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
* ; VDP#7 Set foreground/background color
***************************************************************


***************************************************************
* Textmode (80 columns, 30 rows) - F18A
*--------------------------------------------------------------
tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=1: M1 \ TEXT MODE
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=0: 8x8 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
* ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >2000  (>40 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >1800  (>03 * >800)
* ; VDP#7 Set foreground/background color
***************************************************************
