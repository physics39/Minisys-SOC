`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/14 22:13:43
// Design Name: 
// Module Name: pipelinedcpu
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
module pipelinedcpu(inputclock,resetn,pulse0,pulse1,cnt0,cnt1,pwm,digital,ens);//下载板子时用这个

/*
module pipelinedcpu
(inputclock,resetn,pc,inst,ealu,malu,walu,
pulse0,pulse1,cnt0,cnt1,pwm,digital,ens,
da,db,dimm,pc4,dlmem,msmem,wea,dwmem,ewmem,mwmem,esmem,wdi,mb,wrn,compare,cpdone//for testss
);//仿真时用这个
*/
    //定义外设的输入输出GPIO
    input pulse0;
    input pulse1;
    output [7:0] digital;
    output [7:0] ens;
    output cnt0;
    output cnt1;
    output pwm;
    input inputclock,resetn;
    wire clock;
    //assign clock=inputclock;//仿真时候用这个
    clock_div uut_clk(inputclock,clock);//下载板子时用这个 1khz
    /*
    //debug
    output [2:0] dlmem;
    output [1:0] msmem;
    output [3:0] wea;
    output [31:0] pc,inst,ealu,malu,walu;
    output [1:0] compare;//debug
    output cpdone;//debug
    output [31:0] da,db,dimm,pc4;
    output [31:0] wdi;//debug
    output [1:0] esmem;
    output [31:0] mb;//debug
    output [4:0] wrn;
    output dwmem,ewmem,mwmem;//debug
    //debug end
    */
    wire [3:0] wea;
    wire [31:0] pc,ealu,malu,walu;
    wire [31:0] bpc,jpc,npc,pc4,ins,dpc4,inst,da,db,dimm,ea,eb,eimm;
    wire [1:0] compare;
    wire cpdone;

    wire [31:0] epc4,mb,mmo,wmo,wdi;
    wire [4:0] drn,ern0,ern,mrn,wrn;
    wire [3:0] daluc,ealuc; //daluc = aluc
    wire [1:0] pcsource;
    wire wpcir;
    wire dwreg,dm2reg,dwmem,daluimm,dshift,djal;
    wire djalr;
    wire [2:0] dlmem;
    wire [1:0] dsmem;
    wire ewreg,em2reg,ewmem,ealuimm,eshift,ejal;
    wire ejalr;
    wire [2:0] elmem;
    wire [1:0] esmem;
    
    wire mwreg,mm2reg,mwmem;
    wire [2:0] mlmem;
    wire [1:0] msmem;
    wire wwreg,wm2reg;


    pipeif if_stage (pcsource,pc,bpc,da,jpc,npc,pc4,ins);
    MemorIo mem_io_stage(mwmem,msmem,mlmem,malu,mb,clock,mmo,resetn,pulse0,pulse1,cnt0,cnt1,pwm,wea,digital,ens);
    
                          
    pipepc progcnt (npc,wpcir,clock,resetn,pc);
    pipeir inst_reg (pc4,ins,wpcir,clock,resetn,dpc4,inst);
    pipeid id_stage (mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
                     wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,
                     bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,
                     daluc,daluimm,da,db,dimm,drn,dshift,djal,djalr,dlmem,dsmem,compare,cpdone);//debug
    pipedereg de_reg (dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,
                      drn,dshift,djal,djalr,dlmem,dsmem,dpc4,clock,resetn,
                      ewreg,em2reg,ewmem,ealuc,ealuimm,ea,eb,eimm,
                      ern0,eshift,ejal,ejalr,elmem,esmem,epc4);
    pipeexe exe_stage (ealuc,ealuimm,ea,eb,eimm,eshift,ern0,epc4,
                       ejal,ejalr,ern,ealu);
    pipeemreg em_reg (ewreg,em2reg,ewmem,elmem,esmem,ealu,eb,ern,clock,resetn,
                      mwreg,mm2reg,mwmem,mlmem,msmem,malu,mb,mrn);
    //pipemem mem_stage (mwmem,msmem,mlmem,malu,mb,clock,mmo);
    pipemwreg mw_reg (mwreg,mm2reg,mmo,malu,mrn,clock,resetn,
                          wwreg,wm2reg,wmo,walu,wrn);
    mux2x32 wb_stage (walu,wmo,wm2reg,wdi);
    
endmodule 
