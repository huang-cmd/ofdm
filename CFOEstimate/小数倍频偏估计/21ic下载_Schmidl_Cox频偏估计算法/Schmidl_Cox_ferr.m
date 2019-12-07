%��ʼ��
clear all
close all;
clc;
N=1024;
N_symbol=10;
ml=2;         % Modulation level : QPSK %���Ʒ�ʽ��QPSK
sr=250000; 
br=sr.*ml;
br=250000*ml;
L=120;
ebn0=15;     
deltad=0    %ʱ��100
deltaf=0.75; %Ƶ��
%****************************** ����train1 *******************************
pn=rand(1,N)>0.5;
pn=reshape(pn,N/2,2);
[ipn0,qpn0]=qpskmod(pn,N/2,1,ml);
kmod=1/sqrt(2);
ipn0=ipn0.*kmod;
qpn0=qpn0.*kmod;
sym=ipn0+i*qpn0;
symbuf=zeros(N,1);
symbuf(1:2:N,1)=sym;
train1=symbuf;
clear sym;
clear symbuf;
%*************************************************************************
% ����train2
pn1=rand(1,N)>0.5;
pn1=reshape(pn1,N/2,2);
[ipn1,qpn1]=qpskmod(pn1,N/2,1,ml);
ipn1=ipn1.*kmod;
qpn1=qpn1.*kmod;
sym=ipn1+i*qpn1;
symbuf=zeros(N,1);
symbuf(1:2:N,1)=sym;
clear sym;
pn2=rand(1,N)>0.5;
pn2=reshape(pn2,N/2,2);
[ipn2,qpn2]=qpskmod(pn2,N/2,1,ml);
ipn2=ipn2.*kmod;
qpn2=qpn2.*kmod;
sym=ipn2+i*qpn2;
symbuf(2:2:N,1)=sym;
train2=symbuf;
%****************************** ���ɷ����ź� *****************************
input_stream=rand(1,N*N_symbol*ml)>0.5;
%�����任,ת��N�У�N_symbol*ml�еľ���
para_stream=reshape(input_stream,N,N_symbol*ml);
%qpsk����
[ipn3,qpn3]=qpskmod(para_stream,N,N_symbol,ml);
ipn3=ipn3.*kmod;
qpn3=qpn3.*kmod;
x=ipn3+i*qpn3; %N_symbol*N����

%*************************************************************************
%��һ��ѵ�����ž���AWGN�źŵĽ����ź�
x(:,1)=train1;    %�������źŵĵ�һ�����Ż���ѵ������
x(:,2)=train2;
%Ƶ����ǰ������ѵ������֮��Ĳ�ֹ�ϵ,�����������Ƶƫ��
v = zeros(N,1)
v = 2^(0.5)*train2(1:N,1)./train1(1:N,1);

%ifft�任
y=ifft(x);
ich4=real(y);
qch4=imag(y);
%����ѭ��ǰ׺
[ich5,qch5]=giins(ich4,qch4,N,L,N_symbol);  %����ѭ��ǰ׺��ÿ�����ų���ΪN+L��
%Attenuation Calculation   ˥������
spow=sum(ich5.^2+qch5.^2)/N_symbol/N;
attn=0.5*spow*sr/br*10.^(-ebn0/10);
attn=sqrt(attn)
%��ʱ��
[ich6,qch6]=delay(ich5,qch5,length(ich5),deltad);
y=ich6+i*qch6;
for k=1:length(ich6)
    y(k)=y(k)*exp(j*2*pi*deltaf*k/N);  %��Ƶ��
end
ich7=real(y);
qch7=imag(y);
%����AWNG
[ich8,qch8]=comb(ich7,qch7,attn);
y=ich8+i*qch8;

%���㹫ʽ
for d=1:N
    for n=1:N/2
        z1(n)=conj(y(n+d))*y(n+d+N/2);
    end
    p1(d)=sum(z1);
    for n=1:N/2
        z2(n)=abs(y(d+n)).^2;
    end
    p2(d)=sum(z2);
end
p=abs(p1).^2./(p2.^2);
figure();
plot(p)
grid 
%axis([-500 500 0 1])
%�ҳ����ֵ
[a,b]=max(p)  %aΪ���ֵ��bΪ���ֵ����ʱ�����
ef = angle(p1(b))/pi   %����Ƶƫ��С������

%*************************************************************************
%����Ƶƫ����
r1 = y(b:b+N-1);   %��ʱУ������յ�һ��ѵ������
r2 = y(b+N+L:b+2*N+L-1);   %��ʱУ������յڶ���ѵ������

for k=1:N   %С��ƵƫУ��
    r1(k)=r1(k)*exp(-j*2*pi*ef*k/N);  %
    r2(k)=r2(k)*exp(-j*2*pi*ef*k/N);  %
end

R1 = fft(r1);
R2 = fft(r2);

for g = 0:10
    for k = 1:2:N
        if k+2*g<=N
            B1(k) = conj(R1(k+2*g))*conj(v(k))*R2(k+2*g);
        end
        if k+2*g>N
            B1(k) = 0;
        end
        B2(k) = abs(R2(k))^2;
    end
    B(g+1) = (abs(sum(B1)))^2/(2*sum(B2)^2)
end

[c,d]=max(B);
%���Ƶƫ��С
e = 2*(d-1)+ef


