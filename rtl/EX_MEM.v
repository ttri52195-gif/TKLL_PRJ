/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module EX_MEM(
    input Mem_Read_ID_EX,Mem_Write_ID_EX,PcSrc_ID_EX,Pcsrc, // Đổi Pcsrc -> Flush
    input Mem_to_Reg_ID_EX,Reg_Write_ID_EX,
    input [31:0] PC_Branch,
    input zero,
    input [31:0] result,
    input [31:0] Write_Data,
    input [4:0]  rd_ID_EX_mux,
    
    // Thêm Input mới
    input [31:0] PC_ID_EX,          // Đây là PC+4 từ giai đoạn ID
    input Predict_Taken_ID_EX,      // Dự đoán từ ID

    input clk, rst_n,
    
    output wire Mem_Read_EX_MEM,Mem_Write_EX_MEM,PcSrc_EX_MEM,
    output wire Mem_to_Reg_EX_MEM,Reg_Write_EX_MEM,
    output wire [31:0] PC_Branch_EX_MEM,
    output wire zero_EX_MEM,
    output wire [31:0] result_EX_MEM,
    output wire [31:0] Write_Data_EX_MEM,
    output wire [4:0] rd_EX_MEM,
    
    // Thêm Output mới
    output wire [31:0] PC_4_EX_MEM,   // PC+4 tại MEM
    output wire Predict_Taken_EX_MEM  // Dự đoán tại MEM
);

    reg Mem_Read_r,Mem_Write_r,PcSrc_r;
    reg Mem_to_Reg_r,Reg_Write_r;
    reg [31:0] PC_Branch_r;
    reg zero_r;
    reg [31:0] result_r;
    reg [31:0] Write_Data_r;
    reg [4:0] rd_ID_EX_r;
    
    // Reg mới
    reg [31:0] PC_4_r;
    reg Predict_Taken_r;

always@(posedge clk or negedge rst_n) begin 
    if (!rst_n || Pcsrc) begin 
        Mem_Read_r     <= 1'b0; Mem_Write_r    <= 1'b0; PcSrc_r        <= 1'b0;
        Mem_to_Reg_r   <= 1'b0; Reg_Write_r    <= 1'b0; PC_Branch_r    <= 32'b0;
        zero_r         <= 1'b0; result_r       <= 32'b0; Write_Data_r   <= 32'b0;
        rd_ID_EX_r     <= 5'b0;
        
        PC_4_r          <= 32'b0;
        Predict_Taken_r <= 1'b0;
    end
    else begin 
         Mem_Read_r <= Mem_Read_ID_EX; Mem_Write_r <= Mem_Write_ID_EX;
         PcSrc_r <= PcSrc_ID_EX; Mem_to_Reg_r <= Mem_to_Reg_ID_EX;
         Reg_Write_r <= Reg_Write_ID_EX; PC_Branch_r <= PC_Branch;
         zero_r <= zero; result_r <= result; Write_Data_r <= Write_Data;
         rd_ID_EX_r <= rd_ID_EX_mux; 
         
         PC_4_r <= PC_ID_EX;
         Predict_Taken_r <= Predict_Taken_ID_EX;
    end
end
    // Assigns cũ
    assign Mem_Read_EX_MEM = Mem_Read_r; assign Mem_Write_EX_MEM = Mem_Write_r;
    assign PcSrc_EX_MEM = PcSrc_r; assign Mem_to_Reg_EX_MEM = Mem_to_Reg_r;
    assign Reg_Write_EX_MEM = Reg_Write_r; assign PC_Branch_EX_MEM = PC_Branch_r;
    assign zero_EX_MEM = zero_r; assign result_EX_MEM = result_r;
    assign Write_Data_EX_MEM = Write_Data_r; assign rd_EX_MEM = rd_ID_EX_r;
    
    // Assigns mới
    assign PC_4_EX_MEM = PC_4_r;
    assign Predict_Taken_EX_MEM = Predict_Taken_r;
endmodule