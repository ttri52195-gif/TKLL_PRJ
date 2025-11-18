`timescale 1ns / 1ps
module ALU_Control(
input [3:0] ALUOp,
input [5:0] funct,
output reg [3:0] ALU_Operation 
    );
    
    always @(*) begin 
        ALU_Operation = 4'bXXXX;
        case (ALUOp)
            4'b0000: ALU_Operation = 4'b0010; // LW and SW
            4'b0001: ALU_Operation = 4'b0110; // beq
            4'b0011: ALU_Operation = 4'b0000; // ANDI
            4'b0100: ALU_Operation = 4'b0001; //ORI
            4'b0101: ALU_Operation = 4'b1000; // XORI
            4'b0010: 
                begin 
                    case (funct)
                        6'b100000: ALU_Operation = 4'b0010; //ADD
                        6'b100010: ALU_Operation = 4'b0110; //SUBTRACT
                        6'b100100: ALU_Operation = 4'b0000; //AND
                        6'b100101: ALU_Operation = 4'b0001; //OR
                        6'b101010: ALU_Operation = 4'b0111; // slt
                        6'b100110: ALU_Operation = 4'b1000; // XOR
                        default: ALU_Operation = 4'bXXXX;
                    endcase
                
                end
            default: ALU_Operation = 4'bXXXX;
         endcase
    end
endmodule
