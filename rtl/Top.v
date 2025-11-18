`timescale 1ns / 1ps
/* verilator lint_off MULTITOP */
module Top(

  input wire clk, rst_n,
   /* verilator lint_off UNDRIVEN */
  output wire [31:0] addr_M,read_data_M,add_R,data_R
);
    wire jr,jal;
    wire [31:0] PC_Branch;
    wire [31:0] PC_Branch_EX_MEM, Pc_4;
    wire [31:0] Pc_out,Instruction;
    wire LU_hazard;
    wire [25:0] target;

    wire  [5:0]  Opcode_IF_ID;
    wire  [31:0] Pc_4_IF_ID;
    wire [4:0] rs1_IF_ID,rs2_IF_ID,rd_IF_ID;
    wire [5:0] funct_IF_ID;

    wire [31:0] Write_Data;
    wire Reg_Write_MEM_WB;



	  wire  [31:0] read_data1, read_data2;

    wire  RegDst, Reg_Write, ALUSrc, PcSrc, Mem_Write, Mem_to_Reg, Mem_Read, Jump;
    wire [3:0] ALUOp;  
    wire [15:0] Imediate_IF_ID;
    wire [31:0] word;

wire [4:0] rs1_ID_EX,rs2_ID_EX,rd_ID_EX;
wire [4:0] rd_ID_EX_mux;
wire [5:0] funct_ID_EX;
wire [31:0] word_ID_EX;
wire [31:0] read_data1_ID_EX, read_data2_ID_EX;
wire [31:0] PC_ID_EX;
wire [3:0] ALUOp_ID_EX;
wire ALUSrc_ID_EX,Mem_Read_ID_EX,Mem_Write_ID_EX,PcSrc_ID_EX,Mem_to_Reg_ID_EX,Reg_Write_ID_EX,RegDst_ID_EX;
wire [1:0] F1,F2;
wire [4:0] rd_EX_MEM,rd_MEM_WB;
wire [3:0] ALU_Operation;
wire Pcsrc;
wire zero;
wire [31:0] result;

wire Mem_Read_EX_MEM,Mem_Write_EX_MEM,PcSrc_EX_MEM;
wire Mem_to_Reg_EX_MEM,Reg_Write_EX_MEM;
wire zero_EX_MEM;
wire [31:0] result_EX_MEM;
wire [31:0] Write_Data_EX_MEM;
wire Mem_to_Reg_MEM_WB;
wire [31:0] Read_Data_MEM_WB,Result_MEM_WB;
wire [31:0] Read_Data;
wire [31:0] oprd1,oprd2;
wire [31:0] out_shift;
wire [31:0] out_mux_f2;
    PC PC_uut (.*);
    ALU_Pc ALU_pc_uut(.*);
    Instruction_mem Instruction_mem_uut(.*);
    IF_ID IF_ID_uut(.*);
    Reg_file Reg_file_uut(.*);
    Control_unit Control_unit_uut(.*);
    Sign_extend   Sign_extend_uut(.*);
    ID_EX       ID_EX_uut(.*);
    Forwarding_unit Forwarding_unit_uut(.*);
    ALU_Control ALU_Control_uut(.ALUOp(ALUOp_ID_EX),.funct(funct_ID_EX),.ALU_Operation(ALU_Operation));
    ALU ALU_uut(.*);
    EX_MEM EX_MEM_uut(.*);
  
     MEM_WB MEM_WB_uut(.*);
     Data_mem Data_mem_uut(.*);
     mux_WB mux_WB_uut(.*);
     Hazard_detect Hazard_detect_uut(.*);
     mux_3x1_32bit mux_3x1_32bit_A_uut(.data0(read_data1_ID_EX),.data1(Write_Data),.data2(result_EX_MEM),.sel(F1),.data_out(oprd1));
     mux_3x1_32bit mux_3x1_32bit_B_uut(.data0(read_data2_ID_EX),.data1(Write_Data),.data2(result_EX_MEM),.sel(F2),.data_out(out_mux_f2));
     Enable_Branch Enable_Branch_uut(.zero_EX_MEM(zero_EX_MEM),.PC_Branch_EX_MEM(PcSrc_EX_MEM),.Pcsrc(Pcsrc));
     Shift_Left_2 Shift_Left_2_uut(.inp(word_ID_EX),.out(out_shift));
     adder_32bit adder_32bit_uut(.a(PC_ID_EX),.b(out_shift),.sum(PC_Branch));
     
     assign oprd2 = ALUSrc_ID_EX ? out_mux_f2 : word_ID_EX;
     assign rd_ID_EX_mux = RegDst_ID_EX ? rd_ID_EX : rs2_ID_EX;
     



endmodule
