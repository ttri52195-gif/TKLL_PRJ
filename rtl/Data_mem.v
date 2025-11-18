/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module Data_mem(
  input wire clk,rst_n,	
  input wire [31:0] result_EX_MEM,
  input wire [31:0] Write_Data_EX_MEM,
  input wire Mem_Write_EX_MEM, Mem_Read_EX_MEM,
  output wire [31:0] Read_Data
);
   reg [31:0] mem [0:1023];
  initial begin
   $readmemh("data.hex",mem);
   end

   always@(posedge clk or negedge rst_n)
   begin
          
	   if(!rst_n) begin
/* verilator lint_off UNUSEDLOOP */
            for(integer i = 0 ; i < 1024; i = i + 1)
	    begin
                      mem[i] <= 0;
	    end

	   end

	  else  if(Mem_Write_EX_MEM) mem[result_EX_MEM>>2] <= Write_Data_EX_MEM;

   end
	      assign Read_Data = Mem_Read_EX_MEM ? mem[result_EX_MEM>>2] : 0;
endmodule
