load('k_aero_0_negative.mat','K_aero_0_negative');
load('k_aero_1_positive.mat','K_aero_1_positive');
load('k_aero_1_negative.mat','K_aero_1_negative');

plot (K_aero_0_negative)
figure()
plot (K_aero_1_positive)
figure()
plot (K_aero_1_negative)

