clc;
clear all;
f = 25;Fs = 400;
t = 0:1/Fs:1-1/Fs;
x = zeros(1, length(t));
for k = 1 : length(x)
    x(k) = 8 * cos(2 * pi * f * t(k));
end
number_of_bits = [2, 6];
V_range = 7;

for i = 1:length(number_of_bits)
    N = 2^number_of_bits(i);
    q_levels = linspace(-V_range, V_range, N);
    q_step = (2 * V_range) / N;
    
    % Quantize the signal
    xq{i} = quantize_signal(x, q_levels);
    
    % Plot original signal
    subplot(length(number_of_bits), 3, (i-1)*3 + 1);
    plot(t, x, 'b','Color','r');
    title('Original Speech Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Plot quantized signal
    subplot(length(number_of_bits), 3, (i-1)*3 + 2);
    plot(t, xq{i}, 'r');
    title(sprintf('Quantized Speech ( %d bits)', number_of_bits(i)));
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Plot quantization error
    subplot(length(number_of_bits), 3, (i-1)*3 + 3);
    quant_error = x - xq{i};
    plot(t, quant_error, 'g');
    title(sprintf('Quantization Error ( %d bits)', number_of_bits(i)));
    xlabel('Time (s)');
    ylabel('Amplitude');
end

% Calculate SNR
SNR = zeros(1, length(number_of_bits));
for k = 1:length(number_of_bits)
    SNR(k) = 10 * log10(var(x) / var(x - xq{k}));
end

disp('SNR for 2-bit quantization:');disp(SNR(1));
disp('SNR for 6-bit quantization:');disp(SNR(2));

% d part: Display conclusion
disp('Conclusion:');
if SNR(1) > SNR(2)
    disp('The Signal-to-Noise Ratio (SNR) is higher with 2-bit quantization than with 6-bit quantization.');
elseif SNR(1) < SNR(2)
    disp('The Signal-to-Noise Ratio (SNR) is higher with 6-bit quantization than with 2-bit quantization.');
else
    disp('The Signal-to-Noise Ratio (SNR) is the same for both 2-bit and 6-bit quantization.');
end



function xq = quantize_signal(x, q_levels)
    xq = zeros(1,length(x));
    for i = 1:length(xq)
        [~, index] = min(abs(x(i) - q_levels));
        xq(i) = q_levels(index);
    end
end
