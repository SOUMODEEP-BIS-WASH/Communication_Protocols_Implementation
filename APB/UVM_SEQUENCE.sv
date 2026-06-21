class apb_sequence extends uvm_sequence #(transaction);

  `uvm_object_utils(apb_sequence)
    
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction
  
  task body();
    transaction rw_trans;
    repeat (5) begin
      rw_trans=transaction::type_id::create("rw_trans");
      start_item(rw_trans);
      assert(rw_trans.randomize());
      finish_item(rw_trans);
    end
  endtask
  
endclass
  