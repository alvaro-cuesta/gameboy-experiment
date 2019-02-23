# Config

BUILD_DIR = build
SRC_DIR = src
INC_DIR = inc

ROM_NAME = hello-world
ASM_FLAGS = -p 0x00 -E
LINK_FLAGS = -p 0x00 -m $(BUILD_DIR)/$@.mmap -n $(BUILD_DIR)/$@.sym
FIX_FLAGS = -p 0x00 -v

#

SOURCES = $(wildcard $(SRC_DIR)/*.asm)
OBJECTS = $(patsubst %.asm,%.o,$(SOURCES))
INCS = $(INC_DIR)/*.inc $(INC_DIR)/midi-table.inc

all: $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	mkdir -p $(BUILD_DIR)
	rgblink $(LINK_FLAGS) -o $(BUILD_DIR)/$@.gb $(OBJECTS)
	rgbfix $(FIX_FLAGS) $(BUILD_DIR)/$@.gb

%.o: %.asm $(INCS) font.chr
	rgbasm $(ASM_FLAGS) -i $(INC_DIR)/ -o $@ $<

$(INC_DIR)/midi-table.inc: $(INC_DIR)/generate-midi-table.js
	$(INC_DIR)/generate-midi-table.js > $(INC_DIR)/midi-table.inc

clean:
	rm $(BUILD_DIR)/* $(OBJECTS) $(INC_DIR)/midi-table.inc
