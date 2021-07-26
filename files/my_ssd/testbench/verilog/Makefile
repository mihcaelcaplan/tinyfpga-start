vvp: 
	iverilog -o adc.vvp adc_tf_rtl.v ../../adc_top.v ../../box_ave.v ../../sigmadelta_adc.v 
lxt2: 
	vvp adc.vvp -lxt2
waves: 
	gtkwave adc_test.lxt2