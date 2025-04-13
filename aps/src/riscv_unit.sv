

module riscv_unit(
input logic  clk_i,
input logic  resetn_i,

input logic   [15:0] sw_i,

output logic  [15:0] led_o,

input logic          kclk_i,
input logic          kdata_i,

output logic  [6:0]  hex_led_o,
output logic  [7:0]  hex_sel_o,

input logic          rx_i,
output logic         tx_o,

output logic  [3:0]  vga_r_o,
output logic  [3:0]  vga_g_o,
output logic  [3:0]  vga_b_o,
output logic         vga_hs_o,
output logic         vga_vs_o
    );
  
  logic sysclk, rst;
  sys_clk_rst_gen divider(
  .ex_clk_i(clk_i),
  .ex_areset_n_i(resetn_i),
  .div_i(5),
  .sys_clk_o(sysclk),
  .sys_reset_o(rst)
  );
  
  
  logic [31:0] instr;
  logic [31:0] instr_addr;
  logic        stall;
  logic [31:0] read_cl;
  logic [31:0] read_ld;
  logic        mem_req;
  logic        mem_req_ld;
  logic        mem_we_cl;
  logic        mem_we_ld;
  logic [ 2:0] mem_size;
  logic [31:0] write_cl;
  logic [31:0] write_ld;
  logic [31:0] addr_cl;
  logic [31:0] addr_ld;
  logic [ 3:0] BE;
  logic        ready;
  logic        irq_req;
  logic        irq_ret;
  
  logic [255:0] out;
  logic [31:0] read_data;
  logic [31:0] read_rx;
  logic [31:0] read_tx;
  
  assign out = 256'b1 <<  addr_ld[31:24];
  
  always_comb
  begin
      case(addr_ld[31:24])
          8'h0 : read_ld <= read_data;
          8'h5 : read_ld <= read_rx;
          8'h6 : read_ld <= read_tx;
        default: read_ld <= read_ld;
      endcase
  end

riscv_lsu lsu(
.clk_i          (sysclk),
.rst_i          (rst),
.core_req_i     (mem_req),
.core_we_i      (mem_we_cl),
.core_size_i    (mem_size),
.core_addr_i    (addr_cl),
.core_wd_i      (write_cl),
.core_rd_o      (read_cl),
.core_stall_o   (stall),
.mem_req_o      (mem_req_ld),
.mem_we_o       (mem_we_ld),
.mem_be_o       (BE),
.mem_addr_o     (addr_ld),
.mem_wd_o       (write_ld),
.mem_rd_i       (read_ld),
.mem_ready_i    (ready)
);

ext_mem emem(
.clk_i          (sysclk),
.mem_req_i      (mem_req_ld & out[0]),
.write_enable_i (mem_we_ld),
.bite_enable_i  (BE),
.addr_i         ({18'b0 , addr_ld[13:0] }),
.write_data_i   (write_ld),
.read_data_o    (read_data),
.ready_o        (ready)
);    

riscv_core core(
.irq_req_i     (irq_req),
.clk_i         (sysclk),
.rst_i         (rst),
.stall_i       (stall),
.instr_i       (instr),
.mem_rd_i      (read_cl),
.instr_addr_o  (instr_addr),
.mem_addr_o    (addr_cl),
.mem_size_o    (mem_size),
.mem_req_o     (mem_req),
.mem_we_o      (mem_we_cl),
.irq_ret_o     (irq_ret),
.mem_wd_o      (write_cl)
);   
    
instr_mem instruct(
.addr_i        (instr_addr),
.read_data_o   (instr)
);

uart_rx_sb_ctrl  uart_rx_ctrl(
.clk_i(sysclk),
.rst_i(rst),
.addr_i({8'b0 , addr_ld[23:0] }),
.req_i(mem_req_ld & out[5]),
.write_data_i(write_ld),
.write_enable_i(mem_we_ld),
.read_data_o(read_rx),
.interrupt_request_o(irq_req),
.interrupt_return_i(irq_ret),
.rx_i(rx_i)
);

uart_tx_sb_ctrl uart_tx_ctrl(
.clk_i(sysclk),
.rst_i(rst),
.addr_i({8'b0 , addr_ld[23:0] }),
.req_i(mem_req_ld & out[6]),
.write_data_i(write_ld),
.write_enable_i(mem_we_ld),
.read_data_o(read_tx),
.tx_o(tx_o)
);
endmodule
