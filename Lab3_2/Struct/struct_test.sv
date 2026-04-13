module struct_test();

    typedef bit [6:0] defined_7bit ;

    typedef struct{
        defined_7bit header;
        defined_7bit cmd;
        defined_7bit data;
        defined_7bit crc;
    } my_packet;

  	my_packet packet;
    initial begin
        #2; 
        packet.header =7'h5A;
        packet.cmd = 8'h00;
        packet.data = 8'h00;
        packet.crc = 8'h00;

        $display("my_packet = %p",packet);
        $display("header = 0x%0h cmd = 0x%0h data = 0x%0h crc = 0x%0h",
                 packet.header,
                 packet.cmd,
                 packet.data,
                 packet.crc);
    end

endmodule