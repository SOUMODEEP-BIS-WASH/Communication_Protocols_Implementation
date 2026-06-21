`timescale 1ns / 1ps


module i2c_tb;

    logic [6:0]slave_address_in;
    logic [7:0]slave_register_addr_in;
    logic [7:0]data_in;
    logic rw,run=0,clk=0;
    logic [7:0]data_out;
    
    logic slave1_run=0;
    logic slave2_run=0;
  
    always #5 clk=~clk;
    
    wire w1, w2;

    i2c_master m1(slave_address_in,slave_register_addr_in,data_in,rw,run,clk,w1,w2,data_out);
    i2c_slave s1(slave1_run,w2,w1);
    i2c_slave2 s2(slave2_run,w2,w1);

      pullup(w1);
    pullup(w2);
initial begin
    slave_address_in=81;
    slave_register_addr_in=202;
    rw=1;
    run=0;
    slave1_run=0;
    slave2_run=0;
    #10;
    
    run=1;
    slave1_run=1;
    slave2_run=0;
    #500;
    $display("DATA FROM SENSOR SLAVE = %0d ",data_out);
    
    slave_address_in=18;
    slave_register_addr_in=251;
    rw=0;
    data_in=data_out;
    run=0;
    slave1_run=0;
    slave2_run=0;
    #10;
    
    run=1;
    slave1_run=0;
    slave2_run=1;
    #500;
    $finish;
end

endmodule
