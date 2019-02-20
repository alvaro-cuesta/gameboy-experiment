ASM = rgbasm
LINK = rgblink
FIX = rgbfix

ROM_NAME = hello-world
BUILD_DIR = build
SOURCES = src/main.asm
FIX_FLAGS = -v -p 0

INC_DIR = inc
OBJECTS = $(SOURCES:%.asm=%.o)

all: $(ROM_NAME)

inc/midi-table.inc: ./generate-midi-table.js
	./generate-midi-table.js > inc/midi-table.inc

$(ROM_NAME): $(OBJECTS)
	mkdir -p $(BUILD_DIR)
	$(LINK) -o $(BUILD_DIR)/$@.gb -n $(BUILD_DIR)/$@.sym $(OBJECTS)
	$(FIX) $(FIX_FLAGS) $(BUILD_DIR)/$@.gb

%.o: %.asm inc/midi-table.inc inc/hardware-extra.inc inc/util.inc
	$(ASM) -i$(INC_DIR)/ -o $@ $<

clean:
	rm $(BUILD_DIR)/* $(OBJECTS) inc/midi-table.inc
