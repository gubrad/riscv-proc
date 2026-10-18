
module cpu (
    input clk,
);

    reg [31:0] pc;
    wire [31:0]pcp4;

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

    assign pcp4 = pc + 4;


    always @(negedge clk) begin
        pc = pcp4;
    end

    always @(posedge clk) begin
        
    end

endmodule
