class transaction extends uvm_sequence_item;
  
  `uvm_object_utils(transaction)
  
  typedef enum {READ,WRITE} cmd;
  randc bit [31:0]paddr;
  randc bit [31:0]data;
  randc cmd pwrite;
  
  constraint c1{paddr[31:0]>=32'd0; paddr[31:0]<32'd256;}
  constraint c2{data[31:0]>=32'd0; data[31:0]<32'd256;}
  
  function new(string name="transaction");
    super.new(name);
  endfunction
  
  function string convert2string();
    return $psprintf("pwrite = %s paddr = %0d data=%0h",pwrite.name(),paddr,data);
  endfunction
  
endclass