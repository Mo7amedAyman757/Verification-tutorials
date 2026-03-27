// *Class Exercise slide 114:*
// - In a new file, create a package named pkg that has a class MemTrans with 2 data members (data_in and address)
// - Constructor with default arguments to 0 to initialize the data members
// - void function print to display in hexa the data member values
// - In a new file, import the package and create a module, inside the module create 2 objects of the above class
// - and do as instructed in the initial block
// - Open QuestaSim, compile both file and run simulation on the module and check the printed messages in the transcript

package pkg;  
    class MemTrans;
        logic [8:0] data_in;
        logic [4:0] addr;

        function new(logic[8:0] data_in = 0, logic [4:0] addr = 0);
            this.data_in = data_in;
            this.addr = addr;
        endfunction

        function void display_data();
            $display("data_in = %h, address = %h", data_in, addr);
        endfunction
        
    endclass
endpackage
