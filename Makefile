# Makefile for testhack

OUTPUT = test.nes
HEADER = test.hdr
TARGET = test.bin
SOURCE = test.s
OBJECT = $(patsubst %.s,%.o,$(SOURCE))

AS = wla-6502
LD = wlalink

ASFLAGS =
LDFLAGS = -d linkfile

$(TARGET): $(OBJECT)
	$(LD) $(LDFLAGS) $@

$(OUTPUT): $(TARGET)
	cat $(HEADER) $(TARGET) > $(OUTPUT)

all: $(OUTPUT)

clean:
	rm -f $(OBJECT) $(TARGET) $(OUTPUT)

.SUFFIXES: .s

.s.o:
	$(AS) -$(ASFLAGS)o $< $@

.PHONY: all clean
