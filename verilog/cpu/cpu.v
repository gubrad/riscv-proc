
module cpu (
    input clk,
);

    reg [31:0] pc;
    wire [31:0]pcp4;

    wire [4:0] r1;
    wire [4:0] r2;
    wire [4:0] rd;
    wire reg_write;
    wire [31:0]pc_write;
    wire mem_write;
    wire mem_read;

    wire alu;

    wire [31:0] r1;
    wire [31:0] r2;
    wire [31:0] alu_out;

    wire [31:0] write_data;

    assign pcp4 = pc + 4;

    assign 

    always @(posedge clk) begin
        pc = pcp4;
    end

    always @(posedge clk) begin
        
    end

    always @(*) begin
        if (jump && jalr)
            next_pc = {alu_result[31:1], 1'b0};
        else if (jump)
            next_pc = alu_result;
        else if (branch && branch_result)
            next_pc = alu_result;
        else
            next_pc = pc + 32'd4;
    end

endmodule
