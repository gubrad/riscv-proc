
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
