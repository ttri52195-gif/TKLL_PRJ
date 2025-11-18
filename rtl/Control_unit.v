/* verilator lint_off MULTITOP */

`timescale 1ns / 1ps

module Control_unit( 
    input  wire [5:0] Opcode_IF_ID,
    output reg  RegDst, Reg_Write, ALUSrc, PcSrc, Mem_Write, Mem_to_Reg, Mem_Read, Jump,
    output reg [3:0] ALUOp     
);

always@(*) begin
    
    // ---------- DEFAULT ----------
    RegDst     = 0;
    Reg_Write  = 0;
    ALUSrc     = 0;
    PcSrc      = 0;
    Mem_Write  = 0;
    Mem_to_Reg = 0;
    Mem_Read   = 0;
    Jump       = 0;
    ALUOp      = 4'b0000;

    case (Opcode_IF_ID)

        // ---------------- R-type ----------------
        6'b000000: begin
            RegDst     = 1;
            Reg_Write  = 1;
            ALUSrc     = 0;
            ALUOp      = 4'b0010;
       
 


        end
        // ---------------- LW ----------------
        6'b100011: begin
            RegDst     = 0;
            ALUSrc     = 1;
            Mem_to_Reg = 1;
            Reg_Write  = 1;
            Mem_Read   = 1;
            ALUOp      = 4'b0010;
        end
        // ---------------- SW ----------------
        6'b101011: begin
            ALUSrc     = 1;
            Mem_Write  = 1;
            ALUOp      = 4'b0000;
        end
        // ---------------- BEQ ----------------
        6'b000100: begin
            PcSrc      = 1;
            ALUOp      = 4'b0001;
        end

        // ---------------- JUMP ----------------
        6'b000010: begin
            Jump       = 1;
        end

        // ---------------- ADDI ----------------
        6'b001000: begin
            RegDst     = 0;
            Reg_Write  = 1;
            ALUSrc     = 1;
            ALUOp      = 4'b0000;   
        end

        // ---------------- ANDI ----------------
        6'b001100: begin  
            RegDst     = 0;
            Reg_Write  = 1;
            ALUSrc     = 1;
            ALUOp      = 4'b0001;   
        end
   
       
        // ---------------- ORI ----------------
        6'b001101: begin
            RegDst     = 0;
            Reg_Write  = 1;
            ALUSrc     = 1;
            ALUOp      = 4'b0010;
        end

        // ---------------- SLT ----------------
        6'b001110: begin
            RegDst     = 0;
            Reg_Write  = 0;
            ALUSrc     = 0;
            ALUOp      = 4'b0010;
        end
        //----------------SLTI-----------------
         6'b001010 : begin
            RegDst     = 0;
            Reg_Write  = 0;
            ALUSrc     = 1;
            ALUOp      = 4'b0001;
        end
        // ---------------- LUI ----------------
        6'b001111: begin
            RegDst     = 0;
            Reg_Write  = 1;
            ALUSrc     = 1;
            ALUOp      = 4'b0010;
        end
    
        default: begin
            RegDst     = 0;
            Reg_Write  = 0;
            ALUSrc     = 0;
            PcSrc      = 0;
            Mem_Write  = 0;
            Mem_to_Reg = 0;
            Mem_Read   = 0;
            Jump       = 0;
            ALUOp      = 4'b0000;
        end
    endcase
end    

endmodule
