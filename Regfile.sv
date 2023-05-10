module Regfile (
    input logic rst,
    clk,
    write_en,
    input logic [4:0] rs1_in,
    rs2_in,
    rd,
    input logic [31:0] write_data,
    output logic [31:0] rs1_out,
    rs2_out
);
  logic [31:0] mem[0:31];
  logic [31:0] result;
  assign result = mem[12];
  logic valid_add1, valid_add2, valid_write_en;
  //validations
  assign valid_add1 = |rs1_in;
  assign valid_add2 = |rs2_in;
  assign valid_write_en = |rd & write_en;
  assign rs1_out = valid_add1 ? mem[rs1_in] : '0;
  assign rs2_out = valid_add2 ? mem[rs2_in] : '0;
  initial begin
    $readmemh("registervalues.mem", mem);
  end
  always_ff @(negedge clk)
    if (rst) begin
      mem = '{default: '0};
    end else if (write_en) mem[rd] <= write_data;
endmodule
