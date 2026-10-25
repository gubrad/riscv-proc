
module alu (
    input  [31:0] a,
    input  [31:0] b,
    input [2:0] aluctl,
    input alu_sra,
    output reg [31:0] result,
    input alu,
    output reg trap,
);

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

    always @(*) begin
        result = 32'b0;
        trap = 1'b0;

        if (alu) begin
            case (aluctl)
                3'b000: begin
                    if (alu_sra)
                        result = a - b;
                    else
                        result = a + b;
                end

                3'b001: result = a << b[4:0];

                3'b010: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;

                3'b011: result = (a < b) ? 32'd1 : 32'd0;

                3'b100: result = a ^ b;

                3'b101: begin
                    if (alu_sra)
                        result = $signed(a) >>> b[4:0];
                    else
                        result = a >> b[4:0];
                end

                3'b110: result = a | b;
                3'b111: result = a & b;

                default: trap = 1'b1;
            endcase
        end
    end

endmodule
