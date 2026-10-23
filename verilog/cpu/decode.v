
module decode (
    input  [31:0] instruction,

    //register control
    output [4:0] rsel1,
    output reg r1,
    output [4:0] rsel2,
    output reg r2,
    output [4:0] rdest,
    output reg rwrite,
    
    // mem block control
    output reg mem_write,
    output reg mem_read,

    //dest sel
    output reg[1:0] destsel, // ALU MEM PC+4 IMM

    //in sel
    output reg[1:0] alusel1, // 0 r1 pc+4
    output reg[1:0] alusel2, // 0 r2 imm


    output [2:0] funct3,
    output [6:0] funct7,

    output reg [31:0] imm32,
    output reg imm,
    output reg alu,
);

    wire[6:0] opcode = instruction[6:0];

    assign funct3 = instruction[14:12];
    assign funct7 = instruction[31:25];

    assign rsel1 = instruction[19:15];
    assign rsel2 = instruction[24:20];
    assign rdest = instruction[11:7];

    always @(*) begin

        // Default values prevent inferred latches.
        imm32      = 32'b0;

        reg_write  = 1'b0;
        mem_write  = 1'b0;
        mem_read   = 1'b0;

        alu_src    = 1'b0;
        alu_a_pc   = 1'b0;
        alu_enable = 1'b0;

        result_src = 2'b00;

        branch     = 1'b0;
        jump       = 1'b0;
        jalr       = 1'b0;
        illegal    = 1'b0;

        alu_funct3 = 3'b000;
        alu_funct7 = 7'b0000000;


        case (opcode)
            7'b0110011: begin
                // R-type ALU
                r1 = 1;
                r2 = 1;
                rwrite = 1;
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
