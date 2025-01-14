module CPU (
  input wire clk,
  input wire rst
);

  // Wires for interconnecting components
  wire [31:0] pc, next_pc, instruction;
  wire [31:0] read_data1, read_data2, alu_result, mem_data_out;
  wire [31:0] write_data;
  wire [4:0] rd, rs, rt, shamt;
  wire [5:0] opcode, funct;
  wire [3:0] alu_ctrl;
  wire regWrite, memRead, memWrite;
  wire zout;

  // Instantiate Program Counter
  ProgramCounter pc_module (
    .clk(clk),
    .rst(rst),
    .next_addr(next_pc),
    .pc(pc)
  );

  // Instruction Memory
  inst_mem inst_memory (
    .addr(pc[31:0]), // Adjust for instruction memory size
    .clk(clk),
    .rst(rst),
    .instruction(instruction)
  );

  // Instruction Decode
  assign opcode = instruction[31:26];
  assign rs = instruction[25:21];
  assign rt = instruction[20:16];
  assign rd = instruction[15:11];
  assign shamt = instruction[10:6];
  assign funct = instruction[5:0];

  // Register File
  Register register_file (
    .clk(clk),
    .rst(rst),
    .Ra(rs),
    .Rb(rt),
    .Rw(rd),
    .bus_w(write_data),
    .regWrite(regWrite),
    .bus_a(read_data1),
    .bus_b(read_data2)
  );

  // ALU
  ALU alu (
    .a(read_data1),
    .b(read_data2),
    .alu_ctrl(alu_ctrl),
    .shamt(shamt),
    .result(alu_result),
    .zout(zout)
  );

  // Data Memory
  DataMemory data_memory (
    .clk(clk),
    .rst(rst),
    .addr(alu_result),
    .data_in(read_data2),
    .mem_read(memRead),
    .mem_write(memWrite),
    .data_out(mem_data_out)
  );

  // Control Unit
  ControlUnit control_unit (
    .opcode(opcode),
    .funct(funct),
    .regWrite(regWrite),
    .memRead(memRead),
    .memWrite(memWrite),
    .alu_ctrl(alu_ctrl)
  );

  // Write-back logic
  assign write_data = memRead ? mem_data_out : alu_result;

  // Next PC (basic increment, can be extended for branching)
  assign next_pc = pc + 4;

endmodule
