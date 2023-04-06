
clear all
close all
clc

    %% GLOBAL
    global k_py k_pitch k_yaw
    
    load("parameters.mat");
    load("Coefficients.mat");
        
    cutoff_freq = 2;
    T = 0.002;
    fig = 1;
    %% LOAD DATA

    signal = load("FreqVal_M0_16-19-24_.mat");
    
    
    %% Signal isolation
    
    w = [0.1, 0.3, 0.6, 1, 1.1, 1.3, 1.5, 2, 3, 6, 10, 30, 100];
    signDurInd = 0;
    
    for i= 1:length(w)
        if i < 3
            numPer = 2;
        else
            numPer = 5;
        end
        
        sinDur = 2*pi*numPer / w(i);
        sinDurInd = floor(sinDur / 0.002);
        pauseDurInd = 10 / 0.002;
        
        start = signDurInd + 1;
        
        signDurInd = signDurInd + sinDurInd + pauseDurInd;
        stop =  signDurInd - pauseDurInd  + 1; 
        
        temp = signal.data(1,start:stop) - (start-1)*0.002;
        tt = signal.data(1,start:stop) - (start-1)*0.002;
        period(i,1:length(tt)) = 0:0.002:sinDur;
        pitch_m0(i,1:length(tt)) = signal.data(2,start:stop);
        pitch_m0(i,:) = pitch_m0(i,:) - pitch_m0(i,1);
        [b,a] = butter(2,[w(i)*0.004*0.1, 2.4*w(i)*0.004]); 
        pitch_m0(i,:) = filtfilt(b, a, pitch_m0(i,:));
        
        yaw_m0(i,1:length(tt)) = signal.data(3,start:stop);
        yaw_m0(i,:) = yaw_m0(i,:) - yaw_m0(i,1);
        [b,a] = butter(1, cutoff_freq*0.004, 'low');
        yaw_m0(i,:) = filtfilt(b, a, yaw_m0(i,:));
        
        V_m0(i,1:length(tt)) = signal.data(4,start:stop);   
   
    end
    
    %{
    pitch_m0_d = diff(pitch_m0) / T;
    pitch_m0_d(length(pitch_m0)) = 0;
    pitch_m0_dd = diff(pitch_m0_d) / T;
    pitch_m0_dd(length(pitch_m0_d)) = 0;  
    
    %}
    
%% PITCH effect

    for i=1:length(w)
        
        if i < 3
            numPer = 2;
        else
            numPer = 5;
        end
        sinDur = 2*pi*numPer / w(i);
        t = 0:0.002:sinDur;
        
        [ampI, indexI] = findpeaks(V_m0(i,:));
        [ampO, indexO] = findpeaks(pitch_m0(i,indexI(1):end));
        indexO = indexO + indexI(1);
        
        jj = 1;
        while ampO(jj) < 0
            jj = jj + 1;    
        end

        if isempty(ampO) || max(ampO) < 2
            ampO = 0;
        end
        
        deltaT(i) = (indexI(1)- indexO(jj)) * 0.002;
        
        
        Magn_Pitch(i) = max(ampO) / max(ampI);
            
        phaseShift_Pitch(i) = deltaT(i) * w(i) * 180/pi;
        
        if isempty(ampO) || max(ampO) < 2
            phaseShift_Pitch(i) = -180;
        end
        
        if fig == 1
            set(figure(), 'WindowStyle', 'docked');
            hold on; grid;
            xline(indexI(1)*0.002);
            xline(indexO(jj)*0.002);
            plot(t, pitch_m0(i,1:length(t)));
            plot(t, V_m0(i,1:length(t)));
            hold off;
            title("PITCH EFFECT");
            legend("Out" , "w = " + w(i) + " [Hz]");
        end
        

    end
    
    
    G_model_Pitch(i) = tf([Dt], [Jeq 0.007 Mb*Dm*g]);

    set(figure(), 'WindowStyle', 'docked');
    hold on; grid;
    margin(Magn_Pitch, phaseShift_Pitch, w);
    bode(G_model_Pitch(i));
    title("IN: V_{Motor0}  OUT: PITCH");
    legend("G_{EXP}^{PITCH}", "G_{MODEL}^{PITCH}");
    hold off;

%% YAW effect

   for i=1:length(w) 

        if i < 3
            numPer = 2;
        else
            numPer = 5;
        end
        sinDur = 2*pi*numPer / w(i);
        t = 0:0.002:sinDur;
        
        if fig == 1
            set(figure(), 'WindowStyle', 'docked');
            hold on; grid;
            plot(t, yaw_m0(i,1:length(t)));
            plot(t, V_m0(i,1:length(t)));
            hold off;
            title("YAW EFFECT");
            legend("Out" , "w = " + w(i) + " [Hz]");
        end
    end



    for i=1:length(w)

        [ampO, indexO] = findpeaks(-yaw_m0(i,:));
        [ampI, indexI] = findpeaks(V_m0(i,:));
        
        if isempty(ampO)
            deltaT = - 0.9;
            ampO = 0;
        else
            deltaT = (indexO(1) - indexI(1)) * 0.002;
        end
        G_exp_Yaw(i) = max(ampO) / max(ampI);
        phaseShift_Yaw(i) = deltaT * w(i);

    end


    G_model_Yaw = tf([k_py*Dt], [Jy, k_yaw, 0]);

    set(figure(), 'WindowStyle', 'docked');
    hold on; grid;
    margin(G_exp_Yaw, phaseShift_Yaw, w);
    bode(G_model_Yaw, {0.01, 20});
    title("IN: V_{Motor0}  OUT: YAW");
    legend("G_{EXP}^{YAW}", "G_{MODEL}^{YAW}");
    hold off;

