# Config

BUILD_DIR = build
SRC_DIR = src
INC_DIR = inc

ROM_TITLE = Hello World!
ROM_NAME = hello-world
ROM_VERSION = 0x00
ROM_LICENSEE = XD
ROM_MBC_TYPE = 0x00
RAM_SIZE = 0x00
PAD_VALUE = 0x6B
ASM_FLAGS = -p $(PAD_VALUE) -E
LINK_FLAGS = -m $(BUILD_DIR)/$@.mmap
FIX_FLAGS = -v -j -t "$(ROM_TITLE)" -n $(ROM_VERSION) -m $(ROM_MBC_TYPE) -r ${RAM_SIZE} -p $(PAD_VALUE) -l 0x33

#

SOURCES = $(SRC_DIR)/*.asm
INCS = $(INC_DIR)/*.inc
OBJECTS = $(SOURCES:%.asm=%.o)

all: $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	mkdir -p $(BUILD_DIR)
	rgblink $(LINK_FLAGS) -o $(BUILD_DIR)/$@.gb -n $(BUILD_DIR)/$@.sym $(OBJECTS)
	rgbfix $(FIX_FLAGS) $(BUILD_DIR)/$@.gb

%.o: %.asm $(INCS) font.chr
	rgbasm $(ASM_FLAGS) -i $(INC_DIR)/ -o $@ $<

$(INC_DIR)/midi-table.inc: $(INC_DIR)/generate-midi-table.js
	$(INC_DIR)/generate-midi-table.js > $(INC_DIR)/midi-table.inc

clean:
	rm $(BUILD_DIR)/* $(OBJECTS) $(INC_DIR)/midi-table.inc
