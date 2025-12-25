build:
	iverilog -f rtl.f -f tb.f -o test_top.vvp
 
drc: 
	verilator --lint-only -Wall -f rtl.f -top-module Top
run:
	python3 golden_mips.py
	vvp test_top.vvp

wave:
	gtkwave test_top.vcd	
