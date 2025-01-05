function [rx,tx_out,symbols] = q4(sigma,n)
%---------------

m = 4;
a = 0.5;
%sigma = 0.4

%n = 12000;
Length = 10;
bits = randbit(n);
symbols = bpskmap(bits);

    % Transmit filter
    transmit_filter = raised_cosine(a, m, n);

    % Upsample symbols and apply transmit filter
    upsampled_nsymbols = 1 + (n - 1) * m;
    upsampled_symbols = zeros(1, upsampled_nsymbols);
    upsampled_symbols(1:m:upsampled_nsymbols) = symbols;
    tx = conv(upsampled_symbols, transmit_filter);

  tx_output = add_complex_gaussian_noise(tx, sigma);

    % Receive filter
    rx_output = conv(tx_output, transmit_filter);
    rx = rx_output(4 * [1:n] + upsampled_nsymbols);
    tx_out = tx_output(1:8:length(tx_output));
end

function rc = raised_cosine(a, m, n)
    rc = rcosdesign(a, n, m, 'sqrt');
end


function noisy_signal = add_complex_gaussian_noise(tx, sigma)
    noise_real = normrnd(0, sigma, size(tx));
    noise_imaginary = normrnd(0, sigma, size(tx));
    noise = noise_real + 1j * noise_imaginary;
    noisy_signal = tx + noise;
end


function output = custom_convolution(x, h)
    len_x = length(x);
    len_h = length(h);
    len_y = len_x + len_h - 1;
    output = zeros(1, len_y);
    for i = 1:len_y
        for j = 1:min(len_h, i)
            if i-j+1 > 0 && i-j+1 <= len_x
                output(i) = output(i) + x(i-j+1) * h(j);
            end
        end
    end
end