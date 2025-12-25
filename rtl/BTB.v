/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Branch_Target_Buffer(
    input wire clk, rst_n,
    
    // --- READ PORT (Dùng ở giai đoạn IF) ---
    input wire [31:0] PC_IF,        // PC đang nạp lệnh
    output reg [31:0] Predicted_Target, // Địa chỉ đích dự đoán
    output reg Predict_Taken,       // 1: Dự đoán nhảy, 0: Không

    // --- WRITE PORT (Dùng ở giai đoạn MEM để học) ---
    input wire [31:0] PC_Update,    // PC của lệnh Branch vừa thực thi xong (lấy từ MEM)
    input wire [31:0] Actual_Target,// Địa chỉ đích thực tế (tính bởi ALU)
    input wire Actual_Taken,        // Kết quả thực tế: 1=Nhảy, 0=Không
    input wire is_Branch            // Tín hiệu báo đây là lệnh Branch (để cập nhật bảng)
);

    // Cấu trúc bảng: 64 dòng.
    // Bit 58: Valid | 57-34: Tag | 33-2: Target | 1-0: State
    reg [58:0] btb_entry [0:63]; 

    // Khai báo dây và biến
    wire [5:0] read_index;
    wire [23:0] read_tag;
    wire [5:0] write_index;
    wire [23:0] write_tag;
    reg [1:0] state; // Biến tạm
    integer i;       // Biến chạy vòng lặp

    assign read_index = PC_IF[7:2];
    assign read_tag   = PC_IF[31:8];
    
    assign write_index = PC_Update[7:2];
    assign write_tag   = PC_Update[31:8];

    // --- LOGIC ĐỌC (Combinational) ---
    always @(*) begin
        // Kiểm tra Valid=1, Tag khớp, và State là Weakly/Strongly Taken (bit cao = 1)
        if (btb_entry[read_index][58] && 
           (btb_entry[read_index][57:34] == read_tag) && 
            btb_entry[read_index][1]) 
        begin
            Predict_Taken = 1'b1;
            Predicted_Target = btb_entry[read_index][33:2];
        end else begin
            Predict_Taken = 1'b0;
            Predicted_Target = 32'b0;
        end
    end

    // --- LOGIC GHI (Sequential) ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for(i=0; i<64; i=i+1) btb_entry[i] <= 0;
        end
        else if (is_Branch) begin // Chỉ cập nhật khi là lệnh Branch
            // Trường hợp 1: Đã có trong bảng (Match Tag) -> Cập nhật State
            if (btb_entry[write_index][58] && (btb_entry[write_index][57:34] == write_tag)) begin
                state = btb_entry[write_index][1:0];
                if (Actual_Taken) begin
                    if (state != 2'b11) state = state + 1; // Tăng độ tin cậy Taken
                end else begin
                    if (state != 2'b00) state = state - 1; // Giảm độ tin cậy Taken
                end
                // Cập nhật lại dòng đó (Update target mới nhất luôn)
                btb_entry[write_index] <= {1'b1, write_tag, Actual_Target, state};
            end
            // Trường hợp 2: Chưa có nhưng thực tế lại Nhảy -> Thêm mới
            else if (Actual_Taken) begin
                // Khởi tạo trạng thái Weakly Taken (10)
                btb_entry[write_index] <= {1'b1, write_tag, Actual_Target, 2'b10};
            end
        end
    end
endmodule