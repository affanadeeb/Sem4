% Define constellation points
constellation_points = [-3-3j, -3-1j, -3+1j, -3+3j, ...
                        -1-3j, -1-1j, -1+1j, -1+3j, ...
                         3-3j,  3-1j,  3+1j,  3+3j];

output = zeros(n, 1); % Decision rule

for i = 1:length(rx)
    % Calculate distances to each constellation point
    distances = abs(rx(i) - constellation_points);
    
    % Find the index of the nearest constellation point
    [~, idx] = min(distances);
    
    % Assign the nearest constellation point to the output
    output(i) = constellation_points(idx);
end

% Calculate the symbol error rate
symbol_error_rate = 1 - sum(all(output == symbols, 2)) / n;
error_rate = symbol_error_rate / 10;
disp(['Symbol Error Rate: ', num2str(symbol_error_rate)]);
disp(['Bit Error Rate: ', num2str(error_rate)]);

% Plot the decision statistics
scatter(real(rx), imag(rx), 'o');
hold on;
yline(2, 'r'); yline(-2, 'r'); yline(0, 'r');
xline(2, 'r'); xline(-2, 'r'); xline(0, 'r');
title('Decision statistics for 16QAM');
xlabel('Real part of the decision statistics');
ylabel('Imaginary part of the decision statistics');