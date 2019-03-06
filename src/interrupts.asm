INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"
INCLUDE "pseudo.inc"

SECTION "VBlank ISR", ROM0[ISR_VBLANK]
  jp VBlankHandler

SECTION "Timer ISR", ROM0[ISR_TIMER]
  jp TimerHandler

SECTION "LCD ISR", ROM0[ISR_LCD]
  ; invert palette (needs STATF_LYC enabled and rLYC set to window line start)
  lda [rBGP], %00011011
  reti

SECTION "VBlank Handler", ROM0
VBlankHandler:
  push af
  push bc
  push hl

  ; reset palette for next frame (see LCDHandler)
  lda [rBGP], %11100100

  ; hl = [SinTable + wTest]
  ld hl, SinTable
  ld a, [wTest]
  addhla

  ; add Y offset
  ld a, [hl]
  sub a, 48 + SCRN_Y / 2 - TILE_SIZE / 2
  ld [rSCY], a

  ; hl = [CosTable + wTest]
  ld hl, CosTable
  ld a, [wTest]
  addhla

  ; add X offset
  ld a, [hl]
  sub a, 32 + SCRN_X / 2 - TILE_SIZE / 2 * (HelloWorldStrEnd - HelloWorldStr - 1)
  ld [rSCX], a

  inca [wTest]

.readJoypad
  ld hl, rP1
  ld [hl], P1_READ_DPAD
  ld a, [hl]
  swap a
  and %11110000 ; high nibble
  ld b, a

  ld [hl], P1_READ_BUTTONS
  ld a, [hl]
  and %00001111 ; low nibble
  or b

  cpl ; make 1 = active button
  ld [hl], P1_READ_NOTHING
  ld [wP1], a

  pop hl
  pop bc
  pop af
  reti

SECTION "Timer Handler", ROM0
TimerHandler:
  push af

  ld a, [wTimerCalls]
  cp 2
  jr nz, TimerHandler.skip
  call PlayNote

  pop af
  reti
.skip
  inc a
  ld [wTimerCalls], a

  pop af
  reti
