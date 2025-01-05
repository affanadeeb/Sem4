variance=1/(6*2.614);
sigma =  sqrt(variance);

%------------------
m = 4;
a = 0.5;
n = 12000;
Length = 10;
bits = randbit(n);
symbols =  eightpskmap(reshape(bits,3,length(bits)/3)');
n=n/3;
%scatter(zeros(size(symbols)),symbols,'o')
figure()
%--------------transmit filter
transmit_filter = rcosdesign(a,n,m,'sqrt');
nsymbols_upsampled = 1 +  (n-1)*m; % upsampling
symbols_upsampled = zeros(1,nsymbols_upsampled);
symbols_upsampled(1:m:nsymbols_upsampled) = symbols;
tx= conv(symbols_upsampled,transmit_filter) ;
noise_real = normrnd(0,sigma,[size(tx)]);
noise_imag = normrnd(0,sigma,[size(tx)]);
nx = noise_real + 1j * noise_imag; % added noise at the inputof recieve filter
tx_output = tx + nx;
%--------------receive filter
rx_output = conv(tx_output, transmit_filter);
rx = rx_output(4*[1:n]+nsymbols_upsampled);
scatter (real(rx),imag(rx),'o')
title('decision statistics for 8PSK');
xlabel('real part of the decision statistics');
ylabel('Imaginary part of the decision statistics');


array=zeros(n,1); %decision rule

for i=1:length(rx) 
        if(angle(rx(i)) >= 7*pi/8) 
            array(i)= exp(1j*4*pi/4);
        elseif (angle(rx(i)) >= 5*pi/8) 
            array(i)= exp(1j*3*pi/4);
        elseif (angle(rx(i)) >= 3*pi/8) 
            array(i)= exp(1j*2*pi/4);
        elseif (angle(rx(i)) >= 1*pi/8) 
            array(i)= exp(1j*1*pi/4);
        elseif (angle(rx(i)) >= -1*pi/8) 
            array(i)= exp(1j*0*pi/4);
        elseif (angle(rx(i)) >= -3*pi/8) 
            array(i)= exp(1j*7*pi/4);
        elseif (angle(rx(i)) >= -5*pi/8) 
            array(i)= exp(1j*6*pi/4);
        elseif (angle(rx(i)) >= -7*pi/8)
            array(i)= exp(1j*5*pi/4);
        else
            array(i)= exp(1j*4*pi/4);
        end 
    end
y =   nnz(array - symbols)/n;
err = y