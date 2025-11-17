`timescale 1ns / 1ps
module ALU_Control(
input [1:0] ALUOp,
input [5:0] funct,
output reg [3:0] ALU_Operation 
    );
    
    always @(*) begin 
        ALU_Operation = 4'bXXXX;
        case (ALUOp)
            2'b00: ALU_Operation = 4'b0010; // LW and SW
            2'b01: ALU_Operation = 4'b0110; // beq
            2'b10:
                begin 
                    case (funct)
                        6'b100000: ALU_Operation = 4'b0010; //ADD
                        6'b100010: ALU_Operation = 4'b0110; //SUBTRACT
                        6'b100100: ALU_Operation = 4'b0000; //AND
                        6'b100101: ALU_Operation = 4'b0001; //OR
                        6'b101010: ALU_Operation = 4'b0111; // slt
                        default: ALU_Operation = 4'bXXXX;
                    endcase
                
                end
            default: ALU_Operation = 4'bXXXX;
         endcase
    end
endmodule
