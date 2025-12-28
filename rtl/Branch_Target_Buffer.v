/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Branch_Target_Buffer(
    input wire clk, rst_n,
    
    // --- READ PORT (Dùng ở giai đoạn IF) ---
    /* verilator lint_off UNUSED */
    input wire [31:0] PC_IF,            // PC đang nạp lệnh
    output reg [31:0] Predicted_Target, // Địa chỉ đích dự đoán
    output reg Predict_Taken,           // 1: Dự đoán nhảy, 0: Không

    // --- WRITE PORT (Dùng ở giai đoạn MEM để học) ---
    input wire [31:0] PC_Update,        // PC của lệnh branch cần cập nhật
    input wire [31:0] Actual_Target,    // Địa chỉ đích thực tế
    input wire Actual_Taken,            // Kết quả thực tế: 1=Nhảy, 0=Không
    input wire is_Branch                // Tín hiệu báo đây là lệnh Branch
);

    // ================================================
    // BTB Entry Format (58 bits total):
    // ================================================
    // Bit 57:     Valid (1 bit)
    // Bit 56-33:  Tag (24 bits) 
    // Bit 32-3:   Target Address (30 bits, word-aligned, bits [31:2])
    // Bit 2-1:    2-bit Saturating Counter State
    // Bit 0:      Unused
    //
    // 2-bit Counter States:
    //   00: Strongly Not Taken
    //   01: Weakly Not Taken
    //   10: Weakly Taken       } Predict TAKEN when bit[2]=1
    //   11: Strongly Taken     }
    // ================================================
    
    reg [57:0] btb_entry [0:63];  // 64-entry direct-mapped BTB

    // Indexing and Tagging
    wire [5:0] read_index;
    wire [23:0] read_tag;
    wire [5:0] write_index;
    wire [23:0] write_tag;
    
    // Temporary variables
    reg [1:0] current_state;
    reg [1:0] next_state;
    integer i;

    // Extract index and tag from PC
    assign read_index  = PC_IF[7:2];        // 6 bits for 64 entries
    assign read_tag    = PC_IF[31:8];       // 24 bits tag
    assign write_index = PC_Update[7:2];
    assign write_tag   = PC_Update[31:8];

    // ================================================
    // PREDICTION LOGIC (Combinational)
    // ================================================
    always @(*) begin
        // Check: Valid=1, Tag matches, and State indicates Taken (bit[2]=1)
        if (btb_entry[read_index][57] &&                    // Valid bit
            btb_entry[read_index][56:33] == read_tag &&     // Tag match
            btb_entry[read_index][2]) begin                 // State[2]=1 means Taken
            
            Predict_Taken = 1'b1;
            Predicted_Target = {btb_entry[read_index][32:3], 2'b00};
        end else begin
            Predict_Taken = 1'b0;
            Predicted_Target = 32'b0;
        end
    end

    // ================================================
    // UPDATE LOGIC (Sequential)
    // ================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset: Invalidate all entries
            for (i = 0; i < 64; i = i + 1) begin
                btb_entry[i] <= 58'b0;
            end
        end
        else if (is_Branch) begin
            // Read current state (using blocking assignment for immediate effect)
            current_state = btb_entry[write_index][2:1];
            
            // Case 1: Entry exists (Valid=1 and Tag matches)
            if (btb_entry[write_index][57] && 
                btb_entry[write_index][56:33] == write_tag) begin
                
                // Update 2-bit saturating counter
                if (Actual_Taken) begin
                    // Taken: Increment state (saturate at 11)
                    if (current_state != 2'b11)
                        next_state = current_state + 2'b01;
                    else
                        next_state = 2'b11;
                end else begin
                    // Not Taken: Decrement state (saturate at 00)
                    if (current_state != 2'b00)
                        next_state = current_state - 2'b01;
                    else
                        next_state = 2'b00;
                end
                
                // Write back updated entry (update both target and state)
                // Format: Valid(1) | Tag(24) | Target[31:2](30) | State(2) | Unused(1) = 58 bits
                btb_entry[write_index] <= {1'b1,                    // Valid (1 bit)
                                           write_tag,               // Tag (24 bits)
                                           Actual_Target[31:2],     // Target (30 bits)
                                           next_state,              // Updated state (2 bits)
                                           1'b0};                   // Unused (1 bit)
            end
            
            // Case 2: Entry doesn't exist, but branch was actually taken
            //         (Only allocate entry when branch is taken)
            else if (Actual_Taken) begin
                // Allocate new entry with Weakly Taken state (10)
                btb_entry[write_index] <= {1'b1,                    // Valid (1 bit)
                                           write_tag,               // Tag (24 bits)
                                           Actual_Target[31:2],     // Target (30 bits)
                                           2'b10,                   // Weakly Taken (2 bits)
                                           1'b0};                   // Unused (1 bit)
            end
            
            // Case 3: Entry doesn't exist and branch not taken
        end
    end

endmodule
