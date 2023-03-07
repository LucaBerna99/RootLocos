% IN THIS SCRIPT, STARTING FROM A SIMULINK WHERE THE MOTOR MODEL 
% IS SUPPLIED WITH DIFFERENT VOLTAGES (SEE "Vdc_TEST"), THE FUNCTION
% LINKING THE SUPPLY VOLTAGE AND ARMATURE CURRENT IS IDENTIFIED

% SETUP PARAMETERS ARE LOADED
    parameters_curr()

% SIMULATION IS RUN
    out = sim('CURR_SIMULATION.slx',100);

% OUTPUT OF THE SIMULATION IS SAVED
    currents = out.simout.Data;
    time = out.tout;

% CURRENT OVER TIME IS PLOTTED
    figure()
    plot(time, currents);

% FROM THE PLOT WE EXTRACTED STEADY STATE REGIONS FOR EACH VOLTAGE SUPPLIED
% AND SAVED THE EXTRACTION IN THE ARRAYS NAMED i_v<voltage> 
% extractions are here loaded from file
    load('i_2.mat', 'i_v2')
    load('i_4.mat', 'i_v4')
    load('i_6.mat', 'i_v6')
    load('i_8.mat', 'i_v8')
    load('i_10.mat', 'i_v10')
    load('i_12.mat', 'i_v12')
    load('i_14.mat', 'i_v14')
    load('i_16.mat', 'i_v16')
    load('i_18.mat', 'i_v18')
    
% FOR ALL THE VOLTAGES THE MEAN SS CURRENT IS SAVED IN THE i_v_m ARRAY
    i_v_m(1) = mean(i_v2(:,2));
    i_v_m(2) = mean(i_v4(:,2));
    i_v_m(3) = mean(i_v6(:,2));
    i_v_m(4) = mean(i_v8(:,2));
    i_v_m(5) = mean(i_v10(:,2));
    i_v_m(6) = mean(i_v12(:,2));
    i_v_m(7) = mean(i_v14(:,2));
    i_v_m(8) = mean(i_v16(:,2));
    i_v_m(9) = mean(i_v18(:,2));

% ANGULAR COEFFICIENT OF THE V-->I MAP IS COMPUTED => [ I = m_current*V ]
    m_current = (i_v_m(9)-i_v_m(1))/16;


