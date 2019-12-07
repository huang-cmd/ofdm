function [failure_rate] =IFO_Fang(config)
    %==========��ȡOFDMϵͳ��������===========
    %config = OFDMSystemConfig;
    %ffo_df = 0;%config.ffo_df;%С����Ƶƫ
    %ifo_df = config.ifo_df;%������Ƶƫ
    simu_times = config.simu_times;%�������
    N = config.N;%OFDM�������ڳ���
    Ng = config.Ng;%ѭ��ǰ׺����
    SNR = config.SNR;%�����

    a = zeros(1,N/2);
    for n=1:N/2
        a(n) = exp(2*sqrt(-1)*pi*n*n/N);
    end
    A = a;
    m = 1.2*(rand(1,N/2))-0.2;
    v= exp((sqrt(-1)*pi).*m);
    signal = [v.*A A];
    transmit_data =  signal;

    success_rate = zeros(1,length(SNR));
    failure_rate = zeros(1,length(SNR));
    for n=1:length(SNR)
        cnt = 0;
        for s = 1:simu_times
            ffo_df = -0.5 + rand();
            ifo_df = randi([0,N/4])*2;
            df = ifo_df + ffo_df;
            recv_sig =  add_CFO(transmit_data,df,N);
            recv_sig_add_noise = awgn(recv_sig,SNR(n),'measured');
            ifo_temp =  get_IFO(recv_sig_add_noise,N,v,A);
            if (ifo_temp == ifo_df)
                cnt = cnt+1;
            end
        end
        success_rate(n) =  cnt/simu_times;
    end
    figure
    d = 1:length(SNR);
    plot(SNR,success_rate(d));
    %semilogy(SNR,1-success_rate(d));
    xlabel('SNR(dB)'); 
    ylabel('������'); 
    legend('FangY�㷨');
end

function[recv_sig] = add_CFO(trans_sig,df,N)
%===========���Ƶƫ===========
recv_sig = zeros(1,length(trans_sig));
    for k=1:length(trans_sig)
        %���Ƶƫ
        recv_sig(k) = trans_sig(k)*exp(sqrt(-1)*2*pi*df*k/N);
    end  
end

function [df] = get_IFO(recv_sig,N,v,S)
recv = recv_sig;
    for g=-N/4:N/4
        for k = 0:N/2-1
            B(k+1)  = (recv(k+1)*conj(v(k+1))+recv(1+k+N/2))*conj(S(mod(k+g,N/2)+1));
        end

        F(g+N/4+1) = abs(sum(B));
    end
    [~,df] = max(F);
    df = 2*(df - N/4 -1);
end