
function YawCoefficient(fig)
    
    %% GLOBAL 
    global k_yaw

    %% LOAD
    parameters();
    pitch_yaw = load("Pitch_Yaw_18-28-30.mat");
    
    %% ACQUISITION
    
    t = pitch_yaw.data(1,43000:end)-86.0;
    yawdata = pitch_yaw.data(2,43000:end)*Yaw_encoder_res*pi/180;
    Vmotor1 = pitch_yaw.data(4,43000:end);
    
    %% FITTING
    
    yaw_fit = @(yaw_par,t) yaw_par(1).*t.^6 + yaw_par(2).*t.^5 + yaw_par(3).*t.^4 + yaw_par(4).*t.^3+ yaw_par(5).*t.^2 + yaw_par(6).*t + yaw_par(7);
    yaw0 = [0,0,0,0,0,0,0];
    yaw_par = lsqcurvefit(yaw_fit, yaw0, t, yawdata);
    
    %% DERIVATIVES
    theta_yaw = yaw_fit(yaw_par, t);
    theta_d_yaw = diff(theta_yaw) / 0.002;
    theta_dd_yaw = diff(theta_d_yaw) / 0.002;
    
    yawdata(length(t)) = [];
    yawdata(length(t)-1) = [];
    theta_yaw(length(t)) = [];
    theta_yaw(length(t)-1) = [];
    theta_d_yaw(length(t)-1) = [];
    t(length(t)) = [];
    t(length(t)-1) = [];
    
    
    %% PLOTs
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;
        hold on;
        plot(t, yawdata,':','LineWidth',2);
        plot(t, theta_yaw, 'r', "LineWidth", 1);
        plot(t, theta_d_yaw, 'g');
        plot(t, theta_dd_yaw, 'r');
        legend("measured","fitted");
        hold off;
    end
    
    
    
    %% Dynamics calculation
    
    
    
    k_aero_1_positive();
    k_1_pos = mean(K_aero_1_positive);
    
    for i = 1:1:length(theta_yaw)
        
        F1(i) = 8e-4 * Vmotor1(i)^2;
        k_yaw_vec(i) = (F1(i)*Dt - Jy*theta_dd_yaw(i))/theta_d_yaw(i);
    
    end
    
    k_yaw = abs(mean(k_yaw_vec));
    
    
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;
        hold on;
        plot(t, k_yaw_vec,':','LineWidth',2);
        title("K_{yaw}");
        hold off;
    end

    clc
end