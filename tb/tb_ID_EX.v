`timescale 1ns / 1ps

module tb_ID_EX;

    // Khai báo các biến 'reg' để làm tín hiệu đầu vào cho DUT
    reg [4:0]   rs1, rs2, rd;
    reg [5:0]   funct;
    reg [31:0]  word;
    reg [31:0]  read_data1, read_data2;
    reg [31:0]  PC;
    reg [1:0]   ALUOp;
    reg         ALUSrc, Mem_Read, Mem_Write, PcSrc, Mem_to_Reg, Reg_Write, RegDst;
    reg         clk;
    // Tùy chọn: Thêm rst nếu bạn cập nhật module của mình
     reg         rst_n; 

    // Khai báo các biến 'wire' để hứng tín hiệu đầu ra từ DUT
    wire [4:0]  rs1_ID_EX, rs2_ID_EX, rd_ID_EX;
    wire [5:0]  funct_ID_EX;
    wire [31:0] word_ID_EX;
    wire [31:0] read_data1_ID_EX, read_data2_ID_EX;
    wire [31:0] PC_ID_EX;
    wire [1:0]  ALUOp_ID_EX;
    wire        ALUSrc_ID_EX, Mem_Read_ID_EX, Mem_Write_ID_EX, PcSrc_ID_EX, Mem_to_Reg_ID_EX, Reg_Write_ID_EX, RegDst_ID_EX;

    // ====== Instantiate the Device Under Test (DUT) ======
    // (Kết nối các 'reg' và 'wire' của testbench với module ID_EX)
    ID_EX dut (
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .funct(funct),
        .word(word),
        .read_data1(read_data1), .read_data2(read_data2),
        .PC(PC),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc), .Mem_Read(Mem_Read), .Mem_Write(Mem_Write),
        .PcSrc(PcSrc), .Mem_to_Reg(Mem_to_Reg), .Reg_Write(Reg_Write),
        .RegDst(RegDst),
        .clk(clk),
         .rst_n(rst_n), // Bỏ comment này nếu bạn thêm reset
        
        .rs1_ID_EX(rs1_ID_EX), .rs2_ID_EX(rs2_ID_EX), .rd_ID_EX(rd_ID_EX),
        .funct_ID_EX(funct_ID_EX),
        .word_ID_EX(word_ID_EX),
        .read_data1_ID_EX(read_data1_ID_EX), .read_data2_ID_EX(read_data2_ID_EX),
        .PC_ID_EX(PC_ID_EX),
        .ALUOp_ID_EX(ALUOp_ID_EX),
        .ALUSrc_ID_EX(ALUSrc_ID_EX), .Mem_Read_ID_EX(Mem_Read_ID_EX), .Mem_Write_ID_EX(Mem_Write_ID_EX),
        .PcSrc_ID_EX(PcSrc_ID_EX), .Mem_to_Reg_ID_EX(Mem_to_Reg_ID_EX),
        .Reg_Write_ID_EX(Reg_Write_ID_EX), .RegDst_ID_EX(RegDst_ID_EX)
    );

    // ====== Clock Generation ======
    // Tạo xung clock với chu kỳ 10ns (5ns HIGH, 5ns LOW)
    parameter CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // ====== Stimulus (Kịch bản kiểm thử) ======
    initial begin
        // Khởi tạo tất cả giá trị đầu vào
        rs1 = 0; rs2 = 0; rd = 0; funct = 0; word = 0;
        read_data1 = 0; read_data2 = 0; PC = 0; ALUOp = 0;
        ALUSrc = 0; Mem_Read = 0; Mem_Write = 0; PcSrc = 0;
        Mem_to_Reg = 0; Reg_Write = 0; RegDst = 0;
        
        // Tùy chọn: Kích hoạt reset lúc ban đầu
         rst_n = 0;
         #20; // Giữ reset trong 20ns
         rst_n = 1;
         @(posedge clk); // Đợi sườn lên clock đầu tiên sau khi nhả reset
        
        #5; // Đợi 1 chút cho ổn định

        // --- Chu kỳ 1: Gửi một lệnh R-type (ví dụ: add $3, $1, $2) ---
        @(posedge clk); // Đồng bộ với sườn lên của clock
        #1; // Thêm 1 độ trễ nhỏ để tránh "race condition"
        rs1 = 5'd1;
        rs2 = 5'd2;
        rd = 5'd3;
        funct = 6'h20; // 'add'
        read_data1 = 32'd100; // Giá trị $1
        read_data2 = 32'd200; // Giá trị $2
        PC = 32'h00400000;
        ALUOp = 2'b10;
        ALUSrc = 0;
        Mem_Read = 0;
        Mem_Write = 0;
        Reg_Write = 1;
        RegDst = 1;
        
        // --- Chu kỳ 2: Gửi một lệnh I-type (ví dụ: lw $8, 16($1)) ---
        @(posedge clk);
        #1; 
        rs1 = 5'd1;      // rs
        rd = 5'd8;       // rt (thanh ghi đích)
        word = 32'd16;   // immediate
        read_data1 = 32'd1000; // Giá trị $1 (base address)
        PC = 32'h00400004;
        ALUOp = 2'b00;
        ALUSrc = 1;
        Mem_Read = 1;
        Mem_Write = 0;
        Mem_to_Reg = 1;
        Reg_Write = 1;
        RegDst = 0;

        // --- Chu kỳ 3: Gửi một lệnh BEQ (ví dụ: beq $1, $2, label) ---
        @(posedge clk);
        #1; 
        rs1 = 5'd1;
        rs2 = 5'd2;
        word = 32'd4; // 4 * 4 = 16 (branch offset)
        read_data1 = 32'd100;
        read_data2 = 32'd100; // Giả sử 2 giá trị bằng nhau
        PC = 32'h00400008;
        PcSrc = 1; // Tín hiệu này sẽ được kích hoạt ở EX
        Reg_Write = 0;

        // --- Chu kỳ 4: Chờ để xem giá trị ở chu kỳ 3 đi ra ---
        @(posedge clk);
        #1;
        
        // Kết thúc mô phỏng
        #50;
        $finish;
    end
    
    // ====== Monitoring (Giám sát) ======
    // In ra giá trị của các tín hiệu mỗi khi chúng thay đổi
    // (In cả input và output để dễ dàng đối chiếu)
    initial begin
        $monitor("Time=%0t | clk=%b | rs1_in=%d, rs1_out=%d | read1_in=%h, read1_out=%h | RegWrite_in=%b, RegWrite_out=%b",
                 $time, clk, rs1, rs1_ID_EX, read_data1, read_data1_ID_EX, Reg_Write, Reg_Write_ID_EX);
    end

endmodule