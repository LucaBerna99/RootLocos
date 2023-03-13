%% CLEAN

clc
close all
clear all

%% GLOBAL VARIABLES
global k_pitch k_yaw 
global k_py k_yp 
global w_pos w_neg 
global F_limit

%% AERO
K_aero_MAP(0);

%% K_pitch
PitchCoefficient(0);

%% k_yaw
YawCoefficient(0);

%% k_py, k_yp
mutualEffect(0);

%% STATIC FORCE
StaticFriction(0);

%% SAVE
uisave();