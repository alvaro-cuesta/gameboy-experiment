INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"
INCLUDE "pseudo.inc"

INTERRUPT: macro
SECTION "\1 ISR", ROM0[ISR_\1]
  jp \1_Handler

SECTION "\1 Handler", ROM0
\1_Handler:
ENDM

GLOBAL hTimerCalls, hTest, hP1 ; hram.asm

;
  INTERRUPT VBLANK
  push af
  push bc
  push hl

  ; reset palette for next frame (see LCDHandler)
  lda [rBGP], %11100100

  ; hl = [SinTable + hTest]
  ld hl, SinTable
  ld a, [hTest]
  addhla

  ; add Y offset
  ld a, [hl]
  sub a, 48 + SCRN_Y / 2 - TILE_SIZE / 2
  ld [rSCY], a

  ; hl = [CosTable + hTest]
  ld hl, CosTable
  ld a, [hTest]
  addhla

  ; add X offset
  ld a, [hl]
  sub a, 32 + SCRN_X / 2 - TILE_SIZE / 2 * (HelloWorldStrEnd - HelloWorldStr - 1)
  ld [rSCX], a

  inca [hTest]

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

  ld [hP1], a ; write to RAM

  ; unselect joypad lines
  lda [$ff00+c], P1_READ_NOTHING

  pop hl
  pop bc
  pop af
  reti

  INTERRUPT TIMER
  push af
  push bc
  push hl

  ld a, [hTimerCalls]
  cp 2
  jr nz, .skip
  call PlayNote

  pop hl
  pop bc
  pop af
  reti
.skip
  inc a
  ld [hTimerCalls], a

  pop hl
  pop bc
  pop af
  reti

;
  INTERRUPT LCD
  ; invert palette (needs STATF_LYC enabled and rLYC set to window line start)
  push af
  lda [rBGP], %00011011
  pop af
  reti
