module sevenseg (
    input  logic [3:0] data,
    output logic [6:0] encoded
);
  always_comb begin
    unique case (data)
      // abc_defg
      4'h0: encoded = 7'b1000_000;
      4'h1: encoded = 7'b1111_001;
      4'h2: encoded = 7'b0100_100;
      4'h3: encoded = 7'b0110_000;
      4'h4: encoded = 7'b0011_001;
      4'h5: encoded = 7'b0010_010;
      4'h6: encoded = 7'b0000_010;
      4'h7: encoded = 7'b1111_000;
      4'h8: encoded = 7'b0000_000;
      4'h9: encoded = 7'b0010_000;
      4'ha: encoded = 7'b0001_000;
      4'hb: encoded = 7'b0000_011;
      4'hc: encoded = 7'b1000_110;
      4'hd: encoded = 7'b0100_001;
      4'he: encoded = 7'b0000_110;
      4'hf: encoded = 7'b0001_110;
    endcase
    ;
  end
  ;
endmodule
