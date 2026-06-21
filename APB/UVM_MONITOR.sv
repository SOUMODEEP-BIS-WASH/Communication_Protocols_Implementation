class apb_mon extends uvm_monitor;
  
  virtual dut_if vif;
  
  uvm_analysis_port #(transaction) ap;
  
  `uvm_component_utils(apb_mon)
  
  function new(string name="apb_mon",uvm_component parent=null);
    super.new(name,parent);
    ap=new("ap",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual dut_if)::get(this,".","vif",vif)) begin
      `uvm_error("build_phase","MONITOR VIF FAILED")
    end    
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
    transaction tr;
      do begin
        @(this.vif.monitor_cb);
      end
      while (this.vif.monitor_cb.psel !== 1'b1||this.vif.monitor_cb.penable !== 1'b0);
      tr=transaction::type_id::create("tr",this);
      
      tr.pwrite=(this.vif.monitor_cb.pwrite)?transaction::WRITE:transaction::READ;
      
      tr.paddr=this.vif.monitor_cb.paddr;
      
      
      
      @(this.vif.monitor_cb);
      
      if(this.vif.monitor_cb.penable!==1'b1) begin `uvm_error("APB","VIOLATION: SETUP NOT FOLLOWED BY ENABLE"); end
      
      if(tr.pwrite==transaction::READ) begin tr.data=this.vif.monitor_cb.prdata ; end
      
      else if(tr.pwrite==transaction::WRITE) begin tr.data=this.vif.monitor_cb.pwdata ; end
      uvm_report_info("APB_MONITOR",$psprintf("GOT TRANSACTION %s",tr.convert2string()));
      ap.write(tr);
    end
  endtask
  
endclass