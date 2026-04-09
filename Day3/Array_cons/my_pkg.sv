package  my_pkg;

    // This package contains the definition of the screen class and its associated data types and parameters.
    parameter HEIGHT = 10;
    parameter WIDTH = 10;
    parameter PERCENT_WHITE = 20;

    // Define an enumeration for the color of the pixels, which can be either BLACK or WHITE.
    typedef enum {BLACK, WHITE} color_t;

    class screen;

        // Declare a 2D array of pixels, where each pixel is of type color_t. The dimensions of the array are defined by HEIGHT and WIDTH.
        rand color_t pixel [HEIGHT] [WIDTH];

        // Define a constraint block named colors_c to specify the distribution of pixel colors in the array.
        constraint colors_c{
            foreach(pixel[i,j])
                pixel[i][j] dist{BLACK := 100-PERCENT_WHITE, WHITE := PERCENT_WHITE};
        }
        // Define a function named print_screen to display the contents of the pixel array. It iterates through each row of the array and prints the row number along with the corresponding pixel values.
        function void print_screen();
            foreach(pixel[i])
                $display("Row Number %0d = %0p",i,pixel[i]);
        endfunction
    endclass

endpackage
