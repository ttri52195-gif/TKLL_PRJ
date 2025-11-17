`timescale 1ns / 1ps
module mux_2x1_32bit(
    input [31:0] data0,data1 ,
    input sel,
    output [31:0] data_out
    );
    
    assign data_out = sel ? data1 : data0;
endmodule