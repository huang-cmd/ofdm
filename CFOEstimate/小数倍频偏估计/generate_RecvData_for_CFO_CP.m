%�������ܣ����ɻ���ѭ��ǰ׺��Ƶƫ�����㷨��Ӧ����ʹ�õļ���Ƶƫ�Ĵ������ݣ�recv_sig��
%������� N:OFDMϵͳ��Ч���ų��ȣ���FFT����
%         Ng:ѭ��ǰ׺�ķ��ų���
function [recv_sig] = generate_RecvData_for_CFO_CP(N,Ng,deltaf)
Ns=Ng+N;     %����ѭ��ǰ׺�ķ��ų��� 
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
%=============�������ݷ���=============
src = QAMTable(randi([0,3],N,1)+1); 
sym = ifft(src,N); 
%cp_sym=sym;%[sym(1,N-Ng+1:N) sym];
signal = [sym(1,N-Ng+1:N) sym];
%=============ģ�����Ƶƫ������========
recv_sig = signal;
for k=1:length(recv_sig)
    %���Ƶƫ
    recv_sig(k) = recv_sig(k)*exp(sqrt(-1)*2*pi*deltaf*k/N);
end
end