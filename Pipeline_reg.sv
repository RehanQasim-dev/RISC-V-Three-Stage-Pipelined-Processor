module Pipeline_reg #(
    parameter WIDTH = 32,
    reset = 32'h13
) (
    input logic clk,
    input logic flush,
    stall,
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
  logic not_stalled;
  assign not_stalled = !stall;
  always_ff @(posedge clk) begin
    if (flush) out <= WIDTH'(reset);
    else if (not_stalled) out <= in;
  end
endmodule
