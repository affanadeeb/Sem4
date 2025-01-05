clc;
clear all;

t = -0.1:1/2000000:0.1;

rect = (t > -1 & t < 1); 

tri = @(t) (1 - abs(t)).*(t < 1 & t > -1); 

m = tri((t/0.01) + 1) - tri((t/0.01) - 1);

fc = 1000000; 

fs = 2*fc;

c = cos(2*pi*fc*t);

s = multip_modulator(m, c);

z = nonlinear_modulator(m, c);

bw = 0.5;
filtered_signal = bandpass(z, [fc-bw fc+bw], fs);

sqr=sign(sin(2*pi*t*fc));

s3 = switching_modulator(m, sqr);

disp('fc:');
disp(fc);
disp('fs:');
disp(fs);


%sqr_filtered_signal = lowpass(s3, 2*fs, fs);

%%%%demodulation :
demodulated_signal=s3.*sqr;

figure;
subplot(2,1,1);
plot(t, m, 'b');
xlabel('t');
ylabel('m(t)');
title('original message signal');

subplot(2,1,2);
plot(t, demodulated_signal, 'b');
xlabel('t');
ylabel('m(t)');
title('demodulated signal');




figure;
subplot(2,1,1);
plot(t, sqr, 'b');
xlabel('t');
ylabel('sqr(t)');
title('Square pulse');

subplot(2,1,2);
plot(t, s3, 'b');
xlabel('t');
ylabel('s3(t)');
title('Switching Modulated Signal');

figure;
subplot(2,1,1);
plot(t, m, 'b');
xlabel('t');
ylabel('m(t)');
title('Given Message signal');

subplot(2,1,2);
plot(t, filtered_signal, 'b');
xlabel('t');
ylabel('s(t)');
title('Incoherent Modulated Signal');

figure;
subplot(2,1,1);
plot(t, m, 'b');
xlabel('t');
ylabel('m(t)');
title('Given Message signal');

subplot(2,1,2);
plot(t, s, 'b');
xlabel('t');
ylabel('s(t)');
title('Multiplier Modulated Signal');

figure;
subplot(2,2,1);
plot(t, m, 'b');
xlabel('t');
ylabel('m(t)');
title('Given Message signal');

subplot(2,2,2);
plot(t, s, 'b');
xlabel('t');
ylabel('s(t)');
title('Multiplier Modulated Signal');

subplot(2,2,3);
plot(t, filtered_signal, 'b');
xlabel('t');
ylabel('s(t)');
title('Incoherent Modulated Signal');

subplot(2,2,4);
plot(t, s3, 'b');
xlabel('t');
ylabel('s3(t)');
title('Switching Modulated Signal');


function s = multip_modulator(m, c)
    s = m .* c;
end

function z = nonlinear_modulator(m, c)
    a = 2;
    b = 1;
    %b=0.25;
    x1 = m + c;
    x2 = c - m;
    y1 = a * x1 + b * x1.^2;
    y2 = a * x2 + b * x2.^2;
    z = y1 - y2;
end

function s3=switching_modulator(m, sqr)
    s3=m.*sqr;
end
