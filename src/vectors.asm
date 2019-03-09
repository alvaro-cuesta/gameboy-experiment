INCLUDE "hardware-extra.inc"
INCLUDE "pseudo.inc"
INCLUDE "util.inc"

; from [de] to [hl], c bytes
; clobbers a
  VECTOR CopyBytesSmall, RST0
  lda [hl+], [de]
  inc de
  dec c ; count
  jr nz, CopyBytes
  ret
