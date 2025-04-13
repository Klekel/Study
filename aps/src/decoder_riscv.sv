
module decoder_riscv (
  input  logic [31:0]  fetched_instr_i,
  output logic [1:0]   a_sel_o,
  output logic [2:0]   b_sel_o,
  output logic [4:0]   alu_op_o,
  output logic [2:0]   csr_op_o,
  output logic         csr_we_o,
  output logic         mem_req_o,
  output logic         mem_we_o,
  output logic [2:0]   mem_size_o,
  output logic         gpr_we_o,
  output logic [1:0]   wb_sel_o,
  output logic         illegal_instr_o,
  output logic         branch_o,
  output logic         jal_o,
  output logic         jalr_o,
  output logic         mret_o
);
import riscv_pkg::*;

logic [6:0] opcode;
logic [2:0] func3;
logic [6:0] func7;

assign opcode = fetched_instr_i[6:0];
assign func3  = fetched_instr_i[14:12];
assign func7  = fetched_instr_i[31:25];

always_comb begin
  a_sel_o         <= '0;
  b_sel_o         <= '0;
  wb_sel_o        <= '0;
  alu_op_o        <= '0;
  csr_we_o        <= '0;
  csr_op_o        <= '0;
  mem_req_o       <= '0;
  mem_we_o        <= '0;
  gpr_we_o        <= '0;
  illegal_instr_o <= '0;
  branch_o        <= '0;
  jal_o           <= '0;
  jalr_o          <= '0;
  mret_o          <= '0;
  if ( opcode[1:0] == 2'b11 ) begin
    case (opcode[6:2])
      LOAD_OPCODE    :  case (func3)
                          3'd0: begin //lb
                                  a_sel_o    <= '0;
                                  b_sel_o    <= 3'd1;
                                  wb_sel_o   <= 2'd1;
                                  gpr_we_o   <= 1;
                                  alu_op_o   <= ALU_ADD;
                                  mem_size_o <= LDST_B;
                                  mem_req_o  <= '1;
                                end
                          3'd1: begin //lh
                                  a_sel_o    <= '0;
                                  b_sel_o    <= 3'd1;
                                  wb_sel_o   <= 2'd1;
                                  gpr_we_o   <= 1;                                  
                                  alu_op_o   <= ALU_ADD;
                                  mem_size_o <= LDST_H;
                                  mem_req_o  <= '1;
                                end
                          3'd2: begin //lw
                                  a_sel_o    <= '0;
                                  b_sel_o    <= 3'd1;
                                  wb_sel_o   <= 2'd1;
                                  gpr_we_o   <= 1;
                                  alu_op_o   <= ALU_ADD;
                                  mem_size_o <= LDST_W;
                                  mem_req_o  <= '1;
                                end
                          3'd4: begin //lbu
                                  a_sel_o    <= '0;
                                  b_sel_o    <= 3'd1;
                                  wb_sel_o   <= 2'd1;
                                  gpr_we_o   <= 1;
                                  alu_op_o   <= ALU_ADD;
                                  mem_size_o <= LDST_BU;
                                  mem_req_o  <= '1;
                                end
                          3'd5: begin //lhu
                                  a_sel_o    <= '0;
                                  b_sel_o    <= 3'd1;
                                  wb_sel_o   <= 2'd1;
                                  gpr_we_o   <= 1;
                                  alu_op_o   <= ALU_ADD;
                                  mem_size_o <= LDST_HU;
                                  mem_req_o  <= '1;
                                end
                        default: illegal_instr_o <= '1;
                        endcase
      MISC_MEM_OPCODE:  if (func3 == 3'd0) begin end
                        else illegal_instr_o <= '1;
      OP_IMM_OPCODE  :  case (func3) 
                          3'd0: begin // add with const. addi
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd1;
                                  alu_op_o <= ALU_ADD;
                                  gpr_we_o <= 1;
                                end 
                          3'd4: begin // XOR with const. xori
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd1;
                                  alu_op_o <= ALU_XOR;
                                  gpr_we_o <= 1;
                                end 
                          3'd6: begin // OR with const. ori
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd1;
                                  alu_op_o <= ALU_OR;
                                  gpr_we_o <= 1;
                                end 
                          3'd7: begin // AND with const. andi
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd1;
                                  alu_op_o <= ALU_AND;
                                  gpr_we_o <= 1;
                                end 
                            3'd1: begin //slli
                                    if (func7 == 7'd0) begin//logical shift left
                                      a_sel_o <= 2'd0;
                                      b_sel_o <= 3'd1;
                                      alu_op_o <= ALU_SLL;
                                      gpr_we_o <= 1'd1;
                                    end
                                    else illegal_instr_o <= 1;
                                  end
                            3'd5: begin 
                                    case (func7)
                                      7'd0: begin //logical shift right. srli
                                              a_sel_o <= 2'd0;
                                              b_sel_o <= 3'd1;
                                              alu_op_o <= ALU_SRL;
                                              gpr_we_o <= 1'd1;
                                            end
                                      7'h20: begin //arithmetic shift right. srai
                                              a_sel_o <= 2'd0;
                                              b_sel_o <= 3'd1;
                                              alu_op_o <= ALU_SRA;
                                              gpr_we_o <= 1;
                                            end
                                    default: illegal_instr_o <= 1;
                                    endcase
                                  end
                            3'd2: begin
                                    //result of comparison//slti
                                    a_sel_o <= 2'd0;
                                    b_sel_o <= 3'd1;
                                    alu_op_o <= ALU_SLTS;
                                    gpr_we_o <= 1;
                                  end
                            3'd3: begin //Unsigned comparison//sltiu
                                    a_sel_o <= 2'd0;
                                    b_sel_o <= 3'd1;
                                    alu_op_o <= ALU_SLTU;
                                    gpr_we_o <= 1;
                                  end 
                        default: illegal_instr_o <= '1;
                        endcase
      AUIPC_OPCODE   :  begin  //save the instruction counter as a sum with constant << 12
                          a_sel_o <= 2'd1; //auipc
                          b_sel_o <= 3'd2;
                          alu_op_o <= ALU_ADD;
                          gpr_we_o <= 1;
                        end 
      STORE_OPCODE   :  case (func3) 
                          3'd0: begin //sb
                                  b_sel_o    <= 3'd3;
                                  mem_req_o  <= 1'd1;
                                  mem_we_o   <= 1'd1;
                                  mem_size_o <= LDST_B;
                                end
                          3'd1: begin //sh
                                  mem_req_o  <= 1'd1;
                                  mem_we_o   <= 1'd1;
                                  mem_size_o <= LDST_H;
                                  b_sel_o    <= 3'd3;
                                end
                          3'd2: begin //sw
                                  b_sel_o    <= 3'd3;
                                  mem_req_o  <= 1'd1;
                                  mem_we_o   <= 1'd1;
                                  mem_size_o <= LDST_W;
                                end
                        default: illegal_instr_o <= 1;
                        endcase
      OP_OPCODE      :  case (func3) 
                          3'd0: case (func7)
                                  7'd0:   begin //add
                                            a_sel_o <= 2'd0;
                                            b_sel_o <= 3'd0;
                                            alu_op_o  <= ALU_ADD;
                                            gpr_we_o <= 1;
                                          end
                                  7'h20:  begin //sub
                                            a_sel_o <= 2'd0;
                                            b_sel_o <= 3'd0;
                                            alu_op_o  <= ALU_SUB;
                                            gpr_we_o <= 1;
                                          end
                                default: illegal_instr_o <= 1;
                                endcase
                          3'd4: case (func7)//xor
                                  7'd0: begin
                                          a_sel_o <= 2'd0;
                                          b_sel_o <= 3'd0;
                                          alu_op_o  <= ALU_XOR;
                                          gpr_we_o <= 1;
                                        end
                                default: illegal_instr_o <= 1;
                                endcase
                          3'd6: case (func7)//or
                                  7'd0: begin
                                          a_sel_o <= 2'd0;
                                          b_sel_o <= 3'd0;
                                          alu_op_o  <= ALU_OR;
                                          gpr_we_o <= 1;
                                        end
                                default: illegal_instr_o <= 1;
                                endcase 
                          3'd7: case (func7)//and
                                  7'd0: begin
                                          a_sel_o <= 2'd0;
                                          b_sel_o <= 3'd0;
                                          alu_op_o  <= ALU_AND;
                                          gpr_we_o <= 1;
                                        end
                                default: illegal_instr_o <= 1;
                                endcase 
                          3'd1: case (func7)//sll
                                  7'd0: begin
                                          a_sel_o <= 2'd0;
                                          b_sel_o <= 3'd0;
                                          alu_op_o  <= ALU_SLL;
                                          gpr_we_o <= 1;
                                        end
                                default: illegal_instr_o <= '1;
                                endcase 
                          3'd5: case (func7)
                                  7'd0:   begin //srl
                                            a_sel_o <= 2'd0;
                                            b_sel_o <= 3'd0;
                                            alu_op_o  <= ALU_SRL;
                                            gpr_we_o <= 1;
                                          end
                                  7'h20:  begin //sra
                                            a_sel_o <= 2'd0;
                                            b_sel_o <= 3'd0;
                                            alu_op_o  <= ALU_SRA;
                                            gpr_we_o <= 1;
                                          end
                                default: illegal_instr_o <= '1;
                                endcase 
                          3'd2: case (func7)
                                  7'd0: begin //slt
                                          a_sel_o <= 2'd0;
                                          b_sel_o <= 3'd0;
                                          alu_op_o  <= ALU_SLTS;
                                          gpr_we_o <= 1;
                                        end
                                default: illegal_instr_o <= '1;
                                endcase 
                          3'd3: case (func7)
                                  7'd0: begin //sltu
                                          a_sel_o <= 2'd0;
                                          b_sel_o <= 3'd0;
                                          alu_op_o  <= ALU_SLTU;
                                          gpr_we_o <= 1;
                                        end
                                default: illegal_instr_o <= '1;
                                endcase 
                        endcase
      LUI_OPCODE     :  begin //lui
                          a_sel_o  <= 2'd2;
                          b_sel_o  <= 3'd2;
                          gpr_we_o <= 1'd1;
                          wb_sel_o <= '0;
                        end
      BRANCH_OPCODE  :  case (func3) 
                          3'd0: begin //beq
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd0;
                                  alu_op_o <= ALU_EQ;
                                  branch_o <= 1'd1;
                                end
                          3'd1: begin //bne
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd0;
                                  alu_op_o <= ALU_NE;
                                  branch_o <= 1'd1;
                                end
                          3'd4: begin //blt
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd0;
                                  alu_op_o <= ALU_LTS;
                                  branch_o <= 1'd1;
                                end
                          3'd5: begin //bge
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd0;
                                  alu_op_o <= ALU_GES;
                                  branch_o <= 1'd1;
                                end
                          3'd6: begin //bltu
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd0;
                                  alu_op_o <= ALU_LTU;
                                  branch_o <= 1'd1;
                                end
                          3'd7: begin //bgeu
                                  a_sel_o <= 2'd0;
                                  b_sel_o <= 3'd0;
                                  alu_op_o <= ALU_GEU;
                                  branch_o <= 1'd1;
                                end
                        default: illegal_instr_o <= '1;
                        endcase
      JALR_OPCODE    :  case (func3)
                          3'd0: begin //jalr
                                  a_sel_o <= 2'd1;
                                  b_sel_o <= 3'd4;
                                  jalr_o  <= 1'd1;
                                  gpr_we_o <= 1;
                                end
                          default: illegal_instr_o <= '1;
                          endcase
      JAL_OPCODE     :  begin //jal
                          a_sel_o <= 2'd1;
                          b_sel_o <= 3'd4;
                          alu_op_o <= ALU_ADD;
                          jal_o   <= 1'd1;
                          gpr_we_o <= 1'd1;
                        end
      SYSTEM_OPCODE  :  case (func3)
                          3'd0: if (fetched_instr_i[31:20] != 12'b001100000010) 
                                  case (func7)
                                    7'd0: illegal_instr_o <= 1;//ecall
                                    7'd1: illegal_instr_o <= 1;//ebreak
                                    default: illegal_instr_o <= 1;
                                  endcase
                                  else begin
                                    illegal_instr_o <= 0;
                                    mret_o <= 1;
                                  end
                          3'd1: begin //csrrw
                                  wb_sel_o <= 2'd2;
                                  gpr_we_o <= 1'd1;
                                  a_sel_o  <= 2'd0;
                                  csr_op_o <= CSR_RW;
                                  csr_we_o <= 1'd1;
                                end
                          3'd2: begin //csrrs
                                  wb_sel_o <= 2'd2;
                                  gpr_we_o <= 1'd1;
                                  a_sel_o <= 2'd0;
                                  csr_op_o <= CSR_RS;
                                  csr_we_o <= 1'd1;
                                end
                          3'd3: begin //csrrc
                                  wb_sel_o <= 2'd2;
                                  gpr_we_o <= 1'd1;
                                  a_sel_o <= 2'd0;
                                  csr_op_o <= CSR_RC;
                                  csr_we_o <= 1'd1;
                                end
                          3'd5: begin //csrrwi
                                  wb_sel_o <= 2'd2;
                                  gpr_we_o <= 1'd1;
                                  b_sel_o <= 3'd1;
                                  csr_op_o <= CSR_RWI;
                                  csr_we_o <= 1'd1;
                                end
                          3'd6: begin //csrrsi
                                  wb_sel_o <= 2'd2;
                                  gpr_we_o <= 1'd1;
                                  b_sel_o <= 3'd1;
                                  csr_op_o <= CSR_RSI;
                                  csr_we_o <= 1'd1;
                                end
                          3'd7: begin //csrrci
                                  b_sel_o <= 3'd1;
                                  wb_sel_o <= 2'd2;
                                  gpr_we_o <= 1'd1;
                                  csr_op_o <= CSR_RCI;
                                  csr_we_o <= 1'd1;
                                end
                        default: illegal_instr_o <= 1;
                        endcase
    default: illegal_instr_o <= 1;
    endcase
  end
  else illegal_instr_o <= 1;
end

endmodule