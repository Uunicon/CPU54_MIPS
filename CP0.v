`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/12 14:56:30
// Design Name: 
// Module Name: CP0
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


module CP0(
    input clk,
    input rst,
    input mfc0,         //CPU instruction is Mfc0
    input mtc0,         //CPU instruction is Mtc0
    input [31:0] pc,    
    input [4:0] addr,    //Specifies CP0 register
    input [31:0] wdata,   //Data form GP($28) register to replace CP0 register
    input exception,     //SYSCALL,BREAK,TEQ
    input eret,             // Instruction is ERET(Exception Return)
    input [4:0] cause,
    output [31:0]  rdata,  //Data form CP0 register for GP register
    output [31:0] status,
    output [31:0] exc_addr  //Address for PC at the begeinning of an exception
    );
    
    parameter  SYSCALL = 5'b01000,
                        BREAK    = 5'b01001,
                        REQ         = 5'b01101;
                        
// status  =   12  /   cause   =    13 /   epc   =  14

reg [31:0] cp0_reg [0:31]; //32 cp0 registers
assign  status = cp0_reg [12];

always @(posedge clk or posedge rst)
begin
    if(rst)
       begin 
         cp0_reg [0] <=0 ;
         cp0_reg [1] <=0 ;
         cp0_reg [2] <=0 ;
         cp0_reg [3] <=0 ;
         cp0_reg [4] <=0 ;
         cp0_reg [5] <=0 ;
         cp0_reg [6] <=0 ;
         cp0_reg [7] <=0 ;
         cp0_reg [8] <=0 ;
         cp0_reg [9] <=0 ;
         cp0_reg [10] <=0 ;
         cp0_reg [11] <=0 ;
         cp0_reg [12] <=0 ;
         cp0_reg [13] <=0 ;
         cp0_reg [14] <=0 ;
         cp0_reg [15] <=0 ;
         cp0_reg [16] <=0 ;
         cp0_reg [17] <=0 ;
         cp0_reg [18] <=0 ;
         cp0_reg [19] <=0 ;
         cp0_reg [20] <=0 ;
         cp0_reg [21] <=0 ;
         cp0_reg [22] <=0 ;
         cp0_reg [23] <=0 ;
         cp0_reg [24] <=0 ;
         cp0_reg [25] <=0 ;
         cp0_reg [26] <=0 ;
         cp0_reg [27] <=0 ;
         cp0_reg [28] <=0 ;
         cp0_reg [29] <=0 ;
         cp0_reg [30] <=0 ;
         cp0_reg [31] <=0 ;        
       end
    else 
       begin
          if(mtc0)
             cp0_reg [addr] <= wdata;
          else if (exception)   //enter break
             begin
                cp0_reg [14] <=   pc; //epc
                cp0_reg [12] <=   status<<5; //stauts
                cp0_reg [13] <=   {24'b0,cause,2'b0}; //cause 
             end
          else if(eret) //out break
             begin
                 cp0_reg [12] <= status>>5;
             end
       end
end
    
assign exc_addr  = eret? cp0_reg [14]:32'h00400004;
assign rdata = mfc0? cp0_reg [addr]:32'hz;   
    
endmodule
