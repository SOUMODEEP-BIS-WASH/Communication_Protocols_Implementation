class apb_driver extends uvm_driver #(transaction);
  
  `uvm_component_utils(apb_driver)
  
  virtual dut_if vif;
  
  function new(string name="apb_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual dut_if)::get(this,".","vif",vif)) begin
      `uvm_error("build_phase","DRIVER VIF FAILED")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    //super.run(phase);
    
    this.vif.master_cb.psel   <= 0;
    this.vif.master_cb.penable<= 0;
    this.vif.master_cb.pwrite <= 0;
    this.vif.master_cb.paddr  <= 0;
    this.vif.master_cb.pwdata <= 0;
    forever begin
    	
      transaction tr;
      @(this.vif.master_cb);
      seq_item_port.get_next_item(tr);
      @(this.vif.master_cb);
      uvm_report_info("APB_DRIVER",$psprintf("GOT TRANSACTION %s",tr.convert2string()));
      case(tr.pwrite)
        transaction::READ: drive_read(tr.paddr, tr.data);
      	transaction::WRITE: drive_write(tr.paddr, tr.data);
      endcase
      seq_item_port.item_done();
    end
  endtask
  
  virtual protected task drive_read(input bit [31:0]addr,output logic [31:0]data);
  
    this.vif.master_cb.paddr<=addr;
    this.vif.master_cb.pwrite<=0;
    this.vif.master_cb.psel<=1;
    @(this.vif.master_cb);
    this.vif.master_cb.penable<=1;
    @(this.vif.master_cb);
    data = this.vif.master_cb.prdata;
    this.vif.master_cb.psel<=0;
    this.vif.master_cb.penable<=0;
    
  endtask
    
  virtual protected task drive_write(input bit [31:0]addr,input bit [31:0]data);
  
    this.vif.master_cb.paddr<=addr;
    this.vif.master_cb.pwdata<=data;
    this.vif.master_cb.pwrite<=1;
    this.vif.master_cb.psel<=1;
    @(this.vif.master_cb);
    this.vif.master_cb.penable<=1;
    @(this.vif.master_cb);
    this.vif.master_cb.psel<=0;
    this.vif.master_cb.penable<=0;
    
  endtask
    
  
endclass