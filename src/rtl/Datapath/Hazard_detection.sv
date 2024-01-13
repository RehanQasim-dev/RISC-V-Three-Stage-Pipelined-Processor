module Hazard_detection (
    input logic reg_wr,
    mem_read,
    loaded,
    PC_sel,
    epc_taken,
    input logic [4:0] raddr1,
    raddr2,
    rd_wb,
    input logic [1:0] wb_sel,
    output logic forw_a,
    forw_b,
    flush,
    stall
);
  logic valid, a1, b1;
  assign valid = |rd_wb;
  assign a1 = (raddr1 == rd_wb);
  assign b1 = (raddr2 == rd_wb);
  assign forw_a = ((raddr1 == rd_wb) & reg_wr) & valid & (wb_sel == 2'b01);
  assign forw_b = ((raddr2 == rd_wb) & reg_wr) & valid & (wb_sel == 2'b01);
  assign stall = ((raddr1 == rd_wb) | (raddr2 == rd_wb)) & valid & (wb_sel != 2'b01) & (~loaded);
  assign flush = PC_sel | epc_taken;
endmodule
