module anodecontroller (
    input  logic [2:0] counter,
    output logic [7:0] ss_sel
);
  always_comb begin
    case (counter)
      3'b000:  ss_sel = 8'b11111110;
      3'b001:  ss_sel = 8'b11111101;
      3'b010:  ss_sel = 8'b11111011;
      3'b011:  ss_sel = 8'b11110111;
      3'b100:  ss_sel = 8'b11101111;
      3'b101:  ss_sel = 8'b11011111;
      3'b110:  ss_sel = 8'b10111111;
      3'b111:  ss_sel = 8'b01111111;
      default: ss_sel = 8'b11111111;
    endcase
  end
endmodule
