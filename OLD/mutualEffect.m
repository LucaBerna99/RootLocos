
function mutualEffect(fig)

    %% GLOBAL
    global k_py k_yp k_yaw w_pos_0 w_pos_1
    load("parameters.mat");
    
    %% Load Data
    
    mutual0 = load('M0steps_MutualYaw.mat');
    
    start_m0 = 120/0.002;
    finish_m0 = 270/0.002;
    t = mutual0.data(1,start_m0:finish_m0)-start_m0*0.002;
    yawdata = mutual0.data(3,start_m0:finish_m0)*Yaw_encoder_res;
    V0_m0 = mutual0.data(4,start_m0:finish_m0);
        
    
    %% Effect of M0 on the yaw movement
    
        %% FITTING
        
        phi_yaw_par = csaps(t,yawdata,0.7);
        phi_yaw = ppval(phi_yaw_par,t);    

        phi_d_yaw_par = fnder(phi_yaw_par,1);
        phi_d_yaw = ppval(phi_d_yaw_par,t);

        phi_dd_yaw_par = fnder(phi_d_yaw_par,1);
        phi_dd_yaw = ppval(phi_dd_yaw_par,t);
        
        
        
        %% PLOT DERIVATIVES
        if fig == 1

            set(figure, "WindowStyle", "docked");
            grid;
            hold on;
            plot(t, yawdata,'b','LineWidth',2);
            plot(t, phi_yaw, 'r');
            plot(t, phi_d_yaw, 'g');
            plot(t, phi_dd_yaw, 'b');
            legend("measured \phi","\phi","\phi_d", "\phi_{dd}");
            hold off;

        end
        
        
        
        
        %% EQUATION
    
        for i = 1:length(t)
            
            F(i) = w_pos_0(1)*V0_m0(i)^3 + w_pos_0(2)*V0_m0(i)^2 + w_pos_0(3)*V0_m0(i);
            M0(i) = (k_yaw * phi_d_yaw(i) + Jy * phi_dd_yaw(i)) * Dt;
            k_py_vect(i) = M0(i) / F(i);
    
        end
        
        if fig == 1
            
            set(figure, "WindowStyle", "docked");
            grid;
            hold on;
            plot(t, k_py_vect,'LineWidth',1.5);
            title("Mutual Coeff pitch-yaw");
            hold off;
            
        end
    
        k_py = mean(k_py_vect());
    
    
    
    %% Load data
    
    mutual1 = load('M1steps_Mutual.mat');
    
    start_m1 = 52;
    finish_m1 = 45000;
    t_m1 = mutual1.data(1,start_m1:finish_m1) - start_m1*0.002;
    pitch_m1 = mutual1.data(3,start_m1:finish_m1)*Pitch_encoder_res;
    V1_m1 = mutual1.data(2,start_m1:finish_m1);
    
    
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;
        hold on;
        plot(t_m1, pitch_m1,'LineWidth',0.5);
        plot(t_m1, V1_m1,'LineWidth',1);
        hold off;
    end
    
    
    %% Effect of M1 on the pitch movement
        
        for i = 1:length(t_m1) 
            F(i) = w_pos_1(1)*V1_m1(i)^3 + w_pos_1(2)*V1_m1(i)^2 + w_pos_1(3)*V1_m1(i);
            M1(i) = Mb * g * Dm * Dt * sind(pitch_m1(i));
            k_yp_vect(i) = M1(i) / F(i);
        end
    
        k_yp = mean(k_yp_vect);
    
        if fig == 1
            set(figure, "WindowStyle", "docked");
            grid;
            hold on;
            plot(k_yp_vect,'LineWidth',1);
            title("Mutual Coeff yaw-pitch");
            hold off;
        end
    
        %clc

end



