/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module MEM_WB(
    input wire clk, rst_n,
    input wire Reg_Write_EX_MEM,
    input wire [31:0] result_EX_MEM,
    input wire Mem_to_Reg_EX_MEM,
    input wire [31:0] Read_Data,
    input wire [4:0] rd_EX_MEM,
    
    output reg [4:0] rd_MEM_WB,
    output reg Reg_Write_MEM_WB, Mem_to_Reg_MEM_WB,
    output reg [31:0] Read_Data_MEM_WB, Result_MEM_WB
);

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rd_MEM_WB         <= 0;
            Read_Data_MEM_WB  <= 0;
            Reg_Write_MEM_WB  <= 0;
            Mem_to_Reg_MEM_WB <= 0;
            Result_MEM_WB     <= 0;
        end
        else begin               
            rd_MEM_WB         <= rd_EX_MEM;
            Read_Data_MEM_WB  <= Read_Data;
            Reg_Write_MEM_WB  <= Reg_Write_EX_MEM;
            Mem_to_Reg_MEM_WB <= Mem_to_Reg_EX_MEM;
            Result_MEM_WB     <= result_EX_MEM;   
        end
    end

endmodule