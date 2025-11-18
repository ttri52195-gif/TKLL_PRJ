/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module Enable_Branch(
   input wire zero_EX_MEM,PC_Branch_EX_MEM,
   output wire Pcsrc

);
   assign Pcsrc = zero_EX_MEM && PC_Branch_EX_MEM;
endmodule
