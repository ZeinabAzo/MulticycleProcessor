
module RegisterFile(
    input clk,
    input reg_write_en,
    input [2:0] read_reg1,
    input [2:0] read_reg2,
    input [2:0] write_reg,
    input [7:0] write_data,
    output [7:0] read_data1,
    output [7:0] read_data2
);

    // Array of 8 registers, each 8 bits wide
    reg [7:0] registers [7:0];
    
    integer i;

    // Initialize all registers to 0
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = 8'b0;
        end
    end


    //r0 is always 0. enforce this by returning 0 if read_reg is 0.
    assign read_data1 = (read_reg1 == 3'b000) ? 8'b0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 3'b000) ? 8'b0 : registers[read_reg2];

    // Write port
    always @(posedge clk) begin
        // Only write if reg_write is high AND we are not trying to write to r0
        if (reg_write_en && write_reg != 3'b000) begin
            registers[write_reg] <= write_data;
        end
    end

endmodule