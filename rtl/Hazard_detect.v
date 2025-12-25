/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Hazard_detect(       
     input wire Mem_Read_ID_EX,
     input wire [4:0] rs2_ID_EX, rs1_IF_ID,rs2_IF_ID,
     output wire LU_hazard
);
      assign LU_hazard = Mem_Read_ID_EX &&(rs2_ID_EX == rs1_IF_ID || rs2_ID_EX == rs2_IF_ID) &&(rs2_ID_EX != 0);
                     





endmodule
