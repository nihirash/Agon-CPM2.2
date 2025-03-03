;; PROFILE.SUB on start processor :-)
;; 
;; Simple way implement autostart in CP/M 
;; (c) 2023 Aleksandr Sharikhin
;; Nihirash's Coffeeware License 
    
    org $100
    output "autoexec.com"

BDOS_ENTRY EQU 5

CPM_EXIT EQU 0
CPM_OPEN EQU 15
CPM_CLOSE EQU 16
CPM_READ EQU 20
CPM_WRITE EQU 21
CPM_SETDMA EQU 26
CPM_DELETE EQU 19
CPM_CREATE EQU 22
CPM_RESET EQU 13
CPM_PRINT EQU 9

CPM_EOF EQU $1A

NEW_LINE EQU $0a
C_RETURN EQU $0d

    macro BDOS_CALL n, arg
    ld c, n
    ld de, arg
    call BDOS_ENTRY
    endm

start:
    ld sp, $80

    ;; Output buffer
    ld hl, (BDOS_ENTRY + 1) : ld de, 512 : or a : sbc hl, de : ld l, 0 : ld (buf_ptr), hl
    
    BDOS_CALL CPM_PRINT, banner

    BDOS_CALL CPM_RESET, 0
    BDOS_CALL CPM_SETDMA, buf

    BDOS_CALL CPM_OPEN, fcb
    ;; If $FF - error happens
    xor $ff : jp z, .exit 

    BDOS_CALL CPM_PRINT, found_msg
.read_loop
    ld de, (dma_ptr) : ld c, CPM_SETDMA : call BDOS_ENTRY
    BDOS_CALL CPM_READ, fcb
    cp #1 : jr z, .done
    cp #ff : jr z, .done
    ld hl, (dma_ptr) : ld de, 128 : add hl, de : ld (dma_ptr), hl
    jr .read_loop
.done
    ld hl, (dma_ptr) : ld a, CPM_EOF : ld (hl), a

    BDOS_CALL CPM_CLOSE, fcb

    ld hl, buf
.loop
    ld a, (hl) 
    cp CPM_EOF : jr z, .found
    inc hl
    jr nz, .loop
.found
    dec l
    ld a, l : ld (count), a

    BDOS_CALL CPM_DELETE, fcb2
    BDOS_CALL CPM_CREATE, fcb2
    cp $ff : jr z, .exit
    ld c, CPM_SETDMA : ld de, (buf_ptr) : call BDOS_ENTRY

;; Processing loop
    ld hl, buf
.processing_loop:
    ld a, (hl)
    and a : jr z, .close
    cp CPM_EOF : jr z, .close
    push hl
    call process_byte
    pop hl
    inc hl
    jr .processing_loop
.close
    ld de, (buf_ptr) 
    ld a, (record_count) : ld b, a
    and a : jr z, .exit
.store_loop
    inc d
    push de
    push bc
    ld c, CPM_SETDMA : call BDOS_ENTRY
    BDOS_CALL CPM_WRITE, fcb2
    pop bc
    pop de
    djnz .store_loop

.exit
    BDOS_CALL CPM_CLOSE, fcb2
    rst 0

; A - byte to process
process_byte:
    cp C_RETURN : jr z, .store
    cp NEW_LINE : ret z
    ld c, a
    
    ld hl, (buf_ptr) : ld a, (record_fill) : ld l, a
    inc hl

    ld a, c : ld (hl), a
    ld a, l : ld (record_fill), a

    ret
.store:
    ld hl, (buf_ptr) : ld l, 0
    ld a, (record_fill)
    ld (hl), a

    ld l, a
    inc hl : xor a : ld (hl), a
    ld (record_fill), a

    ld hl, buf_ptr+1 : dec (hl)
    ld hl, record_count : inc (hl)
    ret

record_fill db 0
record_count db 0 
banner:
    db "PROFILE.SUB support activated!"
    db '$'
found_msg:
    db C_RETURN, NEW_LINE
    db "PROFILE.SUB was found - launching it!"
    db C_RETURN, NEW_LINE
    db '$'

;; File with autostart
fcb:
.start
    db 00
    db "PROFILE "
    db "SUB"
    ds 36-($ - .start), 0 

;; CCP batch file
fcb2:
.start
    db 00
    db "$$$     "
    db "SUB"
    ds 36-($ - .start), 0 

dma_ptr dw buf
buf_ptr dw 0

count:  db 0
buf:    equ $
