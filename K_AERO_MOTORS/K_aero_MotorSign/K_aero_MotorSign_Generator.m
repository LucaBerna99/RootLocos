%% IMPORT PARAMETERS
parameters()

%% FORCE CONSTANT DEFINITION

K_FORCE = (Mb*g)*abs(Dm)/Dt;

%% -------------------------- M0 NEGATIVE ---------------------------------

% LOADING OF EXTRACTED DATA FOR MOTOR 0 WITH NEGATIVE VOLTAGE
load('0N_th4.mat')
load('0N_th6.mat')
load('0N_th8.mat')
load('0N_th10.mat')
load('0N_th12.mat')
load('0N_th14.mat')
load('0N_th16.mat')
load('0N_th18.mat')

% theta vector inizialization from extracted data

theta(1) = mean(theta_4(:,2))*Pitch_encoder_res*pi/180;
theta(2) = mean(theta_6(:,2))*Pitch_encoder_res*pi/180;
theta(3) = mean(theta_8(:,2))*Pitch_encoder_res*pi/180;
theta(4) = mean(theta_10(:,2))*Pitch_encoder_res*pi/180;
theta(5) = mean(theta_12(:,2))*Pitch_encoder_res*pi/180;
theta(6) = mean(theta_14(:,2))*Pitch_encoder_res*pi/180;
theta(7) = mean(theta_16(:,2))*Pitch_encoder_res*pi/180;
theta(8) = mean(theta_18(:,2))*Pitch_encoder_res*pi/180;

% voltages definition

voltages = [-4, -6, -8, -10, -12, -14, -16, -18];

% sin theta definition

for i=1:8
sin_theta(i) = sin(theta(i));
end

% K_aero definition

for i=1:8
    K_aero_0_negative(1, i) = voltages (i);
    K_aero_0_negative(2, i) = (K_FORCE*sin_theta(i))/(voltages(i))^2;
end

% saves the result in a file

 save("K_aero_0N.mat", "K_aero_0_negative")
 
%% -------------------------- M0 POSITIVE ---------------------------------

% LOADING OF EXTRACTED DATA FOR MOTOR 0 WITH POSITIVE VOLTAGE
load('0P_th4.mat')
load('0P_th6.mat')
load('0P_th8.mat')
load('0P_th10.mat')
load('0P_th12.mat')
load('0P_th14.mat')
load('0P_th16.mat')
load('0P_th18.mat')

% theta vector inizialization from extracted data

theta(1) = mean(theta_4(:,2))*Pitch_encoder_res*pi/180;
theta(2) = mean(theta_6(:,2))*Pitch_encoder_res*pi/180;
theta(3) = mean(theta_8(:,2))*Pitch_encoder_res*pi/180;
theta(4) = mean(theta_10(:,2))*Pitch_encoder_res*pi/180;
theta(5) = mean(theta_12(:,2))*Pitch_encoder_res*pi/180;
theta(6) = mean(theta_14(:,2))*Pitch_encoder_res*pi/180;
theta(7) = mean(theta_16(:,2))*Pitch_encoder_res*pi/180;
theta(8) = mean(theta_18(:,2))*Pitch_encoder_res*pi/180;

% voltages definition

voltages = [4, 6, 8, 10, 12, 14, 16, 18];

% sin theta definition

for i=1:8
sin_theta(i) = sin(theta(i));
end

% K_aero definition

for i=1:8
    K_aero_0_positive(1, i) = voltages(i);
    K_aero_0_positive(2, i) = (K_FORCE*sin_theta(i))/(voltages(i))^2;
end

% saves the result in a file

 save("K_aero_0P.mat", "K_aero_0_positive")
 
%% -------------------------- M1 NEGATIVE ---------------------------------

% LOADING OF EXTRACTED DATA FOR MOTOR 1 WITH NEGATIVE VOLTAGE

load('1N_th4.mat')
load('1N_th6.mat')
load('1N_th8.mat')
load('1N_th10.mat')
load('1N_th12.mat')
load('1N_th14.mat')
load('1N_th16.mat')
load('1N_th18.mat')

% theta vector inizialization from extracted data

theta(1) = mean(theta_4(:,2))*Pitch_encoder_res*pi/180;
theta(2) = mean(theta_6(:,2))*Pitch_encoder_res*pi/180;
theta(3) = mean(theta_8(:,2))*Pitch_encoder_res*pi/180;
theta(4) = mean(theta_10(:,2))*Pitch_encoder_res*pi/180;
theta(5) = mean(theta_12(:,2))*Pitch_encoder_res*pi/180;
theta(6) = mean(theta_14(:,2))*Pitch_encoder_res*pi/180;
theta(7) = mean(theta_16(:,2))*Pitch_encoder_res*pi/180;
theta(8) = mean(theta_18(:,2))*Pitch_encoder_res*pi/180;

% voltages definition

voltages = [-4, -6, -8, -10, -12, -14, -16, -18];

% sin theta definition

for i=1:8
sin_theta(i) = sin(theta(i));
end

% K_aero definition

for i=1:8
    K_aero_1_negative(1, i) = voltages(i);
    K_aero_1_negative(2, i) = (K_FORCE*sin_theta(i))/(voltages(i))^2;
end

% saves the result in a file

 save("K_aero_1N.mat", "K_aero_1_negative")
 
%% -------------------------- M1 POSITIVE ---------------------------------

% LOADING OF EXTRACTED DATA FOR MOTOR 1 WITH POSITIVE VOLTAGE

load('1P_th4.mat')
load('1P_th6.mat')
load('1P_th8.mat')
load('1P_th10.mat')
load('1P_th12.mat')
load('1P_th14.mat')
load('1P_th16.mat')
load('1P_th18.mat')

% theta vector inizialization from extracted data

theta(1) = mean(theta_4(:,2))*Pitch_encoder_res*pi/180;
theta(2) = mean(theta_6(:,2))*Pitch_encoder_res*pi/180;
theta(3) = mean(theta_8(:,2))*Pitch_encoder_res*pi/180;
theta(4) = mean(theta_10(:,2))*Pitch_encoder_res*pi/180;
theta(5) = mean(theta_12(:,2))*Pitch_encoder_res*pi/180;
theta(6) = mean(theta_14(:,2))*Pitch_encoder_res*pi/180;
theta(7) = mean(theta_16(:,2))*Pitch_encoder_res*pi/180;
theta(8) = mean(theta_18(:,2))*Pitch_encoder_res*pi/180;

% voltages definition

voltages = [4, 6, 8, 10, 12, 14, 16, 18];

% sin theta definition

for i=1:8
sin_theta(i) = sin(theta(i));
end

% K_aero definition

for i=1:8
    K_aero_1_positive(1, i) = voltages(i);
    K_aero_1_positive(2, i) = (K_FORCE*sin_theta(i))/(voltages(i))^2;
end
% saves the result in a file

 save("K_aero_1P.mat", "K_aero_1_positive")
 
 clear all
 
 
 %% --------------------------- END ---------------------------------------
 