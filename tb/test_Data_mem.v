module test_data_mem;

reg clk ,Mem_read,Mem_write, rst_n;
reg [31:0] addr, write_data;
wire [31:0] write_back;

 Data_mem uut(.*);
 initial begin
      $dumpfile("test_data_mem.vcd");
      $dumpvars(0,test_data_mem);
 end
 initial begin
      
	 clk = 0;
	 forever #5 clk = ~clk;
 end

 initial begin

	 Mem_read  = 0;
	 Mem_write = 0;
	 addr      = 0;
	 write_data = 0;
         rst_n     = 1;
 
	@(posedge clk);
	  #1 Mem_read = 1;

        for(integer i = 0; i < 28; i = i+4)
	begin
          #1 addr = i;

	  #1 $display("Mem_read %h",write_back);
        end

          $finish;

 end
 endmodule