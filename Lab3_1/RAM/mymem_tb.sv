module mymem_tb();

    //---------------------Setup and Data Structures---------------------
    localparam TESTS = 100; // number of write/read operations

    bit [15:0] address_array []; //Stores random addresses.
    bit [7:0] data_to_write_array[]; //Stores corresponding random data values.
    bit [7:0] data_read_expect_assoc [int]; //Stores expected data, indexed by address (key datatype: int)
    bit [7:0] data_read_queue[$]; //Stores the actual data read from the RAM

    // DUT port signals
    logic clk;
    logic write;
    logic read;
    logic [7:0] data_in;
    logic [15:0] address;
    logic [7:0] data_out;

    // - DUT instantiation
    my_mem uut(
        clk,
        write,  
        read,
        data_in,
        address,
        data_out
    );

    // Clock Generation
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; 
    end

    // - Counters (error_count and correct_count)
    int error_count, correct_count;

    //---------------------Setup and Data Structures---------------------
    // - Task: stimulus_gen
    // - Loops TESTS times to generate:
    // - Random addresses stored in address_array.
    // - Random data values stored in data_to_write_array.
    task stimulus_gen;
        address_array = new[TESTS];
        data_to_write_array = new[TESTS];
        
        for(int i = 0; i < TESTS; i++) begin
            address_array[i] = $urandom_range(0,32767); // 15-bit
            data_to_write_array[i] = $urandom_range(0,255); // 8bit 
        end
    endtask

    // - Task: golden_model
    // - Loops TESTS times to populate data_read_expect_assoc using:
    // - address_array as the index.
    // - data_to_write_array as expected values.
    task golden_model;
        for(int i = 0; i < TESTS; i++) begin
            data_read_expect_assoc[int'(address_array[i])] = data_to_write_array[i];
        end
    endtask

    // - Task: check9Bits
    // - Checks if the expected data out of the RAM is correct or not
    task check9Bits(input logic [7:0] dut_data_out, input logic [16:0] addr);
        logic [7:0] expected;
        
        expected = data_read_expect_assoc[int'(addr)];
        if (dut_data_out == expected) begin
            correct_count++;
            $display("[CHECK PASS] addr=0x%02h | expected=0x%03h | got=0x%03h",
               addr, expected, dut_data_out);
        end else begin
            error_count++;
            $display("[CHECK FAIL] addr=0x%02h | expected=0x%03h | got=0x%03h",
               addr, expected, dut_data_out);
        end

    endtask

    //---------------------Initial block Implementation---------------------

    initial begin

        // Data preparation
        data_in = 0;
        address = 0;
        read = 0;
        write = 0;  

        // - Call the stimulus_gen and then the golde_model tasks to prepare the data to be sent and expected
        // data to be read from the RAM
        stimulus_gen();
        golden_model(); 

        // Write Operations
        // - Loop TESTS times to write data into the DUT:
        // - On each negative clock edge, drive the address and data_in ports using address_array and
        // data_to_write_array.
        @(negedge clk);
        write = 1;
        
        for(int i = 0; i < TESTS; i++) begin
            @(negedge clk);    
            address = address_array[i];
            data_in = data_to_write_array[i];
        end

        // Read and Self-Checking
        // - Loop TESTS times to read data from the DUT:
        // - Drive the address port using address_array.
        // - Call check9Bits task to compare:
        // - Data read vs. data_read_expect_assoc[address].
        // - Store the read data into data_read_queue.
        @(negedge clk);
        write = 0;
        read = 1;
        for(int i = 0; i < TESTS; i++) begin
            @(negedge clk);    
            address = address_array[i];
            @(posedge clk); 
            #1;
            check9Bits(data_out,address);
            data_read_queue.push_back(data_out);
        end

        // Test Completion and Reporting
        // Print out the read data stored in data_read_queue using a while loop and pop_front method (search
        // online how to do it).
        while(data_read_queue.size() > 0) begin
            $display("queue entry = 0x%0h",data_read_queue.pop_front());
        end

        // Display error_count and correct_count
        $display("  Correct: %0d Error: %0d", correct_count, error_count);
        $stop;


    end

endmodule