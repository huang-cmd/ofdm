%������������OFDMϵͳ���������ڷ���ʹ��
classdef OFDMSystemConfig
    %Don't modify the parameter's name of the following properties.
   properties
    ffo_df = 0.3;%С����Ƶƫ
    ifo_df = 0;%������Ƶƫ
    simu_times = 10000;%�������
    N = 256;%OFDM�������ڳ���
    Ng = 32;%ѭ��ǰ׺����,N/8
    SNR = [0 5 10 15 20 25];%�����
     %SNR = 0:2:24;
    %QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; %QAM����
   end 
end