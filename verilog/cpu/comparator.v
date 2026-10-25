
module comparator (
    input  [31:0] r1, r2,
    input [2:0] f3,
    output reg result,
);

    always @(*) begin
        case (f3)
            3'b000: result = (r1 == r2);                 // BEQ
            3'b001: result = (r1 != r2);                 // BNE
            3'b100: result = ($signed(r1) < $signed(r2)); // BLT
            3'b101: result = ($signed(r1) >= $signed(r2));// BGE
            3'b110: result = (r1 < r2);                  // BLTU
            3'b111: result = (r1 >= r2);                 // BGEU
            default: result = 1'b0;
        endcase
    end

endmodule
