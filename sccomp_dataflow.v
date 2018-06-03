`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/26 20:25:42
// Design Name: 
// Module Name: sccomp_dataflow
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


module sccomp_dataflow(
    input clk_in,
    input reset,
    output [31:0] inst,
    output [31:0] pc,
    output [31:0] addr
   
    //*************test*************
//    output [31:0] L,
//    output [31:0] H
     //
    );
    wire [31:0] imm;
    wire [31:0] dmem_in;
    wire [31:0] alu_r;
    wire cs;
    wire dm_w;
    wire dm_r;
    wire [31:0] ram_out;
    wire [2:0]select;
    assign inst=imm;
//    //*************test********
//    assign ram_out_T =ram_out;
//    //****************
    
    //iram
imem imem(((pc- 32'h00400000)/4),imm);
    //imem im(pc,inst)

//cpu
cpu sccpu(clk_in,reset,imm,ram_out, //input
dmem_in,select,alu_r,pc,addr,cs,dm_w,dm_r); //output
 //
 DMEM dram(
 .clk(clk_in),
 .CS(cs),  //enable control signal
 .DM_W(dm_w), //write
 .DM_R(dm_r), //read
 .select(select),
 .addr((alu_r[31:0]-32'h10010000)),
 .data_in(dmem_in),
 .data_out(ram_out)
     );   
    
endmodule
