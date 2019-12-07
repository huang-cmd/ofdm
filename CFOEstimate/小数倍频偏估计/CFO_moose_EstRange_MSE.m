clear all; 
clc; 
%============��ȡOFDMϵͳ����==========
%[N,Ng,ffo_df,ifo_df,SNR,QAMTable,simu_times] = get_OFDMSystem_config();
config = OFDMSystemConfig;
N = config.N;
Ng = config.Ng;
ffo_df = config.ffo_df;
ifo_df = config.ifo_df;
SNR = config.SNR;
simu_times = config.simu_times;
%=============�������ݷ���=============
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
src = QAMTable(randi([0,3],N,1)+1); 
sym = ifft(src,N); 
transmit_data = [sym(1,N-Ng+1:N) sym sym];
%==============���������������Ƶƫ���Ƶ����================
deltaf = -1.5:0.05:1.5;
CFO_moose_df = zeros(1,length(deltaf));
recv_sig = zeros(1,length(transmit_data));
for n=1:length(deltaf)  
    for k=1:length(transmit_data)
        %���Ƶƫ
        recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*deltaf(n)*k/N);
    end
    CFO_moose_df(n) =  CFO_moose(N,Ng,recv_sig);
end
%==============���Ʋ�ͬƵƫֵ���㷨Ƶƫ����ֵ���ߣ���������====
figure
plot(deltaf,CFO_moose_df,'LineWidth',1);
grid on
set(gca,'XTick',-1.5:0.5:1.5);
xlabel('��һ��Ƶƫ'); 
ylabel('Moose�㷨Ƶƫ���ƾ�ֵ'); 
%================���㲻ͬ����Ȼ����£�Ƶƫ���ƾ�����deltaf=0.3��=====================
CFO_moose_df_mse = zeros(1,length(SNR));
CFO_moose_df_mfo = zeros(1,length(SNR));
%simu_times = 10000;
df = ffo_df+ifo_df;
recv_sig = zeros(1,length(transmit_data));
moose_max_offset = zeros(1,length(SNR));%��¼���ƫ���ʡ�
for k=1:length(transmit_data)
    %���Ƶƫ
    recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*df*k/N);
end    
for n=1:length(SNR)  
    for s = 1:simu_times
        recv_sig_add_noise = awgn(recv_sig,SNR(n));
        df_temp = CFO_moose(N,Ng,recv_sig_add_noise);
        CFO_moose_df_mse(n) = CFO_moose_df_mse(n)+(df_temp - df)^2;
        CFO_moose_df_mfo(n) = CFO_moose_df_mfo(n)+ df_temp;
        moose_max_offset(n) = max( moose_max_offset(n),abs(df_temp - df));
    end
    CFO_moose_df_mse(n) = CFO_moose_df_mse(n) / simu_times;
    CFO_moose_df_mfo(n) = CFO_moose_df_mfo(n) / simu_times;
end
%==========================����MSE����=========================
% figure
% d = 1:length(SNR);
% semilogy(SNR,CFO_moose_df_mse(d));
% grid on
% set(gca,'XTick',0:5:25);
% xlabel('SNR(dB)'); 
% ylabel('Moose�㷨Ƶƫ���ƾ�����MSE��'); 
%====================��MSE�����¼���ļ���================
save('CFO_moose_df_mse.mat','CFO_moose_df_mse','CFO_moose_df_mfo','moose_max_offset');