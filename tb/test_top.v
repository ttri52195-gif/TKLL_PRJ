`timescale 1ns / 1ns

module Testbench;

    // ============================================================
    // 1. INPUTS & OUTPUTS
    // ============================================================
    reg clk;
    reg rst_n;
    reg [4:0] add_R;

    wire [31:0] addr_M;
    wire [31:0] data_M;
    wire [31:0] data_R;

    // ============================================================
    // 2. VARIABLES FOR VERIFICATION
    // ============================================================
    integer log_file;
    integer cycle_count;
    integer i;
    integer errors;
    
    // Mảng lưu kết quả chuẩn (Golden Reference) đọc từ file text
    reg [31:0] expected_regs [0:31];

    // ============================================================
    // 3. INSTANTIATE THE UNIT UNDER TEST (UUT)
    // ============================================================
    Top uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .add_R(add_R), 
        .addr_M(addr_M), 
        .data_M(data_M), 
        .data_R(data_R)
    );

    // ============================================================
    // 4. CLOCK GENERATION (100MHz)
    // ============================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // ============================================================
    // 5. WAVEFORM DUMPING (Tạo file sóng để xem trên GTKWave)
    // ============================================================
    initial begin
        $dumpfile("test_top.vcd");
        $dumpvars(0, Testbench);
    end

    // ============================================================
    // 6. MAIN SIMULATION FLOW
    // ============================================================
    initial begin
        // --- CẤU HÌNH LOG FILE ---
        log_file = $fopen("simulation_log.txt", "w");
        cycle_count = 0;
        errors = 0;
        add_R = 0; // Mặc định soi thanh ghi $0

        // IN HEADER
        $display("");
        $display("=============================================================");
        $display("       MIPS PIPELINE - GOLDEN MODEL VERIFICATION             ");
        $display("=============================================================");

        // --- BƯỚC 1: NẠP DỮ LIỆU ---
        // Nạp file kết quả chuẩn từ Python
        $readmemh("expected_regs.txt", expected_regs);
        

        // --- BƯỚC 2: RESET HỆ THỐNG ---
        $display("[INFO] System Reset...");
        rst_n = 0;
        #20;            // Giữ reset 20ns
        rst_n = 1;      // Thả reset
        $display("[INFO] Simulation Started.");

        // --- BƯỚC 3: CHẠY SIMULATION ---
        // Chạy 2000ns (200 chu kỳ). Tăng lên nếu chương trình dài.
        #9000; 

        // --- BƯỚC 4: KIỂM TRA TỰ ĐỘNG (AUTO-CHECK) ---
        $display("");
        $display("=============================================================");
        $display("                FINAL RESULT VERIFICATION                    ");
        $display("=============================================================");

        for (i = 0; i < 32; i = i + 1) begin
            
            if (uut.Reg_file_uut.mem[i] !== expected_regs[i]) begin
                
                $display("[ERROR] Register $%0d Mismatch!", i);
                $display("        Expected: %d", expected_regs[i]);
                $display("        Actual  : %d", uut.Reg_file_uut.mem[i]); 
                errors = errors + 1;
                
            end
        end

        // --- BƯỚC 5: KẾT LUẬN ---
        if (errors == 0) begin
            $display("");
            $display("    ********************************************");
            $display("    * [PASS] ALL REGISTERS MATCH GOLDEN MODEL *");
            $display("    ********************************************");
            $display("");
        end else begin
            $display("");
            $display("    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            $display("    x  [FAIL] FOUND %0d ERROR(S)               x", errors);
            $display("    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            $display("");
        end

        // Đóng file log và kết thúc
        $fclose(log_file);
        $finish;
    end

    // ============================================================
    // 7. LOGGING (Ghi trạng thái Pipeline mỗi chu kỳ)
    // ============================================================
    always @(negedge clk) begin
        if (rst_n) begin
            cycle_count = cycle_count + 1;
            
            // Ghi vào file log để debug
            // LƯU Ý: Sửa các đường dẫn (uut.PC_uut...) nếu tên module của bạn khác
            $fdisplay(log_file, "Cycle %0d: PC=%h | Inst=%h | PC_Branch=%h | Taken=%b", 
                cycle_count, 
                uut.PC_uut.Pc_out,       
                uut.Instruction,         
                uut.PC_Branch,           
                uut.Pcsrc                
            );
        end
    end

endmodule