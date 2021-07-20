#recording my cli flow to build a working script
all: 
	yosys -p 'synth_ice40 -top ADC_top -json adc_top.json' adc_top.v
	nextpnr-ice40 --lp8k --package cm81 --json adc_top.json --asc adc_top.asc --pcf pins.pcf
	icetime -d lp8k -mtr top.rpt top.asc
	icepack top.asc top.bin
	tinyprog -p top.bin