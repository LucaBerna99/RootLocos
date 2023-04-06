function mutualEffectRamps(fig)

%% LOAD

load("parameters.mat");
global w_pos_0 w_pos_1 
global k_yp k_py F_limit_yaw

cutoff_freq = 2; %Hz

%%
ramp0 = load("RampM0_15-52-21_.mat");
ramp1 = load("RampM1_15-57-22_.mat");

t = ramp0.data(1,:);

pitch_m0 = ramp0.data(2,:);
yaw_m0 = ramp0.data(3,:);
V_m0 = ramp0.data(4,:);

pitch_m1 = ramp1.data(2,:);
yaw_m1 = ramp1.data(3,:);
V_m1 = ramp1.data(5,:);
    
    
%% Forces applied on Motor0

    check = 0;
    
    for i = 1:length(t)
        
        F0(i) = w_pos_0(1)*V_m0(i)^3 + w_pos_0(2)*V_m0(i)^2 + w_pos_0(3)*V_m0(i);
        
        if check == 0 && abs(yaw_m0(i)) > 10
            check = 1;
            index_m0 = i;
            F_limit_mutual_yaw = -F0(i);
            V_m0_limit = V_m0(i);
                        
        end
        
        
        
    end
    
    [ind_m_p ,max_pitch] = max(pitch_m0);
     ind_m_p = floor(ind_m_p/0.002);
    

    
%% Forces applied on Motor1

    [b,a] = butter(1, cutoff_freq*0.004, 'low');
    yaw_m1_filt = filtfilt(b, a, yaw_m1);
    
    phi_yaw_m1 = yaw_m1_filt;
    phi_yaw_d_m1 = diff(phi_yaw_m1) / 0.002;
    phi_yaw_dd_m1 = diff(phi_yaw_d_m1) / 0.002;
    
    t(length(phi_yaw_m1)) = [];
    t(length(phi_yaw_m1)-1) = [];
    phi_yaw_m1(length(phi_yaw_m1)) = [];
    phi_yaw_m1(length(phi_yaw_m1)-1)= [];
    phi_yaw_d_m1(length(phi_yaw_d_m1)) = [];
    
    
    if fig == 1
        
        set(figure, "WindowStyle", "docked");
        grid;
        hold on;
        plot(t, yaw_m1(1:length(t)),':','LineWidth',2);
        plot(t, phi_yaw_m1, 'r', "LineWidth", 1);
        plot(t, phi_yaw_d_m1, 'g');
        plot(t, phi_yaw_dd_m1, 'r');
        legend("Voltage","Measured Yaw", "Yaw", "Yaw_d", "Yaw_{dd}");
        hold off;
        
    end

    k_yaw_vec = zeros(1, length(t));
    check = 0;
    for i = 1:length(t)
        
        F1(i) = w_pos_1(1)*V_m1(i)^3 + w_pos_1(2)*V_m1(i)^2 + w_pos_1(3)*V_m1(i);

        if check == 0 && abs(yaw_m1(i)) > 10
            check = 1;
            index_m1 = i;
            F_limit_yaw = F0(i);
            V_m1_limit = V_m1(i);
        end
    end
    
    [ind_m_p_m, max_pitch_mutual] = max(pitch_m1);
    ind_m_p_m = floor(ind_m_p_m/0.002);
   
    k_yp = F1(ind_m_p_m)/ F0(ind_m_p);
    k_py = F_limit_yaw / F_limit_mutual_yaw;
    
    if fig == 1
        
        set(figure, "WindowStyle", "docked");

        subplot(2,2,1);
        hold on; grid;
        plot(t, pitch_m0(1:length(t)));
        plot(t, V_m0(1:length(t)));
        hold off;
        title("Motor0 Pitch Effect");
        
        subplot(2,2,2);
        hold on; grid;
        xline(index_m0*0.002);
        plot(t, yaw_m0(1:length(t)),"LineWidth", 1.5);
        plot(t, V_m0(1:length(t))*1000);
        hold off;
        title("Motor0 Yaw Effect");
        
        subplot(2,2,3);
        hold on; grid;
        plot(t, pitch_m1(1:length(t)));
        plot(t, V_m1(1:length(t)));
        hold off;
        title("Motor1 Pitch Effect");
        
        subplot(2,2,4);
        hold on; grid;
        xline(index_m1*0.002);
        plot(t, yaw_m1(1:length(t)),"LineWidth", 1.5);
        plot(t, V_m1(1:length(t))*1000);
        hold off;
        title("Motor1 Yaw Effect");
        
    end
end





