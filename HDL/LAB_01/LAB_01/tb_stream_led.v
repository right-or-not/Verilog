`timescale 1ns/1ns

module tb_stream_led;
	
	reg			clk;
	reg			rst;
	wire [7:0]	led;
	
	stream_led inst_stream_led(
   		.clk_i(clk),
		.rst_i(rst),
		.led_o(led)
	);
	
	// init basic signal
	initial begin
		// init clock
		clk <= 1'b0;
		// reset the module first
		rst <= 1'b1;
		#100;
		rst <= 1'b0;
	end
	
	// clock = 100MHz => T = 10ns
	always begin
		#5 clk = ~clk;
	end

	// output vcd file
	initial begin
		$dumpfile("tb_stream_led.vcd");
		$dumpvars;
		#1000000
		$finish;
	end
	
endmodule
