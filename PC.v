module ProgramCounter (
  input wire clk,
  input wire rst,
  input wire [31:0] next_addr,
  output reg [31:0] pc
);

  always @(posedge clk or negedge rst) begin
    if (!rst)
      pc <= 0; // Reset to 0
    else
      pc <= pc + 4; // Update PC
  end
endmodule
