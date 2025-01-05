clc;
clear all;

n = input('Enter the number of systems (n): ');

m = zeros(1, n);
c = zeros(1, n);
k = zeros(1, n);

y = zeros(n, 2);

for l = 1:n
    helper = sprintf('Enter the mass %d value: ', l);
    m(l) = input(helper);
    
    helper = sprintf('Enter damping coefficient %d value: ', l);
    c(l) = input(helper);
    
    helper = sprintf('Enter spring constant %d value: ', l);
    k(l) = input(helper);
end

tspan = [0 30];

%f = @(t) 0;
f = @(t) sin(t);


for l = 1:n
    x0 = input(['Enter initial x position for system ', num2str(l), ': ']);
    v0 = input(['Enter initial y velocity for system ', num2str(l), ': ']);

    odeSystem = @(t, y) [y(2); (1/m(l)) * (f(t) - c(l)*y(2) - k(l)*y(1))];
    
    [t_system, sol] = ode45(odeSystem, tspan, [x0, v0]);
    
    disp(['Results for system ', num2str(l), ':']);
    
    disp(['Final Position: ', num2str(sol(end, 1))]);
    disp(['Final Velocity: ', num2str(sol(end, 2))]);
    
    figure;
    subplot(2, 1, 1);
    plot(t_system, sol(:, 1), 'LineWidth', 2);
    title(['System ', num2str(l), ' - Position Response']);
    xlabel('Time (s)');
    ylabel('Position');
    grid on;
    
    annotation('textbox', [0.7, 0.8, 0.1, 0.1], 'String', ['m = ', num2str(m(l))]);
    annotation('textbox', [0.7, 0.75, 0.1, 0.1], 'String', ['c = ', num2str(c(l))]);
    annotation('textbox', [0.7, 0.7, 0.1, 0.1], 'String', ['k = ', num2str(k(l))]);

    subplot(2, 1, 2);
    plot(t_system, sol(:, 2), 'LineWidth', 2);
    title(['System ', num2str(l), ' - Velocity Response']);
    xlabel('Time (s)');
    ylabel('Velocity');
    grid on;
end
