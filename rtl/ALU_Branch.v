/* verilator lint_off MULTITOP */

`timescale 1ns / 1ps

module ALU_Branch(
       input wire [31:0] PC_ID_EX;
       output wire [31:0] PC_Branch
);
      assign PC_Branch = PC_ID_EX + 4;
endmodule
