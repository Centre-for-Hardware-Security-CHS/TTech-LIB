// TalTech large multiplier library
// Multiplier type: two_way_karatsuba
// Parameters: 571 571 1
// Target tool: genus
module two_way_karatsuba(clk, rst, a, b, c);
input clk;
input rst;
input [570:0] a;
input [570:0] b;
output reg [1141:0] c;

// Wires declaration 
wire  [284:0] a1;
wire  [284:0] b1;
wire  [284:0] c1;
wire  [284:0] d1;
wire  [285:0] sum_a1b1;
wire  [285:0] sum_c1d1;

// Registers declaration 
reg  [284:0] counter_a1c1;
reg  [284:0] counter_b1d1;
reg  [286:0] counter_sum_a1b1_c1d1;
reg  [570:0] mul_a1c1;
reg  [570:0] mul_b1d1;
reg  [572:0] mul_sum_a1b1_sum_c1d1;

// Initializations / initial assignments
assign a1 = a[569:285];
assign b1 = a[284:0];
assign c1 = b[569:285];
assign d1 = b[284:0];

// Step-1 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
	if (rst == 1'b1) begin
		c <= 1142'd0;
		counter_a1c1 <= 285'd0;
		counter_b1d1 <= 285'd0;
		counter_sum_a1b1_c1d1 <= 287'd0;
		mul_a1c1 <= 571'd0;
		mul_b1d1 <= 571'd0;
		mul_sum_a1b1_sum_c1d1 <= 573'd0;
	end
	else begin
		if (counter_a1c1 < 286) begin
			if (a[counter_a1c1] == 1'b1) begin
				mul_a1c1 <= mul_a1c1 ^ (c1 << counter_a1c1);
				counter_a1c1 <= counter_a1c1 + 1;
			end
				counter_a1c1 <= counter_a1c1 + 1;
		end

	end
end

// Step-2 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
		if (counter_b1d1 < 286) begin
			if (b[counter_b1d1] == 1'b1) begin
				mul_b1d1 <= mul_a1c1 ^ (d1 << counter_b1d1);
				counter_b1d1 <= counter_b1d1 + 1;
			end
				counter_b1d1 <= counter_b1d1 + 1;
		end

end

// Assignments to sum_a1b1 and sum_c1d1
assign sum_a1b1 = a1 ^ b1;
assign sum_c1d1 = c1 ^ d1;

// Step-3 of 2-Way Karatsuba Multiplier
always @(posedge clk) begin
		if (counter_sum_a1b1_c1d1 < 286) begin
			if (sum_a1b1[counter_sum_a1b1_c1d1] == 1'b1) begin
				mul_sum_a1b1_sum_c1d1 <= mul_sum_a1b1_sum_c1d1 ^ (sum_c1d1 << counter_sum_a1b1_c1d1);
				counter_sum_a1b1_c1d1 <= counter_sum_a1b1_c1d1 + 1;
			end
				counter_sum_a1b1_c1d1 <= counter_sum_a1b1_c1d1 + 1;
		end
	c = mul_sum_a1b1_sum_c1d1 - mul_b1d1 - mul_a1c1;
	c = c << 285;
	c = c ^ (mul_a1c1 << 571);
	c = c ^ mul_b1d1;

end
endmodule
