interface alu_if(input logic clk, input logic reset);

    logic valid_in;
    logic [3:0] a;
    logic [3:0] b;
    logic cin;
    logic [3:0] ctl;

    logic valid_out;
    logic [3:0] alu;
    logic carry;
    logic zero;

    int transaction_id;

endinterface