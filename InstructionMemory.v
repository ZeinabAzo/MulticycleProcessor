module InstructionMemory(
    input [11:0] address,      // 2^12 = 4096
    output [18:0] instruction  // 19-bit instruction width
);

    // Array of 4096 words, each 19 bits wide
    reg [18:0] rom [0:4095];

    
    assign instruction = rom[address];

endmodule
