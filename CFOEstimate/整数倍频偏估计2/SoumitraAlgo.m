%@INPROCEEDINGS{8049990, 
% author={S. Bhowmick and K. Vasudevan}, 
% booktitle={2017 4th International Conference on Signal Processing and Integrated Networks (SPIN)}, 
% title={Matched filter based integer frequency offset estimation in OFDM systems}, 
% year={2017}, 
% volume={}, 
% number={}, 
% pages={442-447}, 
% keywords={AWGN;matched filters;OFDM modulation;probability;Rayleigh channels;matched filter based integer frequency offset estimation;OFDM systems;carrier frequency offset;integer frequency offset;IFO;CFO;multipath Rayleigh fading channel;additive white Gaussian noise;AWGN;fractional frequency offset;FFO;improved probability;preamble aided integer frequency synchronization scheme;OFDM;Frequency-domain analysis;Time-domain analysis;Estimation;Frequency estimation;Fading channels;Convolution;Frequency synchronization;OFDM;Preamble;Matched filter}, 
% doi={10.1109/SPIN.2017.8049990}, 
% ISSN={}, 
% month={Feb},}
%Ƶ���ϵ�������Ƶƫ�����㷨
classdef SoumitraAlgo
    properties
    end
    
    methods 
        % ���ز���   time_signal:ʱ���ź�   freq_signal:Ƶ���ź�            
        function [time_signal,freq_signal] = generate_data(obj,N,Ng)
            QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
            freq_signal = QAMTable(randi([0,3],N,1)+1)./7; 
%             time_signal = ifft(freq_signal);
%             time_signal = [time_signal(1,N-Ng+1:N) time_signal];
            signal = ifft(freq_signal);
            time_signal = [signal(1,N-Ng+1:N) signal];
            time_signal = [time_signal signal];
        end
        %С����Ƶƫ������
        function [df] = FFOEstimator(obj,recv_sig,N)
            P = 0;
            r = recv_sig;
            for n=1:N
                P = P + conj(r(n))*r(n+N);
            end
            df = angle(P)/(2*pi);
        end
        %�����ź�   recv_sig:���յ���ʱ���ź� TS:���Ͷ�Ƶ���ź�
        %���ز���   df:������Ƶƫ����ֵ
        function [df] = IFOEstimator(obj,recv_sig,N,TS)
            Q=conj(TS(1,N:-1:1));
            recv = recv_sig;
            R = fft(recv);
            E=0;
            for k=1:N
                E= E+abs(Q(k))^2;
            end
            M = conv(Q,R);%length 2*N-1
            [~,df] = max(abs(M)./E);

            df = df - N;
        end
    end
    
end