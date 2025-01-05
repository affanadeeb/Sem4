clc;
clear all;
EbN0_dB = 0:0.1:30;

% Converting Eb/N0 from dB to linear scale
EbN0_linear = 10.^(EbN0_dB/10);

% Calculating ideal bit error probability for BPSK
Prob = 0.5*erfc(sqrt(EbN0_linear));

figure;
semilogy(EbN0_dB, Prob);
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Probability (Pb)');
title('BPSK: Bit Error Probability vs Eb/N0');
grid on;

% Find Eb/N0 for error probabilities of 10^-2 and 10^-5
Pb_target = [1e-2, 1e-5];
EbN0_values = zeros(size(Pb_target));

for i = 1:length(Pb_target)
    idx = find(Prob <= Pb_target(i), 1);
    EbN0_values(i) = EbN0_dB(idx);
end

disp(['Eb/N0 for Pb = 1e-2: ', num2str(EbN0_values(1)), ' dB']);
disp(['Eb/N0 for Pb = 1e-5: ', num2str(EbN0_values(2)), ' dB']);

% Plot the bit error probability curve
figure;
semilogy(EbN0_dB, Prob);
grid on;
hold on;

% Calculate the SNR corresponding to a bit error probability of 10^-2
SNR_target = 10*log10((erfcinv(2*0.01))^2);

% Plot the SNR corresponding to Pb = 10^-2
xline(SNR_target,'r');
yline(0.01,'r');
text(SNR_target, 0.01, sprintf('(%.2f dB)', SNR_target), 'VerticalAlignment', 'bottom');

xlabel('Eb/N0 (dB)');
ylabel('Bit Error Probability (Pb)');
title('BPSK: Bit Error Probability vs Eb/N0');
legend('Bit Error Probability', 'SNR for Pb = 10^{-2}');
