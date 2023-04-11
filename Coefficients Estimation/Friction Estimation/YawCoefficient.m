
function YawCoefficient(fig)
    
    %% COMMENTI
    %Valutare con FVT la velocità raggiunta dal sistema del primo ordine 
    % omega_out = [ (Jy/k_yaw) / ((Jy/k_yaw)s + 1) ] 

    
    %% GLOBAL 
    global k_yaw w_ramp_1P

    %% LOAD
    load("parameters.mat");
    yaw = load("PitchLocked_StepM1_1.mat");
    
    %% ACQUISITION
    start = 1002;
    t = yaw.data(1,start:end) - start*0.002;
    yawdata = (yaw.data(3,start:end) - yaw.data(3,1))*Pitch_encoder_res;
    Vmotor1 = yaw.data(5,start:end);
    
    %% SMOOTH SPLINE and DERIVATIVEs

    phi_par = csaps(t,yawdata,0.7);
    phi = ppval(phi_par,t);  

    phi_d_par = fnder(phi_par,1);
    phi_d = ppval(phi_d_par,t);
    
    for i = 1:length(phi)
        error(i) = yawdata(i) - phi(i); 
    end
    
    if fig == 1
        set(figure, "WindowStyle", "docked");
        grid;hold on;
        plot(yawdata, "Linewidth", 1.5);
        plot(phi);
        plot(Vmotor1);
        hold off;
        legend("\theta^{MEASURED}", "\theta^{FITTED}");

        set(figure, "WindowStyle", "docked");
        grid;
        plot(error, "Linewidth", 1.5);
        title("Fitting error");
    end
    
    %% PLOTs
    if fig == 1
        
        set(figure, "WindowStyle", "docked");
        grid;hold on;
        plot(t, phi_d, 'g');
        legend("\theta_d","\theta_{dd}");
        hold off;
        
    end
    
    %% Assestment time
    check = 0;
    for i=1:length(phi_d)
        if check == 0 && phi_d(i) >= 0.995*phi_d(end)
            ind = i;
            check = 1;
            phi_d(i);
        end
    end
        
    tau = t(ind)/5;
    
    k_yaw = 2*Jy / tau;

    %clc
end