#recording my cli flow to build a working script
all: 
	yosys -p 'synth_ice40 -top adc_ice40_top -json adc_top.json' adc_ice40_top.v adc_top.v sigmadelta_adc.v box_ave.v
	nextpnr-ice40 --lp8k --package cm81 --json adc_top.json --asc adc_top.asc --pcf pins.pcf --gui
	icetime -d lp8k -mtr top.rpt adc_top.asc
	icepack adc_top.asc top.bin
	tinyprog -p top.binm