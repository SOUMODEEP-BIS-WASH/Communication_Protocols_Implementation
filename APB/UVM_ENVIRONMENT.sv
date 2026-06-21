class apb_env extends uvm_env;
  
  `uvm_component_utils(apb_env)
  
  apb_agt agt;
  apb_scoreboard scb;
  apb_sub sub;
  
  virtual dut_if vif;
  
  function new(string name="apb_env", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
    agt=apb_agt::type_id::create("agt",this);
    scb=apb_scoreboard::type_id::create("scb",this);
    sub=apb_sub::type_id::create("sub",this);
    
    if(!uvm_config_db #(virtual dut_if)::get(this,".","vif",vif)) begin
      `uvm_error("build_phase","ENVIRONMENT VIF FAILED")
    end
 	
    uvm_config_db #(virtual dut_if)::set(this,"agt","vif",vif);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    
    super.connect_phase(phase);
    
    agt.mon.ap.connect(scb.mon_export);
    agt.mon.ap.connect(sub.analysis_export);
    
  endfunction
  
endclass