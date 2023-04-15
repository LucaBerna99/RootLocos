%% -----------------------CLEAN-----------------------
clc
close all
clear all

%% -----------------------GLOBAL-VARIABLES-----------------------
%global freq_nat
global k_pitch k_yaw k_pitch_
global k_py k_yp
global w_ramp_0P w_ramp_0N w_ramp_1P w_ramp_1N

% data for inverse aerodynamic map look-up table
global x_table_0P x_table_0N x_table_1P x_table_1N y_table_0P y_table_0N y_table_1P y_table_1N

%% -----------------------FIGURE-----------------------
fig = (questdlg("Would you like to display all figures?", "FIGUREs", "Yes", "No", "No"));

if fig == "Yes"
    fig = 1;
else
    fig = 0;
end

%% -----------------------AERO-----------------------
    F_aero_MAPS(fig);               %done

%% -----------------------k_pitch-----------------------
    PitchCoefficient(fig);          %done
    PitchCoefficientSteps(fig);     %done

%% -----------------------k_yaw-----------------------
    YawCoefficient(fig);            %done

%% --------------------k_py---k_yp------------------------
    mutualEffectRampsLocked(fig)    %done
   
%% -----------------------SAVE-----------------------
    %save in "Coefficients.mat"
    clear fig;
    
    save = questdlg("Would you like to save?", "SAVE", "Yes", "No", "No");
    if save == "Yes"
        clear save;
        uisave();
    end
    clear save;
    