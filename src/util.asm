INCLUDE "hardware-extra.inc"
INCLUDE "pseudo.inc"
INCLUDE "util.inc"

; from [de] to [hl], 0x00 terminated
; clobbers a
  FUNCTION CopyString
  waitVRAM
  lda [hli], [de]
  inc de
  and a ; check if the byte we just copied is zero
  jr nz, CopyString
  ret

; from [de] to [hl], bc bytes
; clobbers a
  FUNCTION CopyBytes
  lda [hl+], [de]
  inc de
  dec bc ; count
  ld a, b
  or c ; check if count is 0, since `dec bc` doesn't update flags
  jr nz, CopyBytes
  ret
