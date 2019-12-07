% close all; 
% clear all; 
% clc; 
%����ѭ��ǰ׺����С����Ƶƫ���ƣ����㷨ֻ�ܽ���С����Ƶƫ�Ĺ��ƣ����ܽ���������Ƶƫ�Ĺ��ơ�
function [FFO_df] = CFO_CP(N,Ng,recv)
d=1;
FFO_df = get_FFO(recv,d,Ng,N);
end
%============Ƶƫ����=====================
function [df] = get_FFO(recv,d,Ng,N)
    P = 0;
    for m=0:Ng-1
        P = P + conj(recv(d+m))*recv(d+m+N);
    end
    df = angle(P)/(2*pi);
end
