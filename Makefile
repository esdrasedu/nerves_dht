SRC = src/common_dht_read.c

ifeq ($(MIX_TARGET), rpi)
	SRC += $(wildcard src/Raspberry_Pi/*.c) src/_Raspberry_Pi_Driver.c
endif

ifeq ($(MIX_TARGET), rpi2)
	SRC += $(wildcard src/Raspberry_Pi_2/*.c) src/_Raspberry_Pi_2_Driver.c
endif

ifeq ($(MIX_TARGET), rpi3)
	SRC += $(wildcard src/Raspberry_Pi_2/*.c) src/_Raspberry_Pi_2_Driver.c
endif

ifeq ($(MIX_TARGET), rpi0)
	SRC += $(wildcard src/Raspberry_Pi_2/*.c) src/_Raspberry_Pi_2_Driver.c
endif

ifeq ($(MIX_TARGET), bbb)
	SRC += $(wildcard src/Beaglebone_Black/*.c) src/_Beaglebone_Black_Drive.c
endif

OBJ = $(SRC:.c=.o)

LDFLAGS +=
CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter
CC ?= $(CROSSCOMPILER)-gcc

.PHONY: all clean

all: priv priv/nerves_dht

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

priv:
	mkdir -p priv

priv/nerves_dht: $(OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	rm -f priv/nerves_dht src/*.o src/**/*.o
