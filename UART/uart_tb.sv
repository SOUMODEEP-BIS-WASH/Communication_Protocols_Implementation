`timescale 1ns / 1ps


module uart_tb;

localparam clk_period = 40;

reg clk=0;
reg rst,dvaltx;
reg [7:0]datain;
wire uart_line,tx_line,tx_active;
wire dvalrx,done;
wire [7:0]dataout;

uart_tx uut1(rst,clk,dvaltx,datain,done,tx_active,tx_line);
uart_rx uut2(clk,uart_line,dataout,dvalrx);

always #(clk_period/2) clk=~clk;

assign uart_line=(tx_active)?tx_line:1'b1;

initial begin

@(posedge clk);rst=1'b0;
@(posedge clk);rst=1'b1;dvaltx=1'b1;datain=8'h3F;
@(posedge clk);dvaltx=1'b0;

@(posedge dvalrx); 

if(dataout==8'h3F) $display("TRANSMISSION SUCCESSFULL: RECEIVED BIT = %0d SENT BIT = %0d ",dataout,datain);
else $display("TRANSMISSION UNSUCCESSFULL: RECEIVED BIT = %0d SENT BIT = %0d ",dataout,datain);
#400; 
 $finish;
end

endmodule
