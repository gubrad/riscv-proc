
module decode (
    input  [31:0] instruction,

    //register control
    output [4:0] rsel1,
    output [4:0] rsel2,
    output [4:0] rdest,

    output reg reg_write,
    
    // mem block control
    output reg mem_write,
    output reg mem_read,

    //result to reg selection
    output reg[1:0] ressel, // ALU MEM PC+4 IMM

    //alu input selection
    output reg[1:0] alusel1, // 0 r1 pc pc4
    output reg[1:0] alusel2, // 0 r2 imm reserved

    //jumps
    output reg branch,
    output reg jalr,
    output reg jump,


    output reg [31:0] imm32,

    output reg alu_enable,
    output reg [2:0] f3,
    output reg [2:0] aluctl,
    output reg [6:0] f7,
    output reg alu_sra
);

    wire[6:0] opcode = instruction[6:0];


    assign rsel1 = instruction[19:15];
    assign rsel2 = instruction[24:20];
    assign rdest = instruction[11:7];
    assign f3 = instruction[14:12];
    assign f7 = instruction[31:25];

    always @(*) begin

        // Default values
        imm32      = 32'b0;

        reg_write  = 1'b0;
        mem_write  = 1'b0;
        mem_read   = 1'b0;

        ressel     = 2'b00;
        alusel1    = 2'b00;
        alusel2    = 2'b00;

        alu_enable = 1'b0;

        branch     = 1'b0;
        jump       = 1'b0;
        jalr       = 1'b0;
        ressel     = 2'b00;

        aluctl = instruction[14:12];
        alu_sra = 1'b0;
        


        case (opcode)
            7'b0110011: begin
                // R-type ALU
                reg_write = 1'b1;
                alusel1 = 2'b01;
                alusel2 = 2'b01;
                ressel = 2'b00;
                alu_enable = 1'b1;
                alu_sra = (f7 == 7'b0100000);
            end

            7'b0010111: begin
                // auipc
                reg_write = 1'b1;
                alusel1 = 2'b10;
                alusel2 = 2'b10;
                imm32[31:12] = instruction[31:12];
                aluctl = 3'b000;
                alu_enable = 1'b1;
            end

            7'b0110111: begin
                // lui
                reg_write = 1'b1;
                imm32[31:12] = instruction[31:12];
                ressel = 2'b11;
            end

            7'b0010011: begin
                // I-type ALU
                reg_write = 1'b1;
                alusel1 = 2'b01;
                alusel2 = 2'b10;
                imm32 = {{20{instruction[31]}}, instruction[31:20]};
                ressel = 2'b00;
                alu_enable = 1'b1;
                alu_sra = (f7 == 7'b0100000);
            end

            7'b0000011: begin
                // load 
                reg_write = 1'b1;
                mem_read = 1'b1;
                alusel1 = 2'b01;
                alusel2 = 2'b10;
                aluctl = 3'b000;
                imm32 = {{20{instruction[31]}}, instruction[31:20]};
                ressel = 2'b01;
                alu_enable = 1'b1;
            end

            7'b0100011: begin
                // store
                mem_write = 1'b1;
                alusel1 = 2'b01;
                alusel2 = 2'b10;
                aluctl = 3'b000;
                imm32 = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
                alu_enable = 1'b1;
            end

            7'b1100011: begin
                // branch
                branch = 1'b1;

                alusel1 = 2'b10;
                alusel2 = 2'b10;

                aluctl = 3'b000; // ADD

                imm32 = {{19{instruction[31]}},
                        instruction[31],
                        instruction[7],
                        instruction[30:25],
                        instruction[11:8],
                        1'b0};

                alu_enable = 1'b1;
            end

            7'b1101111: begin
                // jal
                jump = 1'b1;

                reg_write = 1'b1;

                alusel1 = 2'b10;
                alusel2 = 2'b10;

                aluctl = 3'b000; // ADD

                imm32 = {{11{instruction[31]}},
                        instruction[31],
                        instruction[19:12],
                        instruction[20],
                        instruction[30:21],
                        1'b0};

                ressel = 2'b10;

                alu_enable = 1'b1;
            end

            7'b1100111: begin
                // jalr
                jump = 1'b1;
                jalr = 1'b1;
                reg_write = 1'b1;

                alusel1 = 2'b01;
                alusel2 = 2'b10;

                aluctl = 3'b000; // ADD

                imm32 = {{20{instruction[31]}}, instruction[31:20]};

                ressel = 2'b10;

                alu_enable = 1'b1;
            end

            default: begin
                // unknown
            end
        endcase
    end

endmodule
