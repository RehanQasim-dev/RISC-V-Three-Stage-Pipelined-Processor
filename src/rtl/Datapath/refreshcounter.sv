module refreshcounter (
    input clk,
    rst,
    output [2:0] ss_counter,
    output logic processor_clk
);
  logic [19:0] clk_div;
  always_ff @(posedge clk) begin
    if (rst) clk_div[19:0] <= 20'd0;
    else clk_div <= clk_div + 1'b1;
  end
  // assign ss_counter = clk_div[19:17];
  // assign processor_clk = clk_div[8];
  //debug
  assign ss_counter = clk_div[19:17];
  assign processor_clk = clk_div[8];
endmodule
