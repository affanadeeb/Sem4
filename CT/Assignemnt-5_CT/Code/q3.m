clc;
clear all;

fprintf('For oversampling factor, do not enter values greater than 10 as it may cause out-of-memory errors.\n');
fprintf('I am getting accurate plots for oversampling factor = 8 and For delay_for_raised_cosine = 3\n');
fprintf('But we can also plot for different values; however,\n');
fprintf('avoid entering values greater than 10 due to potential out-of-memory errors.\n');

fprintf('Enter oversampling factor (e.g., 8):');
oversampling_factor = input('');

fprintf('You entered oversampling factor: %d\n', oversampling_factor);

fprintf('Enter delay for raised cosine (e.g., 3): ');
delay_for_raised_cosine = input('');

fprintf('You entered delay for raised cosine: %d\n', delay_for_raised_cosine);

num_symbols = 1000000;
% Generate pulse shapes with the input parameters
[raised_cosine_pulse, matched_raised_cosine_pulse] = generate_raised_cosine_pulse(oversampling_factor, delay_for_raised_cosine);
[rectangular_pulse, matched_rectangular_pulse] = generate_rectangular_pulse(oversampling_factor);

fprintf('This may take a while to get the output plots...\n');

signal_data = generate_random_signal_data(num_symbols);

% Generate upsampled signal
upsampled_signal = upsample(signal_data, oversampling_factor);

% Generate polar signaling with different pulse shaping
signal_with_raised_cosine_pulse = generate_polar_signaling(upsampled_signal, raised_cosine_pulse);
signal_with_rectangular_pulse = generate_polar_signaling(upsampled_signal, rectangular_pulse);

% Plotting
plot_polar_signaling(signal_with_raised_cosine_pulse, signal_with_rectangular_pulse, oversampling_factor, delay_for_raised_cosine);

% Find bit error rate
[bit_error_rate, Eb_N0_dB, theoretical_BER] = calculate_bit_error_rate(signal_data, num_symbols, signal_with_raised_cosine_pulse, signal_with_rectangular_pulse, matched_raised_cosine_pulse, matched_rectangular_pulse, oversampling_factor, delay_for_raised_cosine);

% Plotting BER
plot_bit_error_rate(bit_error_rate, Eb_N0_dB, theoretical_BER);

function [raised_cosine_pulse, matched_raised_cosine_pulse] = generate_raised_cosine_pulse(oversampling_factor, delay_for_raised_cosine)
    % Generate raised cosine pulse

    [raised_cosine_pulse, ~] = rcosflt([1], 1, oversampling_factor, 'sqrt', 0.5, delay_for_raised_cosine);
    
    % Normalizing the pulse
    raised_cosine_pulse = raised_cosine_pulse / norm(raised_cosine_pulse);
    matched_raised_cosine_pulse = fliplr(raised_cosine_pulse);
end


function [rectangular_pulse, matched_rectangular_pulse] = generate_rectangular_pulse(oversampling_factor)
    rectangular_pulse = ones(1, oversampling_factor);
    rectangular_pulse = rectangular_pulse / norm(rectangular_pulse);
    matched_rectangular_pulse = fliplr(rectangular_pulse);
end

function signal_data = generate_random_signal_data(num_symbols)
    signal_data = 2 * randi([0, 1], num_symbols, 1) - 1;

end

function polar_signaling = generate_polar_signaling(upsampled_signal, pulse_shape)
    polar_signaling = custom_convolution(upsampled_signal, pulse_shape);
end

function plot_polar_signaling(signal_with_raised_cosine_pulse, signal_with_rectangular_pulse, oversampling_factor, delay_for_raised_cosine)
    delay_for_raised_cosine_filter = 2 * delay_for_raised_cosine * oversampling_factor;
    delay_for_rectangular_filter = oversampling_factor - 1;

    time_vector = (1:200) / oversampling_factor;

    figure;
    subplot(2, 1, 1);
    plot(time_vector, signal_with_raised_cosine_pulse(delay_for_raised_cosine_filter / 2:delay_for_raised_cosine_filter / 2 + 199), 'LineWidth', 2);
    title('(a) Root-raised cosine pulse.', 'FontSize', 14);
    xlabel('Time', 'FontSize', 12);
    ylabel('Amplitude', 'FontSize', 12);
    grid on;

    subplot(2, 1, 2);
    plot(time_vector, signal_with_rectangular_pulse(delay_for_rectangular_filter:delay_for_rectangular_filter + 199), 'LineWidth', 2);
    title('(b) Rectangular pulse.', 'FontSize', 14);
    xlabel('Time', 'FontSize', 12);
    ylabel('Amplitude', 'FontSize', 12);
    grid on;
