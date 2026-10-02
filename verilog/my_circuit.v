

module memory (
	input clk,
	input [31:0] address,
	input [31:0] write_data,
	input write_enable,
	output [31:0] read_data
);

	reg [31:0] mem [0:1023];

	assign read_data = mem[address[11:2]];

	always @(negedge clk) begin
		if (write_enable)
			mem[address[11:2]] <= write_data;
	end

endmodule

module alu (
    input  [31:0] a,
    input  [31:0] b,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [31:0] result,
    input alu,
    output reg trap,
);

    wire f7;
    assign f7 = funct7[5];

    always @(*) begin
        result = 32'b0;
        trap = 0;
        if (alu){
            case (funct3)
                3'b000: begin // add/sub
                    if(f7)
                        result = a - b;
                    else
                        result = a + b;
                end

                3'b001: begin // sll
                    result = a << b;
                end

                3'b010: begin // slt
                    result = ($signed(a) < $signed(b)) ? 1 : 0;
                end

                3'b011: begin // sltu
                    result = (a < b) ? 1 : 0;
                end

                3'b100: begin // xor
                    result = a ^ b;
                end

                3'b101: begin // srl/sra
                    if(f7)
                        result = $signed(a) >>> b;
                    else
                        result = a >> b;
                end

                3'b110: begin // or
                    result = a | b;
                end

                3'b111: begin // and
                    result = a & b;
                end

                default: begin
                    trap = 1;
                end
            endcase
        }

    end

endmodule

module decode (
    input  [31:0] instruction,
    output [4:0] rs1,
    output r1;
    output [4:0] rs2,
    output r2;
    output [4:0] rd,
    output rw;
    output [2:0] funct3,
    output [6:0] funct7,
    output [31:0] imm32,
    output imm;
    output alu;
);
    wire[6:0] opcode = instruction[6:0];

    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];

    always @(*) begin
        imm32 = 32'b0;
        case (opcode)
            7'b0110011: begin
                // R-type
                r1 = 1;
                r2 = 1;
                rw = 1;
                imm = 0;
                alu = 1;
            end
            7'b0110111: begin
                // lui
            end

            7'b0010011: begin
                // I-type ALU
            end

            7'b0000011: begin
                // load
            end

            7'b0100011: begin
                // store
            end

            7'b1100011: begin
                // branch
            end

            default: begin
                // unknown
            end
        endcase
    end

endmodule



module gpr(
	input clk,

	input [4:0] rs1,
	input [4:0] rs2,

    input write_enable,
    input [4:0] rd,
    input [31:0] write_data,

	output [31:0] reg1,
	output [31:0] reg2,
);

    reg [31:0] gpr [0:31];

    assign reg1 = (rs1 == 5'd0) ? {32{1'b0}} : gpr[rs1];
    assign reg2 = (rs2 == 5'd0) ? {32{1'b0}} : gpr[rs2];

    always @(negedge clk) begin
		if (write_enable)
			gpr[rd] <= write_data;
	end

endmodule


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
