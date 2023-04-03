`timescale 1ns / 1ps
//*************************************************************************
//   > �ļ���: multiply.v
//   > ����  ���˷���ģ�飬��Ч�ʵĵ����˷��㷨��ʹ��������������ֵ��������
//   > ����  : LOONGSON
//   > ����  : 2016-04-14
//*************************************************************************
module multiply(              // �˷���
    input         clk,        // ʱ��
    input         mult_begin, // �˷���ʼ�ź�
    input  [31:0] mult_op1,   // �˷�Դ������1
    input  [31:0] mult_op2,   // �˷�Դ������2
    output [63:0] product,    // �˻�
    output        mult_end    // �˷������ź�
);

    //�˷����������źźͽ����ź�
    reg mult_valid;
    assign mult_end = mult_valid & ~(|multiplier); //�˷������źţ�����ȫ0
    always @(posedge clk)
    begin
        if (!mult_begin || mult_end)
        begin
            mult_valid <= 1'b0;
        end
        else
        begin
            mult_valid <= 1'b1;
        end
    end

    //����Դ����ȡ����ֵ�������ľ���ֵΪ�䱾�������ľ���ֵΪȡ����1
    wire        op1_sign;      //������1�ķ���λ
    wire        op2_sign;      //������2�ķ���λ
    wire [31:0] op1_absolute;  //������1�ľ���ֵ
    wire [31:0] op2_absolute;  //������2�ľ���ֵ
    assign op1_sign = mult_op1[31];
    assign op2_sign = mult_op2[31];
    assign op1_absolute = op1_sign ? (~mult_op1+1) : mult_op1;
    assign op2_absolute = op2_sign ? (~mult_op2+1) : mult_op2;

    //���ر�����������ʱÿ��ʱ������������λ
    reg  [63:0] multiplicand;
    always @ (posedge clk)
    begin
        if (mult_valid)
        begin    // ������ڽ��г˷����򱻳���ÿ��ʱ��������λ
            multiplicand <= {multiplicand[61:0],2'b00};
        end
        else if (mult_begin) 
        begin   // �˷���ʼ�����ر�������Ϊ����1�ľ���ֵ
            multiplicand <= {32'd0,op1_absolute};
        end
    end

    //���س���������ʱÿ��ʱ������������λ
    reg  [31:0] multiplier;
    always @ (posedge clk)
    begin
        if (mult_valid)
        begin   // ������ڽ��г˷��������ÿ��ʱ��������λ
            multiplier <= {2'b00,multiplier[31:2]}; 
        end
        else if (mult_begin)
        begin   // �˷���ʼ�����س�����Ϊ����2�ľ���ֵ
            multiplier <= op2_absolute; 
        end
    end
    
    // ���ֻ���
    wire [63:0] partial_product1;
    wire [63:0] partial_product2;
    assign partial_product1 = multiplier[0] ? multiplicand : 64'd0;
    assign partial_product2 = multiplier[1]?{multiplicand[62:0],1'b0} : 64'd0;
    
    //�ۼ���
   //�ۼ���
    reg [63:0] product_temp;
    always @ (posedge clk)
    begin
        if (mult_valid)
        begin
            product_temp <= product_temp + partial_product1+ partial_product2;
        end
        else if (mult_begin) 
        begin
            product_temp <= 64'd0;  // �˷���ʼ���˻����� 
        end
    end 
     
    //�˷�����ķ���λ�ͳ˷����
    reg product_sign;
    always @ (posedge clk)  // �˻�
    begin
        if (mult_valid)
        begin
              product_sign <= op1_sign ^ op2_sign;
        end
    end 
    //���˷����Ϊ����������Ҫ�Խ��ȡ��+1
    assign product = product_sign ? (~product_temp+1) : product_temp;
endmodule
