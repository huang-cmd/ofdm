%������������OFDMϵͳ���������ڷ���ʹ��
classdef OFDMSystemConfig
    %Don't modify the parameter's name of the following properties.
   properties
    ffo_df =0.4;%С����Ƶƫ
    ifo_df =16;%������Ƶƫ
    simu_times = 1000;%�������
    N = 256;%OFDM�������ڳ���
    Ng = 32;%ѭ��ǰ׺����,N/8
    SNR = [-4 -2 0 2 4 6 8 10 12 14 16 20];%�����
    %SNR = 0;
    %QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; %QAM����
   end 
%    methods
%        function obj = OFDMSystemConfig()
%            obj.ffo_df =rand(1,obj.simu_times)-0.5;%С����Ƶƫ
%        end
%    end
end
