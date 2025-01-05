
function y = qpskmap(x)
    % Converting binary bits to decimal values
    decimal_values = 2 * x(:,1) + x(:,2);
    
    % Gray labeling
    qpsk_symbols = [-1-1j, -1+1j, 1+1j, 1-1j];
    
    % Now mapping :
    y = qpsk_symbols(decimal_values + 1);
end
