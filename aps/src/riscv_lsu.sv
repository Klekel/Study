

module riscv_lsu(
input logic         clk_i,
input logic         rst_i,

input logic         core_req_i,
input logic         core_we_i,
input logic  [ 2:0] core_size_i,
input logic  [31:0] core_addr_i,
input logic  [31:0] core_wd_i,
output logic [31:0] core_rd_o,
output logic        core_stall_o,

output logic        mem_req_o,
output logic        mem_we_o,
output logic [ 3:0] mem_be_o,
output logic [31:0] mem_addr_o,
output logic [31:0] mem_wd_o,
input  logic [31:0] mem_rd_i,
input  logic        mem_ready_i
    );
import riscv_pkg::*; 

     
logic [31:0] data_B  [3:0];
logic [31:0] data_BU [3:0];
logic [31:0] data_H  [1:0];
logic [31:0] data_HU [1:0];

logic [31:0] data_B_result;
logic [31:0] data_BU_result;
logic [31:0] data_H_result;
logic [31:0] data_HU_result;

logic [ 3:0] mp_H_result;
logic [ 3:0] B_signal;

logic [ 1:0] byte_offset;
logic        half_offset;

assign byte_offset = core_addr_i[1:0];
assign half_offset = core_addr_i[1];

//чтение данных из памяти
 always_comb begin
       //знаковый байт 
       data_B[0]  <= { {24{mem_rd_i[7]}}  , mem_rd_i[ 7: 0] } ; 
       data_B[1]  <= { {24{mem_rd_i[15]}} , mem_rd_i[15: 8] } ; 
       data_B[2]  <= { {24{mem_rd_i[23]}} , mem_rd_i[23:16] } ; 
       data_B[3]  <= { {24{mem_rd_i[31]}} , mem_rd_i[31:24] } ;
       //беззнаковый байт
       data_BU[0] <= {  24'b0             , mem_rd_i[ 7: 0] } ; 
       data_BU[1] <= {  24'b0             , mem_rd_i[15: 8] } ; 
       data_BU[2] <= {  24'b0             , mem_rd_i[23:16] } ; 
       data_BU[3] <= {  24'b0             , mem_rd_i[31:24] } ; 
       //знаковое полуслово
       data_H[0]  <= { {16{mem_rd_i[15]}} , mem_rd_i[15: 0] } ;
       data_H[1]  <= { {16{mem_rd_i[31]}} , mem_rd_i[31:16] } ;
       //беззнаковое полуслово
       data_HU[0] <= { 16'b0              , mem_rd_i[15: 0] } ;
       data_HU[1] <= { 16'b0              , mem_rd_i[31:16] } ;       
 end 
 
  
    
 assign  mem_addr_o = core_addr_i;
 assign  mem_we_o   = core_we_i   ;   
 assign  mem_req_o  = core_req_i;
 
 
 always_comb begin
    case(core_size_i)
         LDST_B : mem_wd_o <= {{4{core_wd_i[7:0]}}};
         LDST_H : mem_wd_o <= {{2{core_wd_i[15:0]}}};  
         LDST_W : mem_wd_o <= core_wd_i;
    endcase 
 end
    
    
 always_ff @( posedge clk_i ) begin
       if(rst_i)    core_stall_o <= 0;
       else         core_stall_o <= ( ~( core_stall_o & mem_ready_i ) & core_req_i );   
 end
 
 
 always_comb begin
 //знаковый байт 
    case(byte_offset)
        2'd0 : data_B_result <= data_B[0];
        2'd1 : data_B_result <= data_B[1];
        2'd2 : data_B_result <= data_B[2];
        2'd3 : data_B_result <= data_B[3];
    endcase
 //беззнаковый байт  
    case(byte_offset)
        2'd0 : data_BU_result <= data_BU[0];
        2'd1 : data_BU_result <= data_BU[1];
        2'd2 : data_BU_result <= data_BU[2];
        2'd3 : data_BU_result <= data_BU[3];
    endcase
 //знаковое полуслово   
     case(half_offset)
        1'd0 : data_H_result <= data_H[0];
        1'd1 : data_H_result <= data_H[1];
    endcase
 //беззнаковое полуслово   
    case(half_offset)
        1'd0 : data_HU_result <= data_HU[0];
        1'd1 : data_HU_result <= data_HU[1];
    endcase
    
 end


//мультиплексор на чтение из памяти    
 always_comb begin
    case(core_size_i)
        LDST_B  : core_rd_o <= data_B_result;
        LDST_H  : core_rd_o <= data_H_result;
        LDST_W  : core_rd_o <= mem_rd_i;
        LDST_BU : core_rd_o <= data_BU_result;
        LDST_HU : core_rd_o <= data_HU_result;
    endcase
 end  
 
 assign   B_signal = 4'b0001 << byte_offset;
 
// мультиплексор для полуслов
   always_comb begin
    case(half_offset)
         1'b0 : mp_H_result <= 4'b0011;
         1'b1 : mp_H_result <= 4'b1100;  
    endcase 
 end  
 
 // мультиплексор для выбора режима записи
  always_comb begin
    case(core_size_i)
         LDST_B : mem_be_o <= B_signal;
         LDST_H : mem_be_o <= mp_H_result;  
         LDST_W : mem_be_o <= 4'b1111;
    endcase 
 end   
    
endmodule
