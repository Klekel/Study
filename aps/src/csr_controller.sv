
module csr_controller(
    input logic        clk_i,
    input logic        rst_i,
    input logic        trap_i,

    input logic [ 2:0] opcode_i,

    input logic [11:0] addr_i,
    input logic [31:0] pc_i,
    input logic [31:0] mcause_i,
    input logic [31:0] rs1_data_i,
    input logic [31:0] imm_data_i,
    input logic        write_enable_i,

    output logic [31:0] read_data_o,
    output logic [31:0] mie_o,
    output logic [31:0] mepc_o,
    output logic [31:0] mtvec_o
);

import csr_pkg::*;

logic MIE_ADDR_en;
logic MTVEC_ADDR_en;
logic MSCRATCH_ADDR_en;
logic MEPC_ADDR_en;
logic MCAUSE_ADDR_en;


logic [31:0] MSCRATCH_o;
logic [31:0] MCAUSE_o;


logic [31:0] mepc_mux_o;
logic [31:0] mcause_mux_o;


//мультиплексор
logic [31:0] mux1;
always_comb begin
    case(opcode_i)
        CSR_RW  : mux1 <= rs1_data_i;
        CSR_RS  : mux1 <= rs1_data_i | read_data_o;
        CSR_RC  : mux1 <= ~rs1_data_i & read_data_o;
        CSR_RWI : mux1 <= imm_data_i;
        CSR_RSI : mux1 <= imm_data_i | read_data_o;
        CSR_RCI : mux1 <= ~imm_data_i & read_data_o;
        default : mux1 <= 32'b0;
    endcase
end
// демультиплексор
always_comb begin
    case(addr_i)
        MIE_ADDR       : begin
        MIE_ADDR_en      <= write_enable_i;
        MTVEC_ADDR_en    <=  0;
        MSCRATCH_ADDR_en <=  0;
        MEPC_ADDR_en     <=  0;
        MCAUSE_ADDR_en   <=  0;
        end
        MTVEC_ADDR     : begin
        MTVEC_ADDR_en    <= write_enable_i;
        MIE_ADDR_en      <=  0;
        MSCRATCH_ADDR_en <=  0;
        MEPC_ADDR_en     <=  0;
        MCAUSE_ADDR_en   <=  0;
        end
        
        MSCRATCH_ADDR  : begin
        MSCRATCH_ADDR_en  <= write_enable_i;
        MIE_ADDR_en       <=  0;
        MTVEC_ADDR_en     <=  0;
        MEPC_ADDR_en      <=  0;
        MCAUSE_ADDR_en    <=  0;
        end
        MEPC_ADDR      : begin
        MEPC_ADDR_en      <= write_enable_i;
        MIE_ADDR_en       <=  0;
        MSCRATCH_ADDR_en  <=  0;
        MTVEC_ADDR_en     <=  0;
        MCAUSE_ADDR_en    <=  0;
        end
        MCAUSE_ADDR    : begin
        MCAUSE_ADDR_en    <= write_enable_i;
        MIE_ADDR_en       <=  0;
        MSCRATCH_ADDR_en  <=  0;
        MEPC_ADDR_en      <=  0;
        MTVEC_ADDR_en     <=  0;
        end
       default: begin 
        MCAUSE_ADDR_en    <= 0;
        MIE_ADDR_en       <=  0;
        MSCRATCH_ADDR_en  <=  0;
        MEPC_ADDR_en      <=  0;
        MTVEC_ADDR_en     <=  0;
       end 

    endcase
end
// мультиплексор
always_comb begin
    case(addr_i)
        MIE_ADDR       : read_data_o  = mie_o;
        MTVEC_ADDR     : read_data_o  = mtvec_o;
        MSCRATCH_ADDR  : read_data_o  = MSCRATCH_o;
        MEPC_ADDR      : read_data_o  = mepc_o;
        MCAUSE_ADDR    : read_data_o  = MCAUSE_o;
        default        : read_data_o = 0;
    endcase
end
//
always_comb begin
    case(trap_i)
        0 : mepc_mux_o = mux1;
        1 : mepc_mux_o = pc_i;
    endcase
end
//
always_comb begin
    case(trap_i)
        0 : mcause_mux_o = mux1;
        1 : mcause_mux_o = mcause_i;
    endcase
end
//mie_o
always_ff @( posedge clk_i ) begin
    if(rst_i) mie_o = 0;
    else if(MIE_ADDR_en) mie_o = mux1;
    else mie_o = mie_o;
end
//mtvec_o
always_ff @( posedge clk_i ) begin
    if(rst_i) mtvec_o = 0;
    else if(MTVEC_ADDR_en) mtvec_o = mux1;

end
//MSCRATCH
always_ff @( posedge clk_i ) begin
    if(rst_i) MSCRATCH_o = 0;
    else if(MSCRATCH_ADDR_en) MSCRATCH_o = mux1;
    else MSCRATCH_o = MSCRATCH_o;
end
//MEPC
always_ff @( posedge clk_i ) begin
    if(rst_i) mepc_o= 0;
    else if(MEPC_ADDR_en | trap_i) mepc_o = mepc_mux_o;
    else mepc_o = mepc_o;
end
//MCAUSE
always_ff @( posedge clk_i ) begin
    if(rst_i) MCAUSE_o = 0;
    else if(MCAUSE_ADDR_en | trap_i) MCAUSE_o = mcause_mux_o;
    else MCAUSE_o = MCAUSE_o;
end
endmodule
