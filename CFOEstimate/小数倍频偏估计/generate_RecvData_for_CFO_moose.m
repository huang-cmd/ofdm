%�������ܣ�����moose�㷨��Ӧ����ʹ�õļ���Ƶƫ�Ĵ������ݣ�recv_sig��
%������� N:OFDMϵͳ��Ч���ų��ȣ���FFT����
%         Ng:ѭ��ǰ׺�ķ��ų���
function [recv_sig] = generate_RecvData_for_CFO_moose(N,Ng,deltaf)
Ns=Ng+N;     %����ѭ��ǰ׺�ķ��ų��� 
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
%=============�������ݷ���=============
src = QAMTable(randi([0,3],N,1)+1); 
sym = ifft(src,N); 
signal = [sym(1,N-Ng+1:N) sym sym];
%=============ģ�����Ƶƫ========
recv = signal;
for k=1:length(recv)
    %���Ƶƫ
    recv(k) = recv(k)*exp(i*2*pi*deltaf*k/N);
end
recv_sig = recv;
end