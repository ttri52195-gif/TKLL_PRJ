`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 08:34:44 AM
// Design Name: 
// Module Name: tb_ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_ALU;
reg [31:0] tb_oprd1;
reg [31:0] tb_oprd2;
reg [3:0] tb_ALU_Operation;
wire tb_zero;
wire [31:0] tb_result;

ALU uut(.oprd1(tb_oprd1), .oprd2(tb_oprd2), .ALU_Operation(tb_ALU_Operation), .zero(tb_zero), .result(tb_result));
initial begin 
    $display("-------Kiem tra module ALU -------");
    $display("            Thoi gian  | Oprd1 | Oprd2 | ALUOp | Ket qua (Mong doi) | Ket qua (Thuc te) | Zero");
    $display("            ---------------------------------------------------------------------------------------");
    
    // Test 1
    tb_oprd1 = 32'd12;
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0000; // AND
    #10
    $display("%tns | %5d | %5d |  0000 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd8, tb_result, tb_zero);

    // Test 2
    tb_oprd1 = 32'd12;
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0001; // OR
    #10;
    $display("%8tns | %5d | %5d |  0001 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd14, tb_result, tb_zero);
    
    // Test 3
    tb_oprd1 = 32'd15;
    tb_oprd2 = 32'd20;
    tb_ALU_Operation = 4'b0010; // ADD
    #10;
    $display("%8tns | %5d | %5d |  0010 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd35, tb_result, tb_zero); 
        
    // Test 4
    tb_oprd1 = 32'd100;
    tb_oprd2 = 32'd30;
    tb_ALU_Operation = 4'b0110; // Subtract
    #10;
    $display("%8tns | %5d | %5d |  0110 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd70, tb_result, tb_zero);

    // Test 5
    tb_oprd1 = 32'd50;
    tb_oprd2 = 32'd50;
    tb_ALU_Operation = 4'b0110; // Subtract
    #10;
    $display("%8tns | %5d | %5d |  0110 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd0, tb_result, tb_zero);    
    
    // Test 6
    tb_oprd1 = 32'd10;
    tb_oprd2 = 32'd20;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%8tns | %5d | %5d |  0111 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd1, tb_result, tb_zero);
    
    // Test 7
    tb_oprd1 = 32'd20;
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%8tns | %5d | %5d |  0111 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd0, tb_result, tb_zero);


    // Test 8
    tb_oprd1 = 32'd20;
    tb_oprd2 = 32'd20;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%8tns | %5d | %5d |  0111 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd0, tb_result, tb_zero);
    
    // Test 9
    tb_oprd1 = 32'd7;
    tb_oprd2 = 32'd11;
    tb_ALU_Operation = 4'b1100; // NOR
    #10;
    $display("%8tns | %5d | %5d |  1100 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd4294967280, tb_result, tb_zero);
    
    // Test 10
    tb_oprd1 = 32'd12;
    tb_oprd2 = 32'd5;
    tb_ALU_Operation = 4'b1100; // slt
    #10;
    $display("%8tns | %5d | %5d |  1100 | %16d | %17d |  %b", $time, tb_oprd1, tb_oprd2, 32'd4294967282, tb_result, tb_zero);
    
    
    // --- Test 11: SLT (Số âm, True) ---
    // -5 < 10 -> result = 1 
    tb_oprd1 = -32'd5; // Đã sửa
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0111;
    #10;
    // Dùng $signed() để in ra -5
    $display("%8tns | %5d | %5d |  0111 | %16d | %17d |  %b", $time, $signed(tb_oprd1), $signed(tb_oprd2), 32'd1, tb_result, tb_zero);

    // --- Test 12: ADD (Số âm) ---
    // -10 + 5 = -5
    tb_oprd1 = -32'd10; // Đã sửa
    tb_oprd2 = 32'd5;
    tb_ALU_Operation = 4'b0010;
    #10;
    // Dùng $signed() để in ra -10 và -5
    $display("%8tns | %5d | %5d |  0010 | %16d | %17d |  %b", $time, $signed(tb_oprd1), $signed(tb_oprd2), $signed(-32'd5), $signed(tb_result), tb_zero);

    // --- Trường hợp 11: SUBTRACT (Số âm, Test Zero) ---
    // -10 - (-10) = 0 (Mong đợi Zero = 1)
    tb_oprd1 = -32'd10; // Đã sửa
    tb_oprd2 = -32'd10; // Đã sửa
    tb_ALU_Operation = 4'b0110;
    #10;
    // Dùng $signed() để in ra -10
    $display("%8tns | %5d | %5d |  0110 | %16d | %17d |  %b", $time, $signed(tb_oprd1), $signed(tb_oprd2), 32'd0, tb_result, tb_zero);
    
    #10;
    $display("--- Kiem thu hoan tat ---");
    $finish;    
end
endmodule
