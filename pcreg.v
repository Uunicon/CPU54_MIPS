`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/22 15:03:41
// Design Name: 
// Module Name: pcreg
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


module pcreg(
//    input clk,
//    input rst,
//    input ena,
//    input [31:0] data_in,
//    output reg [31:0] data_out
input clk,
input rst,
input ena,
input wena,
input [31:0]data_in,
output[31:0]data_out
);
reg     [31:0]data;
always @(posedge clk or posedge rst)
    if (rst)
        data <= 32'h00400000;
    else if (ena & wena)
        data <= data_in;
assign data_out = data;
endmodule
