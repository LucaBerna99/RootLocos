function YawStaticFriction(fig)

    %% GLOBAL

    global F_static w_pos F_limit_yaw
    load("parameters.mat");

    %% LOAD
    flimit = load("F_Limit.mat");

    %%
    t = flimit.data10_06_20(1,:);
    yaw = flimit.data10_06_20(3,:)*Yaw_encoder_res;
    V_m1 = flimit.data10_06_20(5,:);
    
    %% LIMIT FORCE
    check = 0;
    for i = 1:length(t)
        
        k(i) = w_pos(3)*V_m1(i)^2 + w_pos(2)*V_m1(i) + w_pos(1);
        F_applied(i) = k(i) * V_m1(i)^2;
        
        if check == 0 && yaw(i) > 1
            check = 1;
            index = i;
            F_limit_yaw = F_applied(i);
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



