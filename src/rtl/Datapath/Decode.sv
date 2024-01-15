/*`include "Pipeline_reg.sv"
`include "Regfile.sv"
`include "Branch_block.sv"
`include "ALU.sv"
*/
module Decode (
    input clk,
    input rst,
    flush,
    stall,
    reg_wr,
    A_sel,
    B_sel,
    forw_a,
    forw_b,
    input logic [31:0] instruction,
    PC,
    wdata,
    input logic [3:0] ALUctrl,
    output logic br_taken,
    output logic [31:0] PC_ppl,
    ALU_ppl,
    rdata2_forwarded_ppl,
    rdata1_forwarded_ppl,
    instruction_ppl
);

  localparam I_type = 5'b00100;
  localparam Load_type = 5'b00000;
  localparam B_type = 5'b11000;
  localparam S_type = 5'b01000;
  localparam J_type = 5'b11011;
  localparam Jalr_type = 5'b11001;
  localparam lui_type = 5'b01101;
  localparam auipc_type = 5'b00101;
  logic [31:0]
      rdata1, PC_ppl_in, rdata2, rdata1_forwarded, rdata2_forwarded, imm, ALU_op_b, ALU_op_a, ALU_o;
  logic [4:0] raddr1, raddr2, waddr_ppl;
  logic [2:0] func3;
  assign func3 = instruction[14:12];
  assign raddr1 = instruction[19:15];
  assign raddr2 = instruction[24:20];
  assign rdata1_forwarded = forw_a ? ALU_ppl : rdata1;
  assign rdata2_forwarded = forw_b ? ALU_ppl : rdata2;
  assign ALU_op_a = A_sel ? rdata1_forwarded : PC;
  assign ALU_op_b = B_sel ? imm : rdata2_forwarded;
  assign waddr_ppl = instruction_ppl[11:7];
  assign PC_ppl_in = flush ? ALU_ppl : PC;
  Pipeline_reg decode_exec_PC (
      .clk(clk),
      .flush(rst),
      .stall(stall),
      .in(PC_ppl_in),
      .out(PC_ppl)
  );
  Pipeline_reg #(
      .reset(0)
  ) decode_exec_alu (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(ALU_o),
      .out(ALU_ppl)
  );
  Pipeline_reg DecEXE_rdata2_forwarded (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(rdata2_forwarded),
      .out(rdata2_forwarded_ppl)
  );
  Pipeline_reg DecEXE_rdata1_forwarded (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(rdata1_forwarded),
      .out(rdata1_forwarded_ppl)
  );
  Pipeline_reg DecEXE_Instr (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(instruction),
      .out(instruction_ppl)
  );
  Regfile Regfile_instance (
      .rst(1'b0),
      .clk(clk),
      .write_en(reg_wr),
      .rs1_in(raddr1),
      .rs2_in(raddr2),
      .rd(waddr_ppl),
      .write_data(wdata),
      .rs1_out(rdata1),
      .rs2_out(rdata2)
  );

  ALU ALU_instance (
      .a_in(ALU_op_a),
      .b_in(ALU_op_b),
      .ALUctrl(ALUctrl),
      .result_o(ALU_o)
  );

  Branch_block Branch_block_instance (
      .op_a(rdata1_forwarded),
      .op_b(rdata2_forwarded),
      .func3(func3),
      .branch_taken(br_taken)
  );

  //Immidiate generation
  always_comb begin
    casex (instruction[6:2])
      Load_type, I_type: imm = {{20{instruction[31]}}, instruction[31:20]};  //load,I
      Jalr_type: imm = {{20{instruction[31]}}, instruction[31:20]};
      S_type: imm = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};  //save
      J_type:
      imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
      B_type:
      imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      lui_type, auipc_type: imm = {{instruction[31:12]}, {12{1'b0}}};
      default: begin
        imm = 'x;
      end
    endcase
  end
endmodule
