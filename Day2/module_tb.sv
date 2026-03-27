import pkg::*;

module module_tb();

MemTrans pkt0, pkt1;

initial begin
    pkt0 = new(.addr(2));
    pkt0.display_data();

    pkt1 = new(.data_in(3),.addr(4));
    pkt1.display_data();
end

endmodule
