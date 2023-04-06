clear all 
clc
close all

acqTime = 0.002;
pauseTIME = 10; % 10s di pausa alla fine di ogni segnale
A = 10;

w = [0.1, 0.3, 0.6, 1, 1.1, 1.3, 1.5, 2, 3, 6, 10, 30, 100];

pause = 0;
signal = 0;
t = 0;
pausetime = 0;

for i= 1:length(w)
    
    if i < 3
        numPer = 3;
    else
        numPer = 5;
    end
   
    timeSin = 0:acqTime:(numPer*2*pi/w(i));
    sinSweep = A * sin(w(i).*timeSin);
    timeSin = timeSin + pausetime(end);
    
    pausetime = 0:acqTime:pauseTIME;   
    pausetime = pausetime + timeSin(end); 
    pause = 0.*pausetime;
    
    t = [t, timeSin, pausetime];
    signal = [signal, sinSweep , pause];
    
end

set(figure(), 'WindowStyle', 'docked')
plot(t, signal);

t(end)

