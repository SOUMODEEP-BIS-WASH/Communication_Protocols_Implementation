class apb_sequencer extends uvm_sequencer #(transaction);
	
  `uvm_component_utils(apb_sequencer)
  
  function new(string name="apb_sequencer", uvm_component parent =null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass
