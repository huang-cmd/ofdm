function [N,Ng,ffo_df,ifo_df,SNR,QAMTable,simu_times] = get_OFDMSystem_config()
ffo_df = 0.5;%С����Ƶƫ
ifo_df = 3;%������Ƶƫ
simu_times = 1000;%�������
N = 256;%OFDM�������ڳ���
Ng = N/8;%ѭ��ǰ׺����
SNR = [0 5 10 15 20 25];%�����
QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; %QAM����
end