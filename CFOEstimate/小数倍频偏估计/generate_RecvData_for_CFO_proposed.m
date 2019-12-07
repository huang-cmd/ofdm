%�������ܣ����ɸĽ��㷨��Ӧ��ͬ��֡���У�TS_sym�����Լ�����ʹ�õļ���Ƶƫ�Ĵ������ݣ�recv_sig��
%������� N:OFDMϵͳ��Ч���ų��ȣ���FFT����
%         Ng:ѭ��ǰ׺�ķ��ų���
function [recv_sig,TS_sym] =  generate_RecvData_for_CFO_proposed(N,Ng,deltaf)
%N     %FFT/IFFT �任�ĵ����������ز�������Nu=N�� 
%Ng      %ѭ��ǰ׺�ĳ��� (��������ĳ���) 
Ns=Ng+N;     %����ѭ��ǰ׺�ķ��ų��� 
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
%=============�������ݷ���=============
src = QAMTable(randi([0,3],N,1)+1); 
sym = ifft(src); 
cp_sym=[sym(1,N-Ng+1:N) sym];
predata = cp_sym;
suffixdata = cp_sym;
%=============����ѵ������======================
a = zeros(1,N/4);
mu = N/4-1;
for n=0:N/4-1
   a(n+1) =7*exp(4*sqrt(-1)*mu*pi*n*n/N);
end
A = ifft(a);
%A =a;
B = conj(A(1,N/4:-1:1));
C= zeros(1,N/4);
for n=1:1:N/4 % C(n) = m(n)B(n)
    if mod(n,2)
       % C(n) = (-1)*conj(B(n));
       C(n) = (-1)*B(n);
    else
       % C(n) = conj(B(n));
       C(n) = B(n);
    end
end
D=C;
signal = [A B C D];
TS_sym = signal;
cp_train = [signal(1,N-Ng+1:N) signal];
transmit_data = [predata cp_train suffixdata];
%=============ģ�⾭���ŵ�=========================
recv = transmit_data;
for k=1:length(recv)
    %���Ƶƫ
    recv(k) = recv(k)*exp(i*2*pi*deltaf*k/N);
end
recv_sig = recv;
end