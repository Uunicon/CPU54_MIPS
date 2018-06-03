`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/26 18:36:53
// Design Name: 
// Module Name: HLreg
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


module HLreg(
input clk,
input rst,
input wena,
input [31:0]data_in,
output[31:0]data_out
);
reg     [31:0]data;
always @(posedge clk or posedge rst)
    if (rst)
        data <= 32'h00000000;
    else if ( wena)
        data <= data_in;
assign data_out = data;
endmodule
