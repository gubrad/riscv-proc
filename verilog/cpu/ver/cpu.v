
module cpu (
    input clk
);

    // =========================
    // Program counter
    // =========================

    reg  [31:0] pc;
    wire [31:0] pc_plus4;
    reg  [31:0] next_pc;

    assign pc_plus4 = pc + 32'd4;

    // =========================
    // Instruction memory
    // =========================

    wire [31:0] instruction;

    imem imem_inst (
        .a  (pc[9:2]),
        .rd (instruction)
    );

    // =========================
    // Decoder
    // =========================

    wire [4:0] rsel1;
    wire [4:0] rsel2;
    wire [4:0] rdest;

    wire reg_write;
    wire mem_write;
    wire mem_read;

    wire [1:0] ressel;
    wire [1:0] alusel1;
    wire [1:0] alusel2;

    wire branch;
    wire jalr;
    wire jump;

    wire [31:0] imm32;

    wire alu_enable;
    wire [2:0] f3;
    wire [2:0] aluctl;
    wire [6:0] f7;
    wire alu_sra;

    wire system;

    decode decode_inst (
        .instruction (instruction),

        .rsel1       (rsel1),
        .rsel2       (rsel2),
        .rdest       (rdest),

        .reg_write   (reg_write),

        .mem_write   (mem_write),
        .mem_read    (mem_read),

        .ressel      (ressel),

        .alusel1     (alusel1),
        .alusel2     (alusel2),

        .branch      (branch),
        .jalr        (jalr),
        .jump        (jump),

        .imm32       (imm32),

        .alu_enable  (alu_enable),
        .f3          (f3),
        .aluctl      (aluctl),
        .f7          (f7),
        .alu_sra     (alu_sra),

        .system      (system)
    );

    // =========================
    // Register file
    // =========================

    wire [31:0] r1_data;
    wire [31:0] r2_data;

    wire [31:0] write_data;

    cpu_reg regfile (
        .clk (clk),

        .a1  (rsel1),
        .a2  (rsel2),
        .a3  (rdest),

        .wd  (write_data),
        .we  (reg_write),

        .d1  (r1_data),
        .d2  (r2_data)
    );

    // =========================
    // ALU input multiplexers
    // =========================

    wire [31:0] alu_a;
    wire [31:0] alu_b;

    assign alu_a =
        (alusel1 == 2'b01) ? r1_data :
        (alusel1 == 2'b10) ? pc      :
        (alusel1 == 2'b11) ? pc_plus4 :
        32'b0;

    assign alu_b =
        (alusel2 == 2'b01) ? r2_data :
        (alusel2 == 2'b10) ? imm32   :
        32'b0;

    // =========================
    // ALU
    // =========================

    wire [31:0] alu_result;
    wire alu_trap;

    alu alu_inst (
        .a       (alu_a),
        .b       (alu_b),
        .aluctl  (aluctl),
        .alu_sra (alu_sra),
        .result  (alu_result),
        .alu     (alu_enable),
        .trap    (alu_trap)
    );

    // =========================
    // Branch comparator
    // =========================

    wire branch_result;

    comparator comparator_inst (
        .r1     (r1_data),
        .r2     (r2_data),
        .f3     (f3),
        .result (branch_result)
    );

    // =========================
    // Data memory
    // =========================

    wire [31:0] mem_data;

    dmem dmem_inst (
        .clk (clk),
        .we  (mem_write),
        .a   (alu_result),
        .wd  (r2_data),
        .f3  (f3),
        .rd  (mem_data)
    );


    reg [31:0] write_data_mux;

    assign write_data = write_data_mux;

    always @(*) begin
        case (ressel)
            2'b00: write_data_mux = alu_result;
            2'b01: write_data_mux = mem_data;
            2'b10: write_data_mux = pc_plus4;
            2'b11: write_data_mux = imm32;

            default: write_data_mux = 32'b0;
        endcase
    end


    always @(*) begin
        if (jump && jalr)
            next_pc = {alu_result[31:1], 1'b0};
        else if (jump)
            next_pc = alu_result;
        else if (branch && branch_result)
            next_pc = alu_result;
        else
            next_pc = pc_plus4;
    end

    initial begin
        pc = 32'b0;
    end

    always @(posedge clk) begin
        pc <= next_pc;
    end

endmodule
