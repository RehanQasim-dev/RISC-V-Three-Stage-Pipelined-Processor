module mux11x1 (
    input  logic [31:0] i1,
    i2,
    i3,
    i4,
    i5,
    i6,
    i7,
    i8,
    i9,
    i10,
    i11,
    input  logic [ 3:0] s,
    output logic [31:0] y
);
  always_comb begin
    case (s)
      4'd0:  y = i1;
      4'd1:  y = i2;
      4'd2:  y = i3;
      4'd3:  y = i4;
      4'd4:  y = i5;
      4'd5:  y = i6;
      4'd6:  y = i7;
      4'd7:  y = i8;
      4'd8:  y = i9;
      4'd9:  y = i10;
      4'd10: y = i11;

      default: y = 32'bX;
    endcase
  end
endmodule
