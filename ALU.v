module ALU (
    input [7:0] in1,
    input [7:0] in2,
    input carry_in,
    input [2:0] alu_control,
    output reg [7:0] result,
    output wire z_flag,
    output reg c_flag
);

    always @(*) begin
        case(alu_control)
            3'b000: {c_flag, result} = in1 + in2;             // ADD
            3'b001: {c_flag, result} = in1 + in2 + carry_in;  // ADDC
            3'b010: {c_flag, result} = in1 - in2;             // SUB
            3'b011: {c_flag, result} = in1 - in2 - carry_in;  // SUBC
            3'b100: begin result = in1 & in2; c_flag = 1'b0; end // AND
            3'b101: begin result = in1 | in2; c_flag = 1'b0; end // OR
            3'b110: begin result = in1 ^ in2; c_flag = 1'b0; end // XOR
            default: {c_flag, result} = 9'b0;
        endcase
    end

    // The Zero flag is 1 when the result is exactly 0
    assign z_flag = (result == 8'b0);

endmodule
