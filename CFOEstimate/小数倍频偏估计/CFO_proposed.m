% close all; 
% clear all; 
% clc; 
%�������� 
function [FFO_df,IFO_df,CFO_df] =CFO_proposed(N,Ng,recv,Ts_sym)
%��Ӹ�˹������
    Ns=N+Ng;
    d = Ns+Ng+1;
    [revised_recv,FFO_df] = FFO_estimate(recv,d,N);
    IFO_df= get_IFO(revised_recv,d,N,Ts_sym);
    
    CFO_df = FFO_df + IFO_df;
end
%============ʱ��Ƶƫ����������=====================
function [revised_recv,df] = FFO_estimate(recv,d,N)
%simulation_times = 1;
df1 = 0;
df2 = 0;
%for i=1:simulation_times
    df1 = get_FFO_roughly(recv,d,N);
    recv = FFO_repair(recv,df1,N);
    df2 = get_FFO_finely(recv,d,N);
    recv = FFO_repair(recv,df2,N);
    df = df1+df2;
%end
revised_recv = recv;
end
%===========ʱ��С����Ƶƫ����========================
function [revise_recv] = FFO_repair(recv,df,N)
    for k=1:length(recv)
        recv(k) = recv(k)*exp(-i*2*pi*df*k/N);
    end
    revise_recv = recv;
end
%============ʱ��С��Ƶƫ�ֹ���=====================
%   df:С����Ƶƫ�ֹ���ֵ
%   recv:���յ������ݣ�ģ����룬Ƶƫ������ݣ�
%   d:׼ȷ�ķ��Ŷ�ʱ��
%   N:OFDM���ų��ȣ�FFT������
function [df] = get_FFO_roughly(recv,d,N)
P = 0;
for m=0:N/4-1
     P = P + conj(recv(d+m+N/2))*recv(d+N/2+N/4+m);
end
df = 2*angle(P)/pi;
end
%============ʱ��С��Ƶƫϸ����=====================
%   df:С����Ƶƫϸ����ֵ
%   recv:С����Ƶƫ����ֵУ���������
%   d:׼ȷ�ķ��Ŷ�ʱ��
%   N:OFDM���ų��ȣ�FFT������
function [df] = get_FFO_finely(recv,d,N)
P = 0;
for m=0:N/4-1
     P = P + conj(recv(d+m+N/4))*power(-1,m+1)*recv(d+3*N/4+m);
end
df = angle(P)/pi;
end

%============ʱ������Ƶƫ����=====================
%�ο�OFDMͬ�������о���ʵ�֡���������
%   df:������Ƶƫ����ֵ
%   FFO_revised_recv:С����Ƶƫ����ֵУ���������
%   d:׼ȷ�ķ��Ŷ�ʱ��
%   N:OFDM���ų��ȣ�FFT������
%   TS:ʱ����ʹ�õ�ѵ������
function [df] = get_IFO(FFO_revised_recv,d,N,TS)
P = zeros(1,N/2+1);
for m=-N/4:N/4
    for n=0:N-1
     P(m+N/4+1) = P(m+N/4+1) + FFO_revised_recv(d+n)*conj(TS(n+1))*exp(-sqrt(-1)*2*pi*m*n/N);
    end
end
[~,df] = max(abs(P));
df = df - N/4 - 1;
end