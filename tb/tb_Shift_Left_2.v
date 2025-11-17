`timescale 1ns / 1ps

// Đặt tên module testbench
module tb_Shift_Left_2;
    reg  [31:0] tb_inp;
    wire [31:0] tb_out;
    Shift_Left_2 uut (
        .inp(tb_inp),   
        .out(tb_out)    
    );

    initial begin
        
        // In tiêu đề ra console
        $display("--- Bat dau kiem thu Shift_Left_2 ---");
        $display("Thoi gian  | Input (hex)      | Output (hex)     | Mong doi (hex)");
        $display("----------------------------------------------------------------------");

        tb_inp = 32'h0000_0000; 
        #10; // Chờ 10ns
        $display("%8tns | %d | %d | %d", $time, tb_inp, tb_out, 32'h0000_0000);
        tb_inp = 32'h0000_0001; 
        #10; 
        $display("%8tns | %d | %d | %d", $time, tb_inp, tb_out, 32'h0000_0004);

        tb_inp = 32'h0000_000A; 
        #10;
        $display("%8tns | %d | %d | %d", $time, tb_inp, tb_out, 32'h0000_0028);

        tb_inp = 32'h4000_0000; 
        #10;
        $display("%8tns | %d | %d | %d", $time, tb_inp, tb_out, 32'h0000_0000);

        tb_inp = 32'h8000_0000; 
        #10;
        $display("%8tns | %d | %d | %d", $time, tb_inp, tb_out, 32'h0000_0000);

        tb_inp = 32'hFFFF_FFFF; 
        #10;
        $display("%8tns | %h | %h | %h", $time, tb_inp, tb_out, 32'hFFFF_FFFC);

        // Kết thúc mô phỏng
        #10;
        $display("--- Kiem thu hoan tat ---");
        $finish;
    end

endmodule