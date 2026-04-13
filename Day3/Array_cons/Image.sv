import image_pkg::*;

screen my_screen;

module image();

    initial begin
        my_screen = new();
        assert(my_screen.randomize());
        my_screen.print_screen();
    end

endmodule