/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Branch_Prediction(
    input wire clk,
    input wire rst_n,
    
    input wire [31:0] PC_IF,        // Địa chỉ PC hiện tại đang Fetch
    output wire Predict_Taken,      // 1: Dự đoán rẽ nhánh (Taken), 0: Không (Not Taken)

    // Phần cập nhật (Dùng kết quả từ giai đoạn MEM để học)
    input wire [31:0] PC_MEM,       
    input wire is_Branch_MEM,      
    input wire Actual_Taken        
);

    // Bảng lịch sử rẽ nhánh 
    // Sử dụng 64 entries (2^6), mỗi entry 2 bit.
    reg [1:0] bht [0:63]; 

    integer i;

    wire [5:0] read_index;
    assign read_index = PC_IF[7:2];

    assign Predict_Taken = bht[read_index][1]; 

    wire [5:0] write_index;
    assign write_index = PC_MEM[7:2];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 64; i = i + 1) begin
                bht[i] <= 2'b01;
            end
        end
        else if (is_Branch_MEM) begin
            case (bht[write_index])
                // Strongly Not Taken
                2'b00: begin
                    if (Actual_Taken) bht[write_index] <= 2'b01; // Sai -> Chuyển sang Weakly
                    else              bht[write_index] <= 2'b00; // Đúng -> Giữ nguyên
                end
                
                // Weakly Not Taken
                2'b01: begin
                    if (Actual_Taken) bht[write_index] <= 2'b10; // Sai -> Chuyển sang Weakly Taken
                    else              bht[write_index] <= 2'b00; // Đúng -> Chuyển sang Strongly NT
                end

                // Weakly Taken
                2'b10: begin
                    if (Actual_Taken) bht[write_index] <= 2'b11; // Đúng -> Chuyển sang Strongly Taken
                    else              bht[write_index] <= 2'b01; // Sai -> Chuyển sang Weakly NT
                end

                // Strongly Taken
                2'b11: begin
                    if (Actual_Taken) bht[write_index] <= 2'b11; // Đúng -> Giữ nguyên
                    else              bht[write_index] <= 2'b10; // Sai -> Chuyển sang Weakly
                end
            endcase
        end
    end

endmodule