* FILE......: mem_scrpad_backrest.asm
* Purpose...: Scratchpad memory backup/restore functions

*//////////////////////////////////////////////////////////////
*                Scratchpad memory backup/restore
*//////////////////////////////////////////////////////////////

***************************************************************
* mem.scrpad.backup - Backup scratchpad memory to >2000
***************************************************************
*  bl   @mem.scrpad.backup
*--------------------------------------------------------------
*  Register usage
*  None
*--------------------------------------------------------------
*  Backup scratchpad memory to the memory area >2000 - >20FF
*  without using any registers.
********@*****@*********************@**************************
mem.scrpad.backup:
********@*****@*********************@**************************
        mov   @>8300,@>2000
        mov   @>8302,@>2002
        mov   @>8304,@>2004
        mov   @>8306,@>2006
        mov   @>8308,@>2008
        mov   @>830A,@>200A
        mov   @>830C,@>200C
        mov   @>830E,@>200E
        mov   @>8310,@>2010
        mov   @>8312,@>2012
        mov   @>8314,@>2014
        mov   @>8316,@>2016
        mov   @>8318,@>2018
        mov   @>831A,@>201A
        mov   @>831C,@>201C
        mov   @>831E,@>201E
        mov   @>8320,@>2020
        mov   @>8322,@>2022
        mov   @>8324,@>2024
        mov   @>8326,@>2026
        mov   @>8328,@>2028
        mov   @>832A,@>202A
        mov   @>832C,@>202C
        mov   @>832E,@>202E
        mov   @>8330,@>2030
        mov   @>8332,@>2032
        mov   @>8334,@>2034
        mov   @>8336,@>2036
        mov   @>8338,@>2038
        mov   @>833A,@>203A
        mov   @>833C,@>203C
        mov   @>833E,@>203E
        mov   @>8340,@>2040
        mov   @>8342,@>2042
        mov   @>8344,@>2044
        mov   @>8346,@>2046
        mov   @>8348,@>2048
        mov   @>834A,@>204A
        mov   @>834C,@>204C
        mov   @>834E,@>204E
        mov   @>8350,@>2050
        mov   @>8352,@>2052
        mov   @>8354,@>2054
        mov   @>8356,@>2056
        mov   @>8358,@>2058
        mov   @>835A,@>205A
        mov   @>835C,@>205C
        mov   @>835E,@>205E
        mov   @>8360,@>2060
        mov   @>8362,@>2062
        mov   @>8364,@>2064
        mov   @>8366,@>2066
        mov   @>8368,@>2068
        mov   @>836A,@>206A
        mov   @>836C,@>206C
        mov   @>836E,@>206E
        mov   @>8370,@>2070
        mov   @>8372,@>2072
        mov   @>8374,@>2074
        mov   @>8376,@>2076
        mov   @>8378,@>2078
        mov   @>837A,@>207A
        mov   @>837C,@>207C
        mov   @>837E,@>207E
        mov   @>8380,@>2080
        mov   @>8382,@>2082
        mov   @>8384,@>2084
        mov   @>8386,@>2086
        mov   @>8388,@>2088
        mov   @>838A,@>208A
        mov   @>838C,@>208C
        mov   @>838E,@>208E
        mov   @>8390,@>2090
        mov   @>8392,@>2092
        mov   @>8394,@>2094
        mov   @>8396,@>2096
        mov   @>8398,@>2098
        mov   @>839A,@>209A
        mov   @>839C,@>209C
        mov   @>839E,@>209E
        mov   @>83A0,@>20A0
        mov   @>83A2,@>20A2
        mov   @>83A4,@>20A4
        mov   @>83A6,@>20A6
        mov   @>83A8,@>20A8
        mov   @>83AA,@>20AA
        mov   @>83AC,@>20AC
        mov   @>83AE,@>20AE
        mov   @>83B0,@>20B0
        mov   @>83B2,@>20B2
        mov   @>83B4,@>20B4
        mov   @>83B6,@>20B6
        mov   @>83B8,@>20B8
        mov   @>83BA,@>20BA
        mov   @>83BC,@>20BC
        mov   @>83BE,@>20BE
        mov   @>83C0,@>20C0
        mov   @>83C2,@>20C2
        mov   @>83C4,@>20C4
        mov   @>83C6,@>20C6
        mov   @>83C8,@>20C8
        mov   @>83CA,@>20CA
        mov   @>83CC,@>20CC
        mov   @>83CE,@>20CE
        mov   @>83D0,@>20D0
        mov   @>83D2,@>20D2
        mov   @>83D4,@>20D4
        mov   @>83D6,@>20D6
        mov   @>83D8,@>20D8
        mov   @>83DA,@>20DA
        mov   @>83DC,@>20DC
        mov   @>83DE,@>20DE
        mov   @>83E0,@>20E0
        mov   @>83E2,@>20E2
        mov   @>83E4,@>20E4
        mov   @>83E6,@>20E6
        mov   @>83E8,@>20E8
        mov   @>83EA,@>20EA
        mov   @>83EC,@>20EC
        mov   @>83EE,@>20EE
        mov   @>83F0,@>20F0
        mov   @>83F2,@>20F2
        mov   @>83F4,@>20F4
        mov   @>83F6,@>20F6
        mov   @>83F8,@>20F8
        mov   @>83FA,@>20FA
        mov   @>83FC,@>20FC
        mov   @>83FE,@>20FE
        b     *r11                  ; Return to caller


