clear all
close all
clc

config = OFDMSystemConfig;%��ȡOFDM��������
%==========�����㷨����ʧ���ʣ�Probability of Failure [POF]��====
%config.simu_times = 1;
SoumitraPOF = IFO_Soumitra(config);
ProposedPOF = IFO_proposed(config);
SchmidlPOF  = IFO_Sch(config);
ChaiLiKaiPOF= IFO_ChaiLiKai(config);
FangPOF     = IFO_Fang(config);
ShaoPOF     = IFO_Shao(config);

SNR = config.SNR;
d = 1:length(config.SNR);
figure
plot(SNR,1-SchmidlPOF(d),'-oc','LineWidth',1);
hold on
plot(SNR,1-ShaoPOF(d),'-db','LineWidth',1);
hold on
plot(SNR,1-FangPOF(d),'-^k','LineWidth',1);
hold on
plot(SNR,1-SoumitraPOF(d),'-*','LineWidth',1);
hold on
plot(SNR,1-ChaiLiKaiPOF(d),'-vr','LineWidth',1);
hold on
plot(SNR,1-ProposedPOF(d),'-s','LineWidth',1);
hold on
xlabel('SNR(dB)'); 
ylabel('Probabilty of Failure(POF)'); 
legend('schmidl�㷨','Shao�㷨','FangYibo�㷨','Soumitra�㷨','ChaiLiKai�㷨','�����㷨');
figure 
%plot(config.SNR,success_rate(d));
semilogy(config.SNR,SchmidlPOF(d),'-oc','LineWidth',1);
hold on
semilogy(config.SNR,ShaoPOF(d),'-db','LineWidth',1);
hold on
semilogy(config.SNR,FangPOF(d),'-^k','LineWidth',1);
hold on
semilogy(config.SNR,SoumitraPOF(d),'-*','LineWidth',1);
hold on
semilogy(config.SNR,ChaiLiKaiPOF(d),'-vr','LineWidth',1);
hold on
semilogy(config.SNR,ProposedPOF(d),'-s','LineWidth',1);
hold on
xlabel('SNR(dB)'); 
ylabel('Probabilty of Failure(POF)'); 
legend('schmidl�㷨','Shao�㷨','FangYibo�㷨','Soumitra�㷨','ChaiLiKai�㷨','�����㷨');
grid on

