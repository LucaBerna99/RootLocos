
function PitchStaticFriction(fig)
%% READ ME
% This function computes the limit Pitch Force for which the apparatus doen
% not move. In this way it is modeled the Hinge Static Friction.
    
    global F_limit_pitch 
    
    load("parameters.mat")

    load('RampM1_15-57-22_.mat');
    time_1N = data(1, :);
    pitch_1N = data(2, :);
    yaw_1N = data(3, :);
    voltage0_1N = data(4, :);
    voltage1_1N = data(5, :);

    %% Limit force in pitch
    i = 1;
    
    while(abs( pitch_1N(1) - pitch_1N(i) ) < 1)
        
        theta = pitch_1N(i)*Pitch_encoder_res*pi/180;
        F_limit_pitch = Mb*g*Dm*theta/Dt;
        i = i+1;
    
    end
    
    
    
end