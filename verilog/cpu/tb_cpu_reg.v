`timescale 1ns/1ps

module tb_cpu_reg;

    reg clk;
    reg [4:0] a1, a2, a3;
    reg [31:0] wd;
    reg we;

    wire [31:0] d1, d2;

    // Instantiate the CPU register file
    cpu_reg uut (
        .clk(clk),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .wd(wd),
        .we(we),
        .d1(d1),
        .d2(d2)
    );

    // Clock: 20 ns period
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Waveform dump
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, tb_cpu_reg);
    end

    // Test registers
    initial begin
        // Initialize inputs
        a1 = 0;
        a2 = 0;
        a3 = 0;
        wd = 0;
        we = 0;

        // Wait for initialization
        #20;

        // Write 100 to register 1
        a3 = 1;
        wd = 32'd100;
        we = 1;
        #20;

        // Write 200 to register 2
        a3 = 2;
        wd = 32'd200;
        we = 1;
        #20;

        // Disable writing and read registers 1 and 2
        we = 0;
        a1 = 1;
        a2 = 2;
        #10;

        $display("Register 1 = %d", d1);
        $display("Register 2 = %d", d2);

        // Write 300 to register 3
        a3 = 3;
        wd = 32'd300;
        we = 1;
        #20;

        // Read registers 2 and 3
        we = 0;
        a1 = 2;
        a2 = 3;
        #10;

        $display("Register 2 = %d", d1);
        $display("Register 3 = %d", d2);

        // End simulation
        #20;
        $finish;
    end

endmodule

