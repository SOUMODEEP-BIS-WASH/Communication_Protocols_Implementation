class apb_test extends uvm_test;
  
  `uvm_component_utils(apb_test)
  
  apb_env env;
  virtual dut_if vif;
  
  function new(string name="apb_test", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
    function void build_phase(uvm_phase phase);
    
    super.build_phase(phase);
    
      env=apb_env::type_id::create("env",this);
      if(!uvm_config_db #(virtual dut_if)::get(this,".","vif",vif)) begin
        `uvm_error("build_phase","TEST VIF FAILED")
    end
 	
      uvm_config_db #(virtual dut_if)::set(this,"env","vif",vif);
      
    endfunction
  
  task run_phase(uvm_phase phase);
    
    //super.run_phase(phase);
    
    apb_sequence seq;
    seq=apb_sequence::type_id::create("seq",this);
    phase.raise_objection(this,"STARTING TEST");
    seq.start(env.agt.sqr);
    #100;
    phase.drop_objection(this,"FINISHING TEST");
  endtask
  
endclass