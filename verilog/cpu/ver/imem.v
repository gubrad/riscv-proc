
module imem (input [7:0] a,
             output [31:0] rd);

 
  reg [31:0] RAM[0:255];
 
  initial  $readmemh ("imem.dat",RAM);
 
  assign rd = RAM[a]; // word aligned
 
endmodule

