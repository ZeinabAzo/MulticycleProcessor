module Processor(
    input clk,
    input reset
);
    
    reg [11:0] PC;                 
    reg [18:0] IR;                  // Instruction Register
    reg carry_flag_reg;             // carry 
    reg zero_flag_reg;              // zero

    // control unit -> output wires
    wire PCWrite, IRWrite, RegWrite, MemRead, MemWrite, ALUSrc, MemToReg, PCSource;
    wire [2:0] ALUControl;
    

    wire [18:0] fetched_instruction;
    wire [7:0] read_data1, read_data2, alu_result, mem_read_data;
    wire alu_z, alu_c;


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 12'b0;
            IR <= 19'b0;
            carry_flag_reg <= 1'b0;
            zero_flag_reg <= 1'b0;
        end else begin
            // Program Counter Update
            if (PCWrite) begin
                if (PCSource == 1)
                    PC <= IR[11:0]; // Jump/Branch
                else
                    PC <= PC + 1;   //go to next line
            end
            
            // Instruction Register Update
            if (IRWrite) begin
                IR <= fetched_instruction;
            end
            
            // Flag Register Update
            if (RegWrite && !MemToReg) begin 
                carry_flag_reg <= alu_c;
                zero_flag_reg <= alu_z;
            end
            
        end
    end

    
    // ALUSrc MUX? use Register 2, or immediate
    wire [7:0] alu_operand2 = ALUSrc ? IR[7:0] : read_data2;
    
    // MemToReg MUX:save the ALU math result, or Data Memory result?
    wire [7:0] write_back_data = MemToReg ? mem_read_data : alu_result;


    // Normally, read_reg2 is bits [7:5]. But for Store (STM), we need to read the 
    // data inside [13:11] so we can push it into Memory.
    wire [2:0] read_addr_2 = MemWrite ? IR[13:11] : IR[7:5];



    InstructionMemory rom (
        .address(PC),
        .instruction(fetched_instruction)
    );

    ControlUnit cu (
        .clk(clk),
        .reset(reset),
        .instruction(IR),
        .z_flag(zero_flag_reg),
        .c_flag(carry_flag_reg),
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

    RegisterFile rf (
        .clk(clk),
        .reg_write_en(RegWrite),
        .read_reg1(IR[10:8]),     
        .read_reg2(read_addr_2),    
        .write_reg(IR[13:11]),     
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    ALU math_unit (
        .in1(read_data1),
        .in2(alu_operand2),
        .carry_in(carry_flag_reg),
        .alu_control(ALUControl),
        .result(alu_result),
        .z_flag(alu_z),
        .c_flag(alu_c)
    );

    DataMemory ram (
        .clk(clk),
        .mem_read(MemRead),
        .mem_write(MemWrite),
        .address(alu_result),       
        .write_data(read_data2),    
        .read_data(mem_read_data)
    );

endmodule