
_trk:
	dl 0
_sec:
	dl 0
_dma:
	dl 0

_drive_home:
	or a
	sbc hl, hl
	ld (_trk), hl
	ret.lil

_drive_trk:
	ld (_trk), bc
	xor a
	ld (_trk+2), a
	ret.lil

_drive_sec:
	ld (_sec), bc
	xor a
	ld (_sec+2), a
	ret.lil

_drive_dma:
	ld (_dma), bc
	ld a, CPM_SEG
	ld (_dma+2), a
	xor a
	ret.lil

_calc_offset:
	ld hl, (_trk)
	
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, hl ; *16
	add hl, hl ; *32
	add hl, hl ; *64

	ld bc, (_sec)
	add hl, bc
	ret

_drive_read:
	xor a
	ld mb, a

	call _calc_offset
	call fs_seek
	call fs_read

	ld a, CPM_SEG
	ld mb, a

	xor a
	ret.lil

_drive_write:
	xor a
	ld mb, a

	call _calc_offset
	call fs_seek
	call fs_write

	ld a, CPM_SEG
	ld mb, a

	xor a
	ret.lil
	

drive_a:
	db "cpma.dsk", 0
drive_b:
	db "cpmb.dsk", 0
drive_c:
	db "cpmc.dsk", 0
drive_d:
	db "cpmd.dsk", 0


f_handle: db 0

f_a:	db 0
f_b:	db 0
f_c:	db 0
f_d:	db 0

_drive_change:
	ld de, f_a
	or a
	sbc hl, hl
	ld l, a
	add hl, de
	ld a, (hl)
	ld (f_handle), a
	ret.lil
	

fs_init:
	ld c, 0
	MOSCALL mos_fclose

	ld hl, drive_a
	ld c, fa_read+fa_write
	MOSCALL mos_fopen
	ld (f_a), a
	or a
	ret z

	ld hl, drive_b
	ld c, fa_read+fa_write
	MOSCALL mos_fopen
	ld (f_b), a
	
	ld hl, drive_c
	ld c, fa_read+fa_write
	MOSCALL mos_fopen
	ld (f_c), a
	
	ld hl, drive_d
	ld c, fa_read+fa_write
	MOSCALL mos_fopen
	ld (f_d), a

	ld a, (f_a)
	ld (f_handle), a
	or a
	ret

fs_seek:
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, hl ; *16
	add hl, hl ; *32
	add hl, hl ; *64
	add hl, hl ; *128

	ld e, 0
	ld a, (f_handle)
	ld c, a
	MOSCALL mos_flseek
	ret

fs_read:
	ld a, (f_handle)
	ld c, a

	ld de, 128
	ld hl, (_dma)

	MOSCALL mos_fread
	ret

fs_write:
	ld a, (f_handle)
	ld c, a
	ld de, 128
	ld hl, (_dma)
	MOSCALL mos_fwrite
	ret
