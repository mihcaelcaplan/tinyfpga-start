// this is the actual implemented ADC

// module adc_ice40_top (
// 	input CLK,                // clk_in,
//     output PIN_1,              // rstn,
// 	output PIN_12,            // serial_out,
// 	input PIN_3,              // analog_cmp_pin,	
// 	output PIN_5,              // analog_out,
// 	output PIN_6               // sample_rdy
//     );

module adc_ice40_top (
	input clk,
    input rstn,
	output serial_out,
	// input [ADC_WIDTH-1:0] digital_in,
	// output [ADC_WIDTH-1:0] digital_out,
	input analog_cmp,	
	output analog_out,
	output sample_rdy
    );

parameter 
ADC_WIDTH = 8,              // ADC Convertor Bit Precision
ACCUM_BITS = 10,            // 2^ACCUM_BITS is decimation rate of accumulator
LPF_DEPTH_BITS = 3,         // 2^LPF_DEPTH_BITS is decimation rate of averager
INPUT_TOPOLOGY = 1;         // 0: DIRECT: Analog input directly connected to + input of comparitor
                            // 1: NETWORK:Analog input connected through R divider to - input of comp.

// assign to internal wires and regs
wire [ADC_WIDTH-1:0] digital_in_i;

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
	.digital_out(digital_in_i),
	.analog_cmp(analog_cmp),	
	.analog_out(analog_out),
	.sample_rdy(sample_rdy)
	);


reg [6:0] my_counter; //7 bit counter - 3 bits less than the accumulator mean 1/8 the period
reg my_rollover;
reg out_clk;
// reg mycounter; //8 bit counter

// always@(posedge clk) begin
// 	my_counter <= ~my_counter;
// end

always @(posedge clk or negedge rstn)
begin
	// this a good trick to initialize things before your reset line gets pulled up
	if( ~rstn ) begin
		my_counter <= 0;
		my_rollover <= 0;
		out_clk <= 0;
		end
	else begin
		my_counter <= my_counter + 1;       // running count
		my_rollover <= &my_counter;         // assert 'rollover' when counter is all 1's
		end
end

always@(posedge my_rollover) begin
	out_clk <= ~out_clk;
end



// output assignments
// assign digital_out = digital_in_i;

endmodule