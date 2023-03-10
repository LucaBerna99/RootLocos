
function mutualEffect(fig)

    %% GLOBAL
    global k_py k_yp k_yaw
    
    
    %% Load Data

    parameters();
    mutual0 = load('M0steps_MutualYaw.mat');
    
    start_m0 = 120/0.002;
    finish_m0 = 270/0.002;
    t_m0 = mutual0.data(1,start_m0:finish_m0)-start_m0*0.002;
    yaw_m0 = mutual0.data(3,start_m0:finish_m0)*Yaw_encoder_res;
    V0_m0 = mutual0.data(4,start_m0:finish_m0);
    
    k_aero = 8e-4;
    
    
    %% Effect of M0 on the yaw movement
    
        %% FITTING
        
        yaw_fit_m0 = @(yaw_par_m0,t_m0) yaw_par_m0(1).*t_m0.^6 + yaw_par_m0(2).*t_m0.^5 + yaw_par_m0(3).*t_m0.^4 + yaw_par_m0(4).*3 + yaw_par_m0(5).*t_m0.^2 + yaw_par_m0(6).*t_m0 ;
        yaw_par0_m0 = [0,0,0,0,0,0,0];
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
        if fig == 1

            set(figure, "WindowStyle", "docked");
            grid;
            hold on;
            plot(t_m0, yaw_m0,'b','LineWidth',2);
            plot(t_m0, phi_yaw_m0, 'r');
            plot(t_m0, phi_d_yaw_m0, 'g');
            plot(t_m0, phi_dd_yaw_m0, 'b');
            legend("measured \phi","\phi","\phi_d", "\phi_{dd}");
            hold off;

        end
        
        
        %% EQUATION
    
        for i = 1:length(t_m0)
    
            M0(i) = (k_yaw * phi_d_yaw_m0(i) + Jy * phi_dd_yaw_m0(i))*Dt;
            k_yp_vect(i) = M0(i) / (k_aero * V0_m0(i)^2);
    
        end
        if fig == 1
            set(figure, "WindowStyle", "docked");
            grid;
            hold on;
            plot(t_m0, k_yp_vect,'LineWidth',1.5);
            title("Mutual Coeff pitch-yaw");
            hold off;
        end
    
        k_py = abs(mean(k_yp_vect));
    
    
    
    %% Load data
    
    mutual1 = load('M1steps_Mutual.mat');
    
    start_m1 = 1; %120/0.002;
    finish_m1 = 90/0.002;
    t_m1 = mutual1.data(1,start_m1:finish_m1) - start_m1*0.002;
    pitch_m1 = mutual1.data(3,start_m1:finish_m1)*Pitch_encoder_res*pi/180;
    V1_m1 = mutual1.data(2,start_m1:finish_m1);
    
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;
        hold on;
        plot(t_m1, pitch_m1,'LineWidth',0.5);
        plot(t_m1, V1_m1,'LineWidth',1);
        hold off;
    end
    
    
    %% Effect of M0 on the yaw movement
        
        
        fit_pitch = [0.528, 3.696, 7.744];
        fit_voltage = [2.0, 4.0, 6.0];
        
        for i =1:length(fit_voltage)
    
            M1(i) = Mb*g*abs(Dm) * sin(fit_pitch(i))*Dt;
            k_yp_vect(i) = M1(i) / (k_aero * fit_voltage(i)^2);
    
        end
    
        k_yp = abs(mean(k_yp_vect));
    
        if fig == 1
            set(figure, "WindowStyle", "docked");
            grid;
            hold on;
            plot(k_yp_vect,'LineWidth',1);
            title("Mutual Coeff yaw-pitch");
            hold off;
        end
    
        clc

end



