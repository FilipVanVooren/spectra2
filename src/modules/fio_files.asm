* FILE......: fio_files.asm
* Purpose...: File I/O support

***************************************************************
* File IO operations
************************************@**************************
io.op.open       equ >00            ; OPEN
io.op.close      equ >01            ; CLOSE
io.op.read       equ >02            ; READ
io.op.write      equ >03            ; WRITE
io.op.rewind     equ >04            ; RESTORE/REWIND
io.op.load       equ >05            ; LOAD
io.op.save       equ >06            ; SAVE
io.op.delfile    equ >07            ; DELETE FILE
io.op.status     equ >09            ; STATUS
***************************************************************
* File types - All relative files are fixed length
************************************@**************************
io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
***************************************************************
* File types - Sequential files
************************************@**************************
io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL



