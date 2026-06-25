module InstructionMemory_TB;
    reg [11:0] address;
    wire [18:0] instruction;

    InstructionMemory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $dumpfile("InstMemory_Waveform.vcd");
        $dumpvars(0, InstructionMemory_TB);
        
        $display("--- Starting Instruction Memory Tests ---");

        // Load the compiled machine code into the ROM
        // Make sure program.txt is in your simulation directory!
        $readmemb("program.txt", uut.rom);

        // Read Address 0
        address = 12'd0;
        #10;
        $display("Address 0: %b (Expected: 0000000000000000001)", instruction);

        // Read Address 1
        address = 12'd1;
        #10;
        $display("Address 1: %b (Expected: 0000000000000000010)", instruction);

        // Read Address 3
        address = 12'd3;
        #10;
        $display("Address 3: %b (Expected: 1111111111111111111)", instruction);

        $display("--- Tests Complete ---");
        $finish;
    end
endmodule
