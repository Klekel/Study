

 module riscv_core(

input logic          clk_i,
input logic          rst_i,

input logic          stall_i,
input logic  [31:0]  instr_i,
input logic  [31:0]  mem_rd_i,

input logic          irq_req_i,

output logic [31:0]  instr_addr_o,
output logic [31:0]  mem_addr_o,
output logic [ 2:0]  mem_size_o,
output logic         mem_req_o,
output logic         mem_we_o,
output logic         irq_ret_o,
output logic [31:0]  mem_wd_o
    );
    
  
  logic [31:0]  wb_data;
  logic [31:0]  read_data1 ;
  logic [31:0]  read_data2 ;
  logic         write_enable;  
 
  logic [4:0]   alu_op;
  logic [2:0]   csr_op;        
  logic         csr_we;      
  logic         mem_req;       
  logic         mem_we;        
  logic [2:0]   mem_size;     
  logic         gpr_we;       
  logic [1:0]   wb_sel;       
  logic         illegal_instr;
  logic         branch;        
  logic         jal;         
  logic         jalr;         
  logic         mret;
  
  logic [31:0]  result;  
  logic         flag;
  
  logic [ 1:0]  mp_a;
  logic [31:0]  mp_a_sign;
  
  logic [ 2:0]  mp_b;
  logic [31:0]  mp_b_sign;
  
  logic [31:0]  mp_1_sign;
  logic [31:0]  mp_2_sign;
  
  logic [31:0]  mp_jalr_sign;
  
  logic         mp_2;

  logic [31:0] PC_o;
  
  //csr_controller
  logic [31:0] csr_wd;
  logic [31:0] mie;
  logic [31:0] mtvec;
  logic [31:0] mepc;
  logic        trap;
  logic [31:0] mcause;
  logic [31:0] csr_mux1;
  logic [31:0] csr_mux2;
  //interrupt_controller
  logic        irq;
  logic [31:0] irq_cause;


  //���������������
  logic [31:0]  imm_I;
  logic [31:0]  imm_U;
  logic [31:0]  imm_S;
  logic [31:0]  imm_B;
  logic [31:0]  imm_J;
  logic [31:0]  imm_Z;
    
    rf_riscv rf(
   .clk_i           (clk_i),
   .write_enable_i  (write_enable),
   .write_addr_i    (instr_i[11: 7] ),
   .read_addr1_i    (instr_i[19:15]),
   .read_addr2_i    (instr_i[24:20]),
   .write_data_i    (wb_data),
   .read_data1_o    (read_data1),
   .read_data2_o    (read_data2)
    );
  
    alu_riscv alu(
   .a_i       (mp_a_sign),
   .b_i       (mp_b_sign),
   .alu_op_i  (alu_op),
   .flag_o    (flag),
   .result_o  (result)
    );
    
    decoder_riscv dc(
   .fetched_instr_i   (instr_i), 
   .a_sel_o           (mp_a),         
   .b_sel_o           (mp_b),         
   .alu_op_o          (alu_op),        
   .csr_op_o          (csr_op),        
   .csr_we_o          (csr_we),       
   .mem_req_o         (mem_req),       
   .mem_we_o          (mem_we),        
   .mem_size_o        (mem_size_o),      
   .gpr_we_o          (gpr_we),        
   .wb_sel_o          (wb_sel),        
   .illegal_instr_o   (illegal_instr), 
   .branch_o          (branch),        
   .jal_o             (jal),           
   .jalr_o            (jalr),          
   .mret_o            (mret)           
    );
    
    
    csr_controller csr(
   .clk_i(clk_i),
   .rst_i(rst_i),
   .trap_i(trap),
   .opcode_i(csr_op),
   .addr_i(instr_i[31:20]),
   .pc_i(PC_o),
   .mcause_i(mcause),
   .rs1_data_i(read_data1),
   .imm_data_i(imm_Z),
   .write_enable_i(csr_we),
   
   .read_data_o(csr_wd),
   .mie_o(mie),
   .mepc_o(mepc),
   .mtvec_o(mtvec)
    );


    interrupt_controller inter(
   .clk_i(clk_i),
   .rst_i(rst_i),
   .exception_i(illegal_instr),
   .irq_req_i(irq_req_i),
   .mie_i(mie[0]),
   .mret_i(mret),
   
   .irq_ret_o(irq_ret_o),
   .irq_cause_o(irq_cause),
   .irq_o(irq)
    );
    //csr_controller and interrupt_controller integration
    assign opcode_i = csr_op;
    always_comb begin
      case(illegal_instr)
      0: mcause <= irq_cause;
      1: mcause <= 32'h00000002;
      endcase
    end
    
    assign mem_req_o = ~trap & mem_req;
    assign mem_we_o = ~trap & mem_we;
    assign write_enable = gpr_we & ~(stall_i | trap);
    assign trap = irq | illegal_instr;
    
    //������������� csr
    always_comb begin
      case(trap)
      0: csr_mux1 <= mp_jalr_sign;
      1: csr_mux1 <= mtvec;
      endcase
    end
    always_comb begin
