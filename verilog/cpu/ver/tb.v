

module tb;

    reg clk = 0;

    cpu dut (
        .clk(clk)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb);

        begin : simulation_loop
            repeat (10000) begin
                @(posedge clk);
                #1;

                $display(
                    "PC=%08h instruction=%08h",
                    dut.pc,
                    dut.instruction
                );

                if (dut.system) begin
                    $display("System instruction at PC = %08h", dut.pc);
                    disable simulation_loop;
                end
            end
        end

        $display("\n--- CPU state ---");
        $display("x1  = %08h", dut.regfile.mem[1]);
        $display("x2  = %08h", dut.regfile.mem[2]);
        $display("x3  = %08h", dut.regfile.mem[3]);
        $display("x4  = %08h", dut.regfile.mem[4]);
        $display("x5  = %08h", dut.regfile.mem[5]);
        $display("x6  = %08h", dut.regfile.mem[6]);
        $display("x7  = %08h", dut.regfile.mem[7]);
        $display("x8  = %08h", dut.regfile.mem[8]);
        $display("x9  = %08h", dut.regfile.mem[9]);
        $display("x10 = %08h", dut.regfile.mem[10]);
        $display("x11 = %08h", dut.regfile.mem[11]);
        $display("x12 = %08h", dut.regfile.mem[12]);
        $display("x13 = %08h", dut.regfile.mem[13]);
        $display("x14 = %08h", dut.regfile.mem[14]);
        $display("x15 = %08h", dut.regfile.mem[15]);
        $display("x16 = %08h", dut.regfile.mem[16]);
        $display("x17 = %08h", dut.regfile.mem[17]);
        $display("x18 = %08h", dut.regfile.mem[18]);
        $display("x19 = %08h", dut.regfile.mem[19]);
        $display("x20 = %08h", dut.regfile.mem[20]);
        $display("x21 = %08h", dut.regfile.mem[21]);
        $display("x22 = %08h", dut.regfile.mem[22]);
        $display("x23 = %08h", dut.regfile.mem[23]);
        $display("x24 = %08h", dut.regfile.mem[24]);
        $display("x25 = %08h", dut.regfile.mem[25]);
        $display("x26 = %08h", dut.regfile.mem[26]);
        $display("x25 = %08h", dut.regfile.mem[25]);
        $display("x27 = %08h", dut.regfile.mem[27]);
        $display("x28 = %08h", dut.regfile.mem[28]);
        $display("x29 = %08h", dut.regfile.mem[29]);
        $display("x30 = %08h", dut.regfile.mem[30]);
        $display("x31 = %08h", dut.regfile.mem[31]);

        $finish;
    end

endmodule

