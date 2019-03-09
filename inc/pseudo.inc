; Pseudo-instructions
;
; Added as needed

    IF !DEF(PSEUDO_INC)
PSEUDO_INC SET 1

lda : MACRO
  ld a, \2
  ld \1, a
ENDM

adda : MACRO
  ld a, \1
  add a, \2
  ld \1, a
ENDM

zeroa : MACRO
  xor a
  ld \1, a
ENDM

ora : MACRO
  ld a, \3
  or a, \2
  ld \1, a
ENDM

inca : MACRO
  ld a, \1
  inc a
  ld \1, a
ENDM

addhla : MACRO
  add a, l
  ld l, a
  adc a, h
  sub l
  ld h, a
ENDM

  ENDC ; PSEUDO_INC
