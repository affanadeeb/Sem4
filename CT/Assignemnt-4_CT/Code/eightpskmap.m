function y = eightpskmap(x)
    % Converting binary bits to decimal values
    decimal_value = 4 * x(:,1) + 2 * x(:,2) + x(:,3);
    
    % Calculating phase angles
    phase_angles = 2 * pi * (0:7) / 8;
    y = exp(1j * phase_angles(decimal_value + 1));
end
