/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module ALU_Branch(
       input wire [31:0] PC_ID_EX,    // Đây là PC+4 từ giai đoạn trước
       input wire [31:0] Immediate,   // Giá trị Offset (Sign-extended)
       output wire [31:0] PC_Branch
);
 
    assign PC_Branch = PC_ID_EX + (Immediate << 2)-4;

endmodule