import pkg::*;

module pkg_tb();
    memTrans mem_obj1, mem_obj2;

    initial begin
        mem_obj1 = new(.address(4'h2));
        mem_obj2 = new(.data_in(8'h3), .address(4'h4));

        mem_obj1.display_data();
        mem_obj2.display_data();

        #10 $stop;
    end

    

endmodule