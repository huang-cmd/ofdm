function [ M,time ] = park(transmit_data,N,Ng,SNR )
% �˴���ʾ�йش˺�����ժҪ
% predata:ѵ������ǰһ������(��ѭ��ǰ׺)
% suffixdata:ѵ�����к�һ������(��ѭ��ǰ׺)
% N,Ng:�ֱ������ų��Ⱥ�ѭ��ǰ׺����
% SNR:�����
% %
Ns = N + Ng;
if SNR<100
recv = awgn(transmit_data,SNR);
else
    recv = transmit_data;
end
%*****************������Ŷ�ʱ***************************** 
P=zeros(1,2*Ns); 
R=zeros(1,2*Ns); 
% tic;
stime = 0;
for d = Ns/2+1:1:2*Ns 
%     tic;
    for m=0:N/2  
        tic;
        P(d-Ns/2) = P(d-Ns/2) + (recv(d+m))*recv(d-1-m);  
        R(d-Ns/2) = R(d-Ns/2) + power(abs(recv(d+m)),2); 
        stime = stime + toc;
    end 
    %stime = stime + toc;
end 
M=power(abs(P),2)./power(abs(R),2); 
% time=toc;
time = stime/(Ns*3/2); 
end

