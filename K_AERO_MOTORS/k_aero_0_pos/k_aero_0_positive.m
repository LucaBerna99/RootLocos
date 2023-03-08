%% IMPORT PARAMETERS
parameters()

%% FORCE CONSTANT DEFINITION

K_FORCE = (Mb*g)/Dt;

%% theta vector inizialization from extracted data

load("theta_4.mat");
load("theta_6.mat");
load("theta_8.mat");
load("theta_10.mat");
load("theta_12.mat");
load("theta_14.mat");
load("theta_16.mat");
load("theta_18.mat");


theta(1) = mean(theta_4(:,2))*Pitch_encoder_res*pi/180;
theta(2) = mean(theta6(:,2))*Pitch_encoder_res*pi/180;
theta(3) = mean(theta8(:,2))*Pitch_encoder_res*pi/180;
theta(4) = mean(theta10(:,2))*Pitch_encoder_res*pi/180;
theta(5) = mean(theta12(:,2))*Pitch_encoder_res*pi/180;
theta(6) = mean(theta14(:,2))*Pitch_encoder_res*pi/180;
theta(7) = mean(theta16(:,2))*Pitch_encoder_res*pi/180;
theta(8) = mean(theta18(:,2))*Pitch_encoder_res*pi/180;

%% voltages definition

voltages = [4, 6, 8, 10, 12, 14, 16, 18];

%% sin theta definition

for i=1:8
sin_theta(i) = sin(theta(i));
end

%% K_aero definition

for i=1:8
K_aero_0_positive(i) = (K_FORCE*sin_theta(i))/(voltages(i))^2;
end