close all;
clear all;
clc

% CFO_sch_EstRange_MSE;
% CFO_moose_EstRange_MSE;
% CFO_CP_EstRange_MSE;
% CFO_JianghuaWei_EstRange_MSE;
% CFO_proposed_EstRange_MSE;
clear all;
clc
config = OFDMSystemConfig;
SNR = config.SNR;
d = 1:length(SNR);
load CFO_Jiang_df_mse.mat;
load CFO_sch_df_mse.mat;
load CFO_moose_df_mse.mat;
load CFO_CP_df_mse.mat
load CFO_proposed_df_mse.mat;
%=============�������ƫ�������ߣ�Maximum offset rate��========
figure
plot(SNR,CP_max_offset(3,d),'-oc','LineWidth',1);
hold on
plot(SNR,sch_max_offset(d),'-db','LineWidth',1);
hold on
plot(SNR,moose_max_offset(d),'-^k','LineWidth',1);
hold on
plot(SNR,Jiang_max_offset(d),'-*','LineWidth',1);
hold on
plot(SNR,proposed_max_offset(d),'-vr','LineWidth',1);
hold on
grid on
set(gca,'XTick',SNR);
set(gca,'YTick',0:0.1:1.6);
xlabel('SNR(dB)'); 
ylabel('������ƫ��ֵ'); 
legend('Van de Beek�㷨(Ng=32,N=256)','Schmidl&Cox�㷨','Moose�㷨','Jianghua Wei�㷨','�����㷨');
grid on;
%=========����CP�㷨��moose�㷨��Schmidl�㷨MSE����========
figure 
semilogy(SNR,CFO_CP_df_mse(3,d),'-vr','LineWidth',1);
hold on
semilogy(SNR,CFO_moose_df_mse(d),'-db','LineWidth',1);
hold on
semilogy(SNR,CFO_sch_df_mse(d),'-^k','LineWidth',1);
set(gca,'XTick',SNR);
xlabel('SNR(dB)'); 
ylabel('Ƶƫ���ƾ�����MSE��'); 
legend('Van de Beek�㷨(Ng=32,N=256)','Moose�㷨','Schmidl&Cox�㷨');
grid on;

%=========����Schmidl�㷨��Jianghua Wei�㷨MSE���߶Ա�ͼ======
figure 
semilogy(SNR,CFO_sch_df_mse(d),'-^k','LineWidth',1);
hold on
semilogy(SNR,CFO_Jiang_df_mse(d),'-vr','LineWidth',1);
hold on
set(gca,'XTick',SNR);
xlabel('SNR(dB)'); 
ylabel('Ƶƫ���ƾ�����MSE��'); 
legend('Schmidl&Cox�㷨','Jianghua Wei�㷨');
grid on;
%===========����Ƶƫ���ƾ����������==============
figure
semilogy(SNR,CFO_CP_df_mse(3,d),'-oc','LineWidth',1);
hold on
semilogy(SNR,CFO_sch_df_mse(d),'-db','LineWidth',1);
hold on
semilogy(SNR,CFO_moose_df_mse(d),'-^k','LineWidth',1);
hold on
semilogy(SNR,CFO_Jiang_df_mse(d),'-*','LineWidth',1);
hold on
semilogy(SNR,CFO_proposed_df_mse(d),'-vr','LineWidth',1);
hold on
grid on
set(gca,'XTick',SNR);
xlabel('SNR(dB)'); 
ylabel('Ƶƫ���ƾ�����MSE��'); 
legend('Van de Beek�㷨(Ng=32,N=256)','Schmidl&Cox�㷨','Moose�㷨','Jianghua Wei�㷨','�����㷨');
%===========����Ƶƫ���ƾ�ֵ����==============
figure
plot(SNR,CFO_CP_df_mfo(3,d),'-oc','LineWidth',1);
hold on
plot(SNR,CFO_sch_df_mfo(d),'-db','LineWidth',1);
hold on
plot(SNR,CFO_moose_df_mfo(d),'-^k','LineWidth',1);
hold on
plot(SNR,CFO_Jiang_df_mfo(d),'-*','LineWidth',1);
hold on
plot(SNR,CFO_proposed_df_mfo(d),'-vr','LineWidth',1);
hold on
grid on
set(gca,'XTick',SNR);
xlabel('SNR(dB)'); 
ylabel('С����Ƶƫ���ƾ�ֵ'); 
legend('Van de Beek�㷨(Ng=32,N=256)','Schmidl&Cox�㷨','Moose�㷨','Jianghua Wei�㷨','�����㷨');
% SNR = 0:2:24;
% d = 1:length(SNR);
% figure
% semilogy(SNR,CFO_moose_df_mse(d),'-vr','LineWidth',1);
% hold on
% semilogy(SNR,CFO_CP_df_mse(3,d),'-^k','LineWidth',1);
% hold on;
% semilogy(SNR,CFO_sch_df_mse(d),'-x','LineWidth',1);
% figure
% plot(SNR,moose_df(d),'-vr','LineWidth',1);
% hold on
% plot(SNR,CP_FFO_df(d),'-oc','LineWidth',1);
% hold on
% plot(SNR,sch_FFO_df(d),'-x','LineWidth',1);
% hold on
% plot(SNR,CFO_Jiang_df_mfo(d),'-*','LineWidth',1);
% hold on
% plot(SNR,p_FFO_df(d),'-^k','LineWidth',1);
% 
% hold on
% xlabel('SNR(dB)'); 
% ylabel('Ƶƫ���ƾ�����MSE��'); 
% legend('Moose�㷨','Van de Beek JJ�㷨','Schmidl&Cox�㷨','Jianghua Wei�㷨','�����㷨');
% grid on;