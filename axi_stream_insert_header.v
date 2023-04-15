module axi_stream_insert_header #(
    parameter DATA_WD = 32,
    parameter DATA_BYTE_WD = DATA_WD / 8,
    parameter BYTE_CNT_WD = $clog2(DATA_BYTE_WD)
)(
    input clk,
    input rst_n,
    // AXI Stream input original data
    input valid_in,
    input [DATA_WD-1 : 0] data_in,
    input [DATA_BYTE_WD-1 : 0] keep_in,
    input last_in,
    output ready_in,
    // AXI Stream output with header inserted
    output valid_out,
    output [DATA_WD-1 : 0] data_out,
    output [DATA_BYTE_WD-1 : 0] keep_out,
    output last_out,
    input ready_out,
    // The header to be inserted to AXI Stream input
    input valid_insert,
    input [DATA_WD-1 : 0] data_insert,
    input [DATA_BYTE_WD-1 : 0] keep_insert,
    input [BYTE_CNT_WD-1 : 0] byte_insert_cnt,
    output ready_insert
);
    localparam HDR_BYTES = (DATA_WD + 31) / 32 * 4 - DATA_BYTE_WD;
    localparam DATA_BYTES = (DATA_WD + 7) / 8;

    reg [(HDR_BYTES*8-1):0] header_insert_reg;
    reg [(DATA_BYTES*8-1):0] data_reg;
    reg [(BYTE_CNT_WD*8-1):0] byte_cnt_reg;
    
    // Your code here
    

// AXI Stream input
assign ready_in = valid_out && ready_out;
assign valid_out = valid_in;
assign data_out = data_in;
assign keep_out = keep_in;
assign last_out = last_in;

// Header insertion
assign ready_insert = (byte_cnt_reg == BYTE_CNT_WD-1);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        header_insert_reg <= '0;
        data_reg <= '0;
        byte_cnt_reg <= '0;
    end
    else if(valid_insert && ready_insert) begin
        header_insert_reg <= {header_insert_reg[(HDR_BYTES-1)*8-1+1:0], data_insert};
        byte_cnt_reg <= byte_cnt_reg + 1;
    end
    else if(ready_in && valid_in) begin
        if(byte_cnt_reg == 0) begin
            data_reg <= {data_in[(DATA_BYTES-1)*8-1:0], header_insert_reg[0]};
            header_insert_reg <= {header_insert_reg[(HDR_BYTES-1)*8-1+1:0]};
        end
        else begin
            data_reg <= data_in;
            header_insert_reg <= header_insert_reg;
        end
        byte_cnt_reg <= byte_cnt_reg - (last_in ? BYTE_CNT_WD : 0);
    end
end
// AXI Stream output
assign ready_out = valid_out && valid_in && (last_out || !last_in);
assign keep_in = {last_out ? {1'b1, '0} : '1, keep_out[(DATA_BYTE_WD-1)*8-2:0]};
assign data_in = data_reg;
assign valid_out = valid_in && (byte_cnt_reg == BYTE_CNT_WD+1);

endmodule

