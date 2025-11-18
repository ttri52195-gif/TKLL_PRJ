/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module Sign_extend(
        input  wire [15:0] Imediate_IF_ID,
        output wire [31:0] word
);

        assign word = {{16{Imediate_IF_ID[15]}},Imediate_IF_ID};

endmodule 
