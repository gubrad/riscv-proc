
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

// bne beq j

    always @(*) begin
        imm32 = 32'b0;
        case (opcode)
            7'b0110011: begin
                // R-type ALU
                r1 = 1;
                r2 = 1;
                rw = 1;
                imm = 0;
                alu = 1;
            end

            7'b0010111: begin
                // auipc
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

            7'b1101111: begin
                // jal
            end

            7'b1100111: begin
                // jalr
            end

            default: begin
                // unknown
            end
        endcase
    end

endmodule
