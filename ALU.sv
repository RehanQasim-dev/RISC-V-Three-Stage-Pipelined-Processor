`include "mux16x1.sv"
module ALU (
    input  logic [31:0] a_in,
    b_in,
    input  logic [ 3:0] ALUctrl,
    output logic [31:0] result_o
);
  logic [31:0]
      and_res, or_res, xor_res, add_sub_res, SLT_res, SLTU_res, t, SLL_res, SRL_res, SRA_res;
  logic [31:0] mux1_o;
  logic C_out, N, V, W, C;  //Flags
  assign N = add_sub_res[31];
  assign C = C_out;
  assign V = (add_sub_res[31] ^ a_in[31]) & (~(a_in[31] ^ b_in[31] ^ ALUctrl[0]));
  assign W = add_sub_res[31] ^ V;
  assign t = ~b_in;
  assign mux1_o = ALUctrl[0] ? t : b_in;
  // Operations
  assign {C_out, add_sub_res} = a_in + mux1_o + ALUctrl[0];
  assign and_res = a_in & b_in;
  assign or_res = a_in | b_in;
  assign xor_res = a_in ^ b_in;
  assign SLT_res = {30'd0, W};
  assign SLTU_res = {30'd0, ~C};
  assign SRA_res = a_in >>> b_in;
  assign SRL_res = a_in >> b_in;
  assign SLL_res = a_in << b_in;
  mux11x1 ALU_mux (
      .i1 (add_sub_res),
      .i2 (add_sub_res),
      .i3 (SLL_res),
      .i4 (SLT_res),
      .i5 (xor_res),
      .i6 (SLTU_res),
      .i7 (SRL_res),
      .i8 (SRA_res),
      .i9 (or_res),
      .i10(and_res),
      .i11(b_in),
      .s  (ALUctrl),
      .y  (result_o)
  );
endmodule
