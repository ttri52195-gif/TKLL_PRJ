module test_Inst_mem;
  
reg clk;
reg  [31:0] Pc_out;
wire [31:0] Instruction;

Instruction_mem uut(.*);
initial begin
      $dumpfile("test_Inst_mem.vcd");
      $dumpvars(0,test_Inst_mem);
 
end

      initial

      begin
        clk = 0;    
	forever #5 clk = ~clk;      
      end

      initial begin
       
      Pc_out = -4; 


      for(integer i = 0; i < 404; i = i +4)
       begin
    
	       @(posedge clk);
	       #1 Pc_out = Pc_out + 4;

	       @(posedge clk);
	       #1 $display("Instruction_mem at address%d =  %h",Pc_out,Instruction);  

             

       end	       


      $finish;
      end









endmodule
