
module uart_tx_sb_ctrl(

input  logic        clk_i,
input  logic        rst_i,
input  logic [31:0] addr_i,
input  logic        req_i,
input  logic [31:0] write_data_i,
input  logic        write_enable_i,
output logic [31:0] read_data_o,

output logic        tx_o
);
//===================was=============
logic       busy;
logic[16:0] baudrate;
logic       parity_en;
logic       stopbit;
logic [7:0] data;
//===================my==============
logic        tx_valid;
logic        rst_valid;
logic  [7:0] tx_data;
logic        busy_o;
//============read_write_rst==============
assign write_req = write_enable_i & req_i ;
assign read_req = !write_enable_i & req_i ;
assign rst = rst_i | (addr_i == 32'h24 & write_req & rst_valid );
//=================rst====================
always_comb 
begin
    if (write_data_i == 32'd1 & write_req) rst_valid = 1;
    else rst_valid = 0;
end
//============module_tx_uart==============
uart_tx tx_inst(
    .clk_i(clk_i),
    .rst_i(rst),
    .tx_o(tx_o),
    .busy_o(busy_o),
    .baudrate_i(baudrate),
    .parity_en_i(parity_en),
    .stopbit_i(stopbit),
    .tx_data_i(tx_data),
    .tx_valid_i(tx_valid)
);
//====================busy_update===================
always_ff @(posedge clk_i)
begin
    if(rst) 
    begin
        busy    <= 1'b0;
    end
    else
    begin
        busy    <= busy_o;
    end
end

always_ff @(posedge clk_i)
begin
    if(!busy)
    begin
        case(addr_i)
            32'h0 : tx_data <= data;
        endcase
    end
end
//===========================read==============
always_comb begin
    if(read_req)
    begin
        case(addr_i)
            32'h00  : read_data_o <= {24'd0, data};
            32'h04  : read_data_o <= {31'd0, tx_valid};
            32'h08  : read_data_o <= {31'd0, busy};
            32'h0C  : read_data_o <= {15'd0, baudrate};
            32'h10  : read_data_o <= {31'd0, parity_en};
            32'h14  : read_data_o <= {31'd0, stopbit};
            default : read_data_o <= read_data_o;
        endcase
    end
end
//===========================write==============
always_comb 
begin
    if(!rst)
    begin
        if(!busy & write_req)
        begin
            case(addr_i)
                32'h0  :  data  <= write_data_i[7:0];
                32'hc  :  baudrate  <= write_data_i[16:0];
                32'h10 :  parity_en <= write_data_i[0];
                32'h14 :  stopbit   <= write_data_i[0];
            endcase
        end
    end
    else 
        begin
            baudrate  <= 32'd9600;
            parity_en <= 1'b1;
            stopbit   <= 1'b1;
            data      <= 8'b0;
        end
end    




always_ff @(posedge clk_i)
begin
    if(rst) tx_valid <= 1'b0;
    else if(!busy & ( write_req & addr_i == 32'h0)) 
    tx_valid <= 1'b1;
    else 
    tx_valid <= 1'b0;
end
endmodule
