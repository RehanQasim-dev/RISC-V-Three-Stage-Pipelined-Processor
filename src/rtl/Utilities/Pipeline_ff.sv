module Pipeline_ff #(
    parameter WIDTH = 32
) (
    input logic clk,
    input logic flush,
    stall,
    input logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
  always_ff @(clk) begin
    if (flush) out <= '0;
    else if (!stall) out <= in;
  end
endmodule
