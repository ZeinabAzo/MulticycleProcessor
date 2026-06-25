module ALU_TB;
    reg [7:0] in1;
    reg [7:0] in2;
    reg carry_in;
    reg [2:0] alu_control;

    wire [7:0] result;
    wire z_flag;
    wire c_flag;

    ALU uut (
        .in1(in1),
        .in2(in2),
        .carry_in(carry_in),
        .alu_control(alu_control),
        .result(result),
        .z_flag(z_flag),
        .c_flag(c_flag)
    );

    initial begin
        $dumpfile("ALU_Waveform.vcd");
        $dumpvars(0, ALU_TB);
        
        $display("--- Starting ALU Tests ---");

        // Initialize
        in1 = 0; in2 = 0; carry_in = 0; alu_control = 0;
        #10;

        // Setup waveform dumping
        $dumpfile("ALU_Waveform.vcd");
        $dumpvars(0, ALU_TB);
        
        $display("--- Starting ALU Tests ---");

        // Initialize
        in1 = 0; in2 = 0; carry_in = 0; alu_control = 0;
        #10;

        // TEST 1: Force a Carry-Out
        // 255 + 1 = 256 (requires 9 bits, so Carry should be 1, Result 0)
        in1 = 8'd255;
        in2 = 8'd1;
        carry_in = 1'b0;
        alu_control = 3'b000; // ADD
        #10;
        $display("Test 1 [ADD Overflow]: Result = %d, Carry = %b, Zero = %b (Expected: Res 0, C 1, Z 1)", result, c_flag, z_flag);

        // TEST 2: Force a Zero Flag
        // 50 - 50 = 0
        in1 = 8'd50;
        in2 = 8'd50;
        carry_in = 1'b0;
        alu_control = 3'b010; // SUB
        #10;
        $display("Test 2 [SUB for Zero]: Result = %d, Carry = %b, Zero = %b (Expected: Res 0, C 0, Z 1)", result, c_flag, z_flag);

        // TEST 3: Add with Carry (ADDC)
        // 10 + 10 + 1 (previous carry) = 21
        in1 = 8'd10;
        in2 = 8'd10;
        carry_in = 1'b1;
        alu_control = 3'b001; // ADDC
        #10;
        $display("Test 3 [ADDC]: Result = %d, Carry = %b, Zero = %b (Expected: Res 21, C 0, Z 0)", result, c_flag, z_flag);

        $display("--- Tests Complete ---");
        $finish;
        
        $display("--- Tests Complete ---");
        $finish;
    end
endmodule
