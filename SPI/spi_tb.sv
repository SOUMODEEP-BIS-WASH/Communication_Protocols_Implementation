`timescale 1ns / 1ps


module spi_tb;

 logic s0,s1,run,ss_0,ss_1,miso;
 logic [7:0]din;
 logic done;
 logic [7:0] dout;
 
 logic s1_s0,s1_s1,s1_done,s1_run;
 logic [7:0]s1_din,s1_dout;
 
  logic s2_s0,s2_s1,s2_done,s2_run;
 logic [7:0]s2_din,s2_dout;
 
  logic s3_s0,s3_s1,s3_done,s3_run;
 logic [7:0]s3_din,s3_dout;
 
  logic s4_s0,s4_s1,s4_done,s4_run;
 logic [7:0]s4_din,s4_dout;

wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10;
 
SPI_MASTER uut1(s0,s1,miso,run,ss_0,ss_1,din,w2,done,w4,w5,w6,w7,w3,dout);
spi_slave uut2(s1_s0,s1_s1,w2,s1_run,w4,w3,s1_din,w1,s1_done,s1_dout);
spi_slave uut3(s2_s0,s2_s1,w2,s2_run,w5,w3,s2_din,w8,s2_done,s2_dout);
spi_slave uut4(s3_s0,s3_s1,w2,s3_run,w6,w3,s3_din,w9,s3_done,s3_dout);
spi_slave uut5(s4_s0,s4_s1,w2,s4_run,w7,w3,s4_din,w10,s4_done,s4_dout);

assign miso=w1|w8|w9|w10;

initial begin 
run=0;s0=0;s1=0;ss_0=1;ss_1=1;
s1_run=0;s1_s0=0;s1_s1=0;
s2_run=0;s2_s0=0;s2_s1=0;
s3_run=0;s3_s0=0;s3_s1=0;
s4_run=0;s4_s0=0;s4_s1=0;
din=230;
s1_din=10;
s2_din=20;
s3_din=30;
s4_din=40;

#20;

run=1;
s4_run=1;
#200;
$finish;
end

endmodule
