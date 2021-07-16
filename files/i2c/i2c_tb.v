`timescale 1ns/1ps

module tb ();
  initial begin
    $dumpfile("i2c_tb.fst");
    $dumpvars(0, t);
  end

  reg pin1;
  wire pin2;

  initial begin
		pin1 = 1'b0;
	end

  always begin
    #31 pin1 = !pin1;
  end

  initial begin
    // repeat(64000000) @(posedge clk);
    repeat(25) @(posedge pin1);

      $finish;
  end

  i2c t (.PIN_1(pin1), .PIN_2(pin2));

endmodule // tb
