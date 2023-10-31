.PHONY: clean

include /home/ianli/rv32emu/mk/toolchain.mk

GCCFLAGS := -fdata-sections -ffunction-sections
CFLAGS = -march=rv32i -mabi=ilp32 -O3
ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS := -Wl,--gc-sections

%.S: %.c
	$(CROSS_COMPILE)gcc $(CFLAGS) -o $@ -S $<

%.o: %.S
	$(CROSS_COMPILE)as $(ASFLAGS) -o $@ $<

all: hw1_liu.elf


hw1_liu.elf: hw1_liu.o
	 $(CROSS_COMPILE)gcc -o $@ $<

clean:
	$(RM) hw1_liu.elf hw1_liu.o hw1_liu.S
