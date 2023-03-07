%% PARAMETERS
 %DC Motor  
    V_nom = 18.0;       %V
    tau_nom = 22.0;     %mN-m
    omega_nom = 3050;   %RPM
    Inom = 0.540;       %A
    Rm = 8.4;           %?
    kt = 0.042;         %N-m/A
    km = 0.042;         %V/(rad/s)
    Jm = 4.0e-6;        %g-m2
    Lm = 1.16;          %mH
%Aero Body
    Mb = 1.075;         %kg
    Dm = -7.59/1000;    %mm/1000 -> m
    Jp = 2.15e-2;       %kg-m2
    Jy = 2.37e-2;       %kg-m2
    Dt = 15.8/100;      %cm/100 -> m
%Motor and Pitch Encoders
    Pitch_encoder_line_count = 512;             %lines/rev
    Pitch_encoder_line_count_quad = 2048;       %lines/rev
    Pitch_encoder_res = 0.176;                  %deg/count
%Yaw Encoder
    Yaw_encoder_line_count =  1024;             %lines/rev
    Yaw_encoder_line_count_quadr = 4096;        %lines/rev
    Yaw_encoder_res = 0.088;                    %deg/count
%Amplifier
    
    %Amplifier type PWM
    peak_current = 2;            %A
    countinuous_current = 0.5;   %A
    V_range = [-18, +18];        %V
    V_range_max =  [- 24, +24];  %V

%% Other Constants

g = 9.81;
B_friction = 7e-5;
