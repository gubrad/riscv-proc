
module imem (input [7:0] a,
             output [31:0] rd);
 
  // The "a" is the address of instruction to fetch, what
  // for our purpose can be taken from ProgramCounter[7:2]
 
  reg [31:0] RAM[0:255];
 
  initial  $readmemh ("memfile.dat",RAM);
 
  assign rd = RAM[a]; // word aligned
 
endmodule

