
module alu (
    input  [31:0] a,
    input  [31:0] b,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [31:0] result,
    input alu,
    output reg trap,
);

    wire sub_or_sra;
    assign sub_or_sra = (funct7 == 7'b0100000);

    always @(*) begin
        result = 32'b0;
        trap = 1'b0;

        if (alu) begin
            case (funct3)
                3'b000: begin
                    if (sub_or_sra)
                        result = a - b;
                    else
                        result = a + b;
                end

                3'b001: result = a << b[4:0];

                3'b010: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;

                3'b011: result = (a < b) ? 32'd1 : 32'd0;

                3'b100: result = a ^ b;

                3'b101: begin
                    if (sub_or_sra)
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
