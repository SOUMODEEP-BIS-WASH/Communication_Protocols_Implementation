interface dut_if;
  
  logic pclk;
  logic rst;
  logic [31:0]paddr;
  logic psel;
  logic penable;
  logic pwrite;
  logic [31:0]pwdata;
  logic [31:0]prdata;
  logic pready;
  
  clocking master_cb @(posedge pclk);
    output psel,paddr,penable,pwrite,pwdata;
    input prdata;
  endclocking
  
  clocking slave_cb @(posedge pclk);
    input psel,paddr,penable,pwrite,pwdata;
    output prdata;
  endclocking
  
  clocking monitor_cb @(posedge pclk);
    input psel,paddr,penable,pwrite,pwdata,prdata;
  endclocking
  
  modport master(clocking master_cb);
  modport slave(clocking slave_cb);
  modport passive(clocking monitor_cb);
  
endinterface
    
module apb_slave(dut_if dif);
	
  parameter SETUP = 0, W_ENABLE = 1, R_ENABLE= 2;
  
  logic [31:0]mem[0:255];
  logic [1:0] apb_state;
  integer i;
  
  always @(posedge dif.pclk or negedge dif.rst) begin
    if(!dif.rst) begin
      apb_state<=SETUP;
      dif.prdata<=0;
      dif.pready<=1;
      for(i=0;i<=255;i=i+1) mem[i]<=i;
    end
    else begin
      case(apb_state)
      
        SETUP:begin
        dif.prdata<=0;
           //$display("%t SETUP psel=%0d penable=%0d pwrite=%0d",$time,dif.psel,dif.penable,dif.pwrite);
          if(dif.psel && !dif.penable) begin
            if(dif.pwrite)begin apb_state<=W_ENABLE; end
            else if (!dif.pwrite) begin apb_state<=R_ENABLE; dif.prdata<=mem[dif.paddr] ;  end
          end
          else begin apb_state<=SETUP; end
        end
        
        W_ENABLE:begin
          if(dif.psel && dif.penable && dif.pwrite) 
            begin mem[dif.paddr]<=dif.pwdata; end
          apb_state<=SETUP;
        end
        
        R_ENABLE:begin
          //$display("%t, %d",$time,dif.prdata);
          apb_state<=SETUP;
        end
        default: apb_state<=SETUP;
      endcase
    end
  end
  
endmodule