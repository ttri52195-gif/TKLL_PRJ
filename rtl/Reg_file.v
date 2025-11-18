/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module Reg_file(
	input wire clk,Reg_Write_MEM_WB,rst_n,
        input wire [4:0] rs1_IF_ID, rs2_IF_ID,
	input wire [4:0] rd_MEM_WB,
        input wire [31:0] Write_Data,
	output wire  [31:0] read_data1, read_data2
);
     
       reg [31:0] mem [31:0];
       wire [4:0] rs, rt;

       assign rs = rs1_IF_ID;
       assign rt = rs2_IF_ID;

       always@(posedge clk or negedge rst_n) begin
     
	       if(!rst_n) begin
                    
		for(integer i = 0 ; i < 32; i = i +1)

		     mem[i] <= 0;	
	       end
		     

         if(Reg_Write_MEM_WB)   mem[rd_MEM_WB] <= Write_Data;

       end

      assign read_data1 = mem[rs];
      assign read_data2  = mem[rt];
endmodule
