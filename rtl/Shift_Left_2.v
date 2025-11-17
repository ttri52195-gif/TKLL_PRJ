`timescale 1ns / 1ps

module Shift_Left_2(
input [31:0] inp,
output [31:0] out);

assign out = (inp << 2);
endmodule
