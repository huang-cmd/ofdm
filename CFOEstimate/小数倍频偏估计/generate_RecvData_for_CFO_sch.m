%�������ܣ�����schmidl�㷨����ʹ�õļ���Ƶƫ�Ĵ������ݣ�recv_sig��,�Լ�������У�v_sig��
%������� N:OFDMϵͳ��Ч���ų��ȣ���FFT����
%         Ng:ѭ��ǰ׺�ķ��ų���
function [recv_sig,v_sig] = generate_RecvData_for_CFO_sch(N,Ng,deltaf)
Ns=Ng+N;     %����ѭ��ǰ׺�ķ��ų��� 
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
%=============�������ݷ���=============
src = QAMTable(randi([0,3],N,1)+1); 
sym = ifft(src,N); 
cp_sym=[sym(1,N-Ng+1:N) sym];
predata = cp_sym;
suffixdata = cp_sym;
%=============����ѵ������1======================
buf=QAMTable(randi([0,3],N/2,1)+1); %1x(N/2)�ľ���
train1=zeros(1,N); 
index = 1; 
for n=1:2:N 
     train1(n)=buf(index); 
     index=index+1; 
end; 
sch = ifft(train1,N);   %[A A]����ʽ 
cp_train1 = [sch(1,N-Ng+1:N) sch];
%=============����ѵ������2======================
buf=QAMTable(randi([0,3],N/2,1)+1); %1x(N/2)�ľ���
train2=zeros(1,N); 
index = 1; 
for n=1:2:N 
     train2(n)=buf(index); 
     index=index+1; 
end; 
sch = ifft(train2,N);   %[A A]����ʽ 
cp_train2 = [sch(1,N-Ng+1:N) sch];
%==============����������====================
v =sqrt(2)*train2./train1;
%=============�����ŵ�=========================
transmit_data = [cp_train1 cp_train2 suffixdata]; 
recv = transmit_data;
for k=1:length(recv)
    recv(k) = recv(k)*exp(i*2*pi*deltaf*k/N);
end

recv_sig = recv;
v_sig = v;
end