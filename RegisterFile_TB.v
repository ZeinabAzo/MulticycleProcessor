module RegisterFile_TB;
    reg clk;
    reg reg_write_en;
    reg [2:0] read_reg1;
    reg [2:0] read_reg2;
    reg [2:0] write_reg;
    reg [7:0] write_data;

    wire [7:0] read_data1;
    wire [7:0] read_data2;

    RegisterFile uut (
        .clk(clk),
        .reg_write_en(reg_write_en),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Generate Clock
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reg_write_en = 0;
        read_reg1 = 0;
        read_reg2 = 0;
        write_reg = 0;
        write_data = 0;

        // Wait 10 ns for global reset to finish
        #10;
        // Setup waveform dumping 
        $dumpfile("RegisterFile_Waveform.vcd");
        $dumpvars(0, RegisterFile_TB);

        $display("--- Starting Register File Tests ---");

        // TEST 1: The R0 Hardwire Test
        // Attempt to write 8'hFF (255) to R0
        reg_write_en = 1;
        write_reg = 3'b000;
        write_data = 8'hFF;
        #10; 
        
        // Read R0 to see if the write was ignored
        reg_write_en = 0;
        read_reg1 = 3'b000;
        #10;
        $display("Test 1 [R0 check]: Read Data 1 = %d (Expected: 0)", read_data1);

        // TEST 2: Write 5 to R4 and read it back
        reg_write_en = 1;
        write_reg = 3'b100; // Register 4
        write_data = 8'd5;
        #10;

        reg_write_en = 0;
        read_reg1 = 3'b100; // Read from Register 4
        #10;
        $display("Test 2 [Write/Read R4]: Read Data 1 = %d (Expected: 5)", read_data1);

        // TEST 3: Simultaneous Read of R3 and R4
        // First, let's write a value to R3 so it's not zero (we already have 5 in R4)
        reg_write_en = 1;
        write_reg = 3'b011; // Register 3
        write_data = 8'd15;
        #10;

        // Now read R3 on port 1, and R4 on port 2 simultaneously
        reg_write_en = 0;
        read_reg1 = 3'b011; // R3
        read_reg2 = 3'b100; // R4
        #10;
        $display("Test 3 [Simultaneous Read]: Data 1 (R3) = %d, Data 2 (R4) = %d (Expected: 15, 5)", read_data1, read_data2);

        $display("--- Tests Complete ---");

        $finish;
    end
endmodule
