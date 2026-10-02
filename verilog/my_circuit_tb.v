module test();
  reg a, b, c;
  wire x, y;

  my_circuit my_circuit_XY(a, b, c, x, y);

  initial begin
    $dumpfile("test.vcd");
    $dumpvars;
    a=0;
    b=0;
    c=0;
    #160 $finish;
  end

  always #20 a = ~a;
  always #40 b = ~b;
  always #80 c = ~c;

  always @(x) $display( "The value of x was changed. Time=%d, x=%b. Inputs: a=%b, b=%b, c=%b.",$time, x,a,b,c);

endmodule
