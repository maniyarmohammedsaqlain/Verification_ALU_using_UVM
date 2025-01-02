class env extends uvm_env;
  `uvm_component_utils(env);
  function new(string path="env",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  agent a;
  scoreboard scb;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a=agent::type_id::create("a",this); 
    scb=scoreboard::type_id::create("scb",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.mon.send.connect(scb.recv);
  endfunction
  
endclass
