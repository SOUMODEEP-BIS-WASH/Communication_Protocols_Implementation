`timescale 1ns / 1ps


module SPI_MASTER(
 input s0,s1,miso,run,ss_0,ss_1,
 input [7:0]din,
 output reg mosi,done,
 output reg ss1,ss2,ss3,ss4,sclk,
 output reg [7:0] dout
    );
    
  bit [7:0]ptr=0;
  bit [7:0]data=0;
  bit clk_in=0;
  
  always #5 clk_in=~clk_in;
  
  always @(posedge clk_in) begin
    if(!run)begin
        data=din;
        done=0;
        slave_select();
    end
    else if (run && (!done)) begin
        if((!s0)&&(!s1)) spi_operation_00();    //posedge send posedge receive
        else if((!s0)&&(s1)) spi_operation_01();    //posedge send negedge receive
        else if((s0)&&(!s1)) spi_operation_10();    //negedge send posedge receive
        else if((s0)&&(s1)) spi_operation_11();    //negedge send negedge receive
        ptr++;
    end
  end  
  
  function void slave_select();
    if((!ss_0)&&(!ss_1)) begin ss1=1;ss2=0;ss3=0;ss4=0; end
    else if((!ss_0)&&(ss_1)) begin ss1=0;ss2=1;ss3=0;ss4=0; end
    else if((ss_0)&&(!ss_1)) begin ss1=0;ss2=0;ss3=1;ss4=0; end
    else if((ss_0)&&(ss_1)) begin ss1=0;ss2=0;ss3=0;ss4=1; end
  endfunction
  
  task spi_operation_00();
    case(ptr) 
           0: begin mosi=data[0]; end
           1: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           2: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           3: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           4: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           5: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           6: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           7: begin data=(data>>1); mosi=data[0]; data[7]=miso; end
           8: begin data=(data>>1); data[7]=miso; dout=data; done=1; mosi='dz; end
           default: begin data=data; done=0; end
    endcase
  endtask
  
  
  task spi_operation_01();
    case(ptr) 
           0: begin mosi=data[0]; end
           1: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           2: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           3: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           4: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           5: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           6: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           7: begin data=(data>>1); mosi=data[0]; @(negedge clk_in)begin data[7]=miso;end end
           8: begin data=(data>>1); @(negedge clk_in)begin data[7]=miso;end dout=data; done=1; ptr=0; end
           default: begin data=data; done=0; end
    endcase
  endtask
  
  task spi_operation_10();
    case(ptr) 
           0: begin @(negedge clk_in)begin mosi=data[0]; end end
           1: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           2: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           3: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           4: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           5: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           6: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           7: begin data=(data>>1); data[7]=miso; @(negedge clk_in)begin mosi=data[0];end end
           8: begin data=(data>>1); data[7]=miso; dout=data; done=1; ptr=0; end
           default: begin data=data; done=0; end
    endcase
  endtask
    
  task spi_operation_11();
    case(ptr) 
           0: begin @(negedge clk_in)begin mosi=data[0]; end end
           1: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           2: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           3: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           4: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           5: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           6: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           7: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; mosi=data[0];end end
           8: begin @(negedge clk_in)begin data=(data>>1); data[7]=miso; dout=data; done=1; ptr=0; end end
           default: begin data=data; done=0; end
    endcase
  endtask
   
  assign sclk=clk_in;
    
endmodule
