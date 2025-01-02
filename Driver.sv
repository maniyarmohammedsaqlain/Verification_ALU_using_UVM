class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver);
  transaction trans;
  virtual aluif aif;
  function new(string path="drv",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans=transaction::type_id::create("trans",this);
    if(!uvm_config_db #(virtual aluif)::get(this,"","aif",aif))
      `uvm_info("drverr","Error occured is driver",UVM_NONE);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever
      begin
        seq_item_port.get_next_item(trans);
        aif.in1<=trans.in1;
        aif.in2<=trans.in2;
        aif.oper<=trans.oper;
        `uvm_info("drv",$sformatf("Data recieved is in1 %d in2 %d oper %d",trans.in1,trans.in2,trans.oper),UVM_NONE);
        seq_item_port.item_done();
        #10;
      end
  endtask
endclass
