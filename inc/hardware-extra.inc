; Extra constants for GB hardware
;
; Added as needed

    IF !DEF(HARDWARE_EXTRA_INC)
HARDWARE_EXTRA_INC SET 1

;
_VRAM0              EQU $8000 ; $8000->$87FF
_VRAM1              EQU $8800 ; $8800->$8FFF
_VRAM2              EQU $9000 ; $9000->$97FF

;
TILE_SIZE           EQU 8

;
ISR_VBLANK          EQU $0040
ISR_LCD             EQU $0048
ISR_TIMER           EQU $0050
ISR_SERIAL          EQU $0058
ISR_PAD             EQU $0060

;
RST0                EQU $0000
RST1                EQU $0008
RST2                EQU $0010
RST3                EQU $0018
RST4                EQU $0020
RST5                EQU $0028
RST6                EQU $0030
RST7                EQU $0038

;
GB_ENTRY_POINT      EQU $0100
GB_LOGO_START       EQU $0104
GB_LOGO_END         EQU $0134
GB_HEADER_START     EQU $0104
GB_HEADER_END       EQU $0150

;
CART_NOT_COMPATIBLE_SGB EQU $00
CART_COMPATIBLE_SGB     EQU $0c

;
CART_REGION_JAPAN   EQU $00
CART_REGION_OTHER   EQU $01

;
CART_USE_NEW_LICENSEE_CODE EQU $33

ENDC ; HARDWARE_EXTRA_INC
