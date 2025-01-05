clear; clc; close all;

%% Parameters
M = 8; % Number of frequencies (8-ary FSK)
Rb = 1000; % Bit rate (bits/s)
Tb = 1/Rb; % Bit duration
Fs = 10000; % Sampling frequency
ts = 1/Fs; % Sampling period

%% Frequency Separations
% (a) Bandwidth-optimal frequency separation
f_bw_opt = Rb/log2(M); % Bandwidth-optimal frequency separation

% (b) Probability of error-optimal frequency separation
f_pe_opt = sqrt(6*log(M)/pi^2)*Rb/(M-1); % Probability of error-optimal frequency separation

%% Modulator
% Frequency vectors for bandwidth-optimal and probability of error-optimal separations
f_bw = (0:M-1)*f_bw_opt; % Bandwidth-optimal frequencies
f_pe = (0:M-1)*f_pe_opt; % Probability of error-optimal frequencies

% Signal generation for bandwidth-optimal separation
t = 0:ts:Tb-ts;
x_bw = zeros(M, length(t));
for i = 1:M
    x_bw(i,:) = cos(2*pi*f_bw(i)*t);
end

% Signal generation for probability of error-optimal separation
x_pe = zeros(M, length(t));
for i = 1:M
    x_pe(i,:) = cos(2*pi*f_pe(i)*t);
end

%% Demodulator
% Correlation receiver for bandwidth-optimal separation
r_bw = zeros(M, length(t));
for i = 1:M
    r_bw(i,:) = x_bw(i,:).*cos(2*pi*f_bw(i)*t);
end

% Correlation receiver for probability of error-optimal separation
r_pe = zeros(M, length(t));
for i = 1:M
    r_pe(i,:) = x_pe(i,:).*cos(2*pi*f_pe(i)*t);
end

%% Probability of Error vs. Eb/N0
EbN0_dB = -5:20; % Eb/N0 range in dB
Pe_bw = zeros(size(EbN0_dB));
Pe_pe = zeros(size(EbN0_dB));

for i = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(i)/10);
    N0 = 1/(2*log2(M)*EbN0);
    
    % Bandwidth-optimal separation
    Pe_bw(i) = qfunc(sqrt(2*log2(M)*EbN0/(M-1)));
    
    % Probability of error-optimal separation
    Pe_pe(i) = qfunc(sqrt(6*log2(M)*EbN0/((M-1)*pi^2)));
end

%% Plot Pe vs. Eb/N0
figure;
semilogy(EbN0_dB, Pe_bw, 'b-', 'LineWidth', 2);
hold on;
semilogy(EbN0_dB, Pe_pe, 'r-', 'LineWidth', 2);
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Probability of Error (Pe)');
title('Probability of Error vs. Eb/N0 for 8-ary FSK');
legend('Bandwidth-optimal', 'Probability of error-optimal', 'Location', 'SouthEast');

%% Plot Spectrum
figure;
subplot(2,1,1);
plot_spectrum(x_bw, Fs, 'Bandwidth-optimal Spectrum');
subplot(2,1,2);
plot_spectrum(x_pe, Fs, 'Probability of Error-optimal Spectrum');

%% Function to plot spectrum
function plot_spectrum(x, Fs, title_str)
    N = size(x, 2);
    nfft = 2^nextpow2(N);
    X = fft(x, nfft, 2);
    X_mag = abs(X(:, 1:nfft/2+1));
    f = Fs/2*linspace(0, 1, nfft/2+1);
    plot(f, 2*X_mag/N);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title(title_str);
    grid on;
end