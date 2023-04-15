
function YawCoefficient(fig)
    
    %% COMMENTI
    %Valutare con FVT la velocità raggiunta dal sistema del primo ordine 
    % omega_out = [ (Jy/k_yaw) / ((Jy/k_yaw)s + 1) ] 

    
    %% GLOBAL 
    global k_yaw

    %% LOAD
    load("parameters.mat");
    load("M0steps_MutualYaw_06-Mar-2023_16-49-17_.mat");
        
    start = 1;
    t = data(1,:) - start*0.002;
    pitch = data(2,:);
    yaw = data(3,:);
    V_m0 = data(4,:);
    
    %% filter
    
    [b,a] = butter(1, 2*0.004, 'low');
    yaw = filtfilt(b, a, yaw);
    yaw_d = diff(yaw)/0.002;
    yaw(end) = [];
    t(end) = [];
    V_m0(end) = [];
    
    
    %%
    if fig == 1
       set(figure(), "windowStyle", "docked");
       grid; hold on;
       plot(t, yaw);
       plot(t, yaw_d);
       hold off;
       title("Yaw and Yaw_d");
    end
    
    if fig == 1
       set(figure(), "windowStyle", "docked");
       grid; hold on;
       plot(t(270/0.002:end)-270, yaw_d(270/0.002:end));
       hold off;
    end
    
    %%
    s = 270/0.002;
    w0 = abs(yaw_d(s));
    w1 = 0.005*w0;
    
    t0 = 270;
    flg = 0;
    
    for i = s:length(t)
        if abs(yaw_d(i)) <= w1 && flg == 0
            flg = 1;
            t1 = i * 0.002;
        end
    end
    
    tau = (t1-t0)/5;
    k_yaw = Jy / tau /2;
    
end