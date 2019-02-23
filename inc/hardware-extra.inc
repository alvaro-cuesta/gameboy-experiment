; Extra constants for GB hardware
;
; Added as needed

    IF !DEF(HARDWARE_EXTRA_INC)
HARDWARE_EXTRA_INC SET 1

;
AUDENA_ON           EQU %10000000  ; global enable
AUDENA_OFF          EQU %00000000  ; global disable (sets all audio regs to 0!)
AUDENA_4_ON         EQU %00001000  ; sound 4 on (doesn't work according to hardware.inc)
AUDENA_4_OFF        EQU %00000000
AUDENA_3_ON         EQU %00000100  ; sound 3 on (doesn't work according to hardware.inc)
AUDENA_3_OFF        EQU %00000000
AUDENA_2_ON         EQU %00000010  ; sound 2 on (doesn't work according to hardware.inc)
AUDENA_2_OFF        EQU %00000000
AUDENA_1_ON         EQU %00000001  ; sound 1 on (doesn't work according to hardware.inc)
AUDENA_1_OFF        EQU %00000000

;
AUDLEN_DUTY_12_5    EQU %00000000
AUDLEN_DUTY_25      EQU %01000000
AUDLEN_DUTY_50      EQU %10000000
AUDLEN_DUTY_75      EQU %11000000

;
AUDENV_UP           EQU %00001000
AUDENV_DOWN         EQU %00000000

;
AUDSWEEP_OFF        EQU %00001000  ; cargo cult: I read somewhere you should leave this bit ON for OFF
AUDSWEEP_ADD        EQU %00000000
AUDSWEEP_SUB        EQU %00001000

;
AUDVOL_VIN_SO2_ON   EQU %00001000
AUDVOL_VIN_SO2_OFF  EQU %00000000
AUDVOL_VIN_SO1_ON   EQU %10000000
AUDVOL_VIN_SO1_OFF  EQU %00000000

;
AUDTERM_4_RIGHT     EQU %00001000
AUDTERM_3_RIGHT     EQU %00000100
AUDTERM_2_RIGHT     EQU %00000010
AUDTERM_1_RIGHT     EQU %00000001
AUDTERM_4_LEFT      EQU %10000000
AUDTERM_3_LEFT      EQU %01000000
AUDTERM_2_LEFT      EQU %00100000
AUDTERM_1_LEFT      EQU %00010000

;
AUDHIGH_RESTART     EQU %10000000
AUDHIGH_LENGTH      EQU %01000000

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
