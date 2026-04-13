import class_pkg::*;

module class_pkg_tb();

    exercise2 class_obj;

    initial begin
        class_obj = new();

        repeat(20) begin
            assert(class_obj.randomize());
            class_obj.display();    
        end
    end

endmodule