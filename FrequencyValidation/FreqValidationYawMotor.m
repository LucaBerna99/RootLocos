
clear all
clc

    %% GLOBAL

    global k_py k_pitch k_yaw
    
    load("parameters.mat");
    load("Coefficients.mat");
    
    fig = 0;

    %%

    %1-Time  2-Pitch  3-Yaw  4-V0  5-V1
    f_0_2 = load('freq20_M1_mutual.mat');
    f_0_2.data(2,:) = f_0_2.data(2,:)*Pitch_encoder_res - f_0_2.data(2,1)*Pitch_encoder_res;
    f_0_2.data(3,:) = f_0_2.data(3,:)*Yaw_encoder_res - f_0_2.data(3,1)*Yaw_encoder_res;

    f_1 = load('freq100_M1_mutual.mat');
    f_1.data(2,:) = f_1.data(2,:)*Pitch_encoder_res - f_1.data(2,1)*Pitch_encoder_res;
    f_1.data(3,:) = f_1.data(3,:)*Yaw_encoder_res - f_1.data(3,1)*Yaw_encoder_res;

    f_1_25 = load('freq125_M1_mutual.mat');
    f_1_25.data(2,:) = f_1_25.data(2,:)*Pitch_encoder_res - f_1_25.data(2,1)*Pitch_encoder_res;
    f_1_25.data(3,:) = f_1_25.data(3,:)*Yaw_encoder_res - f_1_25.data(3,1)*Yaw_encoder_res;

    f_1_5 = load('freq150_M1_mutual.mat');
    f_1_5.data(2,:) = f_1_5.data(2,:)*Pitch_encoder_res - f_1_5.data(2,1)*Pitch_encoder_res;    %CORRECTION
    f_1_5.data(3,:) = f_1_5.data(3,:)*Yaw_encoder_res - f_1_5.data(3,1)*Yaw_encoder_res;

    f_2 = load('freq200_M1_mutual.mat');
    f_2.data(2,:) = f_2.data(2,:)*Pitch_encoder_res - f_2.data(2,1)*Pitch_encoder_res;
    f_2.data(3,:) = f_2.data(3,:)*Yaw_encoder_res - f_2.data(3,1)*Yaw_encoder_res;

    f_5 = load('freq500_M1_mutual.mat');
    f_5.data(2,:) = f_5.data(2,:)*Pitch_encoder_res - f_5.data(2,1)*Pitch_encoder_res;
    f_5.data(3,:) = f_5.data(3,:)*Yaw_encoder_res - f_5.data(3,1)*Yaw_encoder_res;

    f_10 = load('freq1000_M1_mutual.mat');
    f_10.data(2,:) = f_10.data(2,:)*Pitch_encoder_res - f_10.data(2,1)*Pitch_encoder_res;
    f_10.data(3,:) = f_10.data(3,:)*Yaw_encoder_res - f_10.data(3,1)*Yaw_encoder_res;

    f_20 = load('freq2000_M1_mutual.mat');
    f_20.data(2,:) = f_20.data(2,:)*Pitch_encoder_res - f_20.data(2,1)*Pitch_encoder_res;
    f_20.data(3,:) = f_20.data(3,:)*Yaw_encoder_res - f_20.data(2,1)*Yaw_encoder_res;

    
    freq = [f_0_2, f_1, f_1_25, f_1_5, f_2, f_5, f_10, f_20];
    f = [0.2, 1, 1.25, 1.5, 2, 5, 10, 20];


    
%% PITCH EFFECT
    
        
    for i=1:length(freq) 
        stop = round(2*pi / f(i) / 0.002) + 1 ;
        t = freq(i).data(1,1:end);
        
        if fig == 1
            set(figure(), 'WindowStyle', 'docked');
            hold on; grid;
            plot(freq(i).data(1,1:end), freq(i).data(2,1:end));
            plot(freq(i).data(1,1:end), freq(i).data(5,1:end));
            hold off;
            title("PITCH EFFECT");
            legend("OUT","f = " + f(i) + " [Hz]");
        end
    end
    
    for i=1:length(freq)
        
        t = freq(i).data(1,1:stop);

        [ampO(i), indexO(i)] = max(freq(i).data(2,:));
        [ampI(i), indexI(i)] = max(freq(i).data(5,:));
        deltaT(i) = (indexO(i) - indexI(i)) * 0.002;

        G_exp_Pitch(i) = ampO(i) / ampI(i);
        phaseShift_Pitch(i) = deltaT(i) * f(i);

    end
        
    G_model_Pitch = tf([Dt*k_yp], [Jp, k_pitch, Mb*Dm*g]);

    set(figure(), 'WindowStyle', 'docked');
    hold on; grid;
    margin(G_exp_Pitch, phaseShift_Pitch, f);
    bode(G_model_Pitch);
    title({"IN: V_{Motor1}","OUT: PITCH"});
    legend("G_{EXP}^{PITCH}", "G_{MODEL}^{PITCH}");
    hold off;

        
   
    
    
%% YAW EFFECT

        
    for i=1:length(freq) 
        t = freq(i).data(1,1:end);
        
        if fig == 1
            set(figure(), 'WindowStyle', 'docked');
            hold on; grid;
            plot(freq(i).data(1,1:end), freq(i).data(3,1:end));
            plot(freq(i).data(1,1:end), freq(i).data(5,1:end));
            hold off;
            title("YAW EFFECT");
            legend("OUT","f = " + f(i) + " [Hz]");
        end
    end
    
    for i=1:length(freq)

            [ampO(i), indexO(i)] = max(abs(freq(i).data(3,:)));
            [ampI(i), indexI(i)] = max(freq(i).data(5,:));
            deltaT(i) = (indexO(i) - indexI(i)) * 0.002;

            G_exp_Yaw(i) = ampO(i) / ampI(i);
            phaseShift_Yaw(i) = deltaT(i) * f(i);
            
        end
        
        %%
        
    G_model_Yaw = tf([Dt], [Jy, k_yaw, 0]);

    set(figure(), 'WindowStyle', 'docked');
    hold on; grid;
    margin(G_exp_Yaw, phaseShift_Yaw, f);
    bode(G_model_Yaw, {0.01, 20});
    title({"IN: V_{Motor1}","OUT: YAW"});
    legend("G_{EXP}^{YAW}", "G_{MODEL}^{YAW}");
    hold off;

 

