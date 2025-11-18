`timescale 1ns / 1ps

module tb_ALU;
reg [31:0] tb_oprd1;
reg [31:0] tb_oprd2;
reg [3:0] tb_ALU_Operation;
wire tb_zero;
wire [31:0] tb_result;

// Biến đếm số thứ tự test case
integer test_num; 

ALU uut(.oprd1(tb_oprd1), .oprd2(tb_oprd2), .ALU_Operation(tb_ALU_Operation), .zero(tb_zero), .result(tb_result));

initial begin 
    test_num = 0; // Khởi tạo biến đếm
    $display("------------------- Kiem tra module ALU -------------------");
    // Tiêu đề cột thống nhất
    $display(" # | Time(ns) | Operand 1 | Operand 2 | Op   |    Expected (s) |      Actual (s) | Zero");
    $display("---|----------|-----------|-----------|------|-----------------|-----------------|------");

    // --- Test 1: AND (12 & 10 = 8) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd12;
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0000; // AND
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd8, $signed(tb_result), tb_zero);

    // --- Test 2: OR (12 | 10 = 14) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd12;
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0001; // OR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd14, $signed(tb_result), tb_zero);
    
    // --- Test 3: ADD (15 + 20 = 35) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd15;
    tb_oprd2 = 32'd20;
    tb_ALU_Operation = 4'b0010; // ADD
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd35, $signed(tb_result), tb_zero); 
        
    // --- Test 4: SUB (100 - 30 = 70) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd100;
    tb_oprd2 = 32'd30;
    tb_ALU_Operation = 4'b0110; // Subtract
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd70, $signed(tb_result), tb_zero);

    // --- Test 5: SUB (50 - 50 = 0, Zero=1) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd50;
    tb_oprd2 = 32'd50;
    tb_ALU_Operation = 4'b0110; // Subtract
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd0, $signed(tb_result), tb_zero); 
    
    // --- Test 6: SLT (10 < 20 = 1) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd10;
    tb_oprd2 = 32'd20;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd1, $signed(tb_result), tb_zero);
    
    // --- Test 7: SLT (20 < 10 = 0) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd20;
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd0, $signed(tb_result), tb_zero);

    // --- Test 8: SLT (20 < 20 = 0) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd20;
    tb_oprd2 = 32'd20;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd0, $signed(tb_result), tb_zero);
    
    // --- Test 9: NOR (7 NOR 11 = -16) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd7;
    tb_oprd2 = 32'd11;
    tb_ALU_Operation = 4'b1100; // NOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, -32'sd16, $signed(tb_result), tb_zero);
    
    // --- Test 10: NOR (12 NOR 5 = -14) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd12;
    tb_oprd2 = 32'd5;
    tb_ALU_Operation = 4'b1100; // NOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, -32'sd14, $signed(tb_result), tb_zero);
    
    // --- Test 11: SLT (Số âm, True, -5 < 10 = 1) ---
    test_num = test_num + 1;
    tb_oprd1 = -32'sd5; // Đã đổi cú pháp
    tb_oprd2 = 32'd10;
    tb_ALU_Operation = 4'b0111; // slt
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd1, $signed(tb_result), tb_zero);

    // --- Test 12: ADD (Số âm, -10 + 5 = -5) ---
    test_num = test_num + 1;
    tb_oprd1 = -32'sd10; // Đã đổi cú pháp
    tb_oprd2 = 32'd5;
    tb_ALU_Operation = 4'b0010; // ADD
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, -32'sd5, $signed(tb_result), tb_zero);

    // --- Test 13: SUB (Số âm, Test Zero, -10 - (-10) = 0) ---
    test_num = test_num + 1;
    tb_oprd1 = -32'sd10; // Đã đổi cú pháp
    tb_oprd2 = -32'sd10; // Đã đổi cú pháp
    tb_ALU_Operation = 4'b0110; // Subtract
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd0, $signed(tb_result), tb_zero);
    
    // --- Test 14: XOR (11 ^ 25 = 18) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd11;
    tb_oprd2 = 32'd25;
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd18, $signed(tb_result), tb_zero);

    // --- Test 15: XOR (0 ^ 12345 = 12345) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd0;
    tb_oprd2 = 32'd12345;
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd12345, $signed(tb_result), tb_zero);

    // --- Test 16: XOR (555 ^ 555 = 0, Zero=1) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd555;
    tb_oprd2 = 32'd555;
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'sd0, $signed(tb_result), tb_zero);

    // --- Test 17: XOR (NOT, 12345 ^ -1 = -12346) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd12345;
    tb_oprd2 = -32'sd1; // Đã đổi cú pháp
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, -32'sd12346, $signed(tb_result), tb_zero);

    // --- Test 18: XOR (Số âm, 100 ^ -50 = -86) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'd100;
    tb_oprd2 = -32'sd50; // Đã đổi cú pháp
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, -32'sd86, $signed(tb_result), tb_zero);

    // --- Test 19: XOR (Pattern, 0xAAAAAAAA ^ 0x55555555 = -1) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'hAAAAAAAA;
    tb_oprd2 = 32'h55555555;
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, -32'sd1, $signed(tb_result), tb_zero);

    // --- Test 20: XOR (Pattern, 0xAAAAAAAA ^ 0xFFFFFFFF = 0x55555555) ---
    test_num = test_num + 1;
    tb_oprd1 = 32'hAAAAAAAA;
    tb_oprd2 = 32'hFFFFFFFF;
    tb_ALU_Operation = 4'b1000; // XOR
    #10;
    $display("%3d | %8tns | %11d | %11d | %4b | %17d | %17d | %b", test_num, $time, $signed(tb_oprd1), $signed(tb_oprd2), tb_ALU_Operation, 32'd1431655765, $signed(tb_result), tb_zero);
    
    $display("------------------- Kiem thu hoan tat -------------------");
    $finish;  
end

endmodule