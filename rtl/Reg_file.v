/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Reg_file(
	input wire clk,Reg_Write_MEM_WB,rst_n,
    input wire  [4:0] rs1_IF_ID, rs2_IF_ID,
	input wire  [4:0] rd_MEM_WB,
    input wire  [31:0] Write_Data,
	output wire  [31:0] read_data1, read_data2
);
     
       reg [31:0] mem [0:31];


       always@(posedge clk or negedge rst_n) begin
     
	       if(!rst_n) begin
                    
		for(integer i = 0 ; i < 32; i = i+1)

		     mem[i] <= 0;	
             
	    end
		     
            else if(Reg_Write_MEM_WB && rd_MEM_WB != 5'b0)   mem[rd_MEM_WB] <= Write_Data;
            mem[0] <= 0;
       end
    
initial begin
    forever @(posedge clk) begin
        $writememh("reg_mem.hex", mem);
       for(integer i = 0 ; i< 32; i = i +1)
       $display("Register %d =  %d",i,mem[i]);


    end
end
         // HANDLING RAW HAZARD
       assign read_data1  =  (rs1_IF_ID == rd_MEM_WB) ? Write_Data: mem[rs1_IF_ID];
       assign read_data2  =  (rs2_IF_ID == rd_MEM_WB) ? Write_Data: mem[rs2_IF_ID];


endmodule
