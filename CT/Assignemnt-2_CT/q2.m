clc;
clear all;

t = -0.1:1/2000000:0.1;

rect = (t > -1 & t < 1); 

tri = @(t) (1 - abs(t)).*(t < 1 & t > -1); 

m = tri((t/0.01) + 1) - tri((t/0.01) - 1);

fc = 1000000; 

c = cos(2*pi*fc*t);
s = DSB_FC_modulator(m, c);

demodulated_signal=DSB_FC_modulator(m, c);

for m=1:length(demodulated_signal)
    if demodulated_signal(m)<0
        demodulated_signal(m)=0;
    end
end

fs=2*fc; 

filtered_signal = lowpass(demodulated_signal, 1, fs);


figure;

subplot(3,1,1);
plot(t, s, 'b');
xlabel('t');
ylabel('s(t)');
title('Modulated Signal');

subplot(3,1,2);
plot(t, demodulated_signal, 'b');
xlabel('t');
ylabel('s(t)');
title('de-modulated Signal without blocking dc');

subplot(3,1,3);
plot(t, demodulated_signal-1, 'b');
xlabel('t');
ylabel('s(t)');
title('de-modulated Signal with blocking dc');

function s = DSB_FC_modulator(m, c)
    s = (1+m).*c;
end
