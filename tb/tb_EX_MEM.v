`timescale 1ns / 1ps

module tb_EX_MEM;

    // ====== 1. Khai báo 'reg' cho các Inputs của DUT ======
    reg         Mem_Read_ID_EX, Mem_Write_ID_EX, PcSrc_ID_EX;
    reg         Mem_to_Reg_ID_EX, Reg_Write_ID_EX;
    reg [31:0]  PC_Branch;
    reg         zero;
    reg [31:0]  result;
    reg [31:0]  Write_Data;
    reg [4:0]   rd_ID_EX;
    reg         clk;
    reg         rst_n;

    // ====== 2. Khai báo 'wire' cho các Outputs của DUT ======
    wire        Mem_Read_EX_MEM, Mem_Write_EX_MEM, PcSrc_EX_MEM;
    wire        Mem_to_Reg_EX_MEM, Reg_Write_EX_MEM;
    wire [31:0] PC_Branch_EX_MEM;
    wire        zero_EX_MEM;
    wire [31:0] result_EX_MEM;
    wire [31:0] Write_Data_EX_MEM;
    wire [4:0]  rd_EX_MEM;

    // ====== 3. Khởi tạo (Instantiate) Module cần test (DUT) ======
    EX_MEM dut (
        // Inputs
        .Mem_Read_ID_EX(Mem_Read_ID_EX),
        .Mem_Write_ID_EX(Mem_Write_ID_EX),
        .PcSrc_ID_EX(PcSrc_ID_EX),
        .Mem_to_Reg_ID_EX(Mem_to_Reg_ID_EX),
        .Reg_Write_ID_EX(Reg_Write_ID_EX),
        .PC_Branch(PC_Branch),
        .zero(zero),
        .result(result),
        .Write_Data(Write_Data),
        .rd_ID_EX(rd_ID_EX),
        .clk(clk),
        .rst_n(rst_n),

        // Outputs
        .Mem_Read_EX_MEM(Mem_Read_EX_MEM),
        .Mem_Write_EX_MEM(Mem_Write_EX_MEM),
        .PcSrc_EX_MEM(PcSrc_EX_MEM),
        .Mem_to_Reg_EX_MEM(Mem_to_Reg_EX_MEM),
        .Reg_Write_EX_MEM(Reg_Write_EX_MEM),
        .PC_Branch_EX_MEM(PC_Branch_EX_MEM),
        .zero_EX_MEM(zero_EX_MEM),
        .result_EX_MEM(result_EX_MEM),
        .Write_Data_EX_MEM(Write_Data_EX_MEM),
        .rd_EX_MEM(rd_EX_MEM)
    );

    // ====== 4. Tạo Clock ======
    // Tạo clock có chu kỳ 10ns
    parameter CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    // ====== 5. Kịch bản kiểm thử (Stimulus) ======
    initial begin
        $display("--- Bat Dau Testbench cho EX_MEM ---");

        // --- Kịch bản 1: Kiểm tra Reset (rst_n = 0) ---
        $display("Kich ban 1: Kiem tra Reset (active-low)");
        rst_n = 0; // Kích hoạt reset
        
        // Gán giá trị rác (non-zero) cho inputs để đảm bảo reset có hiệu lực
        Mem_Read_ID_EX   = 1'b1;
        Mem_Write_ID_EX  = 1'b1;
        Reg_Write_ID_EX  = 1'b1;
        result           = 32'hAAAAAAAA;
        rd_ID_EX         = 5'd31;
        
        # (CLK_PERIOD * 2); // Giữ reset trong 2 chu kỳ clock

        // --- Kịch bản 2: Nhả Reset và kiểm tra hoạt động bình thường ---
        $display("Kich ban 2: Nha Reset, gui du lieu lenh R-type");
        rst_n = 1; // Nhả reset (mức cao)
        
        // Chờ sườn lên clock đầu tiên sau khi nhả reset
        @(posedge clk);
        // Đợi 1ns để giá trị ổn định (tránh race condition)

        // Gửi dữ liệu chu kỳ 1 (ví dụ: lệnh R-Type: add $10, ...)
        Mem_Read_ID_EX   = 1'b0;
        Mem_Write_ID_EX  = 1'b0;
        PcSrc_ID_EX      = 1'b0;
        Mem_to_Reg_ID_EX = 1'b0; // ALU result to reg
        Reg_Write_ID_EX  = 1'b1;
        PC_Branch        = 32'h00400004;
        zero             = 1'b0;
        result           = 32'hDEADBEEF; // ALU result
        Write_Data       = 32'hxxxxxxxx;
        rd_ID_EX         = 5'd10;

        // Chờ sườn lên clock tiếp theo. Tại đây, DUT sẽ "chụp" data ở trên.
        @(posedge clk);
        
        $display("Time=%0t: Output phai la du lieu R-type (result=...DEADBEEF)", $time);

        // Gửi dữ liệu chu kỳ 2 (ví dụ: lệnh 'lw' $11, ...)
        Mem_Read_ID_EX   = 1'b1; // Bật Mem_Read
        Mem_Write_ID_EX  = 1'b0;
        Reg_Write_ID_EX  = 1'b1;
        Mem_to_Reg_ID_EX = 1'b1; // Memory data to reg
        result           = 32'hCAFE0000; // ALU result (address)
        Write_Data       = 32'h11111111; // Data từ rs2 (không dùng)
        rd_ID_EX         = 5'd11;

        // Chờ sườn lên clock tiếp theo.
        @(posedge clk);
        
        $display("Time=%0t: Output phai la du lieu 'lw' (result=...CAFE0000)", $time);

        // Gửi dữ liệu chu kỳ 3 (ví dụ: lệnh 'beq', branch taken)
        Mem_Read_ID_EX   = 1'b0;
        Mem_Write_ID_EX  = 1'b0;
        Reg_Write_ID_EX  = 1'b0; // Không ghi
        PcSrc_ID_EX      = 1'b1; // Chọn PC Branch
        zero             = 1'b1; // zero = 1
        PC_Branch        = 32'h00400020; // Branch target
        
        @(posedge clk);
        
        $display("Time=%0t: Output phai la du lieu 'beq' (zero=1, PcSrc=1)", $time);

        // Chờ xem giá trị cuối cùng
        @(posedge clk);
        
        
        // Kết thúc mô phỏng
        #50;
        $display("--- Ket thuc Testbench ---");
        $finish;
    end

    // ====== 6. Giám sát (Monitor) ======
    // In ra giá trị của các tín hiệu quan trọng mỗi khi chúng thay đổi
    initial begin
        $monitor("Time=%0t | clk=%b | rst_n=%b | RegWrite_in=%b, RegWrite_out=%b | result_in=%h, result_out=%h | rd_in=%d, rd_out=%d",
                 $time, clk, rst_n, 
                 Reg_Write_ID_EX, Reg_Write_EX_MEM,
                 result, result_EX_MEM,
                 rd_ID_EX, rd_EX_MEM);
    end

endmodule