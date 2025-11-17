`timescale 1ns / 1ps

module tb_ALU_Control;
reg [1:0] tb_ALUOp;
reg [5:0] tb_funct;
wire [3:0] tb_ALU_Operation;

ALU_Control uut(.ALUOp(tb_ALUOp), .funct(tb_funct), .ALU_Operation(tb_ALU_Operation));
initial begin 
// Bắt đầu mô phỏng, in tiêu đề
        $display("--- Bat dau kiem thu ALU_Control ---");
        $display("Thoi gian | ALUOp | Funct    | Mong doi | Ket qua");
        $display("-----------------------------------------------------");

        // --- Trường hợp 1: LW (ALUOp=00, add) ---
        // 'funct' không quan trọng, ta gán là 0 (hoặc 'X')
        tb_ALUOp = 2'b00;
        tb_funct = 6'b000000;
        #10; // Chờ 10 đơn vị thời gian (10ns)
        $display("%5tns |  %2b   | %6b |  0010    |   %4b   (Test LW)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);

        // --- Trường hợp 2: SW (ALUOp=00, add) ---
        // Tương tự LW, nhưng ta thử 1 giá trị 'funct' khác
        tb_ALUOp = 2'b00;
        tb_funct = 6'b111111; // 'funct' vẫn không quan trọng
        #10; 
        $display("%5tns |  %2b   | %6b |  0010    |   %4b   (Test SW)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);

        // --- Trường hợp 3: Branch (ALUOp=01, subtract) ---
        tb_ALUOp = 2'b01;
        tb_funct = 6'b000000; // 'funct' không quan trọng
        #10;
        $display("%5tns |  %2b   | %6b |  0110    |   %4b   (Test BEQ)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);

        // --- Trường hợp 4: R-type (add) (ALUOp=10) ---
        tb_ALUOp = 2'b10;
        tb_funct = 6'b100000;
        #10;
        $display("%5tns |  %2b   | %6b |  0010    |   %4b   (Test R-add)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);
        
        // --- Trường hợp 5: R-type (subtract) (ALUOp=10) ---
        tb_ALUOp = 2'b10;
        tb_funct = 6'b100010;
        #10;
        $display("%5tns |  %2b   | %6b |  0110    |   %4b   (Test R-sub)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);

        // --- Trường hợp 6: R-type (AND) (ALUOp=10) ---
        tb_ALUOp = 2'b10;
        tb_funct = 6'b100100;
        #10;
        $display("%5tns |  %2b   | %6b |  0000    |   %4b   (Test R-AND)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);
        
        // --- Trường hợp 7: R-type (OR) (ALUOp=10) ---
        tb_ALUOp = 2'b10;
        tb_funct = 6'b100101;
        #10;
        $display("%5tns |  %2b   | %6b |  0001    |   %4b   (Test R-OR)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);
        
        // --- Trường hợp 8: R-type (set on less than) (ALUOp=10) ---
        tb_ALUOp = 2'b10;
        tb_funct = 6'b101010;
        #10;
        $display("%5tns |  %2b   | %6b |  0111    |   %4b   (Test R-slt)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);
        
        // --- Trường hợp 9: R-type không xác định (ALUOp=10) ---
        tb_ALUOp = 2'b10;
        tb_funct = 6'b111111; // Mã funct không có trong bảng
        #10;
        $display("%5tns |  %2b   | %6b |  XXXX    |   %4b   (Test R-default)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);

        // --- Trường hợp 10: ALUOp không xác định ---
        tb_ALUOp = 2'b11; 
        tb_funct = 6'b000000;
        #10;
        $display("%5tns |  %2b   | %6b |  XXXX    |   %4b   (Test ALUOp-default)", $time, tb_ALUOp, tb_funct, tb_ALU_Operation);

        // Kết thúc mô phỏng
        #10;
        $display("--- Kiem thu hoan tat ---");
        $finish; // Lệnh kết thúc mô phỏng
    end
endmodule
