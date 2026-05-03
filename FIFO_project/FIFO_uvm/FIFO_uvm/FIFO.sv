////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
output reg [FIFO_WIDTH-1:0] data_out;
output reg wr_ack, overflow, underflow;
output full, empty, almostfull, almostempty;
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack <= 0;
		overflow <= 0;
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		data_out <= 0;
		underflow <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0;
	end  else begin
		if (rd_en && empty) // this synchronized
			underflow <= 1;
		else
			underflow <= 0;		
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if({wr_en, rd_en} == 2'b11) begin // this condition was added 
			if(empty)
                    count <= count + 1;
            else if(full)
                    count <= count - 1;
		end
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
// assign underflow = (empty && rd_en)? 1 : 0;  // this was synchronized 
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;

`ifdef SIM
	property Reset_Behavior;
		@(posedge clk) (!rst_n) |=> (count == 0 && wr_ptr == 0 && rd_ptr == 0);
	endproperty

	assert property(Reset_Behavior);
	cover property(Reset_Behavior);

	property Write_Acknowledge;
		@(posedge clk) disable iff (!rst_n) 
		(wr_en && !full) |=> (wr_ack == 1);	
	endproperty

	assert property(Write_Acknowledge);
	cover property(Write_Acknowledge);

	property overflow_detection;
		@(posedge clk) disable iff (!rst_n) 
		(wr_en && full) |=> (overflow == 1);	
	endproperty

	assert property(overflow_detection);
	cover property(overflow_detection);

	property underflow_detection;
		@(posedge clk) disable iff (!rst_n) 
		(rd_en && empty) |=> (underflow == 1);	
	endproperty

	assert property(underflow_detection);
	cover property(underflow_detection);

	property Full_Flag;
		@(posedge clk) disable iff (!rst_n)
		(count == FIFO_DEPTH) |-> (full == 1);
	endproperty
	assert property(Full_Flag);
	cover  property(Full_Flag);

	property Empty_Flag;
		@(posedge clk) disable iff (!rst_n)
		(count == 0) |-> (empty == 1);
	endproperty
	assert property(Empty_Flag);
	cover  property(Empty_Flag);

	property AlmostFull_Flag;
		@(posedge clk) disable iff (!rst_n)
		(count == FIFO_DEPTH - 1) |-> (almostfull == 1);
	endproperty
	assert property(AlmostFull_Flag);
	cover  property(AlmostFull_Flag);

	property AlmostEmpty_Flag;
		@(posedge clk) disable iff (!rst_n)
		(count == 1) |-> (almostempty == 1);
	endproperty

	assert property(AlmostEmpty_Flag);
	cover  property(AlmostEmpty_Flag);

	property WrPtr_Wraparound;
		@(posedge clk) disable iff (!rst_n)
		(wr_ptr == FIFO_DEPTH - 1 && wr_en && !full) 
		|=> (wr_ptr == 0);
	endproperty

	assert property(WrPtr_Wraparound);
	cover  property(WrPtr_Wraparound);

	property RdPtr_Wraparound;
		@(posedge clk) disable iff (!rst_n)
		(rd_ptr == FIFO_DEPTH - 1 && rd_en && !empty) 
		|=> (rd_ptr == 0);
	endproperty
	assert property(RdPtr_Wraparound);
	cover  property(RdPtr_Wraparound);

	property Ptr_Threshold;
		@(posedge clk) disable iff (!rst_n)
		(wr_ptr < FIFO_DEPTH) && 
		(rd_ptr < FIFO_DEPTH) && 
		(count  <= FIFO_DEPTH);
	endproperty
	assert property(Ptr_Threshold);
	cover  property(Ptr_Threshold);

`endif

endmodule