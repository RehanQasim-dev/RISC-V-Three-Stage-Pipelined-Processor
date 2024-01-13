//`include "RISC_V.sv"
//`include "anodecontroller.sv"
//`include "sevenseg.sv"
//`include "refreshcounter.sv"
module CEP (
    input logic clk,
    input logic rst,
    input logic counter_clear,
    timer_en,
    ext_inter,
    output logic [7:0] ss_sel,
    output logic [6:0] no_encoded
);
  logic processor_clk;
  logic [3:0] no;
  logic [31:0] result;
  logic [2:0] ss_counter;
  RISC_V RISC_V_instance (
      .clk(processor_clk),
      .rst(rst),
      .timer_en(timer_en),
      .ext_inter(ext_inter),
      .result(result)
  );
  anodecontroller anodecontroller_instance (
      .counter(ss_counter),
      .ss_sel (ss_sel)
  );
  always_comb begin
    case (ss_counter)
      3'b000: no = result[3:0];
      3'b001: no = result[7:4];
      3'b010: no = result[11:8];
      3'b011: no = result[15:12];
      3'b100: no = result[19:16];
      3'b101: no = result[23:20];
      3'b110: no = result[27:24];
      3'b111: no = result[31:28];
    endcase
  end
  sevenseg sevenseg_instance (
      .data(no),
      .encoded(no_encoded)
  );

  refreshcounter refreshcounter_instance (
      .clk(clk),
      .rst(counter_clear),
      .ss_counter(ss_counter),
      .processor_clk(processor_clk)
  );
endmodule
