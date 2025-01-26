/*module inst_mem(
input wire [31:0] addr,
input wire clk,
input wire rst,

output wire [31:0] instruction

);
// read text instruction into a memory bank and write it to memory register
parameter MEM_DEPTH = 19;

reg [31:0] inst_memory[MEM_DEPTH:0];

assign instruction = inst_memory[addr];

initial begin
    $readmemh("INST.txt", inst_memory);
end

endmodule */

module inst_mem(
    input wire [31:0] addr,
    input wire clk,
    input wire rst,
    output wire [31:0] instruction
);

// Define memory depth
parameter MEM_DEPTH = 32; // Supports up to 32 instructions

// Instruction memory array
reg [31:0] inst_memory [MEM_DEPTH-1:0];

// Output the instruction based on the address
assign instruction = inst_memory[addr >> 2]; // Divide by 4 for word alignment
integer i;

// Manually initialize instruction memory
initial begin
    // Load 5 instructions into the instruction memory (manually defined)
    inst_memory[0] = 32'h20010007; // addi r1, r0, 7   -> r1 = 7
    inst_memory[1] = 32'h20020003; // addi r2, r0, 3   -> r2 = 3
    inst_memory[2] = 32'h00222024; // and r4, r1, r2   -> r4 = r1 & r2
    inst_memory[3] = 32'h10000003; // beq r0, r1, 3    -> branch (won't execute)
    inst_memory[4] = 32'hC0080009; // lw r8, 9(r0)     -> load word from memory
    // Fill remaining memory with no-operations (NOPs)
    for (i = 5; i < MEM_DEPTH; i = i + 1) begin
        inst_memory[i] = 32'h00000000; // NOP
    end
end

endmodule