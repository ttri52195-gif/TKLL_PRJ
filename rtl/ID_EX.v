/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module ID_EX(
    // Inputs Data
    input [4:0] rs1_IF_ID, rs2_IF_ID, rd_IF_ID,
    input [5:0] funct_IF_ID,
    input [31:0] word,
    input [31:0] read_data1, read_data2,
    input [31:0] Pc_4_IF_ID,
    
    // Inputs Control
    input [3:0] ALUOp,
    input ALUSrc, Mem_Read, Mem_Write, PcSrc, Mem_to_Reg, Reg_Write, RegDst,
    
    // Inputs Flush/Reset
    input Pcsrc, // Tín hiệu này sẽ nối với Miss_Prediction ở Top
    input clk, rst_n,

    // --- MỚI: Tín hiệu dự đoán từ IF_ID ---
    input Predict_Taken_IF_ID, 
    
    // Outputs Data
    output [4:0] rs1_ID_EX, rs2_ID_EX, rd_ID_EX,
    output [5:0] funct_ID_EX,
    output [31:0] word_ID_EX,
    output [31:0] read_data1_ID_EX, read_data2_ID_EX,
    output [31:0] PC_ID_EX,
    
    // Outputs Control
    output [3:0] ALUOp_ID_EX,
    output ALUSrc_ID_EX, Mem_Read_ID_EX, Mem_Write_ID_EX, PcSrc_ID_EX,
    output Mem_to_Reg_ID_EX, Reg_Write_ID_EX, RegDst_ID_EX,

    // --- MỚI: Tín hiệu dự đoán chuyển sang ID_EX ---
    output Predict_Taken_ID_EX 
);

    reg [4:0] rs1_r, rs2_r, rd_r;
    reg [5:0] funct_r;
    reg [31:0] word_r;
    reg [31:0] read_data1_r, read_data2_r;
    reg [31:0] PC_r;
    reg [3:0] ALUOp_r;
    reg ALUSrc_r, Mem_Read_r, Mem_Write_r, PcSrc_r, Mem_to_Reg_r, Reg_Write_r, RegDst_r;
    
    // Register lưu trạng thái dự đoán
    reg Predict_Taken_r; 

    always@(posedge clk or negedge rst_n) begin 
        if (!rst_n || Pcsrc) begin 
            rs1_r          <= 5'b0;
            rs2_r          <= 5'b0;
            rd_r           <= 5'b0;
            funct_r        <= 6'b0;
            word_r         <= 32'b0;
            read_data1_r   <= 32'b0;
            read_data2_r   <= 32'b0;
            PC_r           <= 32'b0;
            ALUOp_r        <= 4'b0;
            ALUSrc_r       <= 1'b0;
            Mem_Read_r     <= 1'b0;
            Mem_Write_r    <= 1'b0;
            PcSrc_r        <= 1'b0;
            Mem_to_Reg_r   <= 1'b0;
            Reg_Write_r    <= 1'b0;
            RegDst_r       <= 1'b0;
            Predict_Taken_r <= 1'b0; // Reset dự đoán
        end 
        else begin
            rs1_r          <= rs1_IF_ID;
            rs2_r          <= rs2_IF_ID;
            rd_r           <= rd_IF_ID;
            funct_r        <= funct_IF_ID;
            word_r         <= word;
            read_data1_r   <= read_data1;
            read_data2_r   <= read_data2;
            PC_r           <= Pc_4_IF_ID;
   
            
            ALUOp_r        <= ALUOp;
            ALUSrc_r       <= ALUSrc;
            Mem_Read_r     <= Mem_Read;
            Mem_Write_r    <= Mem_Write;
            PcSrc_r        <= PcSrc;
            Mem_to_Reg_r   <= Mem_to_Reg;
            Reg_Write_r    <= Reg_Write;
            RegDst_r       <= RegDst;  
            Predict_Taken_r <= Predict_Taken_IF_ID; // Lưu trạng thái dự đoán
        end
    end

    assign rs1_ID_EX        = rs1_r;
    assign rs2_ID_EX        = rs2_r;
    assign rd_ID_EX         = rd_r;
    assign funct_ID_EX      = funct_r;
    assign word_ID_EX       = word_r;
    assign read_data1_ID_EX = read_data1_r;
    assign read_data2_ID_EX = read_data2_r;
    assign ALUOp_ID_EX      = ALUOp_r;
    assign ALUSrc_ID_EX     = ALUSrc_r;
    assign Mem_Read_ID_EX   = Mem_Read_r;
    assign Mem_Write_ID_EX  = Mem_Write_r;
    assign PcSrc_ID_EX      = PcSrc_r;
    assign Mem_to_Reg_ID_EX = Mem_to_Reg_r;
    assign Reg_Write_ID_EX  = Reg_Write_r;
    assign RegDst_ID_EX     = RegDst_r;
    assign PC_ID_EX         = PC_r;
    
    // Output logic mới
    assign Predict_Taken_ID_EX = Predict_Taken_r;

endmodule
