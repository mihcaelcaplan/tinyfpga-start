#TOOL INPUT [ multiple v files are cool :) ]
SRC = top.v 
TESTBENCH = top_tb.v

#THIS NEEDS TO MATCH THE OUTPUT FILE FROM YOUR TESTBENCH
TBDUMPFILE = top_tb.fst	

#TOOL OPTIONS
COMPILER_FLAGS = -v
SIMULATOR_FLAGS = -v

#TOOL OUTPUT
COMPILER_OUTPUT = compiler.out		#COMPILER OUTPUT
SIMULATOR_OUTPUT = -fst-speed			#SIMULATOR OUTPUT TYPE

###############################################################################

#MAKE DIRECTIVES
check : $(TESTBENCH) $(SRC)
	iverilog -v $(SRC)

simulate: compiler.out
	vvp $(SIMULATOR_FLAGS) compiler.out $(SIMULATOR_OUTPUT)

display: $(TBDUMPFILE)
	gtkwave $(TBDUMPFILE)

#MAKE DEPENDENCIES

$(TBDUMPFILE): compiler.out
	vvp $(SIMULATOR_FLAGS) compiler.out $(SIMULATOR_OUTPUT)

compiler.out: $(TESTBENCH) $(SRC)
	iverilog $(COMPILER_FLAGS) -o compiler.out $(TESTBENCH) $(SRC)