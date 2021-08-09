vvp: 
	iverilog -o adc.vvp adc_tf_rtl.v ../adc_top.v ../box_ave.v ../sigmadelta_adc.v 
lxt2: 
	vvp -n adc.vvp -lxt2 
waves: 
	gtkwave adc_test.lxt2


vvp_ice40: 
	iverilog -o adc_ice40.vvp adc_ice40_tf.v ../adc_ice40_top.v ../adc_top.v ../box_ave.v ../sigmadelta_adc.v 
lxt2_ice40: 
	vvp -n adc_ice40.vvp -lxt2 
waves_ice40: 
	gtkwave adc_test_ice40.lxt2