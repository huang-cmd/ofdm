function [ M ] = schmidl( transmit_data,N,Ng,SNR  )
%UNTITLED6 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
Ns = N + Ng;
if SNR<100
recv = awgn(transmit_data,SNR);
else
    recv = transmit_data;
end
%*****************������Ŷ�ʱ***************************** 
P=zeros(1,2*Ns); 
R=zeros(1,2*Ns);
for d = Ns/2+1:1:2*Ns 
    for m=0:1:N/2-1  
        P(d-Ns/2) = P(d-Ns/2) + conj(recv(d+m))*recv(d+N/2+m);  
        R(d-Ns/2) = R(d-Ns/2) + power(abs(recv(d+N/2+m)),2); 
    end 
end 
M=power(abs(P),2)./power(abs(R),2); 
end

