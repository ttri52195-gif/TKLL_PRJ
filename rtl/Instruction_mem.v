/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module Instruction_mem(
       input wire clk,rst_n,
       input wire [31:0] Pc_out,
       output reg  [31:0] Instruction
);
  reg [31:0] mem [0:1023];

  initial begin
	  $readmemh("program.hex",mem);
  end

  always@(posedge clk or negedge rst_n) begin

      if(!rst_n) begin
        /* verilator lint_off UNUSEDLOOP */
        for(integer  i = 0; i < 1024; i = i +1) begin
            mem[i] <= 0;
        end
      end

    else  Instruction <= mem[Pc_out>>2];
     end
endmodule
