/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module Forwarding_unit(
   
   input wire [4:0] rs1_ID_EX, rs2_ID_EX, rd_EX_MEM,rd_MEM_WB,
   input wire Reg_Write_MEM_WB,Reg_Write_EX_MEM,

   output reg [1:0] F1,F2
);

  always@(*)
  begin

  if((Reg_Write_EX_MEM & rd_EX_MEM != 0 ) && (rd_EX_MEM == rs1_ID_EX))
	  F1 = 2'b10;
  else if ((Reg_Write_MEM_WB && rd_MEM_WB != 0) && (rd_MEM_WB == rs1_ID_EX))
	  F1 = 2'b01;

  else   F1 = 0;

  if((Reg_Write_EX_MEM & rd_EX_MEM != 0 ) && (rd_EX_MEM == rs2_ID_EX))
	  F2 = 2'b10;
  else if ((Reg_Write_MEM_WB && rd_MEM_WB != 0) && (rd_MEM_WB == rs2_ID_EX))
	  F2 = 2'b01;

  else    F2 = 0;
  
  end
endmodule
