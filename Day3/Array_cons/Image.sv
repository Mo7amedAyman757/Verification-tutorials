import my_pkg::*;

module Image;

    screen my_screen;
    initial begin
        my_screen = new();
        assert (my_screen.randomize());
        my_screen.print_screen();
    end

endmodule
