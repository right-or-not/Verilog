`timescale 1ns/1ns

module tb_stopwatch;
	
	reg			clk;
	reg			rst;
	reg			trig;
	wire [5:0]	second;
	wire [10:0]	millisec;
	wire		valid;
	
	// instantiate the module: stopwatch
	stopwatch inst_stopwatch(
		.clk_i(clk),
		.rst_i(rst),
		.trig_i(trig),
		.millisec_o(millisec),
		.second_o(second),
		.valid_o(valid)
	);

	// init basic signal
	initial begin
		// init clock and trigger
		clk <= 1'b0;
		trig <= 1'b0;
		// reset the module first
		rst <= 1'b1;
		#100;
		rst <= 1'b0;
	end

	// clock = 100MHz => T = 10ns
	always begin
		#5 clk = ~clk;
	end

	// test the trigger
	initial begin
		// wait for the reset
		#200;

		// 1st: trig
		trig = 1'b1;
		#10;
		trig = 1'b0;

		// wait for 500 clk
		#5000;

		// 2nd: trig
		trig = 1'b1;
		#10;
		trig = 1'b0;

		// wait for 5000 clk
		#500000;
		trig = 1'b1;
		#10;
		trig = 1'b0;

		// finish
		#10000000;
		$display("[Finish]");
		$finish;
	end
	
	always @(posedge clk) begin
		if(valid)
			$display("%d second %d millisecond", second, millisec);
	end

	// output vcd file
	initial begin
		$dumpfile("tb_stopwatch.vcd");
		$dumpvars;
	end
	
endmodule
