TOP := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

PREFIX = $(MIX_COMPILE_PATH)/../priv
BUILD  = $(MIX_COMPILE_PATH)/../obj

# Look for the EI library and header files
# For crosscompiled builds, ERL_EI_INCLUDE_DIR and ERL_EI_LIBDIR must be
# passed into the Makefile.
ifeq ($(ERL_EI_INCLUDE_DIR),)
ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ifeq ($(ERL_ROOT_DIR),)
   $(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH)
endif
ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
ERL_EI_LIBDIR = "$(ERL_ROOT_DIR)/usr/lib"
endif

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)
ERL_LDFLAGS ?= -L$(ERL_EI_LIBDIR) -lei_st

LDFLAGS +=
CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter

RPI := rpi rpi0
RPI2 := rpi2 rpi3 rpi3a rpi4
BBB := bbb

ifneq ($(filter $(MIX_TARGET),$(RPI)),)
	SRC += $(wildcard src/Raspberry_Pi/*.c) src/_Raspberry_Pi_Driver.c src/common_dht_read.c
else ifneq ($(filter $(MIX_TARGET),$(RPI2)),)
	SRC += $(wildcard src/Raspberry_Pi_2/*.c) src/_Raspberry_Pi_2_Driver.c src/common_dht_read.c
else ifneq ($(filter $(MIX_TARGET),$(BBB)),)
	SRC += $(wildcard src/Beaglebone_Black/*.c) src/_Beaglebone_Black_Driver.c src/common_dht_read.c
else ifeq ($(MIX_TARGET), host)
	SRC = src/_Host_Driver.c
	CC = gcc
endif

CC ?= $(CROSSCOMPILER)-gcc

OBJ = $(foreach file,$(SRC),$(BUILD)/$(notdir $(file:.c=.o)))

calling_from_make:
	mix compile

all: $(PREFIX)/nerves_dht

%.o:
	$(CC) -c $(ERL_CFLAGS) $(CFLAGS) -o $@ $(filter %$(notdir $(basename $@)).c, $(SRC))

$(PREFIX) $(BUILD):
	mkdir -p $@

$(PREFIX)/nerves_dht: $(BUILD) $(PREFIX) $(OBJ)
	$(CC) $(wildcard $(BUILD)/*.o) -o $@ $(ERL_LDFLAGS) $(LDFLAGS) -lpthread

clean:
	if [ -n "$(MIX_COMPILE_PATH)" ]; then $(RM) -r $(BUILD); $(RM) -r $(PREFIX); fi

.PHONY: all clean calling_from_make
