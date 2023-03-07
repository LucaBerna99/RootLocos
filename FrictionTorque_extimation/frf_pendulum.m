%% 
clc
close all
clear
parameters();

%% 
th0 = 0;

costh0 = cos(th0);
sinth0 = sin(th0);

m_ph = diag([Jm ,Jm, Mb, Mb, Jp]);


lambda_m = [      1
                  1
            abs(Dm)*costh0
            abs(Dm)*sinth0
                  1           ];

nu_g1 =  abs(Dm)*costh0 ; 

k = Mb * g * nu_g1;

m = lambda_m' * m_ph * lambda_m;

[modes, D] = eig(m^-1 * k);

f_nat = sqrt(diag(D)/2/pi)

lambda_f = [     Dt 
                -Dt
                -1      ];

%% F0 -----------------------------------------------------------
f = 0:0.01:1;
i = sqrt(-1);
F0 = [1 0 0];
for j =   1 : length(f)
    
    ome = 2 * pi * f(j);
    A0 = -ome^2 *m  + k; 
    F = F0 * lambda_f; 
    
    X = (A0^(-1) * F); 
    
    theta(j) = X(1);
    y_a(j) = -Dt*sinth0 -Dt*costh0*X(1);
        
end

set(figure(1), 'Windowstyle', 'docked')
subplot(211)
plot(f, abs(theta)); %magnitude
grid
xlabel('f[Hz]');
ylabel('theta[rad]')

subplot(212)
plot(f, angle(theta)*180/pi); %phase
grid
xlabel('f[Hz]');
ylabel('Phase theta[rad]')

%% F1 -----------------------------------------------------------
f = 0:0.01:1;
i = sqrt(-1);
F0 = [0 1 0];
for j =   1 : length(f)
    
    ome = 2 * pi * f(j);
    A0 = -ome^2 *m  + k; 
    F = F0 * lambda_f; 
    
    X = (A0^(-1) * F); 
    
    theta(j) = X(1);
    y_a(j) = -Dt*sinth0 -Dt*costh0*X(1);
        
end

set(figure(2), 'Windowstyle', 'docked')
subplot(211)
plot(f, abs(theta)); %magnitude
grid
xlabel('f[Hz]');
ylabel('theta[rad]')

subplot(212)
plot(f, angle(theta)*180/pi); %phase
grid
xlabel('f[Hz]');
ylabel('Phase theta[rad]')


%% Cr -----------------------------------------------------------
f = 0:0.01:1;
i = sqrt(-1);
F0 = [0 0 1];
for j =   1 : length(f)
    
    ome = 2 * pi * f(j);
    A0 = -ome^2 *m  + k; 
    F = F0 * lambda_f; 
    
    X = (A0^(-1) * F); 
    
    theta(j) = X(1);
    y_a(j) = -Dt*sinth0 -Dt*costh0*X(1);
        
end

set(figure(3), 'Windowstyle', 'docked')
subplot(211)
plot(f, abs(theta)); %magnitude
grid
xlabel('f[Hz]');
ylabel('theta[rad]')

subplot(212)
plot(f, angle(theta)*180/pi); %phase
grid
xlabel('f[Hz]');
ylabel('Phase theta[rad]')

%% time history

ome = 0;
phi = 0;
F0 = 1;

% system with vertical Force F0

A = -ome^2*m + k;
Q0 = lambda_f(1,:)' * F0*(exp(i*phi));
Q1 = lambda_f(2,:)' * F0*(exp(i*phi));
Q_c = lambda_f(3,:)' * F0*(exp(i*phi));

sys0 = A\Q0;
sys1 = A\Q1;
sys_c = A\Q_c;

t = 0:0.01:5;

y_c_0 = lambda_m(4) * sys0;
y_c_0_time = abs(y_c_0) * cos(ome*t + angle(y_c_0));

y_c_1 = lambda_m(4) * sys1;
y_c_1_time = abs(y_c_1) * cos(ome*t + angle(y_c_1));

y_c_c = lambda_m(4) * sys_c;
y_c_c_time = abs(y_c_c) * cos(ome*t + angle(y_c_c));

set(figure(4), 'WindowStyle', 'docked');
plot(t, y_c_0_time);
grid;

set(figure(5), 'WindowStyle', 'docked');
plot(t, y_c_1_time);
grid;

set(figure(6), 'WindowStyle', 'docked');
plot(t, y_c_c_time);
grid;





