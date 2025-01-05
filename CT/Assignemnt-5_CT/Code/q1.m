clc;
clear all;

num_samples = 100;
sigma_values = [0.1, 0.3, 0.5];
E = 1; 

count = 0;
for i = 1:length(sigma_values)
    count = count + 1;
    if count == 4
        break;
    end

    sigma = sigma_values(count);
    n0 = randn(num_samples, 1) * sqrt(sigma^2);
    n1 = randn(num_samples, 1) * sqrt(sigma^2);

    r0 = n0 + sqrt(E);
    r1 = n1;
    
    figure;
    plot(r0, r1, 'o', 'DisplayName', 'With Noise');
    hold on;
    r0 = n0;
    r1 = n1 + sqrt(E);

    plot(n0, n1 + 1, '*', 'DisplayName', 'Without Noise');
    set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin');
    if count==1
        xticks(-2.6:0.2:2.6);
        yticks(-2.6:0.2:2.6);

    else
        xticks(-2.5:0.5:2.5);
        yticks(-2.5:0.5:2.5);
    end


    hold on;
    plot([0, 0], ylim, 'k--');
    plot(xlim, [0, 0], 'k--');
    title(['Analyzing the Impact of Noise on Binary Communication Systems (\sigma = ', num2str(sigma), ')']);
    xlabel('r0', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('r1', 'FontSize', 12, 'FontWeight', 'bold');
    legend('Without Noise', 'With Noise');

    ax = gca;
    ax.FontSize = 10;
    ax.FontWeight = 'bold';
end
