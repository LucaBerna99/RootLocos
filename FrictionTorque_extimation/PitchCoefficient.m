%% PARAMETERS

    pitch_motor_OFF = load("Pitch_motorOFF.mat");

%% ACQUISITION
    % TODO cut
    start = 5100;
    finish = 12000;
    t = pitch_motor_OFF.data(1,start:end)-start*0.002;
    ydata = pitch_motor_OFF.data(2,start:end)*Pitch_encoder_res;

%% DYNAMICs

    %% Derivatives
    
    fit_dyn = @(x_dyn,t) (x_dyn(1)+ x_dyn(2)*t) .* exp(-x_dyn(3)*t) .* cos(x_dyn(4)*t+x_dyn(5));
    x0_dyn = [ydata(1),1,1,1,1];
    x_dyn = lsqcurvefit(fit_dyn, x0_dyn, t, ydata);

    %% PERIOD
    
    period = 3.712;
    zero = 500;
    tzero = zero * 0.002;

    omega = 2*pi/period;
    
    ydata(length(ydata)) = [];
    ydata(length(ydata)-1) = [];

                 
    theta = fit_dyn(x_dyn,t);
    theta_d = diff(theta) ./ 0.002;
    theta_dd = diff(theta_d) ./ 0.002;

    t(length(theta)) = [];
    t(length(theta)-1) = [];
    theta(length(theta)) = [];
    theta(length(theta)-1)= [];
    theta_d(length(theta_d)) = [];

    set(figure, "WindowStyle", "docked");
    hold on; grid;
    plot(t,ydata);
    plot(t, fit_dyn(x_dyn,t));
    xline(tzero);
    xline(tzero+period);
    xline(tzero+2*period);
    xline(tzero+3*period);
    hold off;
    legend("measured","fitted_{DYNAMIC}");

    set(figure, "WindowStyle", "docked");
    plot(t,theta,t,theta_d,t,theta_dd);
    legend("\theta","\theta_d","\theta_dd");
    title("theta and its derivatives");    
    
    
    %% finding C_R with dynamics formulas
    
    jj =0;
    for j=1:1:length(t)
        
        Cr(j) =  + Mb*g*abs(Dm)*sind(theta(j)) + (Jp + Mb*Dm^2)*theta_dd(j);
        k_dyn(j) = Cr(j) / sign(theta_d(j));
                
    end
    
    k_p_DYN = abs(mean(k_dyn));    
    

%% KINEMATICS with sin(THETA) = THETA --> SMALL ANGLE
    
    %% Filtering data 
    
    small_start = 16050;

    t_s = pitch_motor_OFF.data(1,small_start:end)-(small_start*0.002);
    ydata_s = pitch_motor_OFF.data(2,small_start:end)*Pitch_encoder_res;
    
    fit_small_angle = @(x_s,t_s) x_s(1) .* exp(-x_s(2)*t_s) .* cos(x_s(3)*t_s +x_s(4));
    x0 = [ydata_s(1),1,1,1];
    x_s = lsqcurvefit(fit_small_angle, x0, t_s, ydata_s);
    
    %% analytical functions
    
    theta_small = fit_small_angle(x_s,t_s);
    smorz = (x_s(1)) .* exp(-x_s(2)*t_s);

    theta_d_small = diff(theta_small) / 0.002;
    
    %alpha = k_p_KIN / (2*M_eq)
    k_p_KIN = x_s(2) * 2 * (Mb*Dm^2 + Jp); 
    
    
    set(figure, "WindowStyle", "docked");
    grid;
    hold on;
    plot(t_s,ydata_s)
    plot(t_s,theta_small)
    plot(t_s, smorz, t_s, -smorz);
    yline(-15);
    yline(15);
    hold off;
    title("KINEMATICS with small angles (<15 deg)");



%% RESULTs
    clc

    set(figure, "WindowStyle", "docked");
    grid;
    hold on;
    plot(t(1:length(t)),Cr)
    plot(t(1:length(t)),k_p_KIN*theta_d(1:length(t)))
    plot(t(1:length(t)),k_p_DYN*theta_d(1:length(t)))
    hold off;
    legend("Cr","k_p^{KIN}*\theta_d","k_p^{DYN}*\theta_d")
    title("Comparison between Cr");

    k_p_DYN;
    k_p_KIN;  %small angles
    k_pitch = (k_p_DYN + k_p_KIN)/2;


