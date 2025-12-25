module test_Control_unit_v;

reg [5:0] Opcode;

wire    Reg_dst;
wire    Reg_write; 
wire    Alu_src;    
wire    Branch;    
wire    Mem_write;
wire    Mem_to_reg;
wire    Mem_read;   
wire    Jump;       
wire    [1:0] Alu_op;

Control_unit uut(
    .Opcode(Opcode),
    .Reg_dst(Reg_dst),
    .Reg_write(Reg_write),
    .Alu_src(Alu_src),
    .Branch(Branch),
    .Mem_write(Mem_write),
    .Mem_to_reg(Mem_to_reg),
    .Mem_read(Mem_read),
    .Jump(Jump),
    .Alu_op(Alu_op)
);

initial begin
    $display("Test with Opcode Instruction ");

    #5 Opcode = 6'b000000;
    #1 checker(10'b1_1_0_0_0_0_0_0_10);

    #5 Opcode = 6'b100011;
    #1 checker(10'b0_1_1_0_0_1_1_0_10);

    #5 Opcode = 6'b101011;
    #1 checker(10'b0_0_1_0_1_0_0_0_00);

    #5 Opcode = 6'b000100;
    #1 checker(10'b0_0_0_1_0_0_0_0_01);

    #5 Opcode = 6'b000010;
    #1 checker(10'b0_0_0_0_0_0_0_1_00);

    $finish;
end

task checker;
    input [9:0] expected;
begin
    if(   Reg_dst      == expected[9] &&
          Reg_write    == expected[8] &&
          Alu_src      == expected[7] &&
          Branch       == expected[6] &&
          Mem_write    == expected[5] &&
          Mem_to_reg   == expected[4] &&
          Mem_read     == expected[3] &&
          Jump         == expected[2] &&
          Alu_op       == expected[1:0] 
    ) begin
       $display("Test Passed");
    end else begin
       $display("Test Failed");
    end
end
endtask

endmodule
