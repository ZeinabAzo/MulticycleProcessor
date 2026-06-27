module ControlUnit(
    input clk,
    input reset,
    input [18:0] instruction,
    input z_flag,
    input c_flag,

    // Datapath Control Signals
    output reg PCWrite,
    output reg IRWrite,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    
    // Multiplexer & ALU Controls
    output reg [2:0] ALUControl,
    output reg ALUSrc,      // 0: 2nd operand is Reg2, 1: 2nd operand is Immediate
    output reg MemToReg,    // 0: Save ALU result to Reg, 1: Save Mem data to Reg
    output reg PCSource     // 0: PC = PC + 1, 1: PC = Branch/Jump Target
);

    // FSM States
    parameter FETCH = 3'd0;
    parameter DECODE = 3'd1;
    parameter EXECUTE = 3'd2;
    parameter MEM_ACCESS = 3'd3;
    parameter WRITEBACK = 3'd4;

    reg [2:0] current_state, next_state;

    // Extract Opcode Fields
    wire [1:0] op_2bit = instruction[18:17];
    wire [2:0] op_3bit = instruction[18:16];
    wire [4:0] op_5bit = instruction[18:14];
    
    wire [2:0] fn_reg_reg = instruction[16:14];
    wire [2:0] fn_reg_imm = instruction[16:14];
    wire [1:0] fn_mem = instruction[15:14]; // 01: LDM, 10: STM
    wire [1:0] fn_branch  = instruction[15:14]; // 00: BZ, 01: BNZ, 10: BC, 11: BNC

    // State Register (Sequential)
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= FETCH;
        else
            current_state <= next_state;
    end

    // Next State Logic 
    always @(*) begin
        // Default all signals to 0
        PCWrite = 0; IRWrite = 0; RegWrite = 0; 
        MemRead = 0; MemWrite = 0; 
        ALUControl = 3'b000; ALUSrc = 0; MemToReg = 0; PCSource = 0;
        
        case(current_state)
            
            FETCH: begin
                IRWrite = 1; // Save instruction to Instruction Register
                PCWrite = 1;      //PC = PC + 1
                PCSource = 0;
                next_state = DECODE;
            end
            
            DECODE: begin
                next_state = EXECUTE;
            end
            
            EXECUTE: begin
                if (op_2bit == 2'b00) begin // ALU Reg-Reg
                    ALUSrc = 0; // Use Reg2
                    ALUControl = fn_reg_reg;
                    next_state = WRITEBACK;
                end
                else if (op_2bit == 2'b01) begin // ALU Reg-Imm
                    ALUSrc = 1; // Use 8-bit Immediate
                    ALUControl = fn_reg_imm;
                    next_state = WRITEBACK;
                end
                else if (op_3bit == 3'b100) begin // Memory (LDM / STM)
                    ALUSrc = 1; // Address is r1 + disp (Immediate)
                    ALUControl = 3'b000; // ADD to calculate address
                    next_state = MEM_ACCESS;
                end
                else if (op_3bit == 3'b101) begin // Branch
                    // Check flags to see if we should take the branch
                    if ((fn_branch == 2'b00 && z_flag == 1) ||  // BZ
                        (fn_branch == 2'b01 && z_flag == 0) || // BNZ
                        (fn_branch == 2'b10 && c_flag == 1) || // BC
                        (fn_branch == 2'b11 && c_flag == 0))  // BNC
                    begin
                        PCWrite = 1;
                        PCSource = 1; // PC = Branch Target
                    end
                    next_state = FETCH;
                end
                else if (op_5bit == 5'b11100) begin // Jump
                    PCWrite = 1;
                    PCSource = 1; // PC = Jump Target
                    next_state = FETCH;
                end
                else begin
                    next_state = FETCH; // Fallback
                end
            end
            
            MEM_ACCESS: begin
                if (fn_mem == 2'b01) begin // LDM (Load)
                    MemRead = 1;
                    next_state = WRITEBACK;
                end
                else if (fn_mem == 2'b10) begin // STM (Store)
                    MemWrite = 1;
                    next_state = FETCH; // Store is complete, fetch next instruction
                end
                else begin
                    next_state = FETCH;
                end
            end
            
            WRITEBACK: begin
                RegWrite = 1;
                if (op_3bit == 3'b100 && fn_mem == 2'b01) begin // If it was a Load
                    MemToReg = 1; // Write data from memory to register
                end else begin
                    MemToReg = 0; // Write data from ALU to register
                end
                next_state = FETCH; // Instruction complete!
            end
            
            default: next_state = FETCH;
        endcase
    end
endmodule