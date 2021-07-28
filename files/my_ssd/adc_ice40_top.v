// this is the actual implemented ADC

module adc_ice40_top (
	input CLK,                // clk_in,
    output PIN_1,              // rstn,
	output PIN_12,            // serial_out,
	input PIN_3,              // analog_cmp_pin,	
	output PIN_5,              // analog_out,
	output PIN_6               // sample_rdy
    );

parameter 
ADC_WIDTH = 8,              // ADC Convertor Bit Precision
ACCUM_BITS = 10,            // 2^ACCUM_BITS is decimation rate of accumulator
LPF_DEPTH_BITS = 3,         // 2^LPF_DEPTH_BITS is decimation rate of averager
INPUT_TOPOLOGY = 1;         // 0: DIRECT: Analog input directly connected to + input of comparitor
                            // 1: NETWORK:Analog input connected through R divider to - input of comp.

// assign to internal wires and regs
wire clk;
wire rstn;
wire analog_cmp;
wire [ADC_WIDTH-1:0] digital_in;

wire analog_out;
wire sample_rdy;
wire serial_out;

assign clk = CLK;
assign rstn = PIN_1;
assign analog_cmp = PIN_3;

assign analog_out = PIN_5;
assign sample_rdy = PIN_6;
assign serial_out = PIN_1;


//instantiate ADC_top
ADC_top #(
	.ADC_WIDTH(ADC_WIDTH),
	.ACCUM_BITS(ACCUM_BITS),
	.LPF_DEPTH_BITS(LPF_DEPTH_BITS),
    .INPUT_TOPOLOGY(INPUT_TOPOLOGY)
	)
my_ssd(
	.clk_in(clk),
	.rstn(rstn),
	.digital_out(digital_in),
	.analog_cmp(analog_cmp),	
	.analog_out(analog_out),
	.sample_rdy(sample_rdy)
	);

endmodule