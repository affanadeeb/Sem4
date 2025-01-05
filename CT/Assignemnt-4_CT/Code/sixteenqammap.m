%clc;
%clear all;
%  input signal x
%x = [0 0 0 0;   % Example symbol 1
     %0 0 0 1;   % Example symbol 2
     %0 0 1 0;   % Example symbol 3
     %0 0 1 1;   % Example symbol 4
     %0 1 0 0;   % Example symbol 5
     %0 1 0 1;   % Example symbol 6
    % 0 1 1 0;   % Example symbol 7
   %  0 1 1 1;   % Example symbol 8
  %   1 0 0 0;   % Example symbol 9
 %    1 0 0 1];  % Example symbol 10

% Call the function to map the input symbols to 16-QAM constellation points
%y = sixteenqammap(x);

% Display the result
%disp('Mapped symbols:')
%disp(y);


function y = sixteenqammap(x)
    % Extracting the first two bits for the real part and the next two bits for the imaginary part
    real_bits = x(:,[1:2]);
    imag_bits = x(:,[3:4]);
    
    % Map the real and imaginary parts separately using fourpammap
    real_part = fourpammap(real_bits);
    imag_part = fourpammap(imag_bits);
    
    % Combine the real and imaginary parts to form the complex symbols
    y = real_part + 1j * imag_part;
end
