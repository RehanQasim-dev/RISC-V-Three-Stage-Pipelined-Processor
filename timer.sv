module timer #(
    parameter WIDTH = 4
) (
    input clk,
    input rst,
    en,
    output logic ovf
);
  logic [WIDTH-1:0] count;
  assign ovf = count[WIDTH-1];
  always_ff @(posedge clk) begin
    if (rst) count <= '0;
    else if (ovf) count <= '0;
    else if (en) count <= count + 1'b1;
  end
endmodule
