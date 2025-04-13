

module rf_riscv(
  input  logic        clk_i,
  input  logic        write_enable_i,
  
  input  logic [4:0]  write_addr_i,
  input  logic [4:0]  read_addr1_i,
  input  logic [4:0]  read_addr2_i,
  
  input  logic [31:0] write_data_i,
  output logic [31:0] read_data1_o,
  output logic [31:0] read_data2_o
    );
  
  logic [31:0] rf_mem [32];
  // initial и обнулить све регистры
  initial begin
    for(int i = 0; i < $size(rf_mem); i++)
      rf_mem[i] = '0;
  end

  
  always_ff @( posedge clk_i ) begin
    if ( write_enable_i )
      rf_mem[ write_addr_i ] <= write_data_i;
  end
  
  
  always_comb begin
    if ( read_addr1_i == 0 )  
      read_data1_o <= 32'd0;
    else 
      read_data1_o <= rf_mem[ read_addr1_i ];
  end
  
  always_comb begin
    if ( read_addr2_i == 0 )
      read_data2_o <= 32'd0;
    else 
      read_data2_o <= rf_mem[ read_addr2_i ];
  end
  
  
endmodule
