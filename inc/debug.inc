  IF !DEF(DEBUG_INC)
DEBUG_INC SET 1

DBGMSG: MACRO
  ld  d, d
  jr .end\@
  DW $6464
  DW $0000
  DB \1
.end\@:
ENDM

  ENDC ; DEBUG_INC
