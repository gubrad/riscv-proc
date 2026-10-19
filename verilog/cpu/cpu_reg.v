
module cpu_reg(
    input clk,
    input [4:0] a1, a2, a3,
    input [31:0] wd,
    input we,
    output [31:0] d1, d2);

    reg [31:0] mem[32];

    always @(posedge clk) begin
        if(we) mem[a3] = wd;
        else mem[a3] = mem[a3];
    end;

    initial begin 
        for (i = 0; i < 32; i = i + 1) begin
            mem[i] = 0;
        end
    end

    assign d1 = a1 == 0 ? 0 : mem[a1];
    assign d2 = a2 == 0 ? 0 : mem[a2];

endmodule
