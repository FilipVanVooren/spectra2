* FILE......: cpu_crc16.asm
* Purpose...: CPU memory CRC-16 Cyclic Redundancy Checksum 


***************************************************************
* CALC_CRC - Calculate 16 bit Cyclic Redundancy Check
***************************************************************
*  bl   @calc_crc
*  data p0,p1
*--------------------------------------------------------------
*  p0 = Memory start address
*  p1 = Memory end address
*--------------------------------------------------------------
*  bl   @calc_crcx
*
*  tmp0 = Memory start address
*  tmp1 = Memory end address
*--------------------------------------------------------------
*  REMARKS
*  Introduces register equate wcrc (tmp4/r8) which contains the
*  calculated CRC-16 checksum upon exit.
********|*****|*********************|**************************
wmemory equ   tmp0                  ; Current memory address
wmemend equ   tmp1                  ; Highest memory address to process
wcrc    equ   tmp4                  ; Current CRC
*--------------------------------------------------------------
* Entry point
*--------------------------------------------------------------
calc_crc:
        mov   *r11+,wmemory         ; First memory address
        mov   *r11+,wmemend         ; Last memory address
calc_crcx:
        seto  wcrc                  ; Starting crc value = 0xffff
        jmp   calc_crc2             ; Start with first memory word
*--------------------------------------------------------------
* (1) Next word
*--------------------------------------------------------------
calc_crc1:
        inct  wmemory               ; Next word
*--------------------------------------------------------------
* (2) Process high byte
*--------------------------------------------------------------
calc_crc2:
        mov   *wmemory,tmp2         ; Get word from memory
        srl   tmp2,8                ; memory word >> 8

        mov   wcrc,tmp3
        srl   tmp3,8                ; tmp3 = current CRC >> 8

        xor   tmp2,tmp3             ; XOR current CRC with byte
        andi  tmp3,>00ff            ; Only keep LSB as index in lookup table

        sla   tmp3,1                ; Offset in lookup table = index * 2
        sla   wcrc,8                ; wcrc << 8
        xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
*--------------------------------------------------------------
* (3) Process low byte
*--------------------------------------------------------------
calc_crc3:
        mov   *wmemory,tmp2         ; Get word from memory
        andi  tmp2,>00ff            ; Clear MSB

        mov   wcrc,tmp3
        srl   tmp3,8                ; tmp3 = current CRC >> 8

        xor   tmp2,tmp3             ; XOR current CRC with byte
        andi  tmp3,>00ff            ; Only keep LSB as index in lookup table

        sla   tmp3,1                ; Offset in lookup table = index * 2
        sla   wcrc,8                ; wcrc << 8
        xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
*--------------------------------------------------------------
* Memory range done ?
*--------------------------------------------------------------
        c     wmemory,wmemend       ; Memory range done ?
        jlt   calc_crc1             ; Next word unless done
*--------------------------------------------------------------
* XOR final result with 0
*--------------------------------------------------------------
        clr   tmp3
        xor   tmp3,wcrc             ; Final CRC 
calc_crc.exit:        
        b     *r11                  ; Return



***************************************************************
* CRC Lookup Table - 1024 bytes
* http://www.sunshine2k.de/coding/javascript/crc/crc_js.html
*--------------------------------------------------------------
* Polynomial........: 0x1021
* Initial value.....: 0x0
* Final Xor value...: 0x0
***************************************************************
crc_table
        data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
        data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
        data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
        data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
        data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
        data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
        data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
        data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
        data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
        data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
        data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
        data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
        data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
        data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
        data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
        data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
        data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
        data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
        data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
        data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
        data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
        data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
        data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
        data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
        data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
        data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
        data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
        data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
        data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
        data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
        data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
        data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
