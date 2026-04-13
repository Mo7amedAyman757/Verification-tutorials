package image_pkg;

    // This package contains the definition of the screen class and its associated data types and parameters.
    parameter WIDTH  = 10;
    parameter HEIGHT = 10;
    parameter PERCENT_WHITE = 20;

    // Define an enumerated type colors_t with two values: Black - White
    typedef enum  {BLACK, WHITE} color_t;

    class screen;
        // Declare a 2D randomized unpacked array pixels of type colors_t, with dimensions [HEIGHT][WIDTH].  
        rand color_t pixels [HEIGHT] [WIDTH];
        
        // Define a constraint block named colors_c to specify the distribution of pixel colors in the array. The distribution is defined such that the percentage of WHITE pixels is determined by the PERCENT_WHITE parameter, and the remaining percentage is allocated to BLACK pixels.
        constraint colors_c{
            foreach(pixels[i,j])
                pixels[i][j] dist {WHITE :/PERCENT_WHITE,   BLACK :/ 100 - PERCENT_WHITE};
        }
        
        // Define a function named print_screen to display the contents of the pixels array. It iterates through each row of the array and prints the row number along with the corresponding pixel values.
        function void print_screen();
            foreach(pixels[i]) 
                $display("Row Number %0d = %0p",i,pixels[i]);

        endfunction

    endclass
    
endpackage