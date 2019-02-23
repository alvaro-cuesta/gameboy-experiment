INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"
INCLUDE "pseudo.inc"

SECTION "VBlank ISR", ROM0[ISR_VBLANK]
  call VBlankHandler
  reti

SECTION "Timer ISR", ROM0[ISR_TIMER]
  call TimerHandler
  reti

SECTION "VBlank Handler", ROM0
VBlankHandler:
  ; hl = [SinTable + wTest]
  ld hl, SinTable
  ld a, [wTest]
  addhla

  ; add Y offset
  ld a, [hl]
  sub a, 64 + SCRN_Y / 2 - TILE_SIZE / 2
  ld [rSCY], a

  ; hl = [CosTable + wTest]
  ld hl, CosTable
  ld a, [wTest]
  addhla

  ; add X offset
  ld a, [hl]
  sra a
  sub a, 32 + SCRN_X / 2 - TILE_SIZE / 2 * (HelloWorldStrEnd - HelloWorldStr - 1)
  ld [rSCX], a

  inca [wTest]
  ret

SECTION "Timer Handler", ROM0
TimerHandler:
  ld a, [wTimerCalls]
  cp 2
  jr nz, TimerHandler.skip
  call PlayNote
  ret
.skip
  inc a
  ld [wTimerCalls], a
  ret
