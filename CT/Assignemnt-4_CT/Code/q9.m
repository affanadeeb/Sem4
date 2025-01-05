variance = 1.25 / 4.279;
n = 12000;
a = 0.5;
m = 4;
sigma = sqrt(variance);

% -------------- Parameters --------------
m = 4;
a = 0.5;

n = 12000;
Length = 10;

% Generate random bits
bits = randbit(n);

% Map bits to symbols
symbols = fourpammap(reshape(bits, 2, length(bits)/2)');
n = n / 2;

% Plot transmitted symbols
% scatter(zeros(size(symbols)), symbols, 'o')
figure()

% -------------- Transmit Filter --------------
transmit_filter = rcosdesign(a, n, m, 'sqrt');

% Upsample symbols
nsymbols_upsampled = 1 + (n - 1) * m;
symbols_upsampled = zeros(1, nsymbols_upsampled);
symbols_upsampled(1:m:nsymbols_upsampled) = symbols;

% Convolve with transmit filter
tx = conv(symbols_upsampled, transmit_filter);

% Add noise
noise_real = normrnd(0, sigma, [size(tx)]);
noise_imag = normrnd(0, sigma, [size(tx)]);
nx = noise_real + 1j * noise_imag; % added noise at the input of receive filter
tx_output = tx + nx;

% -------------- Receive Filter --------------
rx_output = conv(tx_output, transmit_filter);
rx = rx_output(4 * [1:n] + nsymbols_upsampled);

% Plot decision statistics
scatter(real(rx), imag(rx), 'o')
hold on;
xline(0);
yline(0);
title('Decision Statistics for 4PAM');
xlabel('Real Part of the Decision Statistics');
ylabel('Imaginary Part of the Decision Statistics');
plot(ones(1, 5), [-2:2], 'r:')
plot(3 .* ones(1, 5), [-2:2], 'r:')
plot(-ones(1, 5), [-2:2], 'r:')
plot(-3 .* ones(1, 5), [-2:2], 'r:')

% Decision rule using quantization
% Define decision levels
decision_levels = [-3, -1, 1, 3];

% Reshape rx to be a column vector
rx_column = rx(:);

% Quantize the received symbols
[~, index] = min(abs(rx_column - decision_levels'), [], 2);
output = decision_levels(index);

% Calculate error
err = 1 - sum((output == symbols)) / n