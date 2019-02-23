INCLUDE "gb-header.inc"

GLOBAL EntryPoint

  GB_HEADER "Hello World!", 0, "XD", CART_REGION_OTHER, \
    CART_NOT_COMPATIBLE_SGB, CART_COMPATIBLE_DMG, \
    CART_ROM, CART_RAM_NONE,
  di
  jp EntryPoint
