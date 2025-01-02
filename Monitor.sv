class monitor extends uvm_monitor;
  `uvm_component_utils(monitor);
  transaction trans;
  virtual aluif aif;
  uvm_analysis_port #(transaction) send;
  
  function new(string path="mon",uvm_component parent=null);
    super.new(path,parent);
    send=new("send",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans=transaction::type_id::create("trans");
    if(!uvm_config_db #(virtual aluif)::get(this,"","aif",aif))
      `uvm_info("moner","Unable to access uvm_config_db",UVM_NONE);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever
      begin
        #10;
        trans.in1=aif.in1;
        trans.in2=aif.in2;
        trans.oper=aif.oper;
        trans.out=aif.out;
        `uvm_info("MON",$sformatf("Data recieved is in1 %d in2 %d oper %d out %d",trans.in1,trans.in2,trans.oper,trans.out),UVM_NONE);
        send.write(trans);
      end
  endtask
endclass
