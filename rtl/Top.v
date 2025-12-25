/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Top(
    input wire clk, rst_n,
    input wire [4:0] add_R,
    /* verilator lint_off UNDRIVEN */
    output wire [31:0] addr_M, data_M, data_R
);

    // =================================================================
    // 1. KHAI BÁO DÂY TÍN HIỆU (WIRES)
    // =================================================================
    wire jr, jal;
    wire [31:0] PC_Branch;
    wire [31:0] PC_Branch_EX_MEM, Pc_4;
    wire [31:0] Pc_out, Instruction;
    wire LU_hazard;
    wire [25:0] target;
    wire [5:0]  Opcode_IF_ID;
    wire [31:0] Pc_4_IF_ID;
    wire [4:0]  rs1_IF_ID, rs2_IF_ID, rd_IF_ID;
    wire [5:0]  funct_IF_ID;
    wire [31:0] Write_Data;
    wire Reg_Write_MEM_WB;
    wire [31:0] read_data1, read_data2;
    wire RegDst, Reg_Write, ALUSrc, PcSrc, Mem_Write, Mem_to_Reg, Mem_Read, Jump;
    wire [3:0] ALUOp;
    wire [15:0] Imediate_IF_ID;
    wire [31:0] word;
    wire [4:0]  rs1_ID_EX, rs2_ID_EX, rd_ID_EX;
    wire [4:0]  rd_ID_EX_mux;
    wire [5:0]  funct_ID_EX;
    wire [31:0] word_ID_EX;
    wire [31:0] read_data1_ID_EX, read_data2_ID_EX;
    wire [31:0] PC_ID_EX;
    wire [3:0]  ALUOp_ID_EX;
    wire ALUSrc_ID_EX, Mem_Read_ID_EX, Mem_Write_ID_EX, PcSrc_ID_EX, Mem_to_Reg_ID_EX, Reg_Write_ID_EX, RegDst_ID_EX;
    wire [1:0]  F1, F2;
    wire [31:0] oprd1, oprd2;
    wire [3:0]  ALU_Operation;
    wire Pcsrc; // Tín hiệu từ Enable_Branch (Actual Taken)
    wire zero;
    wire [31:0] result;
    wire Mem_Read_EX_MEM, Mem_Write_EX_MEM, PcSrc_EX_MEM;
    wire Mem_to_Reg_EX_MEM, Reg_Write_EX_MEM;
    wire zero_EX_MEM;
    wire [31:0] result_EX_MEM;
    wire [31:0] Write_Data_EX_MEM;
    wire [4:0]  rd_EX_MEM;
    wire stall;
    wire Mem_to_Reg_MEM_WB;
    wire [31:0] Read_Data_MEM_WB, Result_MEM_WB;
    wire [31:0] Read_Data;
    wire [31:0] out_mux_f2;
    wire [4:0]  rd_MEM_WB;
    wire [31:0] Read_data;
    // --- BTB & PREDICTION WIRES ---
    wire BTB_Predict_Taken;           // BTB dự đoán tại IF
    wire [31:0] BTB_Predicted_Target; // Địa chỉ BTB dự đoán
    
    wire Predict_Taken_IF_ID;         // Pipeline reg IF->ID
    wire Predict_Taken_ID_EX;         // Pipeline reg ID->EX
    wire Predict_Taken_EX_MEM;        // Pipeline reg EX->MEM
    wire [31:0] PC_4_EX_MEM;          // PC+4 tại MEM

    wire Miss_Prediction;             // Tín hiệu báo sai
    wire [31:0] Correct_Address;      // Địa chỉ sửa sai

    // =================================================================
    // 2. LOGIC SỬA SAI (MISS PREDICTION LOGIC)
    // =================================================================
    
    // Miss khi kết quả thực tế (Pcsrc) KHÁC kết quả dự đoán (Predict_Taken_EX_MEM)
    assign Miss_Prediction = (Pcsrc != Predict_Taken_EX_MEM);

    // Tính địa chỉ đúng để quay về:
    // - Nếu thực tế NHẢY (Pcsrc=1): Địa chỉ đúng là Target (PC_Branch_EX_MEM).
    // - Nếu thực tế KHÔNG NHẢY: Địa chỉ đúng là lệnh kế tiếp (PC_4_EX_MEM).
    assign Correct_Address = Pcsrc ? PC_Branch_EX_MEM : PC_4_EX_MEM;

    // =================================================================
    // 3. KẾT NỐI CÁC MODULE
    // =================================================================

    PC PC_uut (
       .clk(clk), .rst_n(rst_n), 
       .LU_hazard(LU_hazard), 
       .jr(jr), .jal(jal), .Jump(Jump),
       
       // Kết nối Logic Dự đoán
       .Miss_Prediction(Miss_Prediction), 
       .Correct_Address(Correct_Address), 
       .Predict_Taken(BTB_Predict_Taken), 
       .Predicted_Target(BTB_Predicted_Target), 
       
       .target(target), 
       .Pc_4(Pc_4), 
       .Pc_out(Pc_out)
    );

    ALU_Pc ALU_pc_uut(.*); // Tính Pc_out + 4

    Branch_Target_Buffer BTB_uut (
        .clk(clk), .rst_n(rst_n),
        // Read (Fetch Stage)
        .PC_IF(Pc_out),
        .Predicted_Target(BTB_Predicted_Target),
        .Predict_Taken(BTB_Predict_Taken),
        // Write (Memory Stage - Learning)
        .PC_Update(PC_4_EX_MEM - 4), 
        .Actual_Target(PC_Branch_EX_MEM),
        .Actual_Taken(Pcsrc),
        .is_Branch(PcSrc_EX_MEM)
    );

    Instruction_mem Instruction_mem_uut(
        .clk(clk), .rst_n(rst_n), 
        .Pcsrc(Miss_Prediction), // Flush instruction memory buffer nếu cần
        .Pc_out(Pc_out), 
        .Instruction(Instruction)
    );

    // --- IF_ID: Nhớ đảm bảo file IF_ID.v có input Pcsrc và Jump ---
    IF_ID IF_ID_uut(
        .clk(clk), .rst_n(rst_n),
        .LU_hazard(LU_hazard),
        .Jump(Jump),             // Flush khi Jump
        .Pcsrc(Miss_Prediction), // Flush khi Miss Prediction
        
        .Pc_out(Pc_4), 
        .Instruction(Instruction),
        // IO Mới BTB
        .Predict_Taken_IF(BTB_Predict_Taken),
        .Predict_Taken_IF_ID(Predict_Taken_IF_ID),
        // IO Cũ
        .jr(jr), .jal(jal), .target(target), 
        .Opcode_IF_ID(Opcode_IF_ID), .Imediate_IF_ID(Imediate_IF_ID),
        .Pc_4_IF_ID(Pc_4_IF_ID), 
        .rs1_IF_ID(rs1_IF_ID), .rs2_IF_ID(rs2_IF_ID), .rd_IF_ID(rd_IF_ID),
        .funct_IF_ID(funct_IF_ID)
    );

    Reg_file Reg_file_uut(.*);
    Control_unit Control_unit_uut(.*);
    Sign_extend  Sign_extend_uut(.*);

    // --- ID_EX: Nhớ đảm bảo file ID_EX.v có input Pcsrc ---
    ID_EX ID_EX_uut(
        .clk(clk), .rst_n(rst_n),
        .Pcsrc(Miss_Prediction), // Flush pipeline khi Miss
        
        .Predict_Taken_IF_ID(Predict_Taken_IF_ID),
        .Predict_Taken_ID_EX(Predict_Taken_ID_EX),
        // Standard IO (Dùng liệt kê thay vì .* để tránh lỗi dư thừa)
        .rs1_IF_ID(rs1_IF_ID), .rs2_IF_ID(rs2_IF_ID), .rd_IF_ID(rd_IF_ID),
        .funct_IF_ID(funct_IF_ID), .word(word), 
        .read_data1(read_data1), .read_data2(read_data2),
        .Pc_4_IF_ID(Pc_4_IF_ID), .ALUOp(ALUOp),
        .ALUSrc(ALUSrc), .Mem_Read(Mem_Read), .Mem_Write(Mem_Write),
        .PcSrc(PcSrc), .Mem_to_Reg(Mem_to_Reg), .Reg_Write(Reg_Write), .RegDst(RegDst),
        // Outputs
        .rs1_ID_EX(rs1_ID_EX), .rs2_ID_EX(rs2_ID_EX), .rd_ID_EX(rd_ID_EX),
        .funct_ID_EX(funct_ID_EX), .word_ID_EX(word_ID_EX),
        .read_data1_ID_EX(read_data1_ID_EX), .read_data2_ID_EX(read_data2_ID_EX),
        .PC_ID_EX(PC_ID_EX), 
        .ALUOp_ID_EX(ALUOp_ID_EX), .ALUSrc_ID_EX(ALUSrc_ID_EX),
        .Mem_Read_ID_EX(Mem_Read_ID_EX), .Mem_Write_ID_EX(Mem_Write_ID_EX),
        .PcSrc_ID_EX(PcSrc_ID_EX), .Mem_to_Reg_ID_EX(Mem_to_Reg_ID_EX),
        .Reg_Write_ID_EX(Reg_Write_ID_EX), .RegDst_ID_EX(RegDst_ID_EX)
    );

    Forwarding_unit Forwarding_unit_uut(.*);
    ALU_Control ALU_Control_uut(.ALUOp(ALUOp_ID_EX),.funct(funct_ID_EX),.ALU_Operation(ALU_Operation));
    ALU ALU_uut(.*);

    // --- [SỬA LỖI TÍNH ĐỊA CHỈ] Dùng module thay vì Shift/Adder thủ công ---
    ALU_Branch ALU_Branch_uut(
        .PC_ID_EX(PC_ID_EX),     // PC+4
        .Immediate(word_ID_EX),  // Offset
        .PC_Branch(PC_Branch)    // Kết quả
    );

    mux_3x1_32bit mux_3x1_32bit_A_uut(.data0(read_data1_ID_EX),.data1(Write_Data),.data2(result_EX_MEM),.sel(F1),.data_out(oprd1));
    mux_3x1_32bit mux_3x1_32bit_B_uut(.data0(read_data2_ID_EX),.data1(Write_Data),.data2(result_EX_MEM),.sel(F2),.data_out(out_mux_f2));
    
    assign oprd2 = ALUSrc_ID_EX ? word_ID_EX : out_mux_f2;
    assign rd_ID_EX_mux = RegDst_ID_EX ? rd_ID_EX : rs2_ID_EX;

    // --- EX_MEM: Đã XÓA cổng Pcsrc/Flush ở đây ---
    EX_MEM EX_MEM_uut(
        .clk(clk), .rst_n(rst_n),
        // Không nối Miss_Prediction vào đây
        
        .PC_ID_EX(PC_ID_EX),    
        .Predict_Taken_ID_EX(Predict_Taken_ID_EX), 
        .PC_4_EX_MEM(PC_4_EX_MEM),
        .Predict_Taken_EX_MEM(Predict_Taken_EX_MEM),
        .Mem_Read_ID_EX(Mem_Read_ID_EX), .Mem_Write_ID_EX(Mem_Write_ID_EX),
        .PcSrc_ID_EX(PcSrc_ID_EX), .Mem_to_Reg_ID_EX(Mem_to_Reg_ID_EX),
        .Reg_Write_ID_EX(Reg_Write_ID_EX), .PC_Branch(PC_Branch),
        .zero(zero), .result(result), 
        .Write_Data(out_mux_f2), // Lấy từ Mux Forwarding để Store đúng data
        .rd_ID_EX_mux(rd_ID_EX_mux), 
        .Pcsrc(Pcsrc),
        .Mem_Read_EX_MEM(Mem_Read_EX_MEM), .Mem_Write_EX_MEM(Mem_Write_EX_MEM),
        .PcSrc_EX_MEM(PcSrc_EX_MEM), .Mem_to_Reg_EX_MEM(Mem_to_Reg_EX_MEM),
        .Reg_Write_EX_MEM(Reg_Write_EX_MEM), .PC_Branch_EX_MEM(PC_Branch_EX_MEM),
        .zero_EX_MEM(zero_EX_MEM), .result_EX_MEM(result_EX_MEM),
        .Write_Data_EX_MEM(Write_Data_EX_MEM), .rd_EX_MEM(rd_EX_MEM)
    );

    Enable_Branch Enable_Branch_uut(.*); // Sinh ra Pcsrc (Actual Taken)
    Data_mem Data_mem_uut(.*);
    
    // MEM_WB Stage
    // Lưu ý: Không nối flush vào MEM_WB
    MEM_WB MEM_WB_uut(
        .clk(clk), .rst_n(rst_n),
        .Reg_Write_EX_MEM(Reg_Write_EX_MEM),
        .result_EX_MEM(result_EX_MEM),
        .Mem_to_Reg_EX_MEM(Mem_to_Reg_EX_MEM),
        .Read_Data(Read_Data), // Data từ Data Memory
        .rd_EX_MEM(rd_EX_MEM),
        .rd_MEM_WB(rd_MEM_WB),
        .Reg_Write_MEM_WB(Reg_Write_MEM_WB), .Mem_to_Reg_MEM_WB(Mem_to_Reg_MEM_WB),
        .Read_Data_MEM_WB(Read_Data_MEM_WB), .Result_MEM_WB(Result_MEM_WB)
    ); 

    mux_WB mux_WB_uut(.*);
    Hazard_detect Hazard_detect_uut(.*);

    assign data_R = read_data1; 

endmodule