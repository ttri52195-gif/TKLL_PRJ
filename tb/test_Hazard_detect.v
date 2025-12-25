`timescale 1ns/1ps

module Hazard_detect_tb;

    // Inputs
    reg Mem_Read_ID_EX;
    reg [4:0] Rs2_ID_EX, Rs1_IF_ID, Rs2_IF_ID;

    // Output
    wire LU_hazard;

    // Instantiate the DUT
    Hazard_detect uut (
        .Mem_Read_ID_EX(Mem_Read_ID_EX),
        .Rs2_ID_EX(Rs2_ID_EX),
        .Rs1_IF_ID(Rs1_IF_ID),
        .Rs2_IF_ID(Rs2_IF_ID),
        .LU_hazard(LU_hazard)
    );

    // Expected output
    reg expected;

    // === Checker task ===
    task check_output;
        input exp;
        begin
            if (LU_hazard !== exp)
                $display("❌ [FAIL] Time=%0t | LU_hazard=%b (expected %b)", $time, LU_hazard, exp);
            else
                $display("✅ [PASS] Time=%0t | LU_hazard=%b", $time, LU_hazard);
        end
    endtask

    initial begin
        // Dump waveform for GTKWave
        $dumpfile("hazard_detect.vcd");
        $dumpvars(0, Hazard_detect_tb);

        // Default values
        Mem_Read_ID_EX = 0;
        Rs2_ID_EX = 0; Rs1_IF_ID = 0; Rs2_IF_ID = 0;

        #10;

        // === Test 1: Không load → không hazard ===
        Mem_Read_ID_EX = 0;
        Rs2_ID_EX = 5'd2; Rs1_IF_ID = 5'd2; Rs2_IF_ID = 5'd2;
        #1; expected = 0; check_output(expected);
        #9;

        // === Test 2: Load nhưng không trùng thanh ghi → không hazard ===
        Mem_Read_ID_EX = 1;
        Rs2_ID_EX = 5'd5; Rs1_IF_ID = 5'd1; Rs2_IF_ID = 5'd2;
        #1; expected = 0; check_output(expected);
        #9;

        // === Test 3: Load, trùng Rs1 → hazard ===
        Mem_Read_ID_EX = 1;
        Rs2_ID_EX = 5'd3; Rs1_IF_ID = 5'd3; Rs2_IF_ID = 5'd4;
        #1; expected = 1; check_output(expected);
        #9;

        // === Test 4: Load, trùng Rs2 → hazard ===
        Mem_Read_ID_EX = 1;
        Rs2_ID_EX = 5'd7; Rs1_IF_ID = 5'd1; Rs2_IF_ID = 5'd7;
        #1; expected = 1; check_output(expected);
        #9;

        // === Test 5: Load, trùng cả Rs1 và Rs2 → hazard ===
        Mem_Read_ID_EX = 1;
        Rs2_ID_EX = 5'd10; Rs1_IF_ID = 5'd10; Rs2_IF_ID = 5'd10;
        #1; expected = 1; check_output(expected);
        #9;

        // === Test 6: Load, thanh ghi đích là x0 → không hazard (optional) ===
        Mem_Read_ID_EX = 1;
        Rs2_ID_EX = 5'd0; Rs1_IF_ID = 5'd0; Rs2_IF_ID = 5'd0;
        #1; expected = 0; check_output(expected);
        #9;

        $display("✅✅ All tests completed!");
        $finish;
    end
endmodule

