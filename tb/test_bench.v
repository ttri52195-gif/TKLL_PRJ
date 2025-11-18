`timescale 1ns / 1ps
module test_bench();
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] ans;
//    reg [31:0] tb_data1_2x1;
//    reg [31:0] tb_data2_2x1;
//    reg        tb_sel_2x1;
//    wire [31:0] tb_out_2x1; // 'wire' để nhận đầu ra từ DUT

//    // --- Tín hiệu cho MUX 3x1 ---
//    reg [31:0] tb_data1_3x1;
//    reg [31:0] tb_data2_3x1;
//    reg [31:0] tb_data3_3x1;
//    reg [1:0]  tb_sel_3x1;
//    wire [31:0] tb_out_3x1; // 'wire' để nhận đầu ra từ DUT

    // Instantiation (tạo thực thể) của MUX 2x1
    // "uut1" là viết tắt của Unit Under Test 1
//    mux_2x1_32bit uut1 (
//        .data0(tb_data1_2x1),
//        .data1(tb_data2_2x1),
//        .sel(tb_sel_2x1),
//        .data_out(tb_out_2x1)
//    );

    // Instantiation của MUX 3x1
//    mux_3x1_32bit uut2 (
//        .data0(tb_data1_3x1),
//        .data1(tb_data2_3x1),
//        .data2(tb_data3_3x1),
//        .sel(tb_sel_3x1),
//        .data_out(tb_out_3x1)
//    );
    adder_32bit uut3(
        .a(a),
        .b(b),
        .sum(ans));
    // Khối 'initial' là nơi chứa kịch bản test
    initial begin
        // --- Khởi tạo giá trị ban đầu ---
        $display("--- Bat dau Testbench ---");
        
        // Gán giá trị đầu vào cho MUX 2x1
//        tb_data1_2x1 = 32'hAAAAAAAA; // (Hex)
//        tb_data2_2x1 = 32'hBBBBBBBB;
//        tb_sel_2x1   = 1'b0;

//        // Gán giá trị đầu vào cho MUX 3x1
//        tb_data1_3x1 = 32'd111;       // (Decimal)
//        tb_data2_3x1 = 32'd222;
//        tb_data3_3x1 = 32'd333;
//        tb_sel_3x1   = 2'b00;


//        // --- Kịch bản test MUX 2x1 ---
        
//        #10; // Chờ 10ns
//        tb_sel_2x1 = 1'b0; // sel=0, chọn data2
//        $display("[Time %0t] MUX2x1: sel=%b | out=%h (ky vong %h)", $time, tb_sel_2x1, tb_out_2x1, tb_data2_2x1);

//        #10;
//        tb_sel_2x1 = 1'b1; // sel=1, chọn data1
//        $display("[Time %0t] MUX2x1: sel=%b | out=%h (ky vong %h)", $time, tb_sel_2x1, tb_out_2x1, tb_data1_2x1);

//        // --- Kịch bản test MUX 3x1 ---
        
//        #10;
//        tb_sel_3x1 = 2'b00; // sel=00, chọn data1
        

//        #10;
//        tb_sel_3x1 = 2'b01; // sel=01, chọn data2
        

//        #10;
//        tb_sel_3x1 = 2'b10; // sel=10, chọn data3
        
//        #10;
//        tb_sel_3x1 = 2'b11; // sel=11, trường hợp default
        
//        // --- Test thay đổi giá trị đầu vào ---
        
        
//        #10;
//        tb_data2_3x1 = 32'd999; // Thay đổi giá trị data2
//        tb_sel_3x1 = 2'b01;    // Chọn lại data2

//        #20;

        //-----------Test Adder-32bit-----------------
        #200
        a = 32'd111;       // (Decimal)
        b = 32'd222;
        #200
 
        a = 32'd111;       // (Decimal)
        b = 32'd342;
        #200      
        
        a = 32'd045;       // (Decimal)
        b = 32'd123;
        #200
        
        a = 32'd408;       // (Decimal)
        b = 32'd292;
        #200
 
        $finish; // Kết thúc mô phỏng
    end


endmodule
