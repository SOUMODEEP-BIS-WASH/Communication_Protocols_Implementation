`timescale 1ns/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "subscriber.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

module tb;
  
  dut_if apb_if();
  
  apb_slave dut(.dif(apb_if));
  
  initial begin apb_if.pclk=0; end
  
  always #10 apb_if.pclk=~apb_if.pclk;
  
  initial begin apb_if.rst=0; repeat(1) @(posedge apb_if.pclk); apb_if.rst=1;  end
  
  initial begin 
    
    uvm_config_db #(virtual dut_if)::set(null,"*","vif",apb_if);
    
    run_test("apb_test");
    
  end
  
endmodule