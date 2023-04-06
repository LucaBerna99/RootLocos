
function YawCoefficient(fig)
    
    %% GLOBAL 
    global k_yaw w_ramp_1P

    %% LOAD
    load("parameters.mat");
    pitch_yaw = load("RampM1_NoPitch.mat");
    
    %% ACQUISITION
    start = 1;
    t = pitch_yaw.data(1,start:end) - start*0.002;
    yawdata = pitch_yaw.data(3,start:end);
    Vmotor1 = pitch_yaw.data(5,start:end);
    
    %% SMOOTH SPLINE and DERIVATIVEs

    theta_yaw_par = csaps(t,yawdata,0.0001);
    theta_yaw = ppval(theta_yaw_par,t);    
    
    theta_d_yaw_par = fnder(theta_yaw_par,1);
    theta_d_yaw = ppval(theta_d_yaw_par,t);
    
    theta_dd_yaw_par = fnder(theta_d_yaw_par,1);
    theta_dd_yaw = ppval(theta_dd_yaw_par,t);
    
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;hold on;
        plot(yawdata, "Linewidth", 1.5);
        plot(theta_yaw);
        hold off;
        legend("\theta^{MEASURED}", "\theta^{FITTED}");
    end
    
    %% PLOTs
    if fig == 1
        
        set(figure, "WindowStyle", "docked");
        grid;hold on;
        plot(t, theta_d_yaw, 'g');
        plot(t, theta_dd_yaw, 'r');
        legend("\theta_d","\theta_{dd}");
        hold off;
        
    end
    
    
    
    %% Dynamics calculation
    
        
    for i = 1:length(theta_yaw)
        
        F1(i) = w_ramp_1P(1)*Vmotor1(i)^3 + w_ramp_1P(2)*Vmotor1(i)^2 + w_ramp_1P(3)*Vmotor1(i);
        k_yaw_vec(i) = (F1(i)*Dt - Jy*theta_dd_yaw(i));
    
    end

    k_yaw = abs(mean(k_yaw_vec));
    
    
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;hold on;
        plot(k_yaw_vec,':','LineWidth',2);
        title("K_{yaw}");
        hold off;
    end

    clc
end