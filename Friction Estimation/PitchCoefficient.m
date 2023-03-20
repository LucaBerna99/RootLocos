

function PitchCoefficient(fig)

%% GLOBALs
    
    global k_pitch

%% PARAMETERS
    load("parameters.mat");
    pitch_motor_OFF = load("Pitch_motorOFF.mat");

%% ACQUISITION

    start = 5100;
    t = pitch_motor_OFF.data(1,start:end)-start*0.002;
    ydata = pitch_motor_OFF.data(2,start:end)*Pitch_encoder_res;

%% DYNAMICs

    %% BAD FITTING DAMPED DIFFERENTIAL EQUATION
    %{
    fit_diff = @(x_diff,t) (x_diff(1)) .* exp(-x_diff(2)*t) .* cos(x_diff(3)*t+x_diff(4));
    x0_diff = [ydata(1),1,1,1];
    x_diff = lsqcurvefit(fit_diff, x0_diff, t, ydata);
    %}

    %% FITTING

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

    %% DERIVATIVES

    theta = fit_dyn(x_dyn,t);
    theta_d = diff(theta) ./ 0.002;
    theta_dd = diff(theta_d) ./ 0.002;

    t(length(theta)) = [];
    t(length(theta)-1) = [];
    theta(length(theta)) = [];
    theta(length(theta)-1)= [];
    theta_d(length(theta_d)) = [];


    %% PLOTs
    if fig == 1
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
    end
    
    %% finding K_pitch with dynamics formulas
    
    for j=1:length(t)        
        Cr(j) =  - Mb*g*Dm*sind(theta(j)) - (Jp + Mb*Dm^2)*theta_dd(j);
        k_dyn(j) = Cr(j) / sign(theta_d(j));  
    end
    
    %for j=1:length(t)
        
        %Fn(j) = Mb* (theta_d(j)^2 - g*cosd(theta(j)));
        %k_dyn(j) = (theta_dd(j) + Dm*g*(theta(j))) / (-Dm*abs(Fn(j))*sign(theta_d(j)));
        
    %end
    
    k_p_DYN = abs(mean(k_dyn))
    
 
    %%
    t = [942, 2840, 4654, 6467, 8281, 10060, 11894] * 0.002;
    p = [53.33, 43.82, 35.73, 28.69, 22.7, 17.25, 12.85];

    for i = 1:length(t)-1
        wd(i) = 2*pi /(t(i+1)-t(i));
        xi(i) = log(p(i)/p(i+1)) / sqrt(4*pi^2 + (log(p(i)/p(i+1)))^2);
    end

    wd = mean(wd);
    xi = mean(xi);

    wn = wd / sqrt(1-xi^2);
    damping = 2*wn*xi*(Jp+Mb*Dm^2)
    


%% KINEMATICS with sin(THETA) = THETA --> SMALL ANGLE
    
    %% Filtering data 
    
    small_start = 16050;

    t_s = pitch_motor_OFF.data(1,small_start:end)-(small_start*0.002);
    ydata_s = pitch_motor_OFF.data(2,small_start:end)*Pitch_encoder_res;
    
    %% FITTING

    fit_small_angle = @(x_s,t_s) x_s(1) .* exp(-x_s(2)*t_s) .* cos(x_s(3)*t_s +x_s(4));
    x0 = [ydata_s(1),1,1,1];
    x_s = lsqcurvefit(fit_small_angle, x0, t_s, ydata_s);
    
    
    theta_small = fit_small_angle(x_s,t_s);
    smorz = (x_s(1)) .* exp(-x_s(2)*t_s);

    %% DERIVATIVE

    theta_d_small = diff(theta_small) / 0.002;
    
    k_p_KIN = x_s(2) * 2 * (Mb*Dm^2 + Jp)
    
    
    %% PLOTs
    if fig == 1
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
    end



%% RESULTs

    k_pitch = (k_p_DYN + k_p_KIN)/2;

    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;
        hold on;
        plot(t(1:length(t)),k_pitch.*theta_d(1:length(t)))
        hold off;
        legend("k_{PITCH}*\theta_d");
        title("C_R");
    end
    
%%



end


%%