***************************************************************
* mem.scrpad.restore - Restore scratchpad memory from >2000
***************************************************************
*  bl   @mem.scrpad.restore
*--------------------------------------------------------------
*  Register usage
*  None
*--------------------------------------------------------------
*  Restore scratchpad from memory area >2000 - >20FF
*  without using any registers.
********@*****@*********************@**************************
mem.scrpad.restore:
        mov   @>2000,@>8300
        mov   @>2002,@>8302
        mov   @>2004,@>8304
        mov   @>2006,@>8306
        mov   @>2008,@>8308
        mov   @>200A,@>830A
        mov   @>200C,@>830C
        mov   @>200E,@>830E
        mov   @>2010,@>8310
        mov   @>2012,@>8312
        mov   @>2014,@>8314
        mov   @>2016,@>8316
        mov   @>2018,@>8318
        mov   @>201A,@>831A
        mov   @>201C,@>831C
        mov   @>201E,@>831E
        mov   @>2020,@>8320
        mov   @>2022,@>8322
        mov   @>2024,@>8324
        mov   @>2026,@>8326
        mov   @>2028,@>8328
        mov   @>202A,@>832A
        mov   @>202C,@>832C
        mov   @>202E,@>832E
        mov   @>2030,@>8330
        mov   @>2032,@>8332
        mov   @>2034,@>8334
        mov   @>2036,@>8336
        mov   @>2038,@>8338
        mov   @>203A,@>833A
        mov   @>203C,@>833C
        mov   @>203E,@>833E
        mov   @>2040,@>8340
        mov   @>2042,@>8342
        mov   @>2044,@>8344
        mov   @>2046,@>8346
        mov   @>2048,@>8348
        mov   @>204A,@>834A
        mov   @>204C,@>834C
        mov   @>204E,@>834E
        mov   @>2050,@>8350
        mov   @>2052,@>8352
        mov   @>2054,@>8354
        mov   @>2056,@>8356
        mov   @>2058,@>8358
        mov   @>205A,@>835A
        mov   @>205C,@>835C
        mov   @>205E,@>835E
        mov   @>2060,@>8360
        mov   @>2062,@>8362
        mov   @>2064,@>8364
        mov   @>2066,@>8366
        mov   @>2068,@>8368
        mov   @>206A,@>836A
        mov   @>206C,@>836C
        mov   @>206E,@>836E
        mov   @>2070,@>8370
        mov   @>2072,@>8372
        mov   @>2074,@>8374
        mov   @>2076,@>8376
        mov   @>2078,@>8378
        mov   @>207A,@>837A
        mov   @>207C,@>837C
        mov   @>207E,@>837E
        mov   @>2080,@>8380
        mov   @>2082,@>8382
        mov   @>2084,@>8384
        mov   @>2086,@>8386
        mov   @>2088,@>8388
        mov   @>208A,@>838A
        mov   @>208C,@>838C
        mov   @>208E,@>838E
        mov   @>2090,@>8390
        mov   @>2092,@>8392
        mov   @>2094,@>8394
        mov   @>2096,@>8396
        mov   @>2098,@>8398
        mov   @>209A,@>839A
        mov   @>209C,@>839C
        mov   @>209E,@>839E
        mov   @>20A0,@>83A0
        mov   @>20A2,@>83A2
        mov   @>20A4,@>83A4
        mov   @>20A6,@>83A6
        mov   @>20A8,@>83A8
        mov   @>20AA,@>83AA
        mov   @>20AC,@>83AC
        mov   @>20AE,@>83AE
        mov   @>20B0,@>83B0
        mov   @>20B2,@>83B2
        mov   @>20B4,@>83B4
        mov   @>20B6,@>83B6
        mov   @>20B8,@>83B8
        mov   @>20BA,@>83BA
        mov   @>20BC,@>83BC
        mov   @>20BE,@>83BE
        mov   @>20C0,@>83C0
        mov   @>20C2,@>83C2
        mov   @>20C4,@>83C4
        mov   @>20C6,@>83C6
        mov   @>20C8,@>83C8
        mov   @>20CA,@>83CA
        mov   @>20CC,@>83CC
        mov   @>20CE,@>83CE
        mov   @>20D0,@>83D0
        mov   @>20D2,@>83D2
        mov   @>20D4,@>83D4
        mov   @>20D6,@>83D6
        mov   @>20D8,@>83D8
        mov   @>20DA,@>83DA
        mov   @>20DC,@>83DC
        mov   @>20DE,@>83DE
        mov   @>20E0,@>83E0
        mov   @>20E2,@>83E2
        mov   @>20E4,@>83E4
        mov   @>20E6,@>83E6
        mov   @>20E8,@>83E8
        mov   @>20EA,@>83EA
        mov   @>20EC,@>83EC
        mov   @>20EE,@>83EE
        mov   @>20F0,@>83F0
        mov   @>20F2,@>83F2
        mov   @>20F4,@>83F4
        mov   @>20F6,@>83F6
        mov   @>20F8,@>83F8
        mov   @>20FA,@>83FA
        mov   @>20FC,@>83FC
        mov   @>20FE,@>83FE
        b     *r11                  ; Return to caller