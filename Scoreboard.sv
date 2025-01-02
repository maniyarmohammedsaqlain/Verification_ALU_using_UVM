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
