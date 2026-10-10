
module cpu (
    input clk,
);

    reg [31:0] pc;

    wire [4:0] rs1;
    wire use_reg1;
    wire [4:0] rs2;
    wire use_reg2;
    wire [4:0] rd;
    wire reg_write;
    wire pc_write;
    wire mem_write;
    wire mem_read;

    wire alu;

    wire [31:0] reg1;
    wire [31:0] reg2;
    wire [31:0] alu_out;

    wire [31:0] write_data;

    gpr register_file (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .write_enable(rw),
        .rd(rd),
        .write_data(write_data),
        .reg1(reg1),
        .reg2(reg2)
    );

    alu alu_1 (

    );


    always @(negedge clk) begin
        pc <= pc + 4;
    end

    always @(posedge clk) begin
        
    end

endmodule
