/* verilator lint_off MULTITOP */
`timescale 1ns / 1ns

module Instruction_mem(
       input wire clk,rst_n,Pcsrc,
       input wire [31:0] Pc_out,
       output reg  [31:0] Instruction
);
  reg [31:0] mem [0:1023];

initial begin
         $readmemh("program.hex",mem);

end

  always@(posedge clk or negedge rst_n) begin

      if(!rst_n || Pcsrc) begin
        /* verilator lint_off UNUSEDLOOP */
        
         Instruction <= 0; 
      end
   
    else  Instruction <= mem[Pc_out>>2];

     end
endmodule
