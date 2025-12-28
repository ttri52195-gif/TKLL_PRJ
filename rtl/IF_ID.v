/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module IF_ID(
  input   wire clk, rst_n, LU_hazard, Pcsrc, // Đổi tên Pcsrc thành Flush cho rõ nghĩa
  input   wire [31:0] Pc_out,
  input   wire [31:0] Instruction,
  input   wire Jump,
  // Input mới từ BTB
  input   wire Predict_Taken_IF, 
  
  output  wire  jr, jal,
  output  wire [25:0] target,
  output  reg  [5:0]  Opcode_IF_ID, 
  output  reg  [15:0] Imediate_IF_ID,
  output  reg  [31:0] Pc_4_IF_ID,
  output  reg [4:0] rs1_IF_ID,rs2_IF_ID,rd_IF_ID,
  output  reg [5:0] funct_IF_ID,
  
  // Output trạng thái dự đoán
  output  reg Predict_Taken_IF_ID
);

always@(posedge clk or negedge rst_n) begin
    if(!rst_n || Pcsrc || Jump) begin
        Opcode_IF_ID     <= 0;
        rs1_IF_ID        <= 0;
        rs2_IF_ID        <= 0;
        rd_IF_ID         <= 0;
        Imediate_IF_ID   <= 0;
        Pc_4_IF_ID       <= 0;
        funct_IF_ID      <= 0;
        Predict_Taken_IF_ID <= 0; // Reset dự đoán
    end
    else if (!LU_hazard) begin
        Opcode_IF_ID     <= Instruction[31:26];
        rs1_IF_ID        <= Instruction[25:21];
        rs2_IF_ID        <= Instruction[20:16];
        rd_IF_ID         <= Instruction[15:11];
        Imediate_IF_ID   <= Instruction[15:0];
        Pc_4_IF_ID       <= Pc_out;
        funct_IF_ID      <= Instruction[5:0];
        Predict_Taken_IF_ID <= Predict_Taken_IF; // Lưu dự đoán
    end
end
 
    assign jr      = Opcode_IF_ID == 6'b000000 &&  funct_IF_ID == 6'b001000 && Instruction[11:6] == 0;
    assign jal     = Opcode_IF_ID == 6'b000011;
assign target  = {rs1_IF_ID, rs2_IF_ID, Imediate_IF_ID};
endmodule
