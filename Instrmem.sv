module Instrmem (
    input  logic [31:0] addr_i,
    output logic [31:0] instruction_o
);
  initial begin
    $readmemh("instructions.mem", instrmem);
  end
  logic [31:0] instrmem[0:31];
  assign instruction_o = instrmem[addr_i[6:2]];
endmodule

