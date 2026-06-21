class apb_sub extends uvm_subscriber #(transaction);
  
  `uvm_component_utils(apb_sub)
  
  bit [31:0]addr;
  bit [31:0]data;
  
  covergroup cover_bus;
    coverpoint addr{bins a[16]={[0:255]};}
    coverpoint data{bins d[16]={[0:255]};}
  endgroup
  
  function new(string name="apb_sub",uvm_component parent =null);
    super.new(name,parent);
    cover_bus=new();
  endfunction
  
  function void write(transaction t);
    
    `uvm_info("APB_SUBSCRIBER",$psprintf("SUBSCRIBER RECEIVED %s",t.convert2string()),UVM_NONE);
    
    addr=t.paddr;
    data=t.data;
    cover_bus.sample();
    
  endfunction
  
endclass