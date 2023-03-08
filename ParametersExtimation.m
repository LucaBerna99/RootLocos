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


k_pitch
k_yaw
K_aero_ext
m_M0_yaw
m_M1_pitch


