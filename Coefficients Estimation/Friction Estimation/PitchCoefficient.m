

function PitchCoefficient(fig)

%% GLOBALs
    
    global k_pitch freq_nat

%% PARAMETERS
    load("parameters.mat");
    pitch_motor_OFF = load("Pitch_motorOFF.mat");

%% ACQUISITION

    cutoff_freq = 10;
    ord_filter = 2;
    
    start = 5000;
    t = pitch_motor_OFF.data(1,start:end)-start*0.002;
    ydata = pitch_motor_OFF.data(2,start:end)*Pitch_encoder_res;

    [b,a] = butter(ord_filter, cutoff_freq*0.004, 'low');
    ydata_filt = filtfilt(b, a, ydata);

    
    %% PLOTs
    
    if fig == 1
        
        set(figure, "WindowStyle", "docked");
        hold on; grid;
        plot(t, ydata(1:length(t)));
        plot(t, ydata_filt, 'LineWidth', 1.5);
        hold off;
        legend("measured","fitted_{DYNAMIC}");
    
    end
 

%% Damping
    
    % -ydata
    [p_neg, tt] = findpeaks(-ydata);

    for i = 1:length(tt)-1
        
        period_neg(i) = (tt(i+1) - tt(i))*0.002;
        wd_neg(i) = 2*pi /(tt(i+1)-tt(i))/0.002;
        xi_neg(i) = log(p_neg(i)/p_neg(i+1)) / sqrt(4*pi^2 + (log(p_neg(i)/p_neg(i+1)))^2);
        
    end

    period_neg = mean(period_neg);
    wd_neg = mean(wd_neg);
    xi_neg = mean(xi_neg);

   
    % + ydata
    [p_pos, tt] = findpeaks(ydata);

    for i = 1:length(tt)-1
        
        period_pos(i) = (tt(i+1) - tt(i))*0.002;
        wd_pos(i) = 2*pi /(tt(i+1)-tt(i))/0.002;
        xi_pos(i) = log(p_pos(i)/p_pos(i+1)) / sqrt(4*pi^2 + (log(p_pos(i)/p_pos(i+1)))^2);
        
    end

    period_pos = mean(period_pos);
    wd_pos = mean(wd_pos);
    xi_pos = mean(xi_pos);

    
    wd = (wd_pos + wd_neg)/2;
    xi = (xi_pos + xi_neg)/2;
    
    
    freq_nat = wd / sqrt(1-xi^2);
    k_p_PEAK = 2*freq_nat*xi*(Jeq);
    
%% RESULTs

    k_pitch = k_p_PEAK;
    
    
end

