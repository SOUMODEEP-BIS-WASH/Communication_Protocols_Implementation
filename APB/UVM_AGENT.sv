class apb_agt extends uvm_agent;
  
  apb_sequencer sqr;
  apb_driver dvr;
  apb_mon mon;
  
  virtual dut_if vif;
  
  `uvm_component_utils_begin(apb_agt)
  	`uvm_field_object(sqr,UVM_ALL_ON)
  	`uvm_field_object(dvr,UVM_ALL_ON)
  `uvm_field_object(mon,UVM_ALL_ON)
  `uvm_component_utils_end
  
  function new(string name="apb_agt", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    sqr=apb_sequencer::type_id::create("sqr",this);
    dvr=apb_driver::type_id::create("dvr",this);
    mon=apb_mon::type_id::create("mon",this);
  
    if(!uvm_config_db #(virtual dut_if)::get(this,".","vif",vif)) begin
      `uvm_error("build_phase","AGENT VIF FAILED")
    end
 	
    uvm_config_db #(virtual dut_if)::set(this,"sqr","vif",vif);
    uvm_config_db #(virtual dut_if)::set(this,"dvr","vif",vif);
    uvm_config_db #(virtual dut_if)::set(this,"mon","vif",vif);
    
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    dvr.seq_item_port.connect(sqr.seq_item_export);
    uvm_report_info("APB AGENT","DRIVER CONNECTED TO SEQUENCER");
  endfunction
  
endclass