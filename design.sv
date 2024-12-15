module ALU(oper,in1, in2, out);
  input [1:0] oper;
  input [3:0] in1, in2;
  output reg [4:0] out;
  always@(oper)
    begin
      case (oper)
        2'b00: out <= in1 + in2;   
        2'b01: out <= in1 * in2;   
        2'b10: out <= in1 - in2;   
        2'b11: out <= (in2 != 0) ? in1 / in2 : 0; 
        default: out <= 0;        
      endcase
    end
endmodule

interface aluif();
  logic [3:0]in1;
  logic [3:0]in2;
  logic [1:0]oper;
  logic [4:0]out;
endinterface
