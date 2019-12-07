function [failure_rate] =IFO_ChaiLiKai(config)
    %==========��ȡOFDMϵͳ��������===========
    %config = OFDMSystemConfig;
    %ffo_df = config.ffo_df;%С����Ƶƫ
    %ifo_df = config.ifo_df;%������Ƶƫ
    simu_times = config.simu_times;%�������
    N = config.N;%OFDM�������ڳ���
    Ng = config.Ng;%ѭ��ǰ׺����
    SNR = config.SNR;%�����

    TS = generate_TS(N);
    transmit_data = TS;

    success_rate = zeros(1,length(SNR));
    failure_rate = zeros(1,length(SNR));
%     ffo_df = rand(1,simu_times)-0.5;
%     df = ifo_df + ffo_df;

    for n=1:length(SNR)  
        cnt = 0;
        for s = 1:simu_times
            ffo_df = rand(1,simu_times)-0.5;
            ifo_df = randi([0,N/2]);
            df = ifo_df + ffo_df;
            recv_sig = add_CFO(transmit_data,df(s),N);
            recv_sig_add_noise = awgn(recv_sig,SNR(n),'measured');

            ifo_temp =  get_IFO(recv_sig_add_noise,N,TS);
            if (ifo_temp == ifo_df ) 
                cnt = cnt + 1;
            end
        end
        success_rate(n) = cnt/simu_times;
        failure_rate(n) = 1 - success_rate(n);
    end
%     figure
%     d = 1:length(SNR);
%     plot(SNR,success_rate(d));
%     %semilogy(SNR,1-success_rate(d));
%     xlabel('SNR(dB)'); 
%     ylabel('������'); 
%     legend('�������㷨');
%     grid on
end

function[recv_sig] = add_CFO(trans_sig,df,N)
%===========���Ƶƫ===========
recv_sig = zeros(1,length(trans_sig));
for k=1:length(trans_sig)
    %���Ƶƫ
    recv_sig(k) = trans_sig(k)*exp(sqrt(-1)*2*pi*df*k/N);
end  
end

function [df] = get_IFO(recv_sig,N,TS)
P = zeros(1,N+1);
    for g =-N/2:N/2
        for n=1:N
            P(g+N/2+1) = P(g+N/2+1) + recv_sig(n)*conj(TS(n))*exp(-sqrt(-1)*2*pi*g*n/N);
        end
    end
    
    H = abs(P).^2;
    [~,df]= max(H);
    df = df -(N/2+1);
end

function [TS] = generate_TS(N)
    a = zeros(1,N/4);
    mu = N/4-1;
    for n=0:N/4-1
       a(n+1) =exp(4*sqrt(-1)*mu*pi*n*n/N);
    end
    A = a;
    B = conj(A(1,N/4:-1:1));
    C= zeros(1,N/4);
    for n=1:1:N/4 
        if mod(n,2)
           C(n) = (-1)*B(n);
        else
           C(n) = B(n);
        end
    end
    D=C;
    signal = [A B C D];
    TS =signal;%ʱ���ϵ�ѵ������
end