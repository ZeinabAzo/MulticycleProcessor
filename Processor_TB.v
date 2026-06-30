module Processor_TB;
    reg clk;
    reg reset;

    
    Processor uut (
        .clk(clk),
        .reset(reset)
    );

    
    always #5 clk = ~clk;

    initial begin
       
        $dumpfile("Processor_Waveform.vcd");
        $dumpvars(0, Processor_TB);
        

        $readmemb("program.txt", uut.rom.rom);
        
    
        uut.ram.ram[5] = 8'd10;
        

        clk = 0;
        reset = 1;
        #12; 
        reset = 0;

      
        $monitor("Time=%0t | PC=%d | IR=%b | State=%d | r1=%d, r2=%d | RAM[6]=%d", 
                 $time, uut.PC, uut.IR, uut.cu.current_state, 
                 uut.rf.registers[1], uut.rf.registers[2], uut.ram.ram[6]);

        
        #150;


        $display("Final Check: Did the processor store 20 in RAM address 6? RAM[6] = %d", uut.ram.ram[6]);
        
        $finish;
    end
endmodule
