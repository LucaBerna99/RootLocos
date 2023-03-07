%%CLEAN

clc
close all
clear all

%% IMPORT PARAMETERS
parameters();
    

%% DATA ACQUISITION

Pitch_MotorOFF();
%Pitch_Motor0();
%Pitch_Motor0_Negative();
Pitch_Yaw();
mutualEffect();



%% OVERALL RESULTS 

%close all;
%clc

k_pitch
k_yaw
K_aero_ext
m_M0_yaw


