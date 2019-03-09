    IF !DEF(GB_HEADER_INC)
GB_HEADER_INC SET 1

INCLUDE "hardware.inc"
INCLUDE "hardware-extra.inc"

PADDING_BYTE EQU $ac

GB_LOGO_PLACEHOLDER : MACRO
REPT GB_LOGO_END - GB_LOGO_START
  db PADDING_BYTE
ENDR
ENDM

PADDED_TITLE : MACRO ; up to 15 bytes (16th byte = CGB flag, we'll respect that)
.titleStart\@:
  db \1  ; title
.titleEnd\@:
REPT 15 - (.titleEnd\@ - .titleStart\@)
  db $0
ENDR
ENDM

; \1 - title (up to 15 bytes)
; \2 - version
; \3 - licensee code (2 bytes)
; \4 - destination code: CART_REGION_JAPAN / CART_REGION_OTHER
; \5 - SGB flag: CART_NOT_COMPATIBLE_SGB / CART_COMPATIBLE_SGB
; \6 - CGB flag: CART_COMPATIBLE_DMG / CART_COMPATIBLE_DMG_GBC / CART_COMPATIBLE_GBC
; \7 - MBC type: CART_ROM_*
; \8 - RAM size
;
; call macro and put entry point code right below
GB_HEADER : MACRO
SECTION "ROM Header", ROM0[GB_HEADER_START]
GB_Header:
  GB_LOGO_PLACEHOLDER
  PADDED_TITLE \1
  db \6  ; CGB flag
  db \3  ; new licensee code
  db \5  ; SGB flag
  db \7  ; MBC type
  db PADDING_BYTE   ; ROM size
  db \8  ; RAM size
  db \4  ; destination code
  db CART_USE_NEW_LICENSEE_CODE ; use new licensee code
  db \2  ; version
  db PADDING_BYTE   ; header checksum
  db PADDING_BYTE   ; global checksum
  db PADDING_BYTE   ;

SECTION "Entry Point", ROM0[GB_ENTRY_POINT]
GB_EntryPoint:
ENDM

; \1 - title (up to 15 bytes)
; \2 - version
; \3 - old licensee code (1 byte)
; \4 - destination code: CART_REGION_JAPAN / CART_REGION_OTHER
; \5 - CGB flag: CART_COMPATIBLE_DMG / CART_COMPATIBLE_DMG_GBC / CART_COMPATIBLE_GBC
; \6 - MBC type: CART_ROM_*
; \7 - RAM size
;
; call macro and put entry point code right below
GB_HEADER_OLD : MACRO
SECTION "ROM Header", ROM0[GB_HEADER_START]
GB_Header:
  GB_LOGO_PLACEHOLDER
  PADDED_TITLE \1
  db \5  ; CGB flag
  db $0  ; new licensee code
  db $0  ;
  db CART_NOT_COMPATIBLE_SGB  ; SGB flag
  db \6  ; MBC type
  db PADDING_BYTE   ; ROM size
  db \7  ; RAM size
  db \4  ; destination code
  db \3  ; old licensee code
  db \2  ; version
  db PADDING_BYTE   ; header checksum
  db PADDING_BYTE   ; global checksum
  db PADDING_BYTE   ;

SECTION "Entry Point", ROM0[GB_ENTRY_POINT]
GB_EntryPoint:
ENDM

ENDC ; GB_HEADER_INC