end

function [bit_error_rate, Eb_N0_dB, theoretical_BER] = calculate_bit_error_rate(signal_data, num_symbols, signal_with_raised_cosine_pulse, signal_with_rectangular_pulse, matched_raised_cosine_pulse, matched_rectangular_pulse, oversampling_factor, delay_for_raised_cosine)
    length_raised_cosine_signal = length(signal_with_raised_cosine_pulse);
    length_rectangular_signal = length(signal_with_rectangular_pulse);

    noise_sequence = randn(length_raised_cosine_signal, 1);
    bit_error_rate = zeros(10, 2);  
    theoretical_BER = zeros(1, 10);  

    snr_db = 1; % Initial SNR value
    while true
        Eb_N0_dB(snr_db) = snr_db;
        Eb_N0_numeric = 10^(Eb_N0_dB(snr_db) / 10);
        noise_variance = 1 / (2 * Eb_N0_numeric);
        noise_std_dev = sqrt(noise_variance);
        awgn_noise = noise_std_dev * noise_sequence;

        received_signal_raised_cosine = signal_with_raised_cosine_pulse + awgn_noise;
        received_signal_rectangular = signal_with_rectangular_pulse + awgn_noise(1:length_rectangular_signal);

        filtered_signal_raised_cosine = custom_convolution(received_signal_raised_cosine, matched_raised_cosine_pulse);
        filtered_signal_rectangular = custom_convolution(received_signal_rectangular, matched_rectangular_pulse);

        delay_for_raised_cosine_filter = 2 * delay_for_raised_cosine * oversampling_factor;
        delay_for_rectangular_filter = oversampling_factor - 1;

        sampled_signal_raised_cosine = filtered_signal_raised_cosine(delay_for_raised_cosine_filter+1:oversampling_factor:end);
        sampled_signal_rectangular = filtered_signal_rectangular(delay_for_rectangular_filter+1:oversampling_factor:end);

decoded_signal_raised_cosine = 2 * (sampled_signal_raised_cosine(1:num_symbols) >= 0) - 1;
decoded_signal_rectangular = 2 * (sampled_signal_rectangular(1:num_symbols) >= 0) - 1;

        % Calculate bit error rate
        bit_error_rate(snr_db, 1) = sum(abs(signal_data - decoded_signal_raised_cosine)) / (2 * num_symbols);
        bit_error_rate(snr_db, 2) = sum(abs(signal_data - decoded_signal_rectangular)) / (2 * num_symbols);
        
        % Calculate theoretical BER
        theoretical_BER(snr_db) = 0.5 * erfc(sqrt(Eb_N0_numeric));

        if snr_db == 10
            break; 
        end
        
        snr_db = snr_db + 1;
    end
end

function plot_bit_error_rate(bit_error_rate, Eb_N0_dB, theoretical_BER)
    figure;
    semilogy(Eb_N0_dB, theoretical_BER, 'k-', 'LineWidth', 2);
    hold on;
    semilogy(Eb_N0_dB, bit_error_rate(:, 1), 'b-*', 'LineWidth', 2);
    semilogy(Eb_N0_dB, bit_error_rate(:, 2), 'r-o', 'LineWidth', 2);
    hold off;
    legend('Theoretical', 'Root-raised cosine', 'Rectangular', 'Location', 'northeast', 'FontSize', 12);
    xlabel('E_b/N_0 (dB)', 'FontSize', 14);
    ylabel('BER', 'FontSize', 14);
    title('Bit Error Rate Performance', 'FontSize',16);
    set(gca, 'YScale', 'log');
end

function result = custom_convolution(signal, kernel)
    signal_length = length(signal);
    kernel_length = length(kernel);
    result_length = signal_length + kernel_length - 1;
    result = zeros(result_length, 1);

    for n = 1:result_length
        k_min = max(1, n - signal_length + 1);
        k_max = min(kernel_length, n);
        for k = k_min:k_max
            result(n) = result(n) + signal(n - k + 1) * kernel(k);
        end
    end
end


