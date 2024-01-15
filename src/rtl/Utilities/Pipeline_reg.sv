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

  always_ff @(posedge clk) begin
    if (flush) out <= WIDTH'(reset);
    else if (!stall) out <= in;
  end

endmodule
