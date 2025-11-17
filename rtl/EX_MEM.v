`timescale 1ns / 1ps
module EX_MEM(
input Mem_Read_ID_EX,Mem_Write_ID_EX,PcSrc_ID_EX,
input Mem_to_Reg_ID_EX,Reg_Write_ID_EX,
input [31:0] PC_Branch,
input zero,
input [31:0] result,
input [31:0] Write_Data,
input [4:0] rd_ID_EX,
input clk,
input rst_n,
output Mem_Read_EX_MEM,Mem_Write_EX_MEM,PcSrc_EX_MEM,
output Mem_to_Reg_EX_MEM,Reg_Write_EX_MEM,
output [31:0] PC_Branch_EX_MEM,
output zero_EX_MEM,
output [31:0] result_EX_MEM,
output [31:0] Write_Data_EX_MEM,
output [4:0] rd_EX_MEM);

reg Mem_Read_r,Mem_Write_r,PcSrc_r;
reg Mem_to_Reg_r,Reg_Write_r;
reg [31:0] PC_Branch_r;
reg zero_r;
reg [31:0] result_r;
reg [31:0] Write_Data_r;
reg [4:0] rd_ID_EX_r;


always@(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin // Khi rst_n = 0 (mức thấp)
            Mem_Read_r     <= 1'b0;
            Mem_Write_r    <= 1'b0;
            PcSrc_r        <= 1'b0;
            Mem_to_Reg_r   <= 1'b0;
            Reg_Write_r    <= 1'b0;
            PC_Branch_r    <= 32'b0;
            zero_r         <= 1'b0;
            result_r       <= 32'b0;
            Write_Data_r   <= 32'b0;
            rd_ID_EX_r     <= 5'b0;
        end
    else begin 
        Mem_Read_r <= Mem_Read_ID_EX;
        Mem_Write_r <= Mem_Write_ID_EX;
        PcSrc_r <= PcSrc_ID_EX;
        Mem_to_Reg_r <= Mem_to_Reg_ID_EX;
        Reg_Write_r <= Reg_Write_ID_EX;
        PC_Branch_r <= PC_Branch;
        zero_r <= zero;
        result_r <= result;
        Write_Data_r <= Write_Data;
        rd_ID_EX_r <= rd_ID_EX; 
    end
end

assign Mem_Read_EX_MEM = Mem_Read_r;
assign Mem_Write_EX_MEM = Mem_Write_r;
assign PcSrc_EX_MEM = PcSrc_r;
assign Mem_to_Reg_EX_MEM = Mem_to_Reg_r;
assign Reg_Write_EX_MEM = Reg_Write_r;
assign PC_Branch_EX_MEM = PC_Branch_r;
assign zero_EX_MEM = zero_r;
assign result_EX_MEM = result_r;
assign Write_Data_EX_MEM = Write_Data_r;
assign rd_EX_MEM = rd_ID_EX_r;
endmodule
