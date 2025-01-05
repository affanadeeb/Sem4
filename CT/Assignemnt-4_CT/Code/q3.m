clc;
clear all;
bits_seq = randbit(12000);
symbols = bpskmap(bits_seq);

m = 4; % taken from textbook
a = 0.5;
Length = 10;

% Transmit Filter
transmit_filter = raisedcosine(a, m, Length);

upsampled_symbols = upsample_symbols(bits_seq, m,symbols);

tx_output = custom_convolution(upsampled_symbols, transmit_filter);

% Receive Filter
rx_output = custom_convolution(tx_output, transmit_filter) / m;
rx_symbols = downsample(rx_output, m);


figure;

subplot(3,1,1);
plot(transmit_filter);
title('Transmit Filter');
xlabel('Samples');
ylabel('Amplitude');

subplot(3,1,2);
plot(tx_output);
title('Transmitted Signal');
xlabel('Samples');
ylabel('Amplitude');

subplot(3,1,3);
plot(rx_output);
title('Received Signal after Matched Filtering');
xlabel('Samples');
ylabel('Amplitude');

figure;
plot(tx_output);
title('Transmitted Signal');
xlabel('Samples');
ylabel('Amplitude');


% Print Information
fprintf('Number of transmitted bits: %d\n', length(bits_seq));
%fprintf('Number of received symbols: %d\n', length(rx_symbols));


function rc = raisedcosine(a,m,n)
rc = rcosdesign(a,n,m,'sqrt');
end

% Upsample Symbols Function
function upsampled_symbols = upsample_symbols(bits_seq, m,symbols)
    upsampled_nsymbols = 1 + (length(bits_seq) - 1) * m;
    upsampled_symbols = zeros(1, upsampled_nsymbols);
    upsampled_symbols(1:m:upsampled_nsymbols) = symbols;
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
