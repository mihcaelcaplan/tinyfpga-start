// look in pins.pcf for all the pin names on the TinyFPGA BX board
module i2c (
    input PIN_1,
    output PIN_2
);

/* Simple I2C state machine
 * Just wait for start condition, read 8 bytes (addr + r/w)
 * and then fill or empty your data reg
*/

wire scl;
assign scl = PIN_1;

wire sda; 
assign sda = ~scl; //for now lol 

reg [2:0] sr; // state reg 
reg start_detect;
/*
 * 3'b000 - BUS_IDLE
 * 3'b001 - READ_ADDR
 * 3'b010 - READ_DATA
 * 3'b011 - WRITE_DATA
*/

initial begin
    sr = 3'b000;
    start_detect = 1'b0;
end

always @(negedge sda) begin
    if(scl == 1) begin
    start_detect = 1'b1;
    end
end

always @(*) begin
    
    // case (sr)
    // // 3'b000: begin
    // //             if (start_detect == 1'b1) begin
                    
    // //             end
    // //                 sr <= 3'b001;
    // //             end
    // //         end
    // // default: pass
    // endcase

end





    
endmodule
