`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/07 19:21:59
// Design Name: 
// Module Name: adder8
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

//8λ�ӷ���
module adder8(
    input [7:0] ina,
    input [7:0] inb,
    input inc,
    output [7:0] sum,
    output outc
    );
    assign {outc,sum} = ina + inb + inc;
    
endmodule

////8λ�ӷ���
//module lab1_add8(
//    input [7:0]inaa,
//    input [7:0]inbb,
//    input incc,
//    output [7:0]out11,
//    output zz
//    );
//assign {zz,out11}=inaa+inbb+incc;
//endmodule

////32λ�ӷ���
//module lab1_add32(
//    input [31:0]ina,
//    input [31:0]inb,
//    input inc,
//    output [31:0]out1,
//    output z
//    );
////reg��wire����������������16λ�ӷ������ԵĽ��
//reg c;   //���ʼ�Ľ�λ
//reg c1_in;    //��15:8λ���ӷ��������Ľ�λ����һλ�Ľ�λֵ��������c1_out��ֵ��
//reg c2_in;    //��23:16λ���ӷ��������Ľ�λ����һλ�Ľ�λֵ��������c2_out��ֵ��
//reg c3_in;    //��32:24λ���ӷ��������Ľ�λ����һλ�Ľ�λֵ��������c3_out��ֵ��
//wire c1_out;     //��7:0λ���ӷ�������õ��Ľ�λ
//wire c2_out;     //��15:8λ���ӷ�������õ��Ľ�λ
//wire c3_out;     //��23:15λ���ӷ�������õ��Ľ�λ
//wire c4_out;     //��31:24λ���ӷ�������õ��Ľ�λ
//wire [7:0]o1;    //��7:0λ���ӷ�������õ��ĺ�
//wire [7:0]o2;    //��15:8λ���ӷ�������õ��ĺ�
//wire [7:0]o3;    //��23:15λ���ӷ�������õ��ĺ�
//wire [7:0]o4;    //��31:24λ���ӷ�������õ��ĺ�
////��ʼ��c��ֵ
//always@(*)
//begin
//c= inc;
//end
////7:0λ�ļӷ�
//lab1_add8 add1(ina[7:0],inb[7:0],c,o1,c1_out);
////��wire��c1_out����reg��c1_in
//always@(*)
//begin
//c1_in = c1_out;
//end
////15:8�ļӷ�
//lab1_add8 add2(ina[15:8],inb[15:8],c1_in,o2,c2_out);
////��wire��c2_out����reg��c2_in
//always@(*)
//begin
//c2_in = c2_out;
//end
////23:16�ļӷ�
//lab1_add8 add3(ina[23:16],inb[23:16],c2_in,o3,c3_out);
////��wire��c2_out����reg��c2_in
//always@(*)
//begin
//c3_in = c3_out;
//end
////31:24�ļӷ�
//lab1_add8 add4(ina[31:24],inb[31:24],c3_in,o4,c4_out);
////���������ֵ
//assign out1={o4,o3,o2,o1};
//assign z=c4_out;
//endmodule
