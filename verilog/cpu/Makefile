
.DEFAULT_GOAL := all

PROGRAM := program/gcd
VER_DIR := ver

SIM := cpu_sim
IMEM_FILE := imem.dat
DMEM_FILE := dmem.dat

IVERILOG := iverilog
VVP := vvp
AS := riscv64-unknown-elf-as
LD := riscv64-unknown-elf-ld
OBJCOPY := riscv64-unknown-elf-objcopy

VERILOG_SOURCES := \
	$(VER_DIR)/tb.v \
	$(VER_DIR)/cpu.v \
	$(VER_DIR)/decode.v \
	$(VER_DIR)/alu.v \
	$(VER_DIR)/comparator.v \
	$(VER_DIR)/cpu_reg.v \
	$(VER_DIR)/imem.v \
	$(VER_DIR)/dmem.v

.PHONY: all compile run program memory sim clean

all: run

# build program
program: $(PROGRAM).elf

# compile program
$(PROGRAM).o: $(PROGRAM).s
	$(AS) -march=rv32i -mabi=ilp32 -o $@ $<

# link program
$(PROGRAM).elf: $(PROGRAM).o
	$(LD) -m elf32lriscv -Ttext=0 -Tdata=0x100 -e _start -o $@ $<

# memfiles
memory: $(IMEM_FILE) $(DMEM_FILE)

$(IMEM_FILE): $(PROGRAM).elf
	$(OBJCOPY) -O verilog --verilog-data-width=4 \
		--only-section=.text $< $@

$(DMEM_FILE): $(PROGRAM).elf
	$(OBJCOPY) -O verilog --verilog-data-width=4 \
		--only-section=.data $< $@

# compile sim
compile: memory sim

sim: $(SIM)

$(SIM): $(VERILOG_SOURCES)
	$(IVERILOG) -g2012 -Wall -s tb -o $@ $(VERILOG_SOURCES)

# run simulation
run: compile
	$(VVP) $(SIM)

clean:
	rm -f $(SIM) *.vcd *.vvp \
		$(PROGRAM).o $(PROGRAM).elf \
		$(IMEM_FILE) $(DMEM_FILE)
