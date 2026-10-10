
default : all

ifeq ($(USE_VERILATOR),)

all :
	iverilog -t vvp -o test.vvp cpu_reg.v tb_cpu_reg.v
	vvp test.vvp

clean :
	rm -f *.vcd *.vvp

else

all :
	verilator --binary --trace --top test cpu_reg.v tb_cpu_reg.v
	obj_dir/Vtest

clean :
	rm -rf obj_dir

endif
