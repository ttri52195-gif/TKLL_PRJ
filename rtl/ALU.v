/* verilator lint_off MULTITOP */

`timescale 1ns / 1ns
module ALU(
    input [31:0] oprd1,
    input [31:0] oprd2,
    input [3:0] ALU_Operation,
    output reg zero,
    output reg [31:0] result
 );

always @(*) begin 
    case(ALU_Operation)
        4'b0010: 
            result = oprd1 + oprd2;
        4'b0110:
            result = oprd1 - oprd2;
        4'b0000:
            result = oprd1 & oprd2;
        4'b0001:
            result = oprd1 | oprd2;
        4'b1100:
            result = ~(oprd1 | oprd2);
        4'b1000:
            result = oprd1 ^ oprd2;
        4'b0111:
            begin 
                if ($signed(oprd1) < $signed(oprd2))result = 32'd1;
                else result = 32'd0;
            end
    endcase
    zero = (result == 32'd0);
end

endmodule
