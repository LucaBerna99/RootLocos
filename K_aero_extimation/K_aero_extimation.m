% HERE, STARTING FROM THE DATA COLLECTED AT DIFFERENT HEIGHT FOR MOTOR 0,
% THE AERODYNAMICAL COEFFICIENT OF THE BLADES IS ESTIMATED

%IMPORT DATA
    parameters_aero()
    load('PITCH_MOTOR_0.mat')
    pitch_data = data;
    clear data;
    time = pitch_data(1,:);

% PITCH data are converted in RAD
    pitch_data(3,:) = pitch_data(3,:)*Pitch_encoder_res*pi/180;

% SINE of PITCH is computed
    pitch_data_sin = pitch_data;
    pitch_data_sin(3,:) = sin(pitch_data(3,:));

% All coefficients are embedded in K_force and FORCES are computed
    K_force = Mb*g/Dt;
    Forces = K_force*pitch_data_sin(3,:);

% VOLTAGES are extracted from data
    Voltages = pitch_data(4,:);

% CURRENT MAP is applied to VOLTAGES
    for i = 1:238113
    I(i) = m_current*Voltages(i);
    end

% SPEED (squared) is computed for each WORKING POINT
    for i = 1:238113
    Speeds(i) = ((Voltages(i) - Rm*I(i))/km)^2;
    end
    
% AERODYNAMIC COEFFICIENT is computed for each working condition
    for i = 1:238113
    K_aero(i) = abs(Forces(i))/Speeds(i);
    end

% K_aero is plotted as a function of time (together with scaled voltages in order to get the relation)
    figure()
    plot(time, K_aero, time, Voltages/100000)

% EXTRACTED DATA ARE HERE LOADED FROM SAVING FILE

    load('K6.mat', 'k_6')
    load('K8.mat', 'k_8')
    load('K10.mat', 'k_10')
    load('K12.mat', 'k_12')
    load('K14.mat', 'k_14')
    load('K16.mat', 'k_16')

% From data extracted from the plot above (to avoid non coherent region in
% data due to noise in the experiment) K_aero is estimated as the mean of
% the mean values assumed by the coefficients in the chosen intervals
    K_aero_extracted(1) = mean(k_6(:,2));
    K_aero_extracted(2) = mean(k_8(:,2));
    K_aero_extracted(3) = mean(k_10(:,2));
    K_aero_extracted(4) = mean(k_12(:,2));
    K_aero_extracted(5) = mean(k_14(:,2));
    K_aero_extracted(6) = mean(k_16(:,2));

    K_aero_ext = mean(K_aero_extracted);
