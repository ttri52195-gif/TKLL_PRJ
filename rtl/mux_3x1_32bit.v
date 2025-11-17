`timescale 1ns / 1ps
module mux_3x1_32bit(
    input [31:0] data1,data2,data0,
    input [1:0] sel,
    output reg [31:0] data_out
    );
 
always @(*) begin 
    case (sel)
        2'b00 : data_out = data0;
        2'b01 : data_out = data1;
        2'b10 : data_out = data2;
        default : data_out = 32'b0;
     endcase
end
endmodule
