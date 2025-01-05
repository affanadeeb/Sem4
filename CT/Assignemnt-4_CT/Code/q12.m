clc;
clear all;
num_bits = 120000;
num_symbols = 6000;

% Generate random binary data
bits1 = randi([0, 1], 1, num_bits);
bits2 = randi([0, 1], 1, num_bits);

% Map bits to 4PAM symbols
symbols1 = fourpammap(bits1);
symbols2 = fourpammap(bits2);

% Calculate the average symbol energy
Es = mean(abs(symbols1).^2);

% Define the range of Eb/N0 in dB
EbN0_dB = 0:0.1:12;

% Convert Eb/N0 from dB to linear scale
EbN0_linear = 10.^(EbN0_dB/10);
y = sqrt(2);

% Calculate the Bit Error Rate (BER) using the provided equation
Pb_approx = 0.5 * erfc(exp(1) * EbN0_linear / (5 * y));

% Plot the bit error probability curve
figure;
semilogy(EbN0_dB, Pb_approx);
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Probability (Pb)');
title('4PAM: Approximate Bit Error Probability vs Eb/N0');
grid on;

figure;
semilogy(EbN0_dB, Pb_approx); hold on

% Calculate the intersection point for a bit error probability of 10^-2
intersection_EbN0 = 10*log10(5*0.01*erfcinv(2*0.01)/exp(1));
xline(intersection_EbN0,'r:', 'LineWidth', 1.5);
yline(0.01,'r:', 'LineWidth', 1.5); % For intersection of x and y

ylabel('Bit Error Probability (Pb)');
xlabel('Eb/N0 (dB)');
title('BPSK: Bit Error Probability vs Eb/N0');
legend('Approximate BER', 'Intersection for Pb = 10^{-2}');
grid on;

% Set x-axis limit to the range from 0 to 12 dB
xlim([0 12]);



% Find Eb/N0 for a bit error probability of 10^-2
Pb_target = 1e-2;
EbN0_value = interp1(Pb_approx, EbN0_dB, Pb_target);

disp(['Eb/N0 for Pb = 1e-2: ', num2str(EbN0_value), ' dB']);
