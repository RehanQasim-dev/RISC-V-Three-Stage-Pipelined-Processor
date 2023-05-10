`include "CEP.sv"

module RISC_V_tb;
  logic rst, clk, ext_inter, timer_en;
  logic [3:0] interrupt;
  logic [6:0] ss_sel, no_encoded;
  CEP DUT (
      .clk(clk),
      .rst(rst),
      .timer_en(timer_en),
      .ext_inter(ext_inter),
      .ss_sel(ss_sel),
      .no_encoded(no_encoded)
  );
  //clock generation
  localparam CLK_PERIOD = 2;
  initial begin
    clk = 0;
    forever begin
      #(CLK_PERIOD / 2);
      clk = ~clk;
    end
  end
  //Testbench

  initial begin
    rst = 1;
    timer_en = 0;
    ext_inter = 0;
    @(posedge clk);
    rst = 0;
    repeat (10) @(posedge clk);
    timer_en = 1'b1;
    repeat (11) @(posedge clk);
    timer_en = 1'b0;
    repeat (22) @(posedge clk);
    $finish;
  end
  //Monitor values at posedge
  always @(posedge clk) begin
    $strobe(
        "PC=%0d\tFlush=%0d\tstall=%d\tinstr=%h|\nPC=%0d\tinstr=%h\tx1=%0h\tx2=%0h\tx3=%0h\tA=%h\tB=%h\tforw_a=%0d\tforw_b=%0d|\nPC=%0d\tALU_o=%0h\twb_data=%h\tmem=%h\tregwr=%b\twb_sel=%b\tPC_sel=%b\nmem_wr=%b\tdata_to_wr=%h\nmie_wr_flag=%0h\tinterupt_taken=%0h\tmstatus_wr_flag=%0h\tmtvec_wr_flag=%0h\ttimer_inter=%0h\texternal_inter=%0h\nmepc_q=%0d\tmie_q=%0h\tmstatus_q=%0h\tmtvec_q=%0h\tmcause_q=%0h\tmip_q=%0h\nISR_addr=%0b\tcsr_addr=%0h\tepc=%0d\tepc_taken=%0h",
        DUT.datapath.Fetch.PC, DUT.datapath.flush, DUT.datapath.stall,
        DUT.datapath.Fetch.instruction, DUT.datapath.Decode_instance.PC,
        DUT.datapath.Decode_instance.instruction,
        DUT.datapath.Decode_instance.Regfile_instance.mem[1],
        DUT.datapath.Decode_instance.Regfile_instance.mem[2],
        DUT.datapath.Decode_instance.Regfile_instance.mem[3], DUT.datapath.Decode_instance.ALU_op_a,
        DUT.datapath.Decode_instance.ALU_op_b, DUT.datapath.Decode_instance.forw_a,
        DUT.datapath.Decode_instance.forw_b, DUT.datapath.wb_stage_instance.PC, DUT.datapath.ALU_wb,
        DUT.datapath.wdata, DUT.datapath.wb_stage_instance.data_mem_instance.mem[0], DUT.reg_wr,
        DUT.wb_sel, DUT.PC_sel, DUT.mem_wr, DUT.datapath.wb_stage_instance.data_to_mem,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mie_wr_flag,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.interupt_taken,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mstatus_wr_flag,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mtvec_wr_flag,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.timer_inter,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.external_inter,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mepc_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mie_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mstatus_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mtvec_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mcause_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.mip_q,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.ISR_addr,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.addr,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.epc,
        DUT.datapath.wb_stage_instance.CSR_reg_instance.epc_taken);
    $strobe("ovf", DUT.ovf);
    $display("\n---------------------------------------------");
  end
  initial begin
    $dumpfile("RISC_R_dump.vcd");
    $dumpvars;
  end
endmodule
