function YawStaticFriction(fig)

    %% GLOBAL

    global w_ramp_1P F_limit_yaw
    load("parameters.mat");

    %% LOAD
    flimit = load("F_Limit.mat");

    %%
    t = flimit.data(1,:);
    yaw = flimit.data(3,:)*Yaw_encoder_res;
    V_m1 = flimit.data(5,:);
    
    %% LIMIT FORCE
    check = 0;
    
    for i = 1:length(t)
        F_applied(i) = w_ramp_1P(1)*V_m1(i)^3 + w_ramp_1P(2)*V_m1(i)^2 + w_ramp_1P(3)*V_m1(i);
        
        if check == 0 && yaw(i)> 2
            check = 1;
            index = i;
            F_limit_yaw = F_applied(i);
            V_m1(i);
        end
    end
    
    if fig == 1
        
        set(figure(), "Windowstyle", "docked");
        plot(t, yaw);
        hold on; grid
        plot(t, V_m1);
        xline(index*0.002);
        hold off;
        title("Yaw effect");
        
    end
end



