clc;
clear all;

n = input('Enter the number of systems (n): ');

m = zeros(1, n);
b = zeros(1, n);
L = zeros(1, n);

y = zeros(n, 2);

for l = 1:n
    helper = sprintf('Enter the mass %d value: ', l);
    m(l) = input(helper);
    
    helper = sprintf('Enter damping coefficient %d value: ', l);
    b(l) = input(helper);
    
    helper = sprintf('Enter length %d value: ', l);
    L(l) = input(helper);
end

tspan = [0 30];

f = @(t) 0;

for l = 1:n
    theta0 = input(['Enter initial theta position for system ', num2str(l), ': ']);
    omega0 = input(['Enter initial omega velocity for system ', num2str(l), ': ']);

    odeSystem = @(t, y) [y(2); -(b(l)/m(l)) * y(2) - (9.81/L(l)) * sin(y(1))];
    
    [t_system, sol] = ode45(odeSystem, tspan, [theta0, omega0]);
    
    disp(['Results for system ', num2str(l), ':']);
    
    disp(['Final Theta Position: ', num2str(sol(end, 1))]);
    disp(['Final Omega Velocity: ', num2str(sol(end, 2))]);
    
    figure;
    subplot(2, 1, 1);
    plot(t_system, sol(:, 1), 'LineWidth', 2);
    title(['System ', num2str(l), ' - Theta Position Response']);
    xlabel('Time (s)');
    ylabel('Theta Position');
    grid on;
    
    annotation('textbox', [0.7, 0.8, 0.1, 0.1], 'String', ['m = ', num2str(m(l))]);
    annotation('textbox', [0.7, 0.75, 0.1, 0.1], 'String', ['b = ', num2str(b(l))]);
    annotation('textbox', [0.7, 0.7, 0.1, 0.1], 'String', ['L = ', num2str(L(l))]);

    subplot(2, 1, 2);
    plot(t_system, sol(:, 2), 'LineWidth', 2);
    title(['System ', num2str(l), ' - Omega Velocity Response']);
    xlabel('Time (s)');
    ylabel('Omega Velocity');
    grid on;
end
