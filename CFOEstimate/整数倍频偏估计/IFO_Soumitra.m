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
function [failure_rate] =IFO_Soumitra(config)
    %==========��ȡOFDMϵͳ��������===========
    %config = OFDMSystemConfig;
    %ffo_df = config.ffo_df;%С����Ƶƫ
    %ifo_df = config.ifo_df;%������Ƶƫ
    simu_times = config.simu_times;%�������
    N = config.N;%OFDM�������ڳ���
    Ng = config.Ng;%ѭ��ǰ׺����
    SNR = config.SNR;%�����
    %============��������=================
    [transmit_data,freq_signal]= generate_data(N);

    success_rate = zeros(1,length(SNR));
    failure_rate = zeros(1,length(SNR));
    %===========�������ؿ������============
    for n=1:length(SNR)  
        cnt = 0;
        for s = 1:simu_times
            ffo_df = -0.5+rand() ;
            ifo_df = randi([0,N/2]);
            df = ifo_df + ffo_df;
            recv_sig = add_CFO(transmit_data,df,N);
            recv_sig_add_noise = awgn(recv_sig,SNR(n),'measured');

            ifo_temp =  get_IFO(recv_sig_add_noise,N,Ng,freq_signal);%Ƶ������㷨
            if (ifo_temp == ifo_df ) 
                cnt = cnt + 1;
            end
        end
        success_rate(n) = cnt/simu_times;
        failure_rate(n) = 1 - success_rate(n);
    end
    figure
    d = 1:length(SNR);
    plot(SNR,success_rate(d));
    %semilogy(SNR,1-success_rate(d));
    xlabel('SNR(dB)'); 
    ylabel('Probabilty of Success'); 
    legend('Soumitra�㷨');
    grid on
end

function [time_signal,freq_signal] = generate_data(N)
    QAMTable =[7+7i,-7+7i,-7-7i,7-7i]; 
    freq_signal = QAMTable(randi([0,3],N,1)+1)./7; 
    time_signal = ifft(freq_signal);
    %signal = time_signal;
end
function[recv_sig] = add_CFO(trans_sig,df,N)
%===========���Ƶƫ===========
recv_sig = zeros(1,length(trans_sig));
for k=1:length(trans_sig)
    %���Ƶƫ
    recv_sig(k) = trans_sig(k)*exp(sqrt(-1)*2*pi*df*k/N);
end  
end
function [df] = get_IFO(recv_sig,N,Ng,signal)
    Q=conj(signal(1,N:-1:1));
    R = fft(recv_sig);
    E=0;
    for k=1:N
        E= E+abs(Q(k))^2;
    end
    M = conv(Q,R);%length 2*N-1
    [~,df] = max(abs(M)./E);

    df = df - N;
end