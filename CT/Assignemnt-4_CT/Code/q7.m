clc;
clear all;
variance = 1/(2*2.7);
num_bits = 12000;

m = 4;
alpha = 0.5;
sigma = sqrt(variance);

% Generate random bits
bits = randbit(num_bits);
% Map bits to symbols using BPSK modulation
symbols = bpskmap(bits);

% Transmit filter design
transmit_filter = rcosdesign(alpha, num_bits, m, 'sqrt');

% Upsampling
num_symbols_upsampled = 1 + (num_bits - 1) * m;
symbols_upsampled = zeros(1, num_symbols_upsampled);
symbols_upsampled(1:m:num_symbols_upsampled) = symbols;

% Convolution with transmit filter
tx_signal = conv(symbols_upsampled, transmit_filter);

% Add noise
noise_real = normrnd(0, sigma, [size(tx_signal)]);
noise_imag = normrnd(0, sigma, [size(tx_signal)]);
noisy_signal = tx_signal + noise_real + 1j * noise_imag;

% Receive filter
rx_signal = conv(noisy_signal, transmit_filter);
rx_signal_downsampled = rx_signal(4 * [1:num_bits] + num_symbols_upsampled);
tx_signal_downsampled = tx_signal(4 * [1:num_bits] + num_symbols_upsampled);

% Decision rule
output_tx = zeros(num_bits, 1);
output_rx = zeros(num_bits, 1);
for i = 1:length(tx_signal_downsampled)
    if real(tx_signal_downsampled(i)) >= 0
        output_tx(i) = 1;
    else
        output_tx(i) = -1;
    end
end

for i = 1:length(rx_signal_downsampled)
    if real(rx_signal_downsampled(i)) > 0
        output_rx(i) = 1;
    else
        output_rx(i) = -1;
    end
end

% Error calculation
error_tx = sum(abs(output_tx - symbols')) / (2 * num_bits);
error_rx = sum(abs(output_rx - symbols')) / (2 * num_bits);

error_tx, error_rx
