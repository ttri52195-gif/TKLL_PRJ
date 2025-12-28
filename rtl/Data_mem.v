/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Data_mem(
  input wire clk,
  input wire [31:0] result_EX_MEM,
  input wire [31:0] Write_Data_EX_MEM,
  input wire Mem_Write_EX_MEM, Mem_Read_EX_MEM,
  output wire [31:0] Read_Data
);
   reg [31:0] mem [0:1023];

// Initial data for Memory
  initial begin
     $readmemh("data.hex",mem);
   end

   always@(posedge clk)
   begin
          
	    if(Mem_Write_EX_MEM) mem[result_EX_MEM>>2] <= Write_Data_EX_MEM;

   end
	      assign Read_Data = Mem_Read_EX_MEM ? mem[result_EX_MEM>>2] : 0;
endmodule
