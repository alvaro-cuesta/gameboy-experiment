STACK_SIZE EQU $40

EXPORT wStackTop, wStackBottom

SECTION "Stack", WRAM0
wStackTop:
    ds STACK_SIZE
wStackBottom:
