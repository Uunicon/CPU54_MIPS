`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/22 16:34:52
// Design Name: 
// Module Name: DMEM
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


module DMEM(
input clk,
input CS,
input DM_W,
input DM_R,
input [2:0]select, //100 32bit   010:16bit    001:8
input [31:0] addr,
input [31:0] data_in,
output [31:0] data_out
);
wire [7:0] Addr;
assign Addr=addr[7:0];
reg [7:0] num [0:255];   
assign data_out=CS? (DM_R? {num[Addr],num[Addr+1],num[Addr+2],num[Addr+3]}: 32'h00000000):32'hzzzz_zzzz;
always@(negedge clk or negedge CS)
begin
if(CS&&DM_W)
begin
case (select)
  3'b001:num[Addr]<=data_in[7:0];
  3'b010:
  begin
  num[Addr]<=data_in[15:8];
  num[Addr+1]<=data_in[7:0];
  end
  3'b100:
  begin
  num[Addr]<=data_in[31:24];
  num[Addr+1]<=data_in[23:16];
  num[Addr+2]<=data_in[15:8];
  num[Addr+3]<=data_in[7:0];
  end
endcase
end
end
endmodule
