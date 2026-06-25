module DataMemory(
    input clk,
    input mem_read,
    input mem_write,
    input [7:0] address,       //(2^8 = 256)
    input [7:0] write_data,
    output reg [7:0] read_data
);

    // Array of 256 bytes, each 8 bits wide
    reg [7:0] ram [0:255];

    // Write
    always @(posedge clk) begin
        if (mem_write) begin
            ram[address] <= write_data;
        end
    end

    // Read ( make it continuous based on mem_read)
    always @(*) begin
        if (mem_read) begin
            read_data = ram[address];
        end else begin
            read_data = 8'b0; // Default zero
        end
    end
endmodule
