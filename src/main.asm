INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"
INCLUDE "midi-table.inc"
INCLUDE "util.inc"

SECTION "Variables", WRAM0
wTimerCalls:
  ds 1
wCurrentNote:
  ds 1

SECTION "VBlank Interrupt", ROM0[$0040]
  call VBlank
  reti

SECTION "VBlank", ROM0
VBlank:
  ;ld a, [wCurrentNote]

  lda [rSCY], -(SCRN_Y / 2 - TILE_SIZE / 2)
  lda [rSCX], -(SCRN_X / 2 - TILE_SIZE / 2 * (HelloWorldStrEnd - HelloWorldStr - 1))
  ret

SECTION "Timer Interrupt", ROM0[$0050]
  call Timer
  reti

SECTION "Timer", ROM0
Timer:
  ld a, [wTimerCalls]
  cp 2                      ; cada 20 interrupciones, pasa 1 seg
  jr z, Timer.playNote
  inc a                       ; si no, incrementamos y volvemos
  ld [wTimerCalls], a
  ret
.playNote
  call PlayNote
  ret

SECTION "Entry point", ROM0[$100]
  di
  jp Setup

REPT $150 - $104
  db 0
ENDR

SECTION "Game code", ROM0

Setup:
  ld sp, $fffe

.variables
  xor a
  ld [wTimerCalls], a
  ld [wCurrentNote], a
  ld [wCurrentNote + 1], a

.timer
  lda [rTAC], TACF_START | TACF_16KHZ ; timer

  ld a, 51 ; (255 - 51) / 16536 = 0.049 s
  ld [rTMA], a
  ld [rTIMA], a

.audio
  lda [rAUDENA], AUDENA_ON
  lda [rAUDTERM], AUDTERM_1_LEFT | AUDTERM_1_RIGHT
  lda [rAUDVOL], AUDVOL_VIN_SO1_OFF | AUDVOL_VIN_SO2_OFF | (%011 << 4) | (%011 << 0) ; L | R

.instrument
  lda [rAUD1LEN], AUDLEN_DUTY_50 | %111111 ; length
  lda [rAUD1ENV], AUDENV_DOWN | (%1111 << 4) | (%001 << 0) ; initial? + sweep?
  lda [rAUD1SWEEP], AUDSWEEP_OFF

; LCD

.waitVBlank
  ld a, [rLY]
  cp SCRN_Y ; Check if the LCD is past VBlank
  jr c, .waitVBlank

  zeroa [rLCDC], a

  ; Copy font to VRAM
  ld hl, _VRAM2
  ld de, FontTiles
  ld bc, FontTilesEnd - FontTiles

.copyFont
  lda [hli], [de] ; Grab 1 byte from the source, place it at the destination, incrementing hl
  inc de ; Move to next byte
  dec bc ; Decrement count
  ld a, b ; Check if count is 0, since `dec bc` doesn't update flags
  or c
  jr nz, .copyFont

DrawString:
  ld hl, _SCRN0
  ld de, HelloWorldStr

.copyString
  lda [hli], [de]
  inc de
  and a ; Check if the byte we just copied is zero
  jr nz, .copyString ; Continue if it's not

  lda [rBGP], (%11 << 6) | (%10 << 4) | (%01 << 2) | (%00 << 0) ; palette

  ; scroll
  ld a, -10
  ld [rSCY], a
  ld [rSCX], a

  lda [rLCDC], LCDCF_ON | LCDCF_BGON | LCDCF_BG9800 | LCDCF_OBJOFF | LCDCF_WINOFF

Main:
  call PlayNote

.enableInterrupts
  lda [rIE], IEF_TIMER | IEF_VBLANK
  ei

  ; Lock up
.lockup
  halt
  nop
  jr .lockup


PlayNote:
  zeroa [wTimerCalls], a

  ; freq
  ld hl, MidiTable
  lda c, [wCurrentNote]
  xor b
  add hl, bc

  lda [rAUD1LOW], [hl+] ; LSB
  ora [rAUD1HIGH], AUDHIGH_RESTART, [hl] ; MSB

  adda [wCurrentNote], 2

  cp a, 182
  jr nz, PlayNote.return
  zeroa [wCurrentNote]
.return
  ret

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Midi Table", ROM0

MidiTable:
  midiTable

SECTION "Sine Table", ROM0

SineTable:
ANGLE SET   0.0 
      REPT  256 
      DB    (MUL(64.0,SIN(ANGLE))+64.0)>>16 
ANGLE SET ANGLE + 256.0 
      ENDR

SECTION "Hello World string", ROM0

HelloWorldStr:
  db "Hello World", 0
HelloWorldStrEnd:
