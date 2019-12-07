% close all; 
% clear all; 
% clc; 
%�������� 
function [FFO_df] = CFO_JianghuaWei(N,Ng,recv)
d = Ng+1;
FFO_df1 =  get_FFO_roughly(recv,d,N);
recv_revised = FFO_repair(recv,FFO_df1,N);
FFO_df2 = get_FFO_nicely(recv_revised,d,N);
FFO_df = FFO_df1 + FFO_df2;
%FFO_df1
%FFO_df2
end
%============С����Ƶƫ�ֹ���=================
%   FFO_df:С����Ƶƫ
%   recv:���յ������ݣ�ģ����룬Ƶƫ������ݣ�
%   d:׼ȷ�ķ��Ŷ�ʱ��
%   N:OFDM���ų��ȣ�FFT������
function [FFO_df] = get_FFO_roughly(recv,d,N)
P = 0;
for m=0:N/4-1
     P = P + recv(d+m)*conj(recv(d+N/4+m));
end
FFO_df= -2*angle(P)/pi;%С��Ƶƫ���Ʒ�ΧΪ[-1,1]
end
%============С����Ƶƫ�ֹ���=================
%   FFO_df:С����Ƶƫ
%   recv:���յ������ݣ�ģ����룬Ƶƫ������ݣ�
%   d:׼ȷ�ķ��Ŷ�ʱ��
%   N:OFDM���ų��ȣ�FFT������
function [FFO_df] = get_FFO_nicely(recv,d,N)
P = 0;
for m=0:N/4-1
     P = P + recv(d+m)*conj(recv(d+3*N/4+m));
end
FFO_df= -2*angle(P)/(3*pi);%С��Ƶƫ���Ʒ�ΧΪ[-1,1]
end
%============С������ƵƫУ��=================
%   FFO_df:С����Ƶƫ
%   recv:���յ������ݣ�ģ����룬Ƶƫ������ݣ�
%   N:OFDM���ų��ȣ�FFT������
%   recv_revised:С����ƵƫУ���������
function [recv_revised] = FFO_repair(recv,FFO_df,N)
    for k=1:length(recv)
        recv(k) = recv(k)*exp(-sqrt(-1)*2*pi*FFO_df*k/N);
    end
    recv_revised = recv;
end

