INCLUDE "debug.inc"
INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"
INCLUDE "midi-table.inc"
INCLUDE "pseudo.inc"
INCLUDE "util.inc"

  rev_Check_hardware_inc 2.8

GLOBAL CopyBytes, CopyString ; util.asm
GLOBAL hTimerCalls, hCurrentNote, hTest, hP1 ; hram.asm
GLOBAL wStackBottom ; wram.asm

EXPORT EntryPoint

BUTTON_A_BIT       EQU 0
BUTTON_B_BIT       EQU 1
BUTTON_SELECT_BIT  EQU 2
BUTTON_START_BIT   EQU 3
DPAD_RIGHT_BIT     EQU 4
DPAD_LEFT_BIT      EQU 5
DPAD_UP_BIT        EQU 6
DPAD_DOWN_BIT      EQU 7

BUTTON_A_MASK      EQU %00000001
BUTTON_B_MASK      EQU %00000010
BUTTON_SELECT_MASK EQU %00000100
BUTTON_START_MASK  EQU %00001000
DPAD_RIGHT_MASK    EQU %00010000
DPAD_LEFT_MASK     EQU %00100000
DPAD_UP_MASK       EQU %01000000
DPAD_DOWN_MASK     EQU %10000000

SECTION "Game Code", ROM0
EntryPoint::
  ld sp, wStackBottom

Setup:
.variables
  xor a
  ld [hTimerCalls], a
  ld [hTest], a
  ld [hCurrentNote], a
  ld [hCurrentNote + 1], a

.timer
  lda [rTAC], TACF_START | TACF_16KHZ ; timer

  ld a, 51 ; (255 - 51) / 16536 = 0.049 s
  ld [rTMA], a
  ld [rTIMA], a

.audio
  lda [rAUDENA], AUDENA_ON
  lda [rAUDTERM], AUDTERM_1_LEFT | AUDTERM_1_RIGHT
  lda [rAUDVOL], (%011 << 4) | (%011 << 0) ; L | R

.instrument
  lda [rAUD1LEN], AUDLEN_DUTY_50 | %111111 ; length
  lda [rAUD1ENV], AUDENV_DOWN | (%1111 << 4) | (%001 << 0) ; initial? + sweep?
  zeroa [rAUD1SWEEP]

.LCD
  waitVBlank
  zeroa [rLCDC]

.copyFont
  ld hl, _VRAM2
  ld de, FontTiles
  ld bc, FontTilesEnd - FontTiles
  call CopyBytes

.copyHelloWorld
  ld hl, _SCRN0
  ld de, HelloWorldStr
  call CopyString

.copyHelp
  ld hl, _SCRN1 + 1
  ld de, Help1Str
  call CopyString
  ld hl, _SCRN1 + 1 + SCRN_VX_B
  ld de, Help2Str
  call CopyString

.setupScreen
  lda [rBGP], %11100100 ; palette

  ; scroll
  ld a, 0
  ld [rSCY], a
  ld [rSCX], a
  lda [rWY], SCRN_Y - 2 * TILE_SIZE - 1
  lda [rWX], 7 - (TILE_SIZE / 2)

  lda [rLYC], SCRN_Y - 2 * TILE_SIZE - 3

  lda [rLCDC], LCDCF_ON | \
    LCDCF_BGON | LCDCF_BG9800 | \
    LCDCF_WINON | LCDCF_WIN9C00 | \
    LCDCF_OBJOFF

Main:
  call PlayNote

.enableInterrupts
  lda [rIE], IEF_TIMER | IEF_VBLANK | IEF_LCDC
  lda [rSTAT], STATF_LYC
  ei

  ; Main screen
.checkButtons
  halt
  ld hl, hP1

.checkServerButton
  bit BUTTON_A_BIT, [hl]
  jr z, .checkClientButton
.startServer
  ld hl, _SCRN1 + 1
  ld de, ServerWaitingStr
  call CopyString
  ld hl, _SCRN1 + 1 + SCRN_VX_B
  ld de, EmptyStr
  call CopyString
.waitServer
  halt
  jr .waitServer

.checkClientButton
  bit BUTTON_B_BIT, [hl]
  jr z, .checkButtons
.startClient
  ld hl, _SCRN1 + 1
  ld de, ClientConnectingStr
  call CopyString
  ld hl, _SCRN1 + 1 + SCRN_VX_B
  ld de, EmptyStr
  call CopyString
.waitClient
  halt
  jr .waitClient


PlayNote:
  zeroa [hTimerCalls], a

  ; freq
  ld hl, MidiTable
  lda c, [hCurrentNote]
  xor b
  add hl, bc

  lda [rAUD1LOW], [hl+] ; LSB
  ora [rAUD1HIGH], AUDHIGH_RESTART, [hl] ; MSB

  adda [hCurrentNote], 2

  cp a, (MidiTableEnd - MidiTable)
  jr nz, PlayNote.return
  zeroa [hCurrentNote]
.return
  ret

SECTION "Font", ROM0
FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Midi Table", ROM0
MidiTable:
  midiTable
MidiTableEnd:

SECTION "Sin Table", ROM0
SinTable:
ANGLE SET   0.0
      REPT  256
      DB    (MUL(56.0, SIN(ANGLE)) + 56.0) >> 16
ANGLE SET ANGLE + (65536 / 256) << 16
      ENDR

SECTION "Cos Table", ROM0
CosTable:
ANGLE SET   0.0
      REPT  256
      DB    DIV((MUL(64.0, COS(ANGLE)) + 64.0), 2.0) >> 16
ANGLE SET ANGLE + (65536 / 256) << 16
      ENDR

SECTION "Strings", ROM0
HelloWorldStr:
  db "Hello World", 0
HelloWorldStrEnd:
Help1Str:
  db "(A) Server", 0
Help2Str:
  db "(B) Client", 0
EmptyStr:
REPT SCRN_VX_B
  db " "
ENDR
  db 0
ServerWaitingStr:
  db "Waiting for peer...", 0
ClientConnectingStr:
  db "Connecting...", 0
ConnectedStr:
  db "Connected to peer!", 0
