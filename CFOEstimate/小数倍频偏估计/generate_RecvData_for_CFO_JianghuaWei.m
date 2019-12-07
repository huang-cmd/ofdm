%�ο����ף�
% @inproceedings{Wei2010Carrier,
%   title={Carrier Frequency Offset Estimation Using PN Sequence Iteration in OFDM Systems},
%   author={Wei, Jianghua and Yuan, Liu},
%   booktitle={Second International Conference on Networks Security},
%   year={2010},
% }
%�������ܣ�����Jianghua Wei�㷨��������
%������� N:OFDMϵͳ��Ч���ų��ȣ���FFT����
%         Ng:ѭ��ǰ׺�ķ��ų���
function [recv_sig] = generate_RecvData_for_CFO_JianghuaWei(N,Ng,deltaf)
Ns=Ng+N;     %����ѭ��ǰ׺�ķ��ų��� 
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
%=============�������ݷ���=============
src = QAMTable(randi([0,3],N,1)+1); 
sym = ifft(src,N); 
cp_sym=[sym(1,N-Ng+1:N) sym];
%=============����ѵ������======================
buf=QAMTable(randi([0,3],N/4,1)+1); %1x(N/2)�ľ���
train1=zeros(1,N/2); 
index = 1; 
for n=1:2:N/2 
     train1(n)=buf(index); 
     index=index+1; 
end; 
sch = ifft(train1,N/2);   %[A A]����ʽ 
cp_train = [sch(1,N/4-Ng+1:N/4) sch sch];%[cp A A A A]��ʽ
transmit_data = [cp_train cp_sym];
recv = transmit_data;
for k=1:length(recv)
    recv(k) = recv(k)*exp(sqrt(-1)*2*pi*deltaf*k/N);
end

recv_sig = recv;
end