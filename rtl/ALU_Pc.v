/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module ALU_Pc(
     input wire [31:0] Pc_out,
     output wire [31:0]Pc_4
     
);
   assign Pc_4 = Pc_out +4;
endmodule
