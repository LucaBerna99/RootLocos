%% Load Data

mutual0 = load('M0steps_MutualYaw.mat');

start_m0 = 120/0.002;
finish_m0 = 270/0.002;
t_m0 = mutual0.data(1,start_m0:finish_m0);
yaw_m0 = mutual0.data(3,start_m0:finish_m0)*Yaw_encoder_res;
V0_m0 = mutual0.data(4,start_m0:finish_m0);

k_aero = 0.088;



%% Effect of M0 on the yaw movement

    %% FITTING
    
    yaw_fit_m0 = @(yaw_par_m0,t_m0) yaw_par_m0(1).*t_m0.^8 + yaw_par_m0(2).*t_m0.^7 + yaw_par_m0(3).*t_m0.^6 + yaw_par_m0(4).*5 + yaw_par_m0(5).*t_m0.^4 + yaw_par_m0(6).*t_m0.^3 + + yaw_par_m0(7).*t_m0.^2+ + yaw_par_m0(8).*t_m0 + + yaw_par_m0(9);
    yaw_par0_m0 = [0,0,0,0,0,0,0,0,0];
    yaw_par_m0 = lsqcurvefit(yaw_fit_m0, yaw_par0_m0, t_m0, yaw_m0);
    
       
    phi_yaw_m0 = yaw_fit_m0(yaw_par_m0, t_m0);
    phi_d_yaw_m0 = diff(phi_yaw_m0)/0.002;
    phi_dd_yaw_m0 = diff(phi_d_yaw_m0)/0.002;

    yaw_m0(length(t_m0)) = [];
    yaw_m0(length(t_m0)-1) = [];
    phi_yaw_m0(length(t_m0)) = [];
    phi_yaw_m0(length(t_m0)-1) = [];
    phi_d_yaw_m0(length(t_m0)-1) = [];
    t_m0(length(t_m0)) = [];
    t_m0(length(t_m0)-1) = [];

    
    
    %% PLOT DERIVATIVES
    
    set(figure, "WindowStyle", "docked");
    grid;
    hold on;
    plot(t_m0, yaw_m0,'b','LineWidth',2);
    plot(t_m0, phi_yaw_m0, 'r');
    plot(t_m0, phi_d_yaw_m0, 'g');
    plot(t_m0, phi_dd_yaw_m0, 'b');
    legend("measured \phi","\phi","\phi_d", "\phi_{dd}");
    hold off;
    
    
    
    %% EQUATION

    for i = 1:1:length(t_m0)

        M0(i) = (k_yaw * phi_d_yaw_m0(i) + Jy * phi_dd_yaw_m0(i))/Dt;
        F0(i) = k_aero*V0_m0(i)^2;
        k_mutual0(i) = M0(i) / F0(i);

    end

    set(figure, "WindowStyle", "docked");
    grid;
    hold on;
    plot(t_m0, k_mutual0,'LineWidth',1.5);
    hold off;

    m_M0_yaw = abs(mean(k_mutual0));



%% Load data

mutual1 = load('M1steps_Mutual.mat');

start_m1 = 1; %120/0.002;
finish_m1 = 90/0.002;
t_m1 = mutual1.data(1,start_m1:finish_m1);
pitch_m1 = mutual1.data(3,start_m1:finish_m1)*Pitch_encoder_res;
V1_m1 = mutual1.data(2,start_m1:finish_m1);

set(figure, "WindowStyle", "docked");
grid;
hold on;
plot(t_m1, pitch_m1,'LineWidth',0.5);
plot(t_m1, V1_m1,'LineWidth',1);
hold off;


%% Effect of M0 on the yaw movement
    
    
    fit_pitch = [0.528, 3.696, 7.744];
    fit_voltage = [2.0, 4.0, 6.0];
    
    for i=1:1:length(t_m1)
        
        if i < (30/0.002)
            scale_pitch(i) = fit_pitch(1);
        elseif i >= (30/0.002) && i < (60/0.002)
            scale_pitch(i) = fit_pitch(2);
        elseif i >= (60/0.002)
            scale_pitch(i) = fit_pitch(3);
        end

    end

    
    set(figure, "WindowStyle", "docked");
    grid;
    hold on;
    plot(t_m1, scale_pitch,'LineWidth',1);
    plot(t_m1, pitch_m1,'LineWidth',0.5);
    hold off;


    for i =1:length(fit_voltage)
        M1(i) = Mb*g*Dm * sin(fit_pitch(i)*pi/180) / Dt;
        k_mutual1(i) = M1(i) / (k_aero * fit_voltage(i)^2);
    end

    m_M1_pitch =abs(mean(k_mutual1));

    set(figure, "WindowStyle", "docked");
    grid;
    hold on;
    plot(k_mutual1,'LineWidth',1);
    hold off;





