clc;
clear all;

Eb_N0 = 4.4; 
% For BPSK Eb=1
variance = 1/(2*Eb_N0);
n = 12000;

[rx, ~, ~] = q4(sqrt(variance), n); % Assuming q4 function returns rx, t, and symbol, but only rx is used

op = rx(1:4:n);
scatter(real(op), imag(op), 10, 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r'); % Modify marker style and size
hold on;
yline(0, '--k'); % Add dashed black horizontal line at y=0
xline(0, '--k'); % Add dashed black vertical line at x=0
xline(-1, '--b'); % Add dashed blue vertical line at x=-1
xline(1, '--b'); % Add dashed blue vertical line at x=1

title('Decision Statistics');
xlabel('Real Part of the Decision Statistics');
ylabel('Imaginary Part of the Decision Statistics');
grid on; 
