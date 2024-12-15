`include "uvm_macros.svh";
import uvm_pkg::*;


class transaction extends uvm_sequence_item; 
  rand bit[3:0]in1;
  rand bit[3:0]in2;
  rand bit[1:0]oper;
  bit[4:0]out;
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(in1,UVM_DEFAULT)
  `uvm_field_int(in2,UVM_DEFAULT)
  `uvm_field_int(oper,UVM_DEFAULT)
  `uvm_field_int(out,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new(string path="trans");
    super.new(path);
  endfunction
endclass

class sequence1 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence1);
  transaction trans;
  function new(string path="sequence1");
    super.new(path);
  endfunction
  
  virtual task body();
    repeat(10)
      begin
        trans=transaction::type_id::create("trans");
        start_item(trans);
        trans.randomize();
        `uvm_info("gen",$sformatf("Data generated of in1 is %d b is %d oper is %d",trans.in1,trans.in2,trans.oper),UVM_NONE);
        finish_item(trans);
      end
  endtask
endclass


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

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard);
  transaction trans;
  uvm_analysis_imp #(transaction,scoreboard)recv;
  function new(string path="scb",uvm_component parent=null);
    super.new(path,parent);
    recv=new("recv",this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    trans=transaction::type_id::create("trans",this);
  endfunction
  
  virtual function void write(transaction tra);
    trans=tra;
    `uvm_info("SCB",$sformatf("Data recieved is in1 is %d in2 is %d oper is %d out is %d",trans.in1,trans.in2,trans.oper,trans.out),UVM_NONE);
    if(trans.oper==2'b00)
      begin
        if(trans.in1+trans.in2==trans.out)
          begin
            `uvm_info("CHK1",$sformatf("PASSED"),UVM_NONE);
          end
        else
          begin
            `uvm_info("CHK1","FAILED",UVM_NONE);
          end
      end
    else if(trans.oper==2'b01)
      begin
        if(trans.in1*trans.in2==trans.out)
          begin
            `uvm_info("CHK1",$sformatf("PASSED"),UVM_NONE);
          end
        else
          begin
            `uvm_info("CHK1","FAILED",UVM_NONE);
          end
      end
    else if(trans.oper==2'b10)
      begin
        if(trans.in1-trans.in2==trans.out)
          begin
            `uvm_info("CHK1",$sformatf("PASSED"),UVM_NONE);
          end
        else
          begin
            `uvm_info("CHK1","FAILED",UVM_NONE);
          end
      end
    else if(trans.oper==2'b11)
      begin
        if(trans.in1/trans.in2==trans.out)
          begin
            `uvm_info("CHK1",$sformatf("PASSED"),UVM_NONE);
          end
        else
          begin
            `uvm_info("CHK1","FAILED",UVM_NONE);
          end
      end
  endfunction
endclass
    
class agent extends uvm_agent;
  `uvm_component_utils(agent);
  function new(string path="agent",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  driver drv;
  uvm_sequencer #(transaction)seqr;
  monitor mon;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drv=driver::type_id::create("drv",this);
    mon=monitor::type_id::create("mon",this);
    seqr=uvm_sequencer #(transaction)::type_id::create("seqr",this);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass

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

class test extends uvm_test;
  `uvm_component_utils(test);
  env e;
  sequence1 s;
  function new(string path="test",uvm_component parent=null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e=env::type_id::create("e",this);
    s=sequence1::type_id::create("s",this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    s.start(e.a.seqr);
    #50;
    phase.drop_objection(this);
  endtask
endclass

module tb;
  aluif aif();
  ALU ad(.oper(aif.oper),.in1(aif.in1),.in2(aif.in2),.out(aif.out));
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial
    begin
      uvm_config_db #(virtual aluif)::set(null,"uvm_test_top.e.a*","aif",aif);
      run_test("test");
    end
endmodule
      
    
  
      

    
    
  
    
  
  
  
  
  
