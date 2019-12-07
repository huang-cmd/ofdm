% close all; 
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
v_sig =sqrt(2)*train2./train1;
%=============���������ź�====================
transmit_data = [cp_train1 cp_train2 suffixdata]; 
%==============���������������Ƶƫ���Ƶ����================
deltaf = -3:0.05:3;
CFO_sch_ffo = zeros(1,length(deltaf));
CFO_sch_ifo = zeros(1,length(deltaf));
CFO_sch_cfo = zeros(1,length(deltaf));
recv_sig = zeros(1,length(transmit_data));
for n=1:length(deltaf)  
    for k=1:length(transmit_data)
        %���Ƶƫ
        recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*deltaf(n)*k/N);
    end
    [CFO_sch_ffo(n),CFO_sch_ifo(n),CFO_sch_cfo(n)] =  CFO_sch(N,Ng,recv_sig,v_sig);
end
%==============���Ʋ�ͬƵƫֵ���㷨Ƶƫ����ֵ���ߣ���������====
figure
plot(deltaf,CFO_sch_ffo,'-','LineWidth',1);
hold on
plot(deltaf,CFO_sch_ifo,'-.','LineWidth',1);
hold on
plot(deltaf,CFO_sch_cfo,'--','LineWidth',1);
grid on
set(gca,'XTick',-3:0.5:3);
xlabel('��һ��Ƶƫ'); 
ylabel('Schmidl&Cox�㷨Ƶƫ����ֵ'); 
legend('С����Ƶƫ����','������Ƶƫ����','��Ƶƫ����');
% figure(2)
% plot(deltaf,CFO_sch_ifo,'LineWidth',1);
% grid on
% set(gca,'XTick',-3:0.5:3);
% xlabel('��һ��Ƶƫ'); 
% ylabel('������Ƶƫ���ƾ�ֵ'); 
% 
% figure(3)
% plot(deltaf,CFO_sch_cfo,'LineWidth',1);
% grid on
% set(gca,'XTick',-3:0.5:3);
% xlabel('��һ��Ƶƫ'); 
% ylabel('Ƶƫ���ƾ�ֵ'); 
%================���㲻ͬ����Ȼ����£�Ƶƫ���ƾ�����deltaf=0.3��=====================
% FFO_sch_df_mse = zeros(1,length(SNR));%Mean square error
% FFO_sch_df_mfo = zeros(1,length(SNR));%Mean frequency offset
CFO_sch_df_mse = zeros(1,length(SNR));%Mean square error
CFO_sch_df_mfo = zeros(1,length(SNR));%Mean frequency offset
%simu_times = 1000;
% ffo_df = 0.5;%С����Ƶƫ,��Χ[-1,1]
% ifo_df = 3;%������Ƶƫ
df =ffo_df + ifo_df;%��Ƶƫ
recv_sig = zeros(1,length(transmit_data));
sch_max_offset = zeros(1,length(SNR));%��¼���ƫ���ʡ�
for k=1:length(transmit_data)
    %���Ƶƫ
    recv_sig(k) = transmit_data(k)*exp(sqrt(-1)*2*pi*df*k/N);
end    
for n=1:length(SNR)  
    for s = 1:simu_times
        recv_sig_add_noise = awgn(recv_sig,SNR(n));
        %[FFO_df,IFO_df,CFO_df]
        %[ffo_temp,~,cfo_temp] = CFO_sch(N,Ng,recv_sig_add_noise,v_sig);
        [cfo_temp,~,~] = CFO_sch(N,Ng,recv_sig_add_noise,v_sig);
%         FFO_sch_df_mse(n) = FFO_sch_df_mse(n)+(ffo_temp - ffo_df)^2;
%         FFO_sch_df_mfo(n) = FFO_sch_df_mfo(n)+ ffo_temp;
        CFO_sch_df_mse(n) = CFO_sch_df_mse(n)+(cfo_temp - df)^2;
        CFO_sch_df_mfo(n) = CFO_sch_df_mfo(n)+ cfo_temp;
        sch_max_offset(n) = max(sch_max_offset(n),abs(cfo_temp-df));
    end
%     FFO_sch_df_mse(n) = FFO_sch_df_mse(n) / simu_times;
%     FFO_sch_df_mfo(n) = FFO_sch_df_mfo(n) / simu_times;
    CFO_sch_df_mse(n) = CFO_sch_df_mse(n) / simu_times;
    CFO_sch_df_mfo(n) = CFO_sch_df_mfo(n) / simu_times;
end

%==========================����MSE����=========================
% figure
% d = 1:length(SNR);
% semilogy(SNR,FFO_sch_df_mse(d));
% grid on
% set(gca,'XTick',0:5:25);
% xlabel('SNR(dB)'); 
% ylabel('Schmidl&Cox�㷨Ƶƫ���ƾ�����MSE��'); 
%====================��MSE�����¼���ļ���================
save('CFO_sch_df_mse.mat','CFO_sch_df_mse','CFO_sch_df_mfo','sch_max_offset');