module Rocc_Controller (
    input  logic clk,
    rst,
    is_GemmInstr,
    done,
    output logic stall,
    valid
);
  localparam NORMAL = 1'b0;
  localparam WAIT = 1'b1;
  logic cs, ns;
  always_comb begin
    if (cs == NORMAL) begin
      if (is_GemmInstr) begin
        valid = 1'b1;
        stall = 1'b1;
        ns = WAIT;
      end else if (~is_GemmInstr) begin
        valid = 1'b0;
        stall = 1'b0;
        ns = NORMAL;
      end else begin
        valid = 1'bx;
        stall = 1'bx;
        ns = 'x;
      end
    end else if (cs == WAIT) begin
      if (done) begin
        valid = 1'b0;
        stall = 1'b0;
        ns = NORMAL;
      end else if (~done) begin
        valid = 1'b0;
        stall = 1'b1;
        ns = WAIT;
      end else begin
        valid = 1'bx;
        stall = 1'bx;
        ns = 'x;
      end
    end else begin
      valid = 1'bx;
      stall = 1'bx;
      ns = 'x;
    end
  end



  always_ff @(posedge clk) begin : blockName
    if (rst) cs <= NORMAL;
    else cs <= ns;
  end

endmodule
