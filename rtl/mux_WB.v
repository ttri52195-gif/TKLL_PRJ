/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module mux_WB(
  
      input wire Mem_to_Reg_MEM_WB,
      input wire [31:0] Read_Data_MEM_WB,
      input wire [31:0] Result_MEM_WB,
      output wire [31:0] Write_Data
);
     assign  Write_Data = Mem_to_Reg_MEM_WB ? Read_Data_MEM_WB : Result_MEM_WB;
     
endmodule
