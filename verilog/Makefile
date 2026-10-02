
default : all

ifeq ($(USE_VERILATOR),)

all :
	iverilog -t vvp -o test.vvp my_circuit.v my_circuit_tb.v
	vvp test.vvp

clean :
	rm -f *.vcd *.vvp

else

all :
	verilator --binary --trace --top test my_circuit.v my_circuit_tb.v
	obj_dir/Vtest

clean :
	rm -rf obj_dir

endif
