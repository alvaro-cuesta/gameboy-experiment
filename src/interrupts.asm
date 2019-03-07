INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"
INCLUDE "pseudo.inc"

SECTION "VBlank ISR", ROM0[ISR_VBLANK]
  jp VBlankHandler

SECTION "Timer ISR", ROM0[ISR_TIMER]
  jp TimerHandler

SECTION "LCD ISR", ROM0[ISR_LCD]
  jp LCDHandler

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
  ld c, LOW(rP1)
  ; high nibble = d-pad
  lda [$ff00+c], P1_READ_DPAD
REPT 6
  ld a, [$ff00+c]
ENDR
  swap a
  or %00001111
  ld b, a

  ; low nibble = buttons
  lda [$ff00+c], P1_READ_BUTTONS
REPT 6
  ld a, [$ff00+c]
ENDR
  or %11110000
  xor b ; make 1 = active button thanks to ors

  ld [wP1], a ; write to RAM

  ; unselect joypad lines
  lda [$ff00+c], P1_READ_NOTHING

  pop hl
  pop bc
  pop af
  reti

SECTION "Timer Handler", ROM0
TimerHandler:
  push af
  push bc
  push hl

  ld a, [wTimerCalls]
  cp 2
  jr nz, TimerHandler.skip
  call PlayNote

  pop hl
  pop bc
  pop af
  reti
.skip
  inc a
  ld [wTimerCalls], a

  pop hl
  pop bc
  pop af
  reti

SECTION "LCD Handler", ROM0
LCDHandler:
  ; invert palette (needs STATF_LYC enabled and rLYC set to window line start)
  push af
  lda [rBGP], %00011011
  pop af
  reti
