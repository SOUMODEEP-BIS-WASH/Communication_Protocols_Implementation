`timescale 1ns/1ps

//FOR CLK FREQUENCY 25 MHZ, BAUD RATE 115200


module uart_tx #(parameter clk_per_bit=217)(
    input rst,clk,dval,
    input [7:0]data_in,
    output reg done, active, tx_serial
);

localparam IDLE=2'b00, START=2'b01, DATA=2'b10, STOP=2'b11;

reg [$clog2(clk_per_bit):0]clk_count;
reg [7:0]tx_data;
reg [2:0]bit_count;
reg [1:0]PS;

always @(posedge clk or negedge rst)begin

if(!rst) begin
    PS<=IDLE;
    done<=1'b0;
end
else begin

case (PS)
    
    IDLE:
    begin
    done<=1'b0;
    tx_serial<=1'b1;
    clk_count<=1'b0;
    bit_count<=1'b0;
    if(dval) begin active<=1'b1; tx_data <= data_in; PS<=START;  end
    else PS<=IDLE;
    end
    
    START:
    begin
    tx_serial<=1'b0;
    if(clk_count<clk_per_bit-1) begin clk_count<=clk_count+1;PS<=START; end
    else begin PS<=DATA; clk_count<=1'b0; end
    end
    
    DATA:
    begin
    tx_serial<=tx_data[bit_count];
    if(clk_count<clk_per_bit-1) begin clk_count<=clk_count+1;PS<=DATA; end  
    else begin clk_count<=1'b0; if(bit_count<7) begin bit_count <= bit_count+1;PS<=DATA; end else begin bit_count<=1'b0;PS<=STOP; end end
    end
    
    STOP:
    begin
    tx_serial<=1'b1;

    if(clk_count<clk_per_bit-1) begin clk_count<=clk_count+1;PS<=STOP; end 
    else begin clk_count<=0; PS<=IDLE;     active<=1'b0; done<=1'b1;end
    end
    
    default: PS<=IDLE;

endcase
end
end



endmodule