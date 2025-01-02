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
