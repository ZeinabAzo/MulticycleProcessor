module DataMemory_TB;
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [7:0] address;
    reg [7:0] write_data;

    wire [7:0] read_data;

    DataMemory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("DataMemory_Waveform.vcd");
        $dumpvars(0, DataMemory_TB);
        
        $display("--- Starting Data Memory Tests ---");

        // Initialize 
        clk = 0; mem_read = 0; mem_write = 0; address = 0; write_data = 0;
        #10;

        // TEST 1: Write data to address 0x05
        mem_write = 1;
        address = 8'h05;
        write_data = 8'hAA; // Write 1010 1010
        #10;
        
        // Disable write, enable read from address 0x05
        mem_write = 0;
        mem_read = 1;
        #10;
        $display("Test 1 [Read Addr 0x05]: Data = %h (Expected: aa)", read_data);

        // TEST 2: Read from an uninitialized address (should be x or 0 depending on simulator, usually x if not initialized)
        address = 8'h10;
        #10;
        $display("Test 2 [Read Uninitialized Addr 0x10]: Data = %h", read_data);

        // TEST 3: Disable read
        mem_read = 0;
        #10;
        $display("Test 3 [Read Disabled]: Data = %h (Expected: 00)", read_data);

        $display("--- Tests Complete ---");
        $finish;
    end
endmodule
