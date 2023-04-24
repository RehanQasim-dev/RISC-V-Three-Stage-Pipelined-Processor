module Hazard_detection (
    input logic reg_wr,
    mem_read,
    PC_sel,
    input logic [4:0] raddr1,
    raddr2,
    rd_wb,
    output logic forw_a,
    forw_b,
    flush,
    stall
);
  logic valid, a1, b1;
  assign valid = |rd_wb;
  assign a1 = (raddr1 == rd_wb);
  assign b1 = (raddr2 == rd_wb);
  assign forw_a = ((raddr1 == rd_wb) & reg_wr) & valid;
  assign forw_b = ((raddr2 == rd_wb) & reg_wr) & valid;
  assign stall = ((raddr1 == rd_wb) | (raddr2 == rd_wb)) & valid & mem_read;
  assign flush = PC_sel;
endmodule
