%%LOAD PARAMETERS
pitch_motor0 = load("Pitch_M0_18-36-52.mat");

%% PLOT

set(figure, "WindowStyle", "docked");
grid on;
hold on;
plot(pitch_motor0.data(2,:));       %pitch
plot(pitch_motor0.data(2,:)*Pitch_encoder_res);
title("Pitch with Motor0 ON");  