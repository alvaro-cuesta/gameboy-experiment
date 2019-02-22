INCLUDE "pseudo.inc"

EXPORT CopyString, CopyBytes

SECTION "CopyString", ROM0
; from [de] to [hl], 0x00 terminated
; clobbers a
CopyString::
  lda [hli], [de]
  inc de
  and a ; check if the byte we just copied is zero
  jr nz, CopyString
  ret

SECTION "CopyBytes", ROM0
; from [de] to [hl], bc bytes
; clobbers a
CopyBytes::
  lda [hl+], [de]
  inc de
  dec bc ; count
  or c ; check if count is 0, since `dec bc` doesn't update flags
  jr nz, CopyBytes
  or b
  jr nz, CopyBytes
  ret
