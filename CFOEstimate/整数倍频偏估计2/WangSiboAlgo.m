% @article{��˼��2017����ѵ�����е�,
%   title={����ѵ�����е�OFDMƵ��ͬ���Ľ��㷨},
%   author={��˼�� and ������ and ���� and ������},
%   journal={���Ӽ���Ӧ��},
%   volume={43},
%   number={3},
%   pages={104-107},
%   year={2017},
% }
classdef WangSiboAlgo
    methods
        function [data] = generate_data(obj,N,Ng)
            C = ones(1,N/2);
            XEven = [C(1,1:N/8) zeros(1,3*N/8)];
            XOdd  = [zeros(1,N/8) C(1,N/8+1:N/2)];
            X = zeros(1,N);
            X(1,1:2:N) = XOdd;
            X(1,2:2:N) = XEven;
            data = ifft(X);
            data = [data(1,N-Ng+1:N) data];
        end
        
        function [df] = IFOEstimator(obj,recv_sig,N)
            Y = fft(recv_sig);
            YEven = Y(1,2:2:length(Y));
            P =zeros(1,N/2+1);
            for g=0:N/2
                for k = g:g+N/8-1
                    P(g+1) = P(g+1) + abs(YEven(mod(k,N/2)+1))^2;
                end
            end
            [~,df] = max(P);
            df = 2*(df-1);
        end
    end
end
