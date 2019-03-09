INCLUDE "hardware.inc"

  IF !DEF(UTIL_INC)
UTIL_INC SET 1

waitVBlank: MACRO
.waitVBlank\@
  ld a, [rLY]
  cp SCRN_Y
  jr c, .waitVBlank\@
ENDM

waitVRAM: MACRO
.waitVRAM\@
  ldh a, [rSTAT]
  and STATF_BUSY
  jr nz, .waitVRAM\@
ENDM

FUNCTION: MACRO
EXPORT \1

SECTION "\1 Function", ROM0
\1::
ENDM

VECTOR: MACRO
EXPORT \1

SECTION "\1 Vector", ROM0[\2]
\1::
ENDM

  ENDC ; UTIL_INC
