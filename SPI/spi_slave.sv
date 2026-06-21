`timescale 1ns / 1ps


module spi_slave(
 input s0,s1,mosi,run,ss,sclk,
 input [7:0]din,
 output reg miso=0,done,
 output reg [7:0] dout
    );
    
  bit [7:0]ptr=0;
  bit [7:0]data=0;
  bit [7:0]t=0;
  
  always @(posedge sclk) begin
    if(!run)begin
        data=din;
        done=0;
    end
    else if (run && (!done) && ss) begin
        if((!s0)&&(!s1)) spi_operation_00();    //posedge send posedge receive
        else if((!s0)&&(s1)) spi_operation_01();    //posedge send negedge receive
        else if((s0)&&(!s1)) spi_operation_10();    //negedge send posedge receive
        else if((s0)&&(s1)) spi_operation_11();    //negedge send negedge receive
        ptr++;
    end
  end  
    
   task spi_operation_00();
    case(ptr) 
           0: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           1: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           2: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           3: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           4: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           5: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           6: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           7: begin miso=data[0];data=(data>>1);data[7]=mosi; end
           8: begin dout=data; done=1;miso='dz; end
           default: begin data=data; done=0; end
    endcase
  endtask
  
  
  task spi_operation_01();
    case(ptr) 
           0: begin miso=data[0]; end
           1: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           2: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           3: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           4: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           5: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           6: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           7: begin data=(data>>1); miso=data[0]; @(negedge sclk)begin data[7]=mosi;end end
           8: begin data=(data>>1); @(negedge sclk)begin data[7]=mosi;end dout=data; done=1; ptr=0; end
           default: begin data=data; done=0; end
    endcase
  endtask
  
  task spi_operation_10();
    case(ptr) 
           0: begin @(negedge sclk)begin miso=data[0]; end end
           1: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           2: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           3: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           4: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           5: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           6: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           7: begin data=(data>>1); data[7]=mosi; @(negedge sclk)begin miso=data[0];end end
           8: begin data=(data>>1); data[7]=mosi; dout=data; done=1; ptr=0; end
           default: begin data=data; done=0; end
    endcase
  endtask
    
  task spi_operation_11();
    case(ptr) 
           0: begin @(negedge sclk)begin miso=data[0]; end end
           1: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           2: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           3: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           4: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           5: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           6: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           7: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; miso=data[0];end end
           8: begin @(negedge sclk)begin data=(data>>1); data[7]=mosi; dout=data; done=1; ptr=0; end end
           default: begin data=data; done=0; end
    endcase
  endtask
   
    
endmodule
