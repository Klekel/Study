
module interrupt_controller(
    input  logic        clk_i,
    input  logic        rst_i,
    input  logic        exception_i,
    input  logic        irq_req_i,
    input  logic        mie_i,
    input  logic        mret_i,

    output logic        irq_ret_o,
    output logic [31:0] irq_cause_o,
    output logic        irq_o
    );

    logic Q1;
    logic Q2;
    
    logic ex0;
    logic ex1;
    logic ex2;
    logic ex3;
    logic ex4;
    logic ex5;
    logic ex6;
    logic ex7;
    
    assign ex0 = irq_req_i & mie_i;
    assign ex2 = mret_i & ~ex4;
    assign ex4 = exception_i | Q1;
    assign ex3 = ~mret_i & ex4;
    assign ex1 = ~(ex4 | Q2);
    assign ex5 = Q2 | irq_o;
    assign ex6 = ~ex2 & ex5;
    assign ex7 = ex1 & ex0;
    
    
    always_ff @( posedge clk_i ) begin
        if(rst_i) Q1 = 0;
        else Q1 = ex3;
    end

    always_ff @( posedge clk_i ) begin
        if(rst_i) Q2 = 0;
        else Q2 = ex6;
    end

    assign irq_ret_o = ex2;
    assign irq_o = ex7;
    assign irq_cause_o = 32'h10000010;
endmodule
