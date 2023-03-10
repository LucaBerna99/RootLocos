%%CLEAN

clc
close all
clear all


%% GLOBAL VARIABLES

global k_pitch k_yaw k_py k_yp w_pos w_neg

%% AERO
K_aero_MAP(0);

%% K_pitch
PitchCoefficient(0);

%% k_yaw
YawCoefficient(0);

%% k_py, k_yp
mutualEffect(0);