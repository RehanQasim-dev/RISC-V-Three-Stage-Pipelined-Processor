module Branch_block (
    input logic [31:0] op_a,
    op_b,
    input logic [2:0] func3,
    output logic branch_taken
);
  logic [31:0] branch_sub;
  logic overflow, not_zero, neg, carry;
  assign branch_sub = op_a - op_b;
  assign not_zero = |branch_sub;
  assign neg = branch_sub[31];
  assign {carry, overflow} = (op_a ^ op_b) && (op_a ^ branch_sub[31]);
  always_comb begin
    case (func3)
      //beq
      3'b000:  branch_taken = ~not_zero;
      //bneq
      3'b001:  branch_taken = not_zero;
      //blt
      3'b100:  branch_taken = branch_sub[31];
      //bge
      3'b101:  branch_taken = ~branch_sub[31];
      //bltu
      3'b110:  branch_taken = ~carry;
      //bgeu
      3'b111:  branch_taken = carry;
      default: branch_taken = 1'bx;
    endcase
  end
endmodule
