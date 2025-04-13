

module uart_rx_sb_ctrl(
input  logic        clk_i,
input  logic        rst_i,
input  logic [31:0] addr_i,
input  logic        req_i,
input  logic [31:0] write_data_i,
input  logic        write_enable_i,
output logic [31:0] read_data_o,

output logic        interrupt_request_o,
input  logic        interrupt_return_i,

input  logic        rx_i
);


//===================was============================
logic [7:0] rx_data;   
logic       rx_valid;      
logic       busy;
logic[16:0] baudrate;
logic       parity_en;
logic       stopbit;
logic [7:0] data;
logic       valid;    
//===================my=============================
logic busy_o;
logic write_req;  
logic read_req;  
logic rst;
logic rst_valid;
//============read_write_rst_interrupt==============
assign write_req = write_enable_i & req_i ;
assign read_req = !write_enable_i & req_i ;
assign rst = rst_i | (addr_i == 32'h24 & write_req & rst_valid );    
assign interrupt_request_o = valid;
//=================rst==============================
always_comb 
begin
    if (write_data_i == 32'd1 & write_req) rst_valid = 1;
    else rst_valid = 0;
end
//===================module_rx_uart=================
uart_rx rx_inst(
        .clk_i(clk_i),
        .rst_i(rst),
        .rx_i(rx_i),
        .busy_o(busy_o),
        .baudrate_i(baudrate),
        .parity_en_i(parity_en),
        .stopbit_i(stopbit),
        .rx_data_o(rx_data),
        .rx_valid_o(rx_valid)
    );
//====================busy_valid_update===================
always_ff @(posedge clk_i)
begin
    if(rst) 
    begin
        busy  <= 1'b0;
    end
    else
    begin
        busy  <= busy_o;
    end
    
    
    if(rst)data <= 0;
    else if(rx_valid) data  <= rx_data;
    else if(~rst & ~busy & write_req & addr_i == 32'h00 ) data <= write_data_i[7:0];
    else data <= data;
    
    
        if( interrupt_return_i | (read_req & addr_i == 32'h0 ) | rst )//mb_delete_rst
            begin
                valid <= 1'b0;
            end
        else if(rx_valid) valid <= 1'b1;
end
//===========================read==============
always_ff @(posedge clk_i) 
begin
if(read_req)
    begin
        case(addr_i)
            32'h00  : read_data_o <= {24'd0, data};
            32'h04  : read_data_o <= {31'd0, valid};
            32'h08  : read_data_o <= {31'd0, busy};
            32'h0C  : read_data_o <= {15'd0, baudrate};
            32'h10  : read_data_o <= {31'd0, parity_en};
            32'h14  : read_data_o <= {31'd0, stopbit};
            default : read_data_o <= read_data_o;
        endcase
    end
end    
//==================write======================
always_comb 
begin
    if(rst)
    begin
            baudrate  <= 17'd9600;
            parity_en <= 1'b1;
            stopbit   <= 1'b1;
    end
    else 
        begin
            if(!busy & write_req)
        begin
            case(addr_i)          
                32'hc  :  baudrate  <= write_data_i[16:0];
                32'h10 :  parity_en <= write_data_i[0];
                32'h14 :  stopbit   <= write_data_i[0];
            endcase
        end
        end
end    


endmodule
