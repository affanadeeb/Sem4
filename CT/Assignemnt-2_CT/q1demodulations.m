clc;
clear all;

t = -0.1:1/2000000:0.1;

rect = (t > -1 & t < 1); 

tri = @(t) (1 - abs(t)).*(t < 1 & t > -1); 

m = tri((t/0.01) + 1) - tri((t/0.01) - 1);

fc = 1000000; 

c = cos(2*pi*fc*t+pi/3);

%c = cos(2*pi*(fc+5)*t);

%c = cos(2*pi*(fc+5)*t+(pi/3));

s = multip_modulator(m, c);

demodulated_signal=s.*c;
f_m = fft(m,length(m));
f_s = fft(s,length(s));
f_demodulated = fft(demodulated_signal,length(demodulated_signal));

figure;
subplot(3,1,1);
plot((0 : 2*pi/length(f_m) : 2*pi - 1/length(f_m)),angle(f_m));
xlabel('w');
ylabel('M(w)');
title('Phase of Given Message signal');

subplot(3,1,2);
plot((0 : 2*pi/length(f_m) : 2*pi - 1/length(f_m)),angle(f_s));
xlabel('w');
ylabel('S(w)');
title('Phase of Multiplier Modulated Signal');

subplot(3,1,3);
plot((0 : 2*pi/length(f_m) : 2*pi - 1/length(f_m)),angle(f_demodulated));
xlabel('t');
ylabel('s(t)');
title('Phase of Multiplier de-Modulated Signal');


figure;
subplot(3,1,1);
plot((0 : 2*pi/length(f_m) : 2*pi - 1/length(f_m)),abs(f_m));
xlabel('w');
ylabel('M(w)');
title('Amp of Given Message signal');

subplot(3,1,2);
plot((0 : 2*pi/length(f_m) : 2*pi - 1/length(f_m)),abs(f_s));
xlabel('w');
ylabel('S(w)');
title('Amp of Multiplier Modulated Signal');

subplot(3,1,3);
plot((0 : 2*pi/length(f_m) : 2*pi - 1/length(f_m)),abs(f_demodulated));
xlabel('w');
ylabel('s(w)');
title('Amp of Multiplier de-Modulated Signal');


function s = multip_modulator(m, c)
    s = m .* c;
end

