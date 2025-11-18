/* verilator lint_off MULTITOP */
`timescale 1ns / 1ps

module PC(
       input wire clk,rst_n,jr,jal,Jump,
       input wire Pcsrc, LU_hazard,
       input wire [25:0] target,
       input wire [31:0] PC_Branch_EX_MEM, Pc_4,
       output reg [31:0] Pc_out
);
     reg [31:0] r_a;
     always@(posedge clk or negedge rst_n)
      begin

	      if(!rst_n) Pc_out <= 0;

	      else if(!LU_hazard) begin

             Pc_out <= Jump ? {Pc_4[31:28],target,2'b00} :(Pcsrc ? PC_Branch_EX_MEM : Pc_4); 

             if(jal) begin
              r_a <= Pc_4;
             end  
             else if(jr) begin              
             Pc_out <= r_a;

             end
             end
      end
endmodule
