`include "datapath.sv"
`include "Controller.sv"
`include "timer.sv"
module RISC_V (
    input logic clk,
    input logic rst,
    timer_en,
    ext_inter,
    output logic [31:0] result
);
  logic [31:0] instruction;
  logic [ 3:0] interrupt;
  logic
      flush,
      stall,
      ovf,
      mem_read,
      reg_wr,
      A_sel,
      PC_sel,
      B_sel,
      br_taken,
      mem_wr,
      csr_reg_r,
      csr_reg_wr,
      is_mret;
  logic [1:0] wb_sel;
  logic [3:0] ALUctrl;
  Controller Controller (
      .clk(clk),
      .rst(rst),
      .stall(stall),
      .instruction(instruction),
      .br_taken(br_taken),
      .flush(flush),
      .ALUctrl(ALUctrl),
      .mem_wr_ppl(mem_wr),
      .mem_read_ppl(mem_read),
      .A_sel(A_sel),
      .B_sel(B_sel),
      .wb_sel_ppl(wb_sel),
      .reg_wr_ppl(reg_wr),
      .PC_sel_ppl(PC_sel),
      .csr_reg_r_ppl(csr_reg_r),
      .csr_reg_wr_ppl(csr_reg_wr),
      .is_mret_ppl(is_mret)
  );

  datapath datapath (
      .clk(clk),
      .rst(rst),
      .reg_wr(reg_wr),
      .A_sel(A_sel),
      .B_sel(B_sel),
      .mem_wr(mem_wr),
      .mem_read(mem_read),
      .PC_sel(PC_sel),
      .csr_reg_r(csr_reg_r),
      .csr_reg_wr(csr_reg_wr),
      .is_mret(is_mret),
      .interrupt(interrupt),
      .wb_sel(wb_sel),
      .ALUctrl(ALUctrl),
      .instruction(instruction),
      .br_taken(br_taken),
      .main_flush(flush),
      .stall(stall),
      .result(result)
  );
  always_comb begin

    case ({
      ext_inter, ovf
    })
      2'b00: interrupt = 4'b0000;
      2'b01: interrupt = 4'b0001;
      2'b10: interrupt = 4'b0010;
      2'b11: interrupt = 4'b0001;
    endcase
  end
  timer #(
      .WIDTH(4)
  ) timer_instance (
      .clk(clk),
      .rst(rst),
      .en (timer_en),
      .ovf(ovf)
  );

endmodule
