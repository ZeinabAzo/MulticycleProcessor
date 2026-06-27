module ControlUnit_TB;
    reg clk;
    reg reset;
    reg [18:0] instruction;
    reg z_flag;
    reg c_flag;

    wire PCWrite, IRWrite, RegWrite, MemRead, MemWrite;
    wire [2:0] ALUControl;
    wire ALUSrc, MemToReg, PCSource;

    ControlUnit uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .z_flag(z_flag),
        .c_flag(c_flag),
        .PCWrite(PCWrite),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .PCSource(PCSource)
    );

    always #5 clk = ~clk;

    initial begin
        // Setup waveform dumping
        $dumpfile("ControlUnit_Waveform.vcd");
        $dumpvars(0, ControlUnit_TB);
        
                
        $monitor("Time=%0t | State=%d | Inst=%b | PCWr=%b IRWr=%b RegWr=%b MemRd=%b MemWr=%b | ALUSrc=%b MemToReg=%b PCSrc=%b", 
                 $time, uut.current_state, instruction[18:14], PCWrite, IRWrite, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, PCSource);

        $display("--- SYSTEM RESET ---");
        clk = 0; reset = 1; instruction = 19'b0; z_flag = 0; c_flag = 0;
        #12; // Hold reset for a bit
        reset = 0;
        
        
        $display("\n--- TEST 1: ALU Reg-Reg (ADD) ---");
        instruction = 19'b00_000_00000000000000;
        
        #40; 

        
        $display("\n--- TEST 2: Memory Load (LDM) ---");
        instruction = 19'b100_01_00000000000000;
        

        #50;


        $display("\n--- TEST 3: Branch on Zero (BZ) - Condition TRUE ---");
        instruction = 19'b101_00_00000000000000;
        z_flag = 1; // Force the Zero flag ON so the branch is taken
        

        #30;

  
        $display("\n--- TEST 4: Branch on Zero (BZ) - Condition FALSE ---");
        // Same instruction, but we turn the Z flag OFF. 
        // It should NOT assert PCWrite or PCSource in the Execute state.
        instruction = 19'b101_00_00000000000000;
        z_flag = 0; 
        
        #30;

        $display("\n--- Control Unit Testing Complete ---");
        $finish;
    end
endmodule