/*      case(mret)
      0: csr_mux2 <= mp_jalr_sign;
      1: csr_mux2 <= csr_mux1;
      endcase
    end*/
          case(mret)
      0: csr_mux2 <= csr_mux1;
      1: csr_mux2 <= mepc;
      endcase
    end
    
    assign mem_wd_o = read_data2 ;
    
    //����������� �������
    
    always_ff @(posedge clk_i) 
    begin
      if(rst_i)PC_o <= 0;
      else if(stall_i == 0)PC_o <= csr_mux2;
      else PC_o <= PC_o;
    end
    
     assign instr_addr_o = PC_o;
   //���������������
   assign imm_I = { {20{instr_i[31]}} , instr_i[31:20] };
   assign imm_U = { {instr_i[31:12] } , 12'b0 };
   assign imm_S = { {20{instr_i[31]}} , instr_i[31:25] , instr_i[11:7] };
   assign imm_B = { {19{instr_i[31]}} , instr_i[31]    , instr_i[7]     , instr_i[30:25] , instr_i[11: 8] , 1'b0 };
   assign imm_J = { {11{instr_i[31]}} , instr_i[31]    , instr_i[19:12] , instr_i[20]    , instr_i[30:21] , 1'b0 };
   assign imm_Z = {27'b0, {instr_i[19:15]}};
    
    //������������� �� ���� ������������ ��������
    logic [31:0] temp;
    assign temp = read_data1 + imm_I;
    always_comb
    begin
      case(jalr)
          0: mp_jalr_sign <= PC_o + mp_2_sign;
          1: mp_jalr_sign <= { {temp[31:1] } , 1'b0 };
      endcase
    end
    
    //�������������� ��� ���������
    //1
    always_comb
    begin
      case(branch)
          0: mp_1_sign <= imm_J;
          1: mp_1_sign <= imm_B;
      endcase
    end
    
    //2
    assign mp_2 = (jal || (flag && branch));
    
    always_comb
    begin
      case(mp_2)
          0: mp_2_sign <= 32'd4;
          1: mp_2_sign <= mp_1_sign;
      endcase
    end
    
    //�������������� ��� ������� ������������ ������
    always_comb
    begin
      case(mp_a)
          2'd0:     mp_a_sign <= read_data1;
          2'd1:     mp_a_sign <= PC_o;
          2'd2:     mp_a_sign <= 32'd0;
          default:  mp_a_sign <= 32'd0;
      endcase
    end
    
    //�������������� ��� ������� ������������ ������
    always_comb
    begin
      case(mp_b)
          3'd0:      mp_b_sign <= read_data2;
          3'd1:      mp_b_sign <= imm_I;
          3'd2:      mp_b_sign <= imm_U;
          3'd3:      mp_b_sign <= imm_S;
          3'd4:      mp_b_sign <= 32'd4;
          default:   mp_b_sign <= 32'd0;  
      endcase
    end
    
    assign mem_addr_o = result;
    
    //������������� ������ � ������
    always_comb
    begin
      case(wb_sel)
          0: wb_data   <= result;
          1: wb_data   <= mem_rd_i;
          2: wb_data   <= csr_wd;
          default: wb_data <= 0;
      endcase
    end
    
    
endmodule
