
module tb_CEP;
  logic rst, clk, ext_inter, timer_en, counter_clear;
  logic [7:0] ss_sel;
  logic [6:0] no_encoded;
  CEP DUT (
      .clk(clk),
      .rst(rst),
      .counter_clear(counter_clear),
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
    rst = 1'b0;
    counter_clear = 1'b1;
    timer_en = 0;
    ext_inter = 0;
    @(posedge clk);
    counter_clear = 1'b0;
    rst = 1'b1;
    @(posedge clk);
    @(posedge clk);
    rst = 0;
    repeat (300) @(posedge clk);
    $finish;
  end
  //Monitor values at posedge
  always @(posedge DUT.processor_clk) begin
    $strobe(
        "counter=%d rst=%d PC=%0d\tFlush=%0d\tstall=%d\tinstr=%h|\nPC=%0d\tinstr=%h\tx1=%0h\tx2=%0d\tx3=%0h\tA=%h\tB=%h\tforw_a=%0d\tforw_b=%0d|\nPC=%0d\tALU_o=%0h\twb_data=%h\tmem=%d\tregwr=%b\twb_sel=%b\tPC_sel=%b\nmem_wr=%b\tdata_to_wr=%h\nmie_wr_flag=%0h\tinterupt_taken=%0h\tmstatus_wr_flag=%0h\tmtvec_wr_flag=%0h\ttimer_inter=%0h\texternal_inter=%0h\nmepc_q=%0d\tmie_q=%0h\tmstatus_q=%0h\tmtvec_q=%0h\tmcause_q=%0h\tmip_q=%0h\nISR_addr=%0b\tcsr_addr=%0h\tepc=%0d\tepc_taken=%0h",
        DUT.refreshcounter_instance.clk_div, rst, DUT.RISC_V_instance.datapath.Fetch.PC,
        DUT.RISC_V_instance.datapath.flush, DUT.RISC_V_instance.datapath.stall,
        DUT.RISC_V_instance.datapath.Fetch.instruction,
        DUT.RISC_V_instance.datapath.Decode_instance.PC,
        DUT.RISC_V_instance.datapath.Decode_instance.instruction,
        DUT.RISC_V_instance.datapath.Decode_instance.Regfile_instance.mem[1],
        DUT.RISC_V_instance.datapath.Decode_instance.Regfile_instance.mem[2],
        DUT.RISC_V_instance.datapath.Decode_instance.Regfile_instance.mem[3],
        DUT.RISC_V_instance.datapath.Decode_instance.ALU_op_a,
        DUT.RISC_V_instance.datapath.Decode_instance.ALU_op_b,
        DUT.RISC_V_instance.datapath.Decode_instance.forw_a,
        DUT.RISC_V_instance.datapath.Decode_instance.forw_b,
        DUT.RISC_V_instance.datapath.wb_stage_instance.PC, DUT.RISC_V_instance.datapath.ALU_wb,
        DUT.RISC_V_instance.datapath.wb_data,
        DUT.RISC_V_instance.datapath.wb_stage_instance.data_mem_instance.mem[0],
        DUT.RISC_V_instance.reg_wr, DUT.RISC_V_instance.wb_sel, DUT.RISC_V_instance.PC_sel,
        DUT.RISC_V_instance.mem_wr, DUT.RISC_V_instance.datapath.wb_stage_instance.data_to_mem,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mie_wr_flag,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.interupt_taken,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mstatus_wr_flag,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mtvec_wr_flag,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.timer_inter,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.external_inter,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mepc_q,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mie_q,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mstatus_q,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mtvec_q,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mcause_q,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.mip_q,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.ISR_addr,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.addr,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.epc,
        DUT.RISC_V_instance.datapath.wb_stage_instance.CSR_reg_instance.epc_taken);
    $strobe("ovf", DUT.RISC_V_instance.ovf);
    $strobe("\n---------------------------------------------");
    $strobe("ss_sel=%b, no_encoded=%b no=%b result=%d counter=%d", ss_sel, no_encoded, DUT.no,
            DUT.result, DUT.ss_counter);

  end
  initial begin
    $dumpfile("RISC_R_dump.vcd");
    $dumpvars;
  end
endmodule
