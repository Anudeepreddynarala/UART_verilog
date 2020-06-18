`timescale 1ns/10ps
`include "uart_tx.v"
`include "uart_rx.v"

module uart_tb();
  parameter c_CLOCK_PERIOD_NS = 100;
  parameter c_CLKS_PER_BIT    = 87;
  parameter c_BIT_PERIOD      = 8600;
	
	reg clk = 0;
	reg [7:0] byte_in;
	wire [7:0] byte_out;
	reg tx_Dv;
	wire rx_Dv;
	wire tx_done;
	wire tx_active;
	wire byte_transfer;
	uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
	(
		.i_Clock(clk),
		.i_Tx_Dv(tx_Dv),
		.i_Tx_Byte(byte_in),
		
		.o_Tx_Active(tx_active),
		.o_Tx_Serial(byte_transfer),
		.o_Tx_Done(tx_done)
	);
	
	uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
	(
		.i_Clock(clk),
		.i_Rx_Serial(byte_transfer),
		.o_Rx_Dv(rx_Dv),
		.o_Rx_Byte(byte_out)
	);
	
	always
		#(c_CLOCK_PERIOD_NS/2) clk<=!clk;
		
	initial 
	begin
		@(posedge clk);
		@(posedge clk);
		tx_Dv <= 1'b1;
		byte_in<=8'hAB;
		@(posedge clk);
		tx_Dv <= 1'b0;
		
		
		
	end	
always @(posedge rx_Dv)
	begin
	if(byte_out == 8'hAB)
			$display("Test passed - Correct Byte Recieved");
		else
			$display("Test Failed");
	
	end

endmodule	