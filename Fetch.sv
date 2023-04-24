`include "Pipeline_reg.sv"
`include "Instrmem.sv"
module Fetch (
    input clk,
    input rst,
    PC_sel,
    flush,
    stall,
    epc_taken,
    input logic [31:0] epc,
    input logic [31:0] ALU_o,
    output logic [31:0] instruction_ppl,
    PC_ppl
);
  logic not_stalled;
  logic [31:0] PC, PC_mux_o;
  logic [31:0] instruction;
  assign not_stalled = !stall;
  Instrmem Instrmem_instance (
      .addr_i(PC),
      .instruction_o(instruction)
  );
  always_ff @(posedge clk) begin
    if (rst) PC <= 32'd0;
    else if (not_stalled) PC <= PC_mux_o;
  end

  assign PC_mux_o = epc_taken ? epc : (PC_sel ? ALU_o : PC + 4);
  Pipeline_reg Pipieline_reg_instance (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(PC),
      .out(PC_ppl)
  );
  Pipeline_reg Pipieline_reg_instance2 (
      .clk(clk),
      .flush(flush),
      .stall(stall),
      .in(instruction),
      .out(instruction_ppl)
  );
endmodule
