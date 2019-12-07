function [ M,time ] = minn( transmit_data,N,Ng,SNR )
% �˴���ʾ�йش˺�����ժҪ
% predata:ѵ������ǰһ������(��ѭ��ǰ׺)
% suffixdata:ѵ�����к�һ������(��ѭ��ǰ׺)
% N,Ng:�ֱ������ų��Ⱥ�ѭ��ǰ׺����
% SNR:�����
%
 Ns = N + Ng;

if SNR<100
recv = awgn(transmit_data,SNR);
else
    recv = transmit_data;
end
P=zeros(1,2*Ns); 
R=zeros(1,2*Ns);
stime=0;
for d = Ns/2+1:1:2*Ns
    %tic;
    for k=1:2
    for m=0:1:N/4-1  
        tic;
        P(d-Ns/2) = P(d-Ns/2) + conj(recv(d+m+(k-1)*N/2))*recv(d+N/4+(k-1)*N/2+m);  
        R(d-Ns/2) = R(d-Ns/2) + power(abs(recv(d+N/4+(k-1)*N/2+m)),2);
        stime = stime + toc;
    end 
%     stime = stime + toc;
end
end 
M=power(abs(P),2)./power(abs(R),2); 
time = stime/(3*Ns/2);
end

