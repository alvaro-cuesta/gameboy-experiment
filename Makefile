BUILD_DIR = build
SRC_DIR = src
INC_DIR = inc

ROM_TITLE = Hello World!
ROM_NAME = hello-world
ROM_VERSION = 0x00
ROM_LICENSEE = XD
ROM_MBC_TYPE = 0x00
RAM_SIZE = 0x00
SOURCES = $(SRC_DIR)/*.asm
INCS = $(INC_DIR)/*.inc
# padding value doesn't seem to work
FIX_FLAGS = -v -j -t "$(ROM_TITLE)" -n $(ROM_VERSION) -m $(ROM_MBC_TYPE) -r ${RAM_SIZE} -l 0x33 -p 0x6B

OBJECTS = $(SOURCES:%.asm=%.o)

all: $(ROM_NAME)

$(ROM_NAME): $(OBJECTS)
	mkdir -p $(BUILD_DIR)
	rgblink -o $(BUILD_DIR)/$@.gb -n $(BUILD_DIR)/$@.sym $(OBJECTS)
	rgbfix $(FIX_FLAGS) $(BUILD_DIR)/$@.gb

%.o: %.asm $(INCS) font.chr
	rgbasm -i $(INC_DIR)/ -o $@ $<

$(INC_DIR)/midi-table.inc: $(INC_DIR)/generate-midi-table.js
	$(INC_DIR)/generate-midi-table.js > $(INC_DIR)/midi-table.inc

clean:
	rm $(BUILD_DIR)/* $(OBJECTS) $(INC_DIR)/midi-table.inc
