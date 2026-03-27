// *Constraint Exercise 1 slide 128:*
// - In a new file, create a package named class_pkg that has a class Exercise2 with 
// - 2 data members (data and address)
// - Add 2 constraint blocks as in the slide
// - Add a void print function to print the data members
// - In a new file, import the package and create a module, 
// - then create an object in initial block and then randomize and print the 
// - datamembers 20 times using randomize() function

package class_pkg;

    class exercise1;
       rand logic [8:0] data_in;
       rand logic [3:0] addr;

       constraint addr_dist{
        addr dist{4'd0:/10,
                  [1:14]:/80,
                  4'd15:/10};
        data_in == 5;
       }

        function void display_data();
            $display("data = %d, address = %d", data_in, addr);
        endfunction

    endclass

endpackage
