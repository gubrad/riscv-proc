
module dmem (input clk, we,
             input [31:0] a, wd,
             input [2:0] f3,
             output [31:0] rd
             );
 
  reg [31:0] RAM[0:127];
 
  assign rd = RAM[a[8:2]]; // word aligned

  initial  $readmemh ("dmem.dat",RAM);
 
  always@(posedge clk)
    if(we) RAM[a[8:2]] <= wd;
 
endmodule
