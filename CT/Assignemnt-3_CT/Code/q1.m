clc; clear all; close all;
t = 0:0.5*10^(-6):0.005;
mt = sin(2*pi*1000*t);
int_mt = cumtrapz(t, mt);
st = cos(2*pi*10000*t + 2*pi*5000*int_mt); 
Sf = fftshift(fft(st));
f = linspace(-1e6, 1e6, length(Sf)); 
subplot(311), plot(t, mt), grid, title('message m(t)');
subplot(312), plot(t, st), grid, title('FM s(t)');
subplot(313), plot(f, abs(Sf)), grid, title('|S(f)|');