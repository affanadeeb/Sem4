function y = fourpammap(x)
    % Converting binary bits to decimal values
    decimal_values = 2 * x(:,1) + x(:,2);
    
    % Defining 4-PAM symbols with Gray labeling
    pam_symbols = [-3, -1, 1, 3];
    
    % Now mapping :
    y = pam_symbols(decimal_values + 1);
end
