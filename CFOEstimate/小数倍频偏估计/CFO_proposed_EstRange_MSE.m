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
sym = ifft(src); 
cp_sym=[sym(1,N-Ng+1:N) sym];
predata = cp_sym;
suffixdata = cp_sym;
%=============����ѵ������======================
a = zeros(1,N/4);
mu = N/4-1;
for n=0:N/4-1
   a(n+1) =7*sqrt(2)*exp(4*sqrt(-1)*mu*pi*n*n/N);
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
Ts_sym = signal;
cp_train = [signal(1,N-Ng+1:N) signal];
transmit_data = [predata cp_train suffixdata];
%==============���������������Ƶƫ���Ƶ����================
deltaf = -3:0.05:3;
CFO_proposed_ffo = zeros(1,length(deltaf));%С����Ƶƫ
CFO_proposed_ifo = zeros(1,length(deltaf));%������Ƶƫ
CFO_proposed_cfo = zeros(1,length(deltaf));%��Ƶƫ

recv_sig = zeros(1,length(transmit_data));
for n=1:length(deltaf)  
    for k=1:length(transmit_data)
        %���Ƶƫ
        recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*deltaf(n)*k/N);
    end
    [CFO_proposed_ffo(n),CFO_proposed_ifo(n),CFO_proposed_cfo(n)] = CFO_proposed(N,Ng,recv_sig,Ts_sym);
end
%==============���Ʋ�ͬƵƫֵ���㷨Ƶƫ����ֵ���ߣ���������====
figure
plot(deltaf,CFO_proposed_ffo,'-','LineWidth',1);
hold on
plot(deltaf,CFO_proposed_ifo,'-.','LineWidth',1);
hold on
plot(deltaf,CFO_proposed_cfo,'--','LineWidth',1);
grid on
set(gca,'XTick',-3:0.5:3);
xlabel('��һ��Ƶƫ'); 
ylabel('�����㷨Ƶƫ����ֵ'); 
legend('С����Ƶƫ����','������Ƶƫ����','��Ƶƫ����');
% figure(2)
% plot(deltaf,CFO_proposed_ifo,'LineWidth',1);
% grid on
% set(gca,'XTick',-3:0.5:3);
% xlabel('��һ��Ƶƫ'); 
% ylabel('Ƶƫ���ƾ�ֵ'); 
% 
% figure(3)
% plot(deltaf,CFO_proposed_cfo,'LineWidth',1);
% grid on
% set(gca,'XTick',-3:0.5:3);
% xlabel('��һ��Ƶƫ'); 
% ylabel('Ƶƫ���ƾ�ֵ'); 
%================���㲻ͬ����Ȼ����£�Ƶƫ���ƾ�����deltaf=0.3��=====================
CFO_proposed_df_mse = zeros(1,length(SNR));
CFO_proposed_df_mfo = zeros(1,length(SNR));
% FFO_proposed_df_mse = zeros(1,length(SNR));
% FFO_proposed_df_mfo = zeros(1,length(SNR));
% simu_times = 1000;
% ffo_df = 0.5;%С����Ƶƫ����Χ[-2,2]
% ifo_df = 3;%������Ƶƫ
df =ffo_df + ifo_df;%��Ƶƫ
recv_sig = zeros(1,length(transmit_data));
proposed_max_offset = zeros(1,length(SNR));%��¼���ƫ���ʡ�
for k=1:length(transmit_data)
    %���Ƶƫ
    recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*df*k/N);
end    
for n=1:length(SNR)  
    for s = 1:simu_times
        recv_sig_add_noise = awgn(recv_sig,SNR(n));
        %[FFO_df,IFO_df,CFO_df]
       % [ffo_temp,~,cfo_temp] =  CFO_proposed(N,Ng,recv_sig_add_noise,Ts_sym);
       [cfo_temp,~,~] =  CFO_proposed(N,Ng,recv_sig_add_noise,Ts_sym);
%         FFO_proposed_df_mse(n) = FFO_proposed_df_mse(n)+(ffo_temp - ffo_df)^2;
%         FFO_proposed_df_mfo(n) = FFO_proposed_df_mfo(n)+ ffo_temp;
        CFO_proposed_df_mse(n) = CFO_proposed_df_mse(n)+(cfo_temp - df)^2;
        CFO_proposed_df_mfo(n) = CFO_proposed_df_mfo(n)+ cfo_temp;
        proposed_max_offset(n) = max(proposed_max_offset(n),abs(cfo_temp - df));
    end
    CFO_proposed_df_mse(n) = CFO_proposed_df_mse(n) / simu_times;
    CFO_proposed_df_mfo(n) = CFO_proposed_df_mfo(n) / simu_times;
end
%==========================����MSE����=========================
% figure
% d = 1:length(SNR);
% semilogy(SNR,CFO_proposed_df_mse(d));
% grid on
% set(gca,'XTick',0:5:25);
% xlabel('SNR(dB)'); 
% ylabel('�����㷨Ƶƫ���ƾ�����MSE��'); 

%====================��MSE�����¼���ļ���================
save('CFO_proposed_df_mse.mat','CFO_proposed_df_mse','CFO_proposed_df_mfo','proposed_max_offset','SNR');
