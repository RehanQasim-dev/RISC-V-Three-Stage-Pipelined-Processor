module LS_controller (
    input  logic [ 2:0] func3,
    input  logic [ 1:0] address,
    input  logic [31:0] rdata2,
    output logic [31:0] wdata_mem,
    output logic [ 2:0] load_ctrl,
    output logic [ 3:0] mask
);
  localparam b = 3'b000;
  localparam h = 3'b001;
  localparam w = 3'b010;
  localparam bu = 3'b100;
  localparam hu = 3'b101;
  always_comb begin
    case (func3)
      b: begin
        case (address)
          2'b00: begin
            mask = 4'b0001;
            wdata_mem = {{24{1'b0}}, {rdata2[7:0]}};
          end
          2'b01: begin
            mask = 4'b0010;
            wdata_mem = {{16{1'b0}}, {rdata2[7:0]}, {8{1'b0}}};
          end
          2'b10: begin
            mask = 4'b0100;
            wdata_mem = {{8{1'b0}}, {rdata2[7:0]}, {16{1'b0}}};
          end
          2'b11: begin
            mask = 4'b1000;
            wdata_mem = {{rdata2[7:0]}, {24{1'b0}}};
          end
          default: begin
            mask = 'x;
            wdata_mem = 'x;
          end
        endcase
        load_ctrl = 3'b000;
      end
      h: begin
        case (address[1])
          0: begin
            mask = 4'b0011;
            wdata_mem = {{16{1'b0}}, {rdata2[15:0]}};
          end
          1: begin
            mask = 4'b1100;
            wdata_mem = {{rdata2[15:0]}, {16{1'b0}}};
          end
          default: begin
            mask = 'x;
            wdata_mem = 'x;
          end
        endcase
        load_ctrl = 3'b001;
      end
      w: begin
        mask = 4'b1111;
        wdata_mem = rdata2;
        load_ctrl = 3'b010;
      end
      bu: begin
        mask = 'x;
        wdata_mem = rdata2;
        load_ctrl = 3'b011;
      end
      hu: begin
        mask = 'x;
        wdata_mem = rdata2;
        load_ctrl = 3'b100;
      end
      default: begin
        mask = 'x;
        wdata_mem = rdata2;
        load_ctrl = 3'b100;
      end
    endcase
  end
endmodule
