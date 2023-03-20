%% -----------------------CLEAN-----------------------

clc
close all
clear all

%% -----------------------GLOBAL-VARIABLES-----------------------
global k_pitch k_yaw 
global k_py k_yp 
global w_pos w_neg w_pos_0 w_neg_0 w_pos_1 w_neg_1 w_static
global F_limit_yaw F_limit_pitch

%% -----------------------AERO-----------------------
    K_aero_MAP(1);

%% -----------------------K_pitch-----------------------
    PitchCoefficient(0);

%% -----------------------k_yaw-----------------------
    YawCoefficient(0);

%% -----------------------k_py-k_yp-----------------------
    mutualEffect(0);

%% -----------------------YAW-STATIC-FORCE-----------------------
    YawStaticFriction(0);
    
%% -----------------------PITCH-STATIC-FORCE-----------------------
    PitchStaticFriction();

    
%% -----------------------SAVE-----------------------
    %save in "Coefficients.mat"
    uisave();
    
   



