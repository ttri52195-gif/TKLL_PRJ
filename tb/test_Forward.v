`timescale 1ns/1ps

module Forwarding_unit_tb;

    // === Inputs ===
    reg [4:0] Rs1_ID_EX, Rs2_ID_EX, Rd_EX_MEM, Rd_MEM_WB;
    reg Reg_Write_MEM_WB, Reg_Write_EX_MEM;

    // === Outputs ===
    wire [1:0] F1, F2;

    // === DUT Instantiation ===
    Forwarding_unit uut (
        .Rs1_ID_EX(Rs1_ID_EX),
        .Rs2_ID_EX(Rs2_ID_EX),
        .Rd_EX_MEM(Rd_EX_MEM),
        .Rd_MEM_WB(Rd_MEM_WB),
        .Reg_Write_MEM_WB(Reg_Write_MEM_WB),
        .Reg_Write_EX_MEM(Reg_Write_EX_MEM),
        .F1(F1),
        .F2(F2)
    );

    // === Expected values ===
    reg [1:0] expected_F1, expected_F2;

    // === Task: Check output correctness ===
    task check_output;
        input [1:0] exp_F1;
        input [1:0] exp_F2;
        begin
            if (F1 !== exp_F1 || F2 !== exp_F2) begin
                $display(" [FAIL] Time=%0t | F1=%b (exp %b) | F2=%b (exp %b)",
                         $time, F1, exp_F1, F2, exp_F2);
            end else begin
                $display("✅ [PASS] Time=%0t | F1=%b | F2=%b", $time, F1, F2);
            end
        end
    endtask

    initial begin
        // === VCD file generation for GTKWave ===
        $dumpfile("forwarding_unit.vcd");
        $dumpvars(0, Forwarding_unit_tb);

        // Initialize
        Rs1_ID_EX = 0; Rs2_ID_EX = 0;
        Rd_EX_MEM = 0; Rd_MEM_WB = 0;
        Reg_Write_MEM_WB = 0; Reg_Write_EX_MEM = 0;

        #10;

        // === Test 1: No forwarding ===
        Rs1_ID_EX = 5'd1; Rs2_ID_EX = 5'd2;
        Rd_EX_MEM = 5'd3; Rd_MEM_WB = 5'd4;
        Reg_Write_EX_MEM = 0; Reg_Write_MEM_WB = 0;
        #1; expected_F1 = 2'b00; expected_F2 = 2'b00;
        check_output(expected_F1, expected_F2);
        #9;

        // === Test 2: Forward from EX/MEM to Rs1 ===
        Reg_Write_EX_MEM = 1; Reg_Write_MEM_WB = 0;
        Rd_EX_MEM = 5'd1;
        #1; expected_F1 = 2'b10; expected_F2 = 2'b00;
        check_output(expected_F1, expected_F2);
        #9;

        // === Test 3: Forward from MEM/WB to Rs1 ===
        Reg_Write_EX_MEM = 0; Reg_Write_MEM_WB = 1;
        Rd_MEM_WB = 5'd1;
        #1; expected_F1 = 2'b01; expected_F2 = 2'b00;
        check_output(expected_F1, expected_F2);
        #9;

        // === Test 4: Forward from EX/MEM to Rs2 ===
        Reg_Write_EX_MEM = 1; Reg_Write_MEM_WB = 0;
        Rd_EX_MEM = 5'd2;
        #1; expected_F1 = 2'b00; expected_F2 = 2'b10;
        check_output(expected_F1, expected_F2);
        #9;

        // === Test 5: Forward from MEM/WB to Rs2 ===
        Reg_Write_EX_MEM = 0; Reg_Write_MEM_WB = 1;
        Rd_MEM_WB = 5'd2;
        #1; expected_F1 = 2'b00; expected_F2 = 2'b01;
        check_output(expected_F1, expected_F2);
        #9;

        // === Test 6: Both EX/MEM and MEM/WB active, same Rd ===
        Reg_Write_EX_MEM = 1; Reg_Write_MEM_WB = 1;
        Rs1_ID_EX = 5'd3; Rs2_ID_EX = 5'd3;
        Rd_EX_MEM = 5'd3; Rd_MEM_WB = 5'd3;
        #1; expected_F1 = 2'b10; expected_F2 = 2'b10; // EX/MEM takes priority
        check_output(expected_F1, expected_F2);
        #9;

        $display("All tests completed!");
        $finish;
    end

endmodule

