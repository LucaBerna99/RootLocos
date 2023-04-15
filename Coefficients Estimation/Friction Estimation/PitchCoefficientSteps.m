function PitchCoefficientSteps(fig)

    %% GLOBALs
    
    global k_pitch_

    %% LOAD
    
    %esperimento a 60s con step che comincia a 5s
    load("parameters.mat");
    step_18 = load("Step18V.mat");
    step_16 = load("Step16V.mat");
    step_14 = load("Step14V.mat");
    step_12 = load("Step12V.mat");
    
    %% Initial plot
    
    if fig == 1
        
        set(figure(), "windowStyle", "docked");
        plot(step_18.data(2,:))
        title("Step 18V");
        
        set(figure(), "windowStyle", "docked");
        plot(step_16.data(2,:))
        title("Step 16V");
        
        set(figure(), "windowStyle", "docked");
        plot(step_14.data(2,:))
        title("Step 14V");
        
        set(figure(), "windowStyle", "docked");
        plot(step_12.data(2,:))
        title("Step 12V");
    
    end
    
    %%
    dT = 0.002;
    start = 5/0.002;
    stop = 30/0.002;
    t = step_18.data(1,start:stop);
    
    V_m0 = step_18.data(4,:);
    
    pitch_18 = step_18.data(2,start:stop);
    pitch_16 = step_16.data(2,start:stop);
    pitch_14 = step_14.data(2,start:stop);
    pitch_12 = step_12.data(2,start:stop);
    
    [b,a] = butter(2, 2*0.004, 'low');
    
    pitch_18_filt = filtfilt(b, a, pitch_18);
    pitch_16_filt = filtfilt(b, a, pitch_16);
    pitch_14_filt = filtfilt(b, a, pitch_14);
    pitch_12_filt = filtfilt(b, a, pitch_12);
    
    
    [p18, t18] = findpeaks(pitch_18_filt);
    [p16, t16] = findpeaks(pitch_16_filt);
    [p14, t14] = findpeaks(pitch_14_filt);
    [p12, t12] = findpeaks(pitch_12_filt);
    
        if fig == 1
        
        set(figure(), "windowStyle", "docked");
        hold on;grid;
        plot(step_18.data(2,start:end))
        plot(pitch_18_filt)
        hold off;
        title("Step 18V");
        
        set(figure(), "windowStyle", "docked");
        hold on;grid;
        plot(step_16.data(2,start:end))
        plot(pitch_16_filt)
        hold off;
        title("Step 16V");
        
        set(figure(), "windowStyle", "docked");
        hold on;grid;
        plot(step_14.data(2,start:end))
        plot(pitch_14_filt)
        hold off;
        title("Step 14V");
        
        set(figure(), "windowStyle", "docked");
        hold on;grid;
        plot(step_12.data(2,start:end))
        plot(pitch_12_filt)
        hold off;
        title("Step 12V");
    
    end
    
    
    if fig == 1
        set(figure(), "windowStyle", "docked");
        findpeaks(pitch_18_filt)
        title("Step 18V");
        
        set(figure(), "windowStyle", "docked");
        findpeaks(pitch_16_filt)
        title("Step 16V");
        
        set(figure(), "windowStyle", "docked");
        findpeaks(pitch_14_filt)
        title("Step 14V");
        
        set(figure(), "windowStyle", "docked");
        findpeaks(pitch_12_filt)
        title("Step 12V");
    end
        
    
    %% 18V step
    for i = 1:length(t18)-1
        T_18(i) = (t18(i+1) - t18(i))*dT;
        wd_18(i) = 2*pi /(t18(i+1)-t18(i))/dT;
    end
    sub_ratio_18 = 1/5 * log(p18(1)/p18(5));
    T_18_m = mean(T_18);
    wd_18_m = mean(wd_18);
    xi_18_m = 1 / sqrt(1 + (2*pi/sub_ratio_18)^2);
    fnat_18 = wd_18_m / sqrt(1-xi_18_m^2);
    k_pitch_18 = 2*fnat_18*xi_18_m*(Jeq);
    
    %% 16V step
    for i = 1:length(t16)-1
        T_16(i) = (t16(i+1) - t16(i))*dT;
        wd_16(i) = 2*pi /(t16(i+1)-t16(i))/dT;
    end
    sub_ratio_16 = 1/5 * log(p16(1)/p16(5));
    T_16_m = mean(T_16);
    wd_16_m = mean(wd_16);
    xi_16_m = 1 / sqrt(1 + (2*pi/sub_ratio_16)^2);
    fnat_16 = wd_16_m / sqrt(1-xi_16_m^2);
    k_pitch_16 = 2*fnat_16*xi_16_m*(Jeq);
    
    %% 14V step
    for i = 1:length(t14)-1
        T_14(i) = (t14(i+1) - t14(i))*dT;
        wd_14(i) = 2*pi /(t14(i+1)-t14(i))/dT;
    end
    sub_ratio_14 = 1/5 * log(p14(1)/p14(5));
    T_14_m = mean(T_14);
    wd_14_m = mean(wd_14);
    xi_14_m = 1 / sqrt(1 + (2*pi/sub_ratio_14)^2);
    fnat_14 = wd_14_m / sqrt(1-xi_14_m^2);
    k_pitch_14 = 2*fnat_14*xi_14_m*(Jeq);
    
    %% 12V step
    for i = 1:length(t12)-1
        T_12(i) = (t12(i+1) - t12(i))*dT;
        wd_12(i) = 2*pi /(t12(i+1)-t12(i))/dT;
    end
    sub_ratio_12 = 1/5 * log(p12(1)/p12(5));
    T_12_m = mean(T_12);
    wd_12_m = mean(wd_12);
    xi_12_m = 1 / sqrt(1 + (2*pi/sub_ratio_12)^2);
    fnat_12 = wd_12_m / sqrt(1-xi_12_m^2);
    k_pitch_12 = 2*fnat_12*xi_12_m*(Jeq);
    
    
    %% RESULT    
    k_pitch_ = (k_pitch_18  + k_pitch_16 + k_pitch_14 + k_pitch_12)/4;
    

end