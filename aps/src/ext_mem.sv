
module ext_mem(
input  logic          clk_i,
input  logic          mem_req_i,
input  logic          write_enable_i,
input  logic   [ 3:0] bite_enable_i,
input  logic   [31:0] addr_i,
input  logic   [31:0] write_data_i,

output logic   [31:0] read_data_o,
output logic          ready_o
    );
    
  logic [31:0] memory [4096];
  logic [31:0] temp;  
  logic [31:0] num;
  
  assign num = addr_i / 4; 
  assign ready_o = 1; 
  
  initial $readmemh("init_data.mem", memory);


    always_comb begin
    if ( ~mem_req_i || write_enable_i )
      read_data_o = 32'hfa11_1eaf;
    else if ( mem_req_i && ( num < 4096) )
      read_data_o = temp;
    else if ( mem_req_i && ( num > 4096) )
      read_data_o = 32'hdead_beef;
    else
      read_data_o = read_data_o;
    end
    
     always_ff @( posedge clk_i ) begin
    if ( write_enable_i && mem_req_i )
    begin
       if(bite_enable_i[3])
      memory[ num ][31:24] <= write_data_i[31:24];
      
       if(bite_enable_i[2])
      memory[ num ][23:16] <= write_data_i[23:16];
      
       if(bite_enable_i[1])
      memory[ num ][15:8] <= write_data_i[15:8];
      
       if(bite_enable_i[0])
      memory[ num ][7:0] <= write_data_i[7:0];
    end
  end
  
  always_ff @( posedge clk_i ) begin
    if ( mem_req_i )
      temp <= memory[ num ];
    else 
      temp <= temp;
  end
    
endmodule
