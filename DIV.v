`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/26 16:18:16
// Design Name: 
// Module Name: DIV
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


  module DIV(
  input [31:0]dividend,
  input [31:0]divisor,
  input start,
  input clock,
  input reset,
  output [31:0]q,
  output [31:0]r,
  output reg busy
  );
  reg [4:0]count;
  reg [31:0]reg_q;
  reg [31:0]reg_r;
  reg [31:0]reg_b;
  reg q_sign;
  reg r_sign;
  reg a_sign;
  wire [32:0]sub_add=r_sign?{reg_r,reg_q[31]}+{1'b0,reg_b}:{reg_r,reg_q[31]}-{1'b0,reg_b};
  assign r=a_sign?(-(r_sign?reg_r+reg_b:reg_r)):(r_sign?reg_r+reg_b:reg_r);
  assign q=q_sign?-reg_q:reg_q;
  always@(negedge clock or posedge reset)
  begin
  if(reset)
  begin count<=0;busy<=0;end
  else if(start&&(!busy))begin 
  count<=0;reg_q<=dividend[31]?-dividend:dividend;
  reg_r<=0;
  reg_b<=divisor[31]?-divisor:divisor;
  r_sign<=0;busy<=1'b1;
  q_sign<=dividend[31]^divisor[31];
  a_sign<=dividend[31];
  end
  else if(busy)begin
  reg_r<=sub_add[31:0];
  r_sign<=sub_add[32];
  reg_q<={reg_q[30:0],~sub_add[32]};
  count<=count+1;
  if(count==31)busy<=0;
  end
  end
  endmodule
