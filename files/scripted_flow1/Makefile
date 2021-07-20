#recording my cli flow to build a working script
all: 
	yosys -p 'synth_ice40 -top top -json top.json' top.v
	nextpnr-ice40 --lp8k --package cm81 --json top.json --asc top.asc --pcf pins.pcf
	icetime -d lp8k -mtr top.rpt top.asc
	icepack top.asc top.bin
	tinyprog -p top.bin