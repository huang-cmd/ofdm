clear all;
%close all;
clc
%==========��ȡOFDMϵͳ��������===========
config = OFDMSystemConfig;
ffo_df = config.ffo_df;%С����Ƶƫ
ifo_df = config.ifo_df;%������Ƶƫ
simu_times = config.simu_times;%�������
N = config.N;%OFDM�������ڳ���
Ng = config.Ng;%ѭ��ǰ׺����
SNR = config.SNR;%�����
%============����ѵ������=================
%[transmit_data,TS] = generate_TS_method1(N,Ng);
TS = generate_TS(N);
transmit_data = TS;
%===========���Ƶƫ===========
df =ffo_df + ifo_df;%��Ƶƫ
%recv_sig = zeros(1,length(transmit_data));
%Shao_max_offset = zeros(1,length(SNR));%��¼���ƫ���ʡ�
% for k=1:length(transmit_data)
%     %���Ƶƫ
%     recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*df*k/N);
% end    

success_rate = zeros(1,length(SNR));
failure_rate = zeros(1,length(SNR));
%SNR = 15;
%ffo_df = 0.3;%С����Ƶƫ
%ifo_df = 40;%������Ƶƫ
simu_times = 1000;%�������
ffo_df = zeros(1,simu_times);%rand(1,simu_times)-0.5;%0.2+
df = ifo_df + ffo_df;
%=====rayleighchan��������========
Fs=N;
Ts = 1;
Fd = 0;
tau = [0 1 2 3 4];
pdb = [0 0 0 0 0];
h = rayleighchan(Ts,Fd,tau,pdb);
%=================================
recv_chan =  filter(h, transmit_data);
for n=1:length(SNR)  
    cnt = 0;
    for s = 1:simu_times
%         %recv_sig = add_CFO(transmit_data,df(s),N);
%         recv_sig_add_noise = awgn(recv_sig,SNR(n),'measured');
%         recv_sig_add_noise = filter(h, recv_sig_add_noise);
         
         recv_sig=add_CFO(recv_chan,df(s),N);
         recv_sig_add_noise = awgn(recv_sig,SNR(n),'measured');
         ifo_temp =  get_IFO(recv_sig_add_noise,N,TS);
        if (ifo_temp == ifo_df ) 
            cnt = cnt + 1;
        end
    end
    success_rate(n) = cnt/simu_times;
    failure_rate(n) = 1 - success_rate(n);
end
figure
d = 1:length(SNR);
plot(SNR,success_rate(d));
xlabel('SNR(dB)'); 
ylabel('������'); 
legend('�����㷨');

function[recv_sig] = add_CFO(trans_sig,df,N)
%===========���Ƶƫ===========
recv_sig = zeros(1,length(trans_sig));
for k=1:length(trans_sig)
    %���Ƶƫ
    recv_sig(k) = trans_sig(k)*exp(sqrt(-1)*2*pi*df*k/N);
end  
end

function [df] = get_IFO(recv_sig,N,TS)
    d=1;
    Q=0;
    for k=1:N-1
       Q1 = recv_sig(k)*conj(TS(k));
       Q2 = recv_sig(k+1)*conj(TS(k+1));
       Q = Q + conj(Q1)*Q2;
    end
    idf_coarse = N*angle(Q)/(2*pi);
    if idf_coarse>=0
        idf = floor(idf_coarse);
    else
        idf = ceil(idf_coarse);
    end
    
    ddf = idf_coarse - idf;
    W= N/8;
    P = zeros(1,2*W+1);
    E = 0;
    for g = idf-W:idf+W
        for n=1:N
            P(g-idf+W+1) = P(g-idf+W+1) + recv_sig(n)*conj(TS(n))*exp(-sqrt(-1)*2*pi*g*n/N);
        end
    end
    
    for n=1:N
        E = E+abs(recv_sig(n))^2;
    end
    
    H = abs(P).^2/E;
    [~,df]= max(H);
    df = df +idf-W-1;
%     figure
%     plot(idf-W:idf+W,H);
end

function [TS] = generate_TS(N)
a = zeros(1,N/4);
mu = N/4-1;
for n=0:N/4-1
   a(n+1) =exp(4*sqrt(-1)*mu*pi*n*n/N);
end
A = ifft(a);
B = conj(A(1,N/4:-1:1));
C= zeros(1,N/4);
for n=1:1:N/4 
    if mod(n,2)
       C(n) = (-1)*B(n);
    else
       C(n) = B(n);
    end
end
D=C;
signal = [A B C D];
TS =signal;%ʱ���ϵ�ѵ������
end