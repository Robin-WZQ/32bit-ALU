`timescale 1ns / 1ps
`define clock_period 40
module test();
    reg [31:0] A,B;
    reg [3:0] OP;
    reg clk;
    reg Rst;
    real time_now;
    always #(`clock_period/2) clk = ~clk;
    initial//��ʼ����ÿ�����������������
    begin
            clk=1;
            Rst = 0;
        /*��λ��*/
            OP=4'b0000;A=32'h0000_0000; B=32'h0000_0001;#50;
            OP=4'b0000;A=32'h0000_0001; B=32'h0000_0001;#50;
        /*��λ��*/
            OP=4'b0001;A=32'h0000_0000; B=32'h0000_0001;#50;
            OP=4'b0001;A=32'h0000_0000; B=32'h0000_0000;#50;
        /*��λ���*/
            OP=4'b0010;A=32'h0000_0000; B=32'h0000_0001;#50;
            OP=4'b0010;A=32'h0000_0000; B=32'h0000_0000;#50;
        /*��λ���*/
            OP=4'b0011;A=32'h0000_0000; B=32'h0000_0001;#50;
            OP=4'b0011;A=32'h0000_0000; B=32'h0000_0000;#50;
        /*A<Bʱ,���1���������0*/
            OP=4'b0110;A=32'h7FFF_FFFF; B=32'h8FFF_FFFF;#50;
            OP=4'b0110;A=32'hFFFF_FFFF; B=32'h7FFF_FFFF;#50;
        /*B�߼�����Aָ����λ��*/
            OP=4'b0111;A=32'h0000_0001; B=32'h0000_0001;#50;
            OP=4'b0111;A=32'h0000_0001; B=32'h0000_0008;#50;
        /*����������-���н�λ*/
            time_now = $time;
//            $display("Now the time is %t", time_now);
            OP=4'b0100;A=32'h7FFF_FFFF; B=32'h7FFF_FFFF;#50;
//            $display("Now the time is %t", time_now);
            OP=4'b0100;A=32'hFFFF_FFFF; B=32'hFFFF_FFFF;#50;
        /*����������-��ǰ��λ*/
            OP=4'b0101;A=32'h7FFF_FFFF; B=32'h7FFF_FFFF;#50;
            OP=4'b0101;A=32'hFFFF_FFFF; B=32'hFFFF_FFFF;#50;
        /*����������-�桤����*/
            OP=4'b1000;
            A=32'h7FFF_FFFF; B=32'h7FFF_FFFF;
            Rst = 0;
            #(`clock_period)
            Rst = 1;
            #(`clock_period)
            Rst = 0;
            #(`clock_period*40)
       $stop;

    end
    
    wire [31:0] F;
    wire ZF, CF, OF, SF, PF;
    ALU ALU_test(
        .OP(OP),
        .A(A),
        .B(B),
        .Rst(Rst),
        .clk(clk),
        .F(F),
        .ZF(ZF),
        .CF(CF),
        .OF(OF),
        .SF(SF),
        .PF(PF)
    );
    
endmodule