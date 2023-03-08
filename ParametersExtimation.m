%%CLEAN

clc
close all
clear all

%% IMPORT PARAMETERS
parameters();
    

%% DATA ACQUISITION

%% K_pitch
PitchCoefficient();
close all;

%% k_yaw
YawCoefficient();
close all;

%% AERO

k_aero_0_positive();
K_aero_1_positive();
k_aero_0_negative();
k_aero_1_negative();

%% m_M0_yaw, m_M1_pitch
mutualEffect();



%% OVERALL RESULTS 

%friction coefficient
    k_pitch
    k_yaw

%mutual effect coefficients
    m_M0_yaw
    m_M1_pitch

% aerodynamic coefficients
    k_aero0pos = mean(K_aero_0_positive)
    k_aero1pos = mean(K_aero_1_positive)
    k_aero0neg = mean(K_aero_0_negative)
    k_aero1neg = mean(K_aero_1_negative)


