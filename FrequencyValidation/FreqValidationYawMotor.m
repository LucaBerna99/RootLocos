
clear all
close all
clc

    %% GLOBAL
    global k_py k_pitch k_yaw
    
    load("parameters.mat");
    load("Coefficients.mat");
        
    fig = 0;
    %% LOAD DATA

    signal = load("FreqVal_M1_16-39-35_.mat");
    
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
        pitch_m1(i,1:length(tt)) = signal.data(2,start:stop);
        pitch_m1(i,:) = pitch_m1(i,:) - pitch_m1(i,1);
        yaw_m1(i,1:length(tt)) = signal.data(3,start:stop);
        yaw_m1(i,:) = yaw_m1(i,:) - yaw_m1(i,1);
        V_m1(i,1:length(tt)) = signal.data(5,start:stop);   
   
    end
   
    
    
    
%% PITCH effect

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
            plot(t, pitch_m1(i,1:length(t)));
            plot(t, V_m1(i,1:length(t)));
            hold off;
            title("PITCH EFFECT");
            legend("Out" , "w = " + w(i) + " [Hz]");
        end

        
        
        [ampO, indexO] = findpeaks(pitch_m1(i,:));
        [ampI, indexI] = findpeaks(V_m1(i,:));
        
        if isempty(ampO)
            deltaT = - 0.9;
            ampO = 0;
        else
            deltaT = (indexO(1) - indexI(1)) * 0.002;
        end
        

        G_exp_Pitch(i) = max(ampO) / max(ampI);
        phaseShift_Pitch(i) = deltaT * w(i);

    end

    G_model_Pitch = tf([Dt], [Jeq , k_pitch, Mb*Dm*g]);

    set(figure(), 'WindowStyle', 'docked');
    hold on; grid;
    margin(G_exp_Pitch, phaseShift_Pitch, w);
    bode(G_model_Pitch);
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
            plot(t, yaw_m1(i,1:length(t)));
            plot(t, V_m1(i,1:length(t)));
            hold off;
            title("YAW EFFECT");
            legend("Out" , "w = " + w(i) + " [Hz]");
        end
    end



    for i=1:length(w)

        [ampO, indexO] = findpeaks(abs(yaw_m1(i,:)));
        [ampI, indexI] = findpeaks(V_m1(i,:));
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

