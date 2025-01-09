// ALU
`timescale 1ns/1ps
module ALU (
  input wire [31:0] a,
  input wire [31:0] b,
  input wire [3:0] alu_ctrl,
  input wire [4:0] shamt,
  output reg [31:0] result,
  output wire zout
);

  // Zout logic
  assign zout = (result == 32'h0) ? 1 : 0; // Set zout to 1 if result is zero, otherwise 0

  // Always block for combinational logic
  always @(*) begin
    case (alu_ctrl)
      4'b0000: result = a + b; // Addition
      4'b0010: result = a - b; // Subtraction
      4'b0100: result = a & b; // Bitwise AND
      4'b0101: result = ~(a | b); // NOR
      4'b1010: result = (shamt < 32) ? b << shamt : 32'hxxxx; // Logical shift left
      4'b1011: result = (shamt < 32) ? b >> shamt : 32'hxxxx; // Logical shift right
      default: result = 32'hxxxx; // Undefined operation
    endcase
end

endmodule