module CSR_reg (
    input clk,
    input rst,
    reg_wr,
    reg_r,
    input logic [31:0] PC,
    input logic [11:0] addr,
    input logic [3:0] interrupt,
    input logic [31:0] wdata_csr,
    input logic is_mret,
    output logic [31:0] rdata,
    epc,
    output logic epc_taken
);
  logic mie_wr_flag, interupt_taken, mstatus_wr_flag, mtvec_wr_flag, timer_inter, external_inter;
  logic [31:0] mepc_q, mie_q, mstatus_q, mtvec_q, mcause_q, mip_q, mcause_d, mip_d, ISR_addr;
  assign timer_inter_occur = mie_q[7] & mip_q[7];
  localparam mepc_addr = 12'h341;
  localparam mcause_addr = 12'h342;
  localparam mip_addr = 12'h344;
  localparam mtvec_addr = 12'h305;
  localparam mie_addr = 12'h304;
  localparam mstatus_addr = 12'h304;
  assign timer_inter = mip_q[7] & mie_q[7];
  assign external_inter = mip_q[11] & mie_q[11];
  assign interupt_taken = (timer_inter | external_inter) & mstatus_q[3];
  assign epc_taken = is_mret | interupt_taken;
  assign ISR_addr = mtvec_q[0] ? {mtvec_q[31:2], 2'b00} : {mtvec_q[31:2], 2'b00} + {mcause_q[29:0], 2'b00};
  assign epc = is_mret ? mepc_q : ISR_addr;

  //csr_registers

  always_ff @(posedge clk) begin
    if (rst) mepc_q <= '0;
    else if (interupt_taken) mepc_q <= PC;
  end
  always_ff @(posedge clk) begin
    if (rst) mie_q <= '0;
    else if (mie_wr_flag) mie_q <= wdata_csr;
  end
  always_ff @(posedge clk) begin
    if (rst) mstatus_q <= '0;
    else if (mstatus_wr_flag) mstatus_q <= wdata_csr;
  end
  always_ff @(posedge clk) begin
    if (rst) mtvec_q <= '0;
    else if (mtvec_wr_flag) mtvec_q <= wdata_csr;
  end
  //
  always_ff @(posedge clk) begin
    if (rst) mcause_q <= '0;
    else mcause_q <= mcause_d;
  end
  always_ff @(posedge clk) begin
    if (rst) mip_q <= '0;
    else mip_q <= mip_d;
  end
  //
  always_comb begin
    case (interrupt)
      4'd1: begin
        mip_d = 32'h80;
        mcause_d = 32'd7;
      end
      4'd2: begin
        mip_d = 32'h800;
        mcause_d = 32'd11;
      end
      default: begin
        mcause_d = '0;
        mip_d = '0;
      end
    endcase
  end
  //
  always_comb begin
    rdata = '0;
    if (reg_r) begin
      case (addr)
        mip_addr: begin
          rdata = mip_q;
        end
        mie_addr: begin
          rdata = mie_q;
        end
        mstatus_addr: begin
          rdata = mstatus_q;
        end
        mcause_addr: begin
          rdata = mcause_q;
        end
        mtvec_addr: begin
          rdata = mtvec_q;
        end
        mepc_addr: begin
          rdata = mepc_q;
        end
        default: rdata = '0;
      endcase
    end
  end
  always_comb begin
    mie_wr_flag = 1'b0;
    mstatus_wr_flag = 1'b0;
    mtvec_wr_flag = 1'b0;
    if (reg_wr) begin
      case (addr)
        mie_addr: begin
          mie_wr_flag = 1'b1;
        end
        mstatus_addr: begin
          mstatus_wr_flag = 1'b1;
        end
        mtvec_addr: begin
          mtvec_wr_flag = 1'b1;
        end
      endcase
    end
  end
endmodule
