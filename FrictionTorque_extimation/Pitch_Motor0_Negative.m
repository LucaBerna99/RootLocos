%% LOAD PARAMETERS

pitch_motor0_neg = load("Pitch_M0(negative)_18-45-57.mat");


%% PLOT

set(figure, "WindowStyle", "docked");
grid on;
hold on;
plot(pitch_motor0_neg.data(2,:));   %pitch
plot(pitch_motor0_neg.data(2,:)*Pitch_encoder_res);
hold off;
title("Pitch with Motor0 ON with Negative Voltages");

