`timescale 1ns / 1ps

//FOR CLK FREQUENCY 25 MHZ, BAUD RATE 115200

module uart_rx #(parameter clk_per_bit=217)(
 input clk,rx_serial,
 output [7:0]dataout,
 output dataval
    );
 
 localparam IDLE=3'b000,START=3'b001, DATA=3'b010,STOP=3'b011, CLEANUP=3'b100;
 
 reg [$clog2(clk_per_bit):0]clk_count=0;
 reg [7:0]rx_data=0;
 reg [2:0]bit_count=0;
 reg dval=0;
 reg [2:0]PS;
 
 always @(posedge clk) begin
 
 case(PS)
 
 IDLE:
 begin
 dval<=1'b0;
 bit_count<=1'b0;
 clk_count<=1'b0;
 if(!rx_serial) PS<=START;
 else PS<=IDLE;
 end
 
 START:
 begin
 if(clk_count==(clk_per_bit/2))begin if(!rx_serial) begin clk_count<=1'b0; PS<=DATA; end else begin PS<=IDLE; end end
 else begin clk_count<=clk_count+1;PS<=START; end
 end
 
 DATA:
 begin
 if(clk_count<clk_per_bit-1) begin clk_count<= clk_count+1; PS<=DATA; end
 else begin clk_count<=1'b0; rx_data[bit_count]=rx_serial; if(bit_count<7) begin bit_count<=bit_count+1;PS<=DATA; end else begin bit_count<=1'b0; PS<=STOP; end end
 end

 STOP:
 begin
 if(clk_count<clk_per_bit-1) begin clk_count<=clk_count+1; PS<=STOP;end
 else begin clk_count<=1'b0; dval<=1'b1; PS<=CLEANUP; end
 end
 
 CLEANUP: 
 begin
 dval<=1'b0;
 PS<=IDLE;
 end
 
 default: PS <= IDLE;
 
 endcase
 end
 
 assign dataval=dval;
 assign dataout=rx_data;
 
endmodule
