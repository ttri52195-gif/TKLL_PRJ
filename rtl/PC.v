/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module PC(
       input wire clk, rst_n, 
       input wire LU_hazard, 
       input wire jr, jal, Jump,
       
       // Các tín hiệu điều khiển việc nhảy mới
       input wire Miss_Prediction,       // Có đoán sai không? (Ưu tiên cao nhất)
       input wire [31:0] Correct_Address,// Địa chỉ đúng để sửa sai
       input wire Predict_Taken,         // BTB bảo nhảy không?
       input wire [31:0] Predicted_Target,// Địa chỉ BTB đưa ra
       
       input wire [25:0] target, // Cho lệnh Jump J/JAL
       input wire [31:0] Pc_4,   // PC + 4 hiện tại
       
       output reg [31:0] Pc_out
);
    reg [31:0] r_a;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin 
            Pc_out <= 0;
            r_a <= 0;
        end
        else if(!LU_hazard) begin
            // --- LOGIC CHỌN PC MỚI (Thứ tự ưu tiên rất quan trọng) ---
            
            // 1. Sửa sai dự đoán (Quan trọng nhất: phải quay lại đường đúng ngay)
            if (Miss_Prediction) begin
                Pc_out <= Correct_Address;
            end
            // 2. Lệnh JUMP vô điều kiện (J, JAL) - Được xử lý ở giai đoạn Decode/ID
            // Lưu ý: Logic Jump cũ của bạn lấy Pc_4[31:28] ghép với target
            else if (Jump) begin
                Pc_out <= {Pc_4[31:28], target, 2'b00};
            end
            // 3. Lệnh JR (Nhảy về thanh ghi)
            else if (jr) begin
                Pc_out <= r_a;
            end
            // 4. Dự đoán của BTB (Nếu không có các lệnh trên, tin vào BTB)
            else if (Predict_Taken) begin
                Pc_out <= Predicted_Target;
            end
            // 5. Mặc định: Chạy lệnh kế tiếp
            else begin
                Pc_out <= Pc_4; 
            end

            // Logic lưu Return Address cho JAL
            if(jal) r_a <= Pc_4;
        end
        // Nếu có LU_hazard -> Giữ nguyên PC_out (Stall)
    end
endmodule