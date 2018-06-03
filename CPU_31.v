`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/04/22 21:46:59
// Design Name: 
// Module Name: CPU_31
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
/////////////////////////////////////////////////////////////////////////////////


module cpu(
    input clk_in,
    input reset,
    input [31:0]imem,//
    input [31:0] ram_out,
    output  [31:0] dmem_in,
    output [2:0] select, //DMEM select 8bits 16bits 32bits
//    output [31:0] Rt,
    output [31:0] alu_r,
    output [31:0] pc,
    output [31:0] addr,
    output cs, //dmem control signal 
    output dm_w, //dmem write
    output dm_r//dmem read
    //teset
//    output [31:0] L,
//    output [31:0] H
    );

    wire [31:0]Rt;
    wire [31:0]npc;
    wire M3,M3_2,M4,M4_2, M2,M5,M1,M1_2,M6,M7; //mux2
    wire ALUC3,ALUC2,ALUC1,ALUC0;
    wire RF_W; //regfiles write
    wire RL_CLK; //regfiles clk

    wire [3:0]ALUC;//alu control
    wire [31:0] PC;
    wire [31:0] mux_out_1;
    wire [31:0] mux_out_1_2;
   // wire [31:0] mux_out_2;
    reg [31:0] Rd;
    wire [31:0] mux_out_3;
    wire [31:0] mux_out_3_2;
    
    wire [31:0] mux_in_4;
    wire [31:0] mux_out_4;
    wire [31:0] mux_out_4_2;
//    wire [31:0] mux_out_4_3;
    wire [31:0] mux_out_5;
    
    wire [31:0] Rs; //Rs
    assign Rstest =  Rs;

    wire [31:0] ext18_sign;
    wire [4:0] rdc;
    wire [4:0] rsc;
    wire [4:0] rtc;
    wire [31:0] ext16;
    wire [31:0] ext16_sign;
    wire ext16_sin_judge;
    
    
    wire zero;
    wire carry;
    wire negative;
    wire overflow;
    
    assign pc = PC;
    assign addr = alu_r;
    assign  dmem_in    =   Rt;
    //**************TEST
//    assign ext16_T = ext16;
//    assign ext16_sign_T=ext16_sign;
//    assign RS_T = Rs;  //
//    assign RT_T = Rt; //
//    assign RTC_T = rtc; //
    assign RDC_T = rdc; //
//    assign RSC_T = rsc; //
//    assign  mux_out_1_T=mux_out_1; 
   // assign  mux_out_2_T=mux_out_2;

//    assign  mux_out_5_T=mux_out_5;
//    assign  mux_in_4_T=mux_in_4;    
//    assign  mux_out_4_2_T=mux_out_4_2;
//    assign mux_out_3_2_T=mux_out_3_2;
//****************************
 wire _add, _addu, _sub, _subu, _and, _or, _xor, _nor;
   wire _slt, _sltu, _sll, _srl, _sra, _sllv, _srlv, _srav, _jr;
   wire  _addi, _addiu, _andi, _ori, _xori, _lw, _sw;
   wire _beq, _bne, _slti, _sltiu, _lui, _j, _jal;
//CP0
wire _break,_syscall,_teq,_eret,_mfc0,_mtc0;
   
   //1~17
   assign _add = (imem[31:26]==6'b000000&&imem[5:0]==6'b100000)?1'b1:1'b0;
   assign _addu = (imem[31:26]==6'b000000&&imem[5:0]==6'b100001)?1'b1:1'b0;
   assign _sub = (imem[31:26]==6'b000000&&imem[5:0]==6'b100010)?1'b1:1'b0;
   assign _subu = (imem[31:26]==6'b000000&&imem[5:0]==6'b100011)?1'b1:1'b0;
   assign _and = (imem[31:26]==6'b000000&&imem[5:0]==6'b100100)?1'b1:1'b0;
   assign _or = (imem[31:26]==6'b000000&&imem[5:0]==6'b100101)?1'b1:1'b0;
   assign _xor = (imem[31:26]==6'b000000&&imem[5:0]==6'b100110)?1'b1:1'b0;
   assign _nor = (imem[31:26]==6'b000000&&imem[5:0]==6'b100111)?1'b1:1'b0;
   
   assign _slt = (imem[31:26]==6'b000000&&imem[5:0]==6'b101010)?1'b1:1'b0;
   assign _sltu = (imem[31:26]==6'b000000&&imem[5:0]==6'b101011)?1'b1:1'b0;
   assign _sll = (imem[31:26]==6'b000000&&imem[5:0]==6'b000000)?1'b1:1'b0;
   assign _srl = (imem[31:26]==6'b000000&&imem[5:0]==6'b000010)?1'b1:1'b0;
   assign _sra = (imem[31:26]==6'b000000&&imem[5:0]==6'b000011)?1'b1:1'b0;
   assign _sllv = (imem[31:26]==6'b000000&&imem[5:0]==6'b000100)?1'b1:1'b0;
   assign _srlv = (imem[31:26]==6'b000000&&imem[5:0]==6'b000110)?1'b1:1'b0;
   assign _srav = (imem[31:26]==6'b000000&&imem[5:0]==6'b000111)?1'b1:1'b0;
   assign _jr = (imem[31:26]==6'b000000&&imem[5:0]==6'b001000)?1'b1:1'b0;
   
   //18~29
   assign _addi = (imem[31:26]==6'b001000)?1'b1:1'b0;
   assign _addiu = (imem[31:26]==6'b001001)?1'b1:1'b0;
   assign _andi = (imem[31:26]==6'b001100)?1'b1:1'b0;
   assign _ori = (imem[31:26]==6'b001101)?1'b1:1'b0;
   assign _xori = (imem[31:26]==6'b001110)?1'b1:1'b0;
   assign _lw = (imem[31:26]==6'b100011)?1'b1:1'b0;
   assign _sw = (imem[31:26]==6'b101011)?1'b1:1'b0;
   assign _beq = (imem[31:26]==6'b000100)?1'b1:1'b0;
   assign _bne = (imem[31:26]==6'b000101)?1'b1:1'b0;
   assign _slti = (imem[31:26]==6'b001010)?1'b1:1'b0;
   assign _sltiu = (imem[31:26]==6'b001011)?1'b1:1'b0;
   assign _lui = (imem[31:26]==6'b001111)?1'b1:1'b0;
   
   //30 31
   assign _j = (imem[31:26]==6'b000010)?1'b1:1'b0;
   assign _jal = (imem[31:26]==6'b000011)?1'b1:1'b0;
   
   //*********32~54**************
   wire _clz,_divu,_div,_multu,_mul;
   wire _lb,_lbu,_lhu, _lh;
   wire _sb,_sh;
   assign _clz = (imem[31:26]==6'b011100&&imem[5:0]==6'b100000)?1'b1:1'b0;
   assign _divu = (imem[31:26]==6'b000000&&imem[5:0]==6'b011011)?1'b1:1'b0;
   assign _div = (imem[31:26]==6'b000000&&imem[5:0]==6'b011010)?1'b1:1'b0;
   assign _multu = (imem[31:26]==6'b000000&&imem[5:0]==6'b011001)?1'b1:1'b0;
   assign _mul = (imem[31:26]==6'b011100&&imem[5:0]==6'b000010)?1'b1:1'b0;
   
   assign _lb = (imem[31:26]==6'b100_000)?1'b1:1'b0;
   assign _lbu = (imem[31:26]==6'b100_100)?1'b1:1'b0;
   assign _lh = (imem[31:26]==6'b100_001)?1'b1:1'b0;
   assign _lhu = (imem[31:26]==6'b100_101)?1'b1:1'b0;
   
   assign _sb = (imem[31:26]==6'b101_000)?1'b1:1'b0;
   assign _sh = (imem[31:26]==6'b101_001)?1'b1:1'b0;

   assign _mfhi = (imem[31:26]==6'b000000&&imem[5:0]==6'b010000)?1'b1:1'b0;
   assign _mflo = (imem[31:26]==6'b000000&&imem[5:0]==6'b010010)?1'b1:1'b0;
   
   assign _mthi = (imem[31:26]==6'b000000&&imem[5:0]==6'b010001)?1'b1:1'b0;
   assign _mtlo = (imem[31:26]==6'b000000&&imem[5:0]==6'b010011)?1'b1:1'b0;
   
   assign _bgez = (imem[31:26]==6'b000001)?1'b1:1'b0;
   assign _jalr = (imem[31:26]==6'b000000&&imem[5:0]==6'b001001)?1'b1:1'b0;
   //************clz************
wire [31:0] CLZ;
  assign CLZ =Rs[31]==1? 32'h00000000:Rs[30]==1? 32'h00000001:Rs[29]==1? 32'h00000002:Rs[28]==1? 32'h00000003:Rs[27]==1? 32'h00000004:
          Rs[26]==1? 32'h00000005:Rs[25]==1? 32'h00000006:Rs[24]==1? 32'h00000007:Rs[23]==1? 32'h00000008:Rs[22]==1? 32'h00000009:
          Rs[21]==1? 32'h0000000a:Rs[20]==1? 32'h0000000b:Rs[19]==1? 32'h0000000c:Rs[18]==1? 32'h0000000d:Rs[17]==1? 32'h0000000e:
          Rs[16]==1? 32'h0000000f:Rs[15]==1? 32'h00000010:Rs[14]==1? 32'h00000011:Rs[13]==1? 32'h00000012:Rs[12]==1? 32'h00000013:
          Rs[11]==1? 32'h00000014:Rs[10]==1? 32'h00000015:Rs[9]==1? 32'h00000016:Rs[8]==1? 32'h00000017:Rs[7]==1? 32'h00000018:
          Rs[6]==1? 32'h00000019:Rs[5]==1? 32'h0000001a:Rs[4]==1? 32'h0000001b:Rs[3]==1? 32'h0000001c:Rs[2]==1? 32'h0000001d:
          Rs[1]==1? 32'h0000001e:Rs[0]==1? 32'h0000001f:32'h00000020;

//  always @ (*)
//     begin
//        if(_clz) case(Rs)
//                         32'b1???????????????????????????????:   clz_temp   =       32'h0;
//                         32'b01??????????????????????????????:   clz_temp   =       32'h1;
//                         32'b001?????????????????????????????:   clz_temp   =       32'h2;
//                         32'b0001????????????????????????????:   clz_temp   =       32'h3;
//                         32'b00001???????????????????????????:   clz_temp   =       32'h4;
//                         32'b000001??????????????????????????:   clz_temp   =       32'h5;
//                         32'b0000001?????????????????????????:   clz_temp   =       32'h6;
//                         32'b00000001????????????????????????:   clz_temp   =       32'h7;
//                         32'b000000001???????????????????????:   clz_temp   =       32'h8;
//                         32'b0000000001??????????????????????:   clz_temp   =       32'h9;
//                         32'b00000000001?????????????????????:   clz_temp   =       32'ha;
//                         32'b000000000001????????????????????:   clz_temp   =       32'hb;
//                         32'b0000000000001???????????????????:   clz_temp   =       32'hc;
//                         32'b00000000000001??????????????????:   clz_temp   =       32'hd;
//                         32'b000000000000001?????????????????:   clz_temp   =       32'he;
//                         32'b0000000000000001????????????????:   clz_temp   =       32'hf;
//                         32'b00000000000000001???????????????:   clz_temp   =       32'h10;
//                         32'b000000000000000001??????????????:   clz_temp   =       32'h11;
//                         32'b0000000000000000001?????????????:   clz_temp   =       32'h12;
//                         32'b00000000000000000001????????????:   clz_temp   =       32'h13;
//                         32'b000000000000000000001???????????:   clz_temp   =       32'h14;
//                         32'b0000000000000000000001??????????:   clz_temp   =       32'h15;
//                         32'b00000000000000000000001?????????:   clz_temp   =       32'h16;
//                         32'b000000000000000000000001????????:   clz_temp   =       32'h17;
//                         32'b0000000000000000000000001???????:   clz_temp   =       32'h18;
//                         32'b00000000000000000000000001??????:   clz_temp   =       32'h19;
//                         32'b000000000000000000000000001?????:   clz_temp   =       32'h1a;
//                         32'b0000000000000000000000000001????:   clz_temp   =       32'h1b;
//                         32'b00000000000000000000000000001???:   clz_temp   =       32'h1c;
//                         32'b000000000000000000000000000001??:   clz_temp   =       32'h1d;
//                         32'b0000000000000000000000000000001?:   clz_temp   =       32'h1e;
//                         32'b00000000000000000000000000000001:   clz_temp   =        32'h1f;
//                         32'b00000000000000000000000000000000:    clz_temp   =       32'h20;
//                     endcase
//     end
   //*********clz******end**********
  
   //***********divu*********
   wire [31:0]divu_q;
   wire [31:0] du_q;
   wire [31:0]divu_r;
   wire [31:0] du_r;
   wire divu_busy;
  DIVU divu(
  .dividend(Rs),
  .divisor(Rt),
  .start(_divu),
  .clock(clk_in),
   .reset(reset),
   .q(du_q),
   .r(du_r),
   .busy(divu_busy)
       );
  
  assign      divu_q=divu_busy?32'bz:du_q;
  assign      divu_r=divu_busy?32'bz:du_r;   
   //**********divu***end********
  
  //************div*************
    wire [31:0]div_q;
    wire [31:0] d_q;
    wire [31:0]div_r;
    wire [31:0] d_r;
    wire div_busy;
       DIV div(
       .dividend(Rs),
       .divisor(Rt),
       .start(_div),
       .clock(clk_in),
        .reset(reset),
        .q(d_q),
        .r(d_r),
        .busy(div_busy)
            );
       
       assign      div_q=div_busy?32'bz:d_q;
       assign      div_r=div_busy?32'bz:d_r;  
  //*********div***end
  
  //*********multu**********
      wire [63:0]multu_r;
      wire [63:0] mu_r;
//      wire multu_busy;
         MULTU  multu(
         .clk(clk_in),
          .reset(reset),
          .start(_multu),
          .a(Rs),
          .b(Rt),
          .z(mu_r)
//          .busy(multu_busy)
              );
//         assign      multu_r=multu_busy?64'bz:mu_r;
          assign      multu_r=mu_r;
  //*********multu***end****

    //*********mul**********
      wire [63:0]mul_r;
      wire [63:0] m_r;
//      wire mul_busy;
//         MUL  muL(
//         .clk(clk_in),
//          .reset(reset),
//          .start(_mul),
//          .a(Rs),
//          .b(Rt),
//          .z(m_r),
//          .busy(mul_busy)
//              );
         assign      mul_r=Rs*Rt;
         
        
         assign m_r=mul_r[31:0];
  //*********multu***end****
  
  wire busy;
//  assign busy=mul_busy||multu_busy||div_busy||divu_busy;
    assign busy= div_busy||divu_busy;

  //***********_lw*****_lb **** _lbu**** _lh***_lhu******
    //**********sw***sb**********sh*********
  wire [5:0]  op =  imem[31:26];
  reg [31:0] dmem_data;
  always@(*)begin
   case(op)
             //lb
             6'b100_000:     dmem_data   =   {{24{ram_out[31]}},ram_out[31:24]};
             //lbu
             6'b100_100:    dmem_data   =   {24'b0,ram_out[31:24]};
             //lh
             6'b100_001:     dmem_data   =   {{16{ram_out[31]}},ram_out[31:16]};
             //lhu
             6'b100_101:    dmem_data   =   {16'b0,ram_out[31:16]};
             //lw
             6'b100011:     dmem_data   =   ram_out;
             default:dmem_data   =   ram_out;
         endcase
  end
  assign select = _sb?3'b001:(_sh?3'b010:3'b100);
 //    case(op)
//             //sb
//             6'b101_000:     dmem_in    =   {24'b0,Rt[7:0]};
//             //sh
//             6'b101_001:     dmem_in    =   {16'b0,Rt[15:0]};
//             //sw
////             6'b101_011:     dmem_in    =   Rt;
//             default:
            
//        endcase

  //*************************************
  //*********LO******HI*******
  wire [31:0]lo_out;
  reg [31:0]lo_in;
  wire [31:0]hi_out;
  reg [31:0]hi_in;
  wire [11:0]  op12 = {imem[31:26],imem[5:0]};
 
  wire LO_ctrl,HI_ctrl;
  
  assign L=lo_in;
  assign H=hi_in;
  
  assign LO_ctrl=_divu || _div||_mtlo||_multu?1'b1:1'b0;
  assign HI_ctrl=_divu || _div||_mthi||_multu?1'b1:1'b0;
  always@(*)begin
     case(op12)
               //divu
               12'b000000_011011:    begin
                lo_in   =  divu_q;
                hi_in   =  divu_r;
                end
               //div
               12'b000000_011010:    begin
               lo_in   =  div_q;
               hi_in   =  div_r;
               end
               //multu
               12'b000000_011001:begin
               lo_in = multu_r[31:0];
               hi_in = multu_r[63:32];
               end
               //mtlo
               12'b000000_010011:     lo_in   =  Rs;
               //mthi
               12'b000000_010001:    hi_in   =   Rs;
           endcase  
    end
  
  
 HLreg LO(
   .clk(clk_in),
   .rst(reset),
   .wena(LO_ctrl),
   .data_in(lo_in),
   .data_out(lo_out)
   );  
  
 HLreg HI(
  .clk(clk_in),
  .rst(reset),
  .wena(HI_ctrl),
  .data_in(hi_in),
  .data_out(hi_out)
  );
  //***********************
  
   //************CP0***********
   assign _break = (imem[31:26]==6'b000000&&imem[5:0]==6'b001101)?1'b1:1'b0;
   assign _syscall = (imem[31:26]==6'b000000&&imem[5:0]==6'b001100)?1'b1:1'b0;
   assign _teq = (imem[31:26]==6'b000000&&imem[5:0]==6'b110100)?1'b1:1'b0;
   assign _eret = (imem[31:26]==6'b010000&&imem[5:0]==6'b011000)?1'b1:1'b0;
   assign _mfc0 = (imem[31:26]==6'b010000&&imem[25:21]==5'b00000)?1'b1:1'b0;
   assign _mtc0 = (imem[31:26]==6'b010000&&imem[25:21]==5'b00100)?1'b1:1'b0;
   
   //************CP0_CONTROL************
   
   wire exception;
   wire [4:0] cause;
   assign exception = (_break||_syscall||(_teq&&zero)) ?1'b1:1'b0;
   assign cause = _break?5'b01001:(_syscall?5'b01000:(_teq?5'b01101:5'b00000));

   wire [31:0] rdata; 
   wire [31:0] status;
   wire [31:0] exc_addr;  //un
   
CP0 cp0(clk_in,reset,_mfc0,_mtc0,PC,imem[15:11],
Rt, 
exception,_eret,
cause,
rdata, status,exc_addr );
   
   //******************CP0_END*************************
   
   //Control signal expression
   assign M3 = _sll || _srl || _sra ;
   assign M3_2 = _jal||_jalr ;
   assign M4 = _addi || _addiu || _andi || _ori || _xori || _slti || _sltiu || _lui || _lw||_lb || _lbu || _lh ||_lhu || _sw ||_sb||_sh;
   assign M4_2 = _jal ||_jalr;
   assign M6 =_addi||_addiu||_andi||_ori||_xori|||_slti||_sltiu||_lui||_lw ||_lb || _lbu || _lh ||_lhu||_mfc0;
   assign M7 =_jal;
   assign ALUC[3] = _slt || _sltu ||_sllv || _srlv || _srav || _sll || _srl || _sra || _slti || _sltiu || _lui ;
   assign ALUC[2] = _and || _or ||_xor || _nor || _sllv || _srlv || _srav || _sll || _srl || _sra || _andi || _ori || _xori ;
   assign ALUC[1] = _add || _sub ||_xor || _nor || _slt || _sltu || _sllv || _sll || _addi || _xori || _slti || _sltiu;
   assign ALUC[0] = _sub || _subu ||_or || _nor || _slt || _srlv || _srl || _ori || _slti || _beq || _bne ||_teq;//cp0 teq
   assign M2 = (!_lw) && (!_lb) && (!_lbu) &&  (!_lh) && (!_lhu);
   assign rdc = M6?imem[20:16]:(M7?5'd31:imem[15:11]);
   assign RF_W= (!_sw)&&(!_beq)&&(!_bne)&&(!_bgez)&&(!_j)&&(!_jr)&&(!_sb)&&(!_sh)&&(!_mtc0)&&(!_eret)&&(!_syscall)&&(!_teq)&&(!_break)&&(!_divu)&&(!_div)&&(!_multu)&&(!_mthi)&&(!_mtlo);//&&(!_break)&&(!_divu)&&(!_div)&&(!_multu)&&(!_mthi)&&(!_mtlo)
   assign RL_CLK= ((!_sw)&&(!_beq)&&(!_bne)&&(!_bgez)&&(!_j)&&(!_jal)&&(!_jalr)&&(!_jr)&&(!_sb)&&(!_sh))&&clk_in;
   assign M5 = (_beq&&zero) || (_bne&&(!zero)) ||(_bgez&&(Rs[31]==1'b0));
   assign M1 = (!_j)&&(!_jal)&&(!_jalr) ;
   assign M1_2 = _jr||_jalr ;
   assign cs = _lw||_lb || _lbu || _lh ||_lhu || _sw||_sb||_sh;
   assign dm_r = _lw||_lb || _lbu || _lh ||_lhu;
   assign dm_w = _sw||_sb||_sh;
   assign ext16_sin_judge = _addi || _addiu || _slti||_sltiu || _lw||_lb || _lbu || _lh ||_lhu; //sign_ext
   
//***************************
    assign ext18_sign = {{14{imem[15]}},{imem[15:0],2'h0}};
    assign npc = PC + 4;
    assign ext16_sign = {{16{imem[15]}},imem[15:0]};//
    assign ext16 = {16'h0,imem[15:0]};
    assign mux_in_4 = ext16_sin_judge?ext16_sign:ext16;
    assign rsc = imem[25:21];
    assign rtc = imem[20:16];
    
assign mux_out_1=M1?mux_out_5:{PC[31:28],imem[25:0],2'b00};  //mux1

  
//CP0 eret
assign mux_out_1_2=M1_2?Rs:((_eret||exception)?exc_addr:mux_out_1); //mux1_2


//CP0 mfc0
//assign mux_out_2=M2?alu_r:(_mfc0?rdata:dmem_data); //mux2   //cp0
wire [6:0]  op3 =  {M2,_mfc0,_clz,_mfhi,_mflo,_multu,_mul};
  always@(*)begin
   case(op3)
             //M2=0
             7'b0000000:     Rd   =  dmem_data;
             //M2=1
             7'b1000000:    Rd   =  alu_r;
             //mfc0
             7'b1100000:     Rd   =  rdata;
             //clz
             7'b1010000:    Rd   =  CLZ;
             //mfhi
             7'b1001000:     Rd   =   hi_out;
             //mflo
             7'b1000100:     Rd   =   lo_out;
             //multu
             7'b1000010:     Rd   =   mu_r[31:0];
             //mul
             7'b1000001:     Rd   =   m_r[31:0];
             default:Rd   =   alu_r;
         endcase
         
  end


assign mux_out_3=M3?{27'b0,imem[10:6]}:Rs;



assign mux_out_3_2=M3_2?PC:mux_out_3;
//MUX MUX3_2(
//.data0(mux_out_3),
//.data1(PC_out),
//.is(M3_2),
//.d_out(mux_out_3_2)
//); 

assign mux_out_4=M4?mux_in_4:Rt;
//MUX MUX4(
//.data0(Rt),
//.data1(mux_in_4),
//.is(M4),
//.d_out(mux_out_4)
//); 

assign mux_out_4_2=M4_2?32'd4:mux_out_4;
//MUX MUX4_2(
//.data0(mux_out_4),
//.data1(32'd8),
//.is(M4_2),
//.d_out(mux_out_4_2)
//); 
//assign mux_out_4_3=_bgez?32'd0:mux_out_4_2;


assign mux_out_5=M5?ext18_sign+npc:npc;
//MUX MUX5(
//.data0(npc),  // NPC
//.data1(),
//.is(M5),
//.d_out(mux_out_5)
//); 



pcreg PCreg(
.clk(clk_in),
.rst(reset),
.ena(1),
.wena(!busy),
.data_in(mux_out_1_2),
.data_out(PC)
);

regfile cpu_ref(
.clk(clk_in),
.rst(reset),
.ena(1),
.we(RF_W),
.raddr1(rsc), //rsc
.raddr2(rtc),//rtc
.waddr(rdc),  //rdc 5bits
.wdata(Rd), //rd
.rdata1(Rs), //rs
.rdata2(Rt) //rt
        );
        
ALU alu(
.a(mux_out_3_2),
.b(mux_out_4_2),
.aluc(ALUC),
.r(alu_r),
.zero(zero),
.carry(carry),
.negative(negative),
.overflow(overflow)
            );
            
//DMEM dram(
//.clk(clk_in),
//.CS(DM_CS),  //enable control signal
//.DM_W(DM_W), //write
//.DM_R(DM_R), //read
//.Addr(alu_r[9:0]),
//.Data_in(Rt),
//.Data_out(ram_out)
//    );

endmodule