/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Sign_extend(
        input  wire [15:0] Imediate_IF_ID,
        input  wire Extend_sel,
        output wire [31:0] word
);
 
        assign word = Extend_sel ? {{16{Imediate_IF_ID[15]}},Imediate_IF_ID}:{16'h0000,Imediate_IF_ID} ;

endmodule 
