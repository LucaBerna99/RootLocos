%%CLEAN

clc
close all
clear all

%% IMPORT PARAMETERS
parameters();
    

%% DATA ACQUISITION

%% K_pitch
Pitch_MotorOFF();
close all;

%% k_yaw
Pitch_Yaw();
close all;

%% m_M0_yaw, m_M1_pitch
mutualEffect();


%% OVERALL RESULTS 

%friction coefficient
    k_pitch
    k_yaw

%mutual effect coefficients
    m_M0_yaw
    m_M1_pitch

%aerodynamic coefficients
    K_aero_0_positive
    K_aero_1_positive
    K_aero_0_negative
    K_aero_1_negative


