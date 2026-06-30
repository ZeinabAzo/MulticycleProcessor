# Custom 19-Bit Multi-Cycle Processor

## Overview
This project is a fully functional, custom 19-bit multi-cycle processor written in Verilog. It was developed as a midterm project for my Term 4 Computer Architecture course at KNTU. Rather than using a standard MIPS architecture, this processor runs on a completely custom 19-bit instruction set designed specifically for this project.

## Architecture Specs
* **Instruction Width:** 19 bits
* **Data Width:** 8 bits
* **Registers:** 8 general-purpose registers (`r0` is hardwired to 0)
* **Control Unit:** 5-Stage Finite State Machine (Fetch, Decode, Execute, Mem Access, Write-back)

## Hardware Modules
* `Processor.v` - The top-level datapath that wires all components together.
* `ControlUnit.v` - The FSM brain that decodes instructions and controls multiplexer routing.
* `ALU.v` - Handles 7 combinational logic operations and evaluates Zero/Carry flags.
* `RegisterFile.v` - Array of 8-bit registers with simultaneous read ports and a write-enable safeguard.
* `InstructionMemory.v` - ROM holding the machine code to be executed.
* `DataMemory.v` - RAM for loading and storing data during execution.

## Simulation & Testing
Every module includes its own dedicated testbench (`_TB.v`) to verify logic independently. The final system was simulated using ModelSim to prove the top-level datapath can successfully fetch, decode, and execute a multi-line program from memory. 

The processor was tested using both binary (`.txt`) and hexadecimal (`.hex`) machine code formats.

### How to Run the Simulation
1. Compile all `.v` files in your Verilog simulator (e.g., ModelSim).
2. Ensure `program.hex` is placed in the root of your working directory.
3. Run the top-level simulation using `Processor_Hex_TB.v`.
4. Monitor the console transcript to watch the register states update and verify the final RAM storage output.
