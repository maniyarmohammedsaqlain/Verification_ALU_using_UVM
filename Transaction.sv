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
