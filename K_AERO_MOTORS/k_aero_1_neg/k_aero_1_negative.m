%% IMPORT PARAMETERS
parameters()

%% FORCE CONSTANT DEFINITION

K_FORCE = (Mb*g)/Dt;

%% theta vector inizialization from extracted data

theta(1) = mean(theta_4(:,2))*Pitch_encoder_res*pi/180;
theta(2) = mean(theta_6(:,2))*Pitch_encoder_res*pi/180;
theta(3) = mean(theta_8(:,2))*Pitch_encoder_res*pi/180;
theta(4) = mean(theta_10(:,2))*Pitch_encoder_res*pi/180;
theta(5) = mean(theta_12(:,2))*Pitch_encoder_res*pi/180;
theta(6) = mean(theta_14(:,2))*Pitch_encoder_res*pi/180;
theta(7) = mean(theta_16(:,2))*Pitch_encoder_res*pi/180;
theta(8) = mean(theta_18(:,2))*Pitch_encoder_res*pi/180;

%% voltages definition

voltages = [-4, -6, -8, -10, -12, -14, -16, -18];

%% sin theta definition

for i=1:8
sin_theta(i) = sin(theta(i));
end

%% K_aero definition

for i=1:8
K_aero_1_negative(i) = (K_FORCE*sin_theta(i))/(voltages(i))^2;
end