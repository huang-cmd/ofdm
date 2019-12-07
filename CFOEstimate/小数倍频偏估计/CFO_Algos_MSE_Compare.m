close all
clear all
clc
%ʹ��֮ǰ������ͨ����OFDMSystemConfig.m����get_OFDMSystem_config.m����OFDMϵͳ����
CFO_proposed_EstRange_MSE;
CFO_sch_EstRange_MSE;
CFO_moose_EstRange_MSE;
CFO_CP_EstRange_MSE;
CFO_Jiang_EstRange_MSE;
clear all
clc

load CFO_Jiang_df_mse.mat
load CFO_proposed_df_mse.mat;
load CFO_sch_df_mse.mat;
load CFO_moose_df_mse.mat;
load CFO_CP_df_mse.mat;
label = ['-oc';'-db';'-^k';'-vr'];
d = 1:length(SNR);
%=======�����������=============
% D_proposed = zeros(1,length(SNR));
% D_sch = zeros(1,length(SNR));
% D_moose = zeros(1,length(SNR));
% D_CP = zeros(1,length(SNR));
% C = 10*pi/(3*256*log(10));
% for k=1:length(SNR)
%    D_proposed(k) =  C*SNR(k)*(0.3-CFO_proposed_df_mfo(k))^2;
%    D_sch(k) =  C*SNR(k)*(0.3-CFO_sch_df_mfo(k))^2;
%    D_CP(k) =  C*SNR(k)*(0.3-CFO_CP_df_mfo(k))^2;
%    D_moose(k) =  C*SNR(k)*(0.3-CFO_moose_df_mfo(k))^2;
%     
% end

%==========���������������===========

% figure 
% semilogy(SNR,D_CP(d),'-oc','LineWidth',1);
% hold on
% semilogy(SNR,D_sch(d),'-db','LineWidth',1);
% hold on
% semilogy(SNR,D_moose(d),'-^k','LineWidth',1);
% hold on
% semilogy(SNR,D_proposed(d),'-vr','LineWidth',1);
% hold on
% grid on
% set(gca,'XTick',0:5:25);
% xlabel('SNR(dB)'); 
% ylabel('�������D(dB)'); 
% legend('Van de Beek�㷨(Ng=32,N=256)','Schmidl&Cox�㷨','Moose�㷨','�����㷨');
%==========����Ƶƫ���ƾ���������ߣ�MSE��========
figure
semilogy(SNR,CFO_CP_df_mse(3,d),'-oc','LineWidth',1);
hold on
semilogy(SNR,CFO_sch_df_mse(d),'-db','LineWidth',1);
hold on
semilogy(SNR,CFO_moose_df_mse(d),'-^k','LineWidth',1);
hold on
semilogy(SNR,CFO_proposed_df_mse(d),'-vr','LineWidth',1);
hold on
grid on
set(gca,'XTick',0:5:25);
xlabel('SNR(dB)'); 
ylabel('Ƶƫ���ƾ�����MSE��'); 
legend('Van de Beek�㷨(Ng=32,N=256)','Schmidl&Cox�㷨','Moose�㷨','�����㷨');
%===========����Ƶƫ���ƾ�ֵ����==============
figure
plot(SNR,CFO_CP_df_mfo(3,d),'-oc','LineWidth',1);
hold on
plot(SNR,CFO_sch_df_mfo(d),'-db','LineWidth',1);
hold on
plot(SNR,CFO_moose_df_mfo(d),'-^k','LineWidth',1);
hold on
plot(SNR,CFO_proposed_df_mfo(d),'-vr','LineWidth',1);
hold on
grid on
set(gca,'XTick',0:5:25);
xlabel('SNR(dB)'); 
ylabel('С����Ƶƫ���ƾ�ֵ'); 
legend('Van de Beek�㷨(Ng=32,N=256)','Schmidl&Cox�㷨','Moose�㷨','�����㷨');
%===========������Ƶƫ���ƾ�ֵ����==============
figure
plot(SNR,CFO_sch_df_mfo(d),'-^k','LineWidth',1);
hold on
plot(SNR,CFO_proposed_df_mfo(d),'-vr','LineWidth',1);
hold on
grid on
set(gca,'XTick',0:5:25);
xlabel('SNR(dB)'); 
ylabel('Ƶƫ���ƾ�ֵ'); 
legend('Schmidl&Cox�㷨','�����㷨');
 %==========������Ƶƫ���ƾ���������ߣ�MSE��========
 %Schmidl
figure
semilogy(SNR,CFO_sch_df_mse(d),'-^k','LineWidth',1);
hold on
semilogy(SNR,CFO_proposed_df_mse(d),'-vr','LineWidth',1);
grid on
set(gca,'XTick',0:5:25);
xlabel('SNR(dB)'); 
ylabel('Ƶƫ���ƾ�����MSE��'); 
legend('Schmidl&Cox�㷨','�����㷨');