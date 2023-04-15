interface axi_stream_insert_header_if (input logic clk);

  localparam DATA_WD = 32;
  localparam DATA_BYTE_WD = DATA_WD / 8;
  localparam BYTE_CNT_WD = $clog2(DATA_BYTE_WD);

  // AXI Stream input original data
  logic valid_in;
  logic [DATA_WD-1 : 0] data_in;
  logic [DATA_BYTE_WD-1 : 0] keep_in;
  logic last_in;
  logic ready_in;

  // AXI Stream output with header inserted
  logic valid_out;
  logic [DATA_WD-1 : 0] data_out;
  logic [DATA_BYTE_WD-1 : 0] keep_out;
  logic last_out;
  logic ready_out;

  // The header to be inserted to AXI Stream input
  logic valid_insert;
  logic [DATA_WD-1 : 0] data_insert;
  logic [DATA_BYTE_WD-1 : 0] keep_insert;
  logic [BYTE_CNT_WD-1 : 0] byte_insert_cnt;
  
  modport dut (
    input clk,
    input rst_n,
    input valid_in,
    input [DATA_WD-1 : 0] data_in,
    input [DATA_BYTE_WD-1 : 0] keep_in,
    input last_in,
    output ready_in,
    output valid_out,
    output [DATA_WD-1 : 0] data_out,
    output [DATA_BYTE_WD-1 : 0] keep_out,
    output last_out,
    input ready_out,
    input valid_insert,
    input [DATA_WD-1 : 0] data_insert,
    input [DATA_BYTE_WD-1 : 0] keep_insert,
    input [BYTE_CNT_WD-1 : 0] byte_insert_cnt,
    output ready_insert
  );
  
endinterface : axi_stream_insert_header_if

