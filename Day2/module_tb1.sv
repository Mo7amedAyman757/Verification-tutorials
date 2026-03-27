import class_pkg::*;

module module_tb1();

exercise1 test = new;

initial begin

    for(int i =0; i < 20; i = i + 1)begin
        assert(test.randomize());
        test.display_data();
    end

end

endmodule
