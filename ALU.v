`timescale 1ns / 1ps

//ALUģ��
module ALU(OP,A,B,Rst,clk,F,ZF,CF,OF,SF,PF);
    parameter SIZE = 31;//����λ��
    input [3:0] OP;//�������
    input [SIZE:0] A;//��������
    input [SIZE:0] B;//��������
    input Rst,clk; //ʱ���߼���·�ź�
    output [SIZE:0] F;//������
    output  ZF, //0��־λ, ������Ϊ0(ȫ��)����1, ������0 
            CF, //����λ��־λ, ȡ���λ��λC,�ӷ�ʱC=1��CF=1��ʾ�н�λ,����ʱC=0��CF=1��ʾ�н�λ
            OF, //�����־λ�����з��������������壬�����OF=1������Ϊ0
            SF, //���ű�־λ����F�����λ��ͬ
            PF; //��ż��־λ��F��������1����PF=1������Ϊ0
    reg [SIZE:0] F;
    wire [SIZE:0] F2;
    reg flag=0;
    reg C;
    wire ZF,CF,OF,SF,PF,Carry;//CΪ���λ��λ
    wire cout;

    // һλȫ����
    task fulladder(
        input  a,b,cin,
        output sum,cout
        );
        begin
            assign sum = (a^b) ^cin;
            assign cout = (a&b)|((a^b)&cin);
        end
    endtask
    
    // ************************************************************************
    // 32λ���н�λ�ӷ���
    task full_adder_32bit(
        input [31:0] a,b,
        output [31:0] sum,
        output cout
        );
        reg [31:0] carry;
        begin  
            fulladder(a[0],b[0],    1'b0, sum[0],carry[0]);
            fulladder(a[1],b[1],carry[0], sum[1],carry[1]);
            fulladder(a[2],b[2],carry[1], sum[2],carry[2]);
            fulladder(a[3],b[3],carry[2], sum[3],carry[3]);
            fulladder(a[4],b[4],carry[3], sum[4],carry[4]);
            fulladder(a[5],b[5],carry[4], sum[5],carry[5]);
            fulladder(a[6],b[6],carry[5], sum[6],carry[6]);
            fulladder(a[7],b[7],carry[6], sum[7],carry[7]);
            fulladder(a[8],b[8],carry[7], sum[8],carry[8]);
            fulladder(a[9],b[9],carry[8], sum[9],carry[9]);
            fulladder(a[10],b[10],carry[9], sum[10],carry[10]);
            fulladder(a[11],b[11],carry[10], sum[11],carry[11]);
            fulladder(a[12],b[12],carry[11], sum[12],carry[12]);
            fulladder(a[13],b[13],carry[12], sum[13],carry[13]);
            fulladder(a[14],b[14],carry[13], sum[14],carry[14]);
            fulladder(a[15],b[15],carry[14], sum[15],carry[15]);
            fulladder(a[16],b[16],carry[15], sum[16],carry[16]);
            fulladder(a[17],b[17],carry[16], sum[17],carry[17]);
            fulladder(a[18],b[18],carry[17], sum[18],carry[18]);
            fulladder(a[19],b[19],carry[18], sum[19],carry[19]);
            fulladder(a[20],b[20],carry[19], sum[20],carry[20]);
            fulladder(a[21],b[21],carry[20], sum[21],carry[21]);
            fulladder(a[22],b[22],carry[21], sum[22],carry[22]);
            fulladder(a[23],b[23],carry[22], sum[23],carry[23]);
            fulladder(a[24],b[24],carry[23], sum[24],carry[24]);
            fulladder(a[25],b[25],carry[24], sum[25],carry[25]);
            fulladder(a[26],b[26],carry[25], sum[26],carry[26]);
            fulladder(a[27],b[27],carry[26], sum[27],carry[27]);
            fulladder(a[28],b[28],carry[27], sum[28],carry[28]);
            fulladder(a[29],b[29],carry[28], sum[29],carry[29]);
            fulladder(a[30],b[30],carry[29], sum[30],carry[30]);
            fulladder(a[31],b[31],carry[30], sum[31],carry[31]);
            
            assign cout = carry[31];
        end
    endtask
    // ************************************************************************
    
    // ************************************************************************
    // 32λ��ǰ��λ�ӷ���
    /******************4λCLA����************************/
    task CLA(
         input c0,g1,g2,g3,g4,p1,p2,p3,p4,
         output c1,c2,c3,c4);
         
         begin
             assign   c1 = g1 ^ (p1 & c0);
             assign   c2 = g2 ^ (p2 & g1) ^ (p2 & p1 & c0);
             assign   c3 = g3 ^ (p3 & g2) ^ (p3 & p2 & g1) ^ (p3 & p2 & p1 & c0);
             assign   c4 = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1) ^(p4 & p3 & p2 & p1 & c0);
         end
         
    endtask
    
    //��λ���н�λ�ӷ���
    task adder_4(
         input [3:0] x,
         input [3:0] y,
         input c0,
         output c4,Gm,Pm,
         output [3:0] F);
              
         reg p1,p2,p3,p4,g1,g2,g3,g4;
         reg c1,c2,c3;
         reg temp;
         
         begin
 
            assign p1 = x[0] ^ y[0];	  
            assign p2 = x[1] ^ y[1];
            assign p3 = x[2] ^ y[2];
            assign p4 = x[3] ^ y[3];
            
            assign g1 = x[0] & y[0];
            assign g2 = x[1] & y[1];
            assign g3 = x[2] & y[2];
            assign g4 = x[3] & y[3];
            
             CLA(
			.c0(c0),
			.c1(c1),
			.c2(c2),
			.c3(c3),
			.c4(c4),
			.p1(p1),
			.p2(p2),
			.p3(p3),
			.p4(p4),
			.g1(g1),
			.g2(g2),
			.g3(g3),
			.g4(g4)
		  );
		  
            fulladder(.a(x[0]),.b(y[0]),.cin(c0),.sum(F[0]),.cout(temp));
            fulladder(.a(x[1]),.b(y[1]),.cin(c1),.sum(F[1]),.cout(temp));
            fulladder(.a(x[2]),.b(y[2]),.cin(c2),.sum(F[2]),.cout(temp));
            fulladder(.a(x[3]),.b(y[3]),.cin(c3),.sum(F[3]),.cout(temp));

            
            assign Pm = p1 & p2 & p3 & p4;
            assign Gm = g4 ^ (p4 & g3) ^ (p4 & p3 & g2) ^ (p4 & p3 & p2 & g1);
        end
    endtask
    
    //16λCLA����
    task CLA_16(
        input [15:0] A,
        input [15:0] B,
        input c0,
        output gx,px,
        output [15:0] S);
        
        reg c4,c8,c12,temp;
        reg Pm1,Gm1,Pm2,Gm2,Pm3,Gm3,Pm4,Gm4;
        
        begin
            adder_4(
                  .x(A[3:0]),
                  .y(B[3:0]),
                  .c0(c0),
                  .c4(temp),
                  .F(S[3:0]),
                  .Gm(Gm1),
                  .Pm(Pm1)
            );
            assign   c4 = Gm1 ^ (Pm1 & c0);
            adder_4(
                 .x(A[7:4]),
                  .y(B[7:4]),
                  .c0(c4),
                  .c4(temp),
                  .F(S[7:4]),
                  .Gm(Gm2),
                  .Pm(Pm2)
            );
            assign   c8 = Gm2 ^ (Pm2 & Gm1) ^ (Pm2 & Pm1 & c0);
            adder_4(
                 .x(A[11:8]),
                  .y(B[11:8]),
                  .c0(c8),
                  .c4(temp),
                  .F(S[11:8]),
                  .Gm(Gm3),
                  .Pm(Pm3)
            );
            assign	 c12 = Gm3 ^ (Pm3 & Gm2) ^ (Pm3 & Pm2 & Gm1) ^ (Pm3 & Pm2 & Pm1 & c0);
            adder_4(
                 .x(A[15:12]),
                  .y(B[15:12]),
                  .c0(c12),
                  .c4(temp),
                  .F(S[15:12]),
                  .Gm(Gm4),
                  .Pm(Pm4)
            );
            
            assign  px = Pm1 & Pm2 & Pm3 & Pm4;
            assign  gx = Gm4 ^ (Pm4 & Gm3) ^ (Pm4 & Pm3 & Gm2) ^ (Pm4 & Pm3 & Pm2 & Gm1);
        end
               
    endtask
    
    task adder32(
         input [31:0] A,
         input [31:0] B,
         output [31:0] S,
         output C31);
       
        reg px1,gx1,px2,gx2;
        reg c15;
        
         begin   
            CLA_16(
              .A(A[15:0]),
                .B(B[15:0]),
                .c0(0),
                .S(S[15:0]),
                .px(px1),
                .gx(gx1)
            );
            
            assign c15 = gx1 ^ (px1 && 0); //c0 = 0
            
            CLA_16(
            .A(A[31:16]),
              .B(B[31:16]),
              .c0(c15),
              .S(S[31:16]),
              .px(px2),
              .gx(gx2)
            );
            
            assign C31 = gx2 ^ (px2 && c15);
       end
    endtask
    // ************************************************************************
    serialadd seri(A,B,Rst,clk,F2,Carry);

    always@(*)
    begin
        C=0;
        case(OP)
            4'b0000:begin F=A&B; end    //��λ��
            4'b0001:begin F=A|B; end    //��λ��
            4'b0010:begin F=A^B; end    //��λ���
            4'b0011:begin F=~(A|B); end //��λ���
            4'b0100:begin full_adder_32bit(A,B,F,C); end//���н�λ�ӷ�
            4'b0101:begin adder32(A,B,F,C); end //��ǰ��λ�ӷ�
            4'b0110:begin F=A<B; end    //A<B��F=1������F=0
            4'b0111:begin F=B<<A; end   //��B����Aλ
            4'b1000:begin 
                F<=F2;
                C<=Carry; 
            end
        endcase
        
    end
    
    assign PF = ~^F;//��ż��־��F��������1����F=1��ż����1����F=0
    assign ZF = F==0;//FȫΪ0����ZF=1
    assign CF = C; //��λ��λ��
    assign OF = A[SIZE]^B[SIZE]^F[SIZE]^C;//�����־��ʽ
    assign SF = F[SIZE];//���ű�־,ȡF�����λ
    
endmodule

//// �桤���н�λ�ӷ���
//// ʵ��ԭ������������λ�Ĵ���+һ����λ������+һ��ȫ����
//// ��������Ҫ���һ����·����ʱ�������ڴ���һλ��ӵĴ��мӷ���

// һλȫ����
module fulladder(
    input wire a,b,cin,
    output wire sum,cout
    );
    assign sum = (a^b) ^cin;
    assign cout = (a&b)|((a^b)&cin);
endmodule

// ��λ�Ĵ�����ֱ��ȡQ[0]����
module shiftrne(R,L,E,w,clk,Q);

   parameter n=32;
	input [n-1:0] R;
	input L,E,w,clk;
	output reg [n-1:0] Q;

	integer k;

	always @(posedge clk) begin
	   if(L)
		  Q<=R;
		else if(E) begin
		   for(k=n-1; k>0; k=k-1)
			   Q[k-1] <= Q[k];
			Q[n-1] <=w;
		end
	end

endmodule

module serialadd(A,B,Rst,clk,S,Carry);
  input [31:0] A,B;
  input Rst,clk;
  output wire [31:0] S;
  output wire Carry;

  reg [5:0] Count;
  reg s,y,Y;
  wire [31:0] QA,QB;
  wire Run;
  parameter G=1'b0, H=1'b1;

  shiftrne #(.n(32)) shift_A(.R(A),.L(Rst),.E(1'b1),.w(1'b0),.clk(clk),.Q(QA));
  shiftrne #(.n(32)) shift_B(.R(B),.L(Rst),.E(1'b1),.w(1'b0),.clk(clk),.Q(QB));
  shiftrne #(.n(32)) shift_S(.R(32'b0),.L(Rst),.E(Run),.w(s),.clk(clk),.Q(S));
  
  assign Carry = S[0];

  always @(QA,QB,y) begin

      case (y)
		  G:
		  begin
		    s = QA[0]^QB[0];
			 if(QA[0]&QB[0]) Y=H;
			 else  Y=G;

		  end
		  H:
		  begin
		    s = QA[0]~^QB[0];
			 if(~QA[0]&~QB[0]) Y=G;
			 else  Y=H;

		  end
		 default:
		    Y  = G;
		endcase
  end

  //ʱ���ź�
  always @(posedge clk)
    if(Rst)
	   y<=G;
	 else
	    y<=Y;

  //��λ���Ʋ�����
  always @(posedge clk)
    if(Rst) Count=32;
	 else if(Run) Count = Count-1;

  assign Run = |Count;
endmodule