LIBPS4	:= $(PS4SDK)/libPS4

CC	:= gcc
OBJCOPY	:= objcopy
ODIR	:= build
SDIR	:= source
IDIRS	:= -I$(LIBPS4)/include -Iinclude
LDIRS	:= -L$(LIBPS4)
MAPFILE := $(shell basename "$(CURDIR)").map
CFLAGS	:= $(IDIRS) -Os -std=c11 -ffunction-sections -fdata-sections -fno-builtin -nostartfiles -nostdlib -Wall -Wextra -masm=intel -march=btver2 -mtune=btver2 -m64 -mabi=sysv -mcmodel=small -fpie -fPIC
LFLAGS	:= $(LDIRS) -Xlinker -T $(LIBPS4)/linker.x -Xlinker -Map="$(MAPFILE)" -Wl,--build-id=none -Wl,--gc-sections
LIBS	:= -lPS4

# Range 45–80
TEMPS := $(shell seq 45 85)
TARGETS := $(foreach T,$(TEMPS),fan_$(T).bin)

all: $(TARGETS)

fan_%.bin:
	$(CC) $(LIBPS4)/crt0.s $(SDIR)/*.c -o temp.t $(CFLAGS) $(LFLAGS) $(LIBS) -DFAN_THRESHOLD=$*
	$(OBJCOPY) -O binary temp.t $@
	rm -f temp.t

.PHONY: clean
clean:
	rm -rf *.bin $(MAPFILE) $(ODIR)
