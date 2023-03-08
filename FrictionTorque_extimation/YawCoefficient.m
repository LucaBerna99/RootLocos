
pitch_yaw = load("Pitch_Yaw_18-28-30.mat");

%% 

%{
set(figure, "WindowStyle", "docked");
grid;
subplot(2,2,1)
hold on;
plot(pitch_yaw.data(3,:));      %pitch
plot(pitch_yaw.data(3,:)*Pitch_encoder_res);
hold off;
subplot(2,2,2)
hold on;
plot(pitch_yaw.data(2,:));      %yaw
plot(pitch_yaw.data(2,:)*Yaw_encoder_res);
hold off;
subplot(2,2,3)
hold on;
plot(pitch_yaw.data(4,:));      %tensione motore0
hold off;
subplot(2,2,4)
hold on;
plot(pitch_yaw.data(5,:));      %tensione motore1
hold off;
%}


%% Rotational Velocity

t = pitch_yaw.data(1,43000:end)-86.0;
yawdata = pitch_yaw.data(2,43000:end)*Yaw_encoder_res*pi/180;
Vmotor1 = pitch_yaw.data(4,43000:end);

yaw_fit = @(yaw,t) yaw(1).*t.^4+yaw(2).*t.^3+yaw(3).*t.^2+yaw(4).*t+yaw(5);
yaw0 = [1,1,1,1,1];
yaw = lsqcurvefit(yaw_fit, yaw0, t, yawdata);

theta_yaw = yaw_fit(yaw, t);
theta_d_yaw = diff(theta_yaw) / 0.002;
theta_dd_yaw = diff(theta_d_yaw) / 0.002;

set(figure, "WindowStyle", "docked");
grid;
hold on;
plot(t, yawdata,'b','LineWidth',1.5);
plot(t, theta_yaw, 'r');
plot(t, theta_d_yaw, 'r');
plot(t, theta_dd_yaw, 'r');
legend("measured","fitted");
hold off;



%%



k_aero_1_positive();
k_1_pos = mean(K_aero_1_positive);
for i = 1:1:length(theta_yaw)
    
    F1(i) = 8e-4 * Vmotor1(i)^2;
    k_yaw(i) = (F1(i)*Dt - Jy*theta_dd_yaw(i))/theta_d_yaw(i);

end

k_yaw = abs(mean(k_yaw));




