variance=1/(2*2.7);
n=12000;

m = 4;
a = 0.5;
sigma = sqrt(variance);

%n = 12000;
Length = 10;
bits = randbit(n);
symbols = bpskmap(bits);
% [rx,tx_output,symbols] = q4(variance,n);
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
tx_out = tx_output(4*[1:n]+nsymbols_upsampled);
output=zeros(n,1); %decision rule
j=1;
for i=1:length(tx_out)
    if real(tx_out(i)) >= 0
        output(j)= 1;
    else
        output(j)= -1;
    end
    j = j+1;
end

sum(abs(output - symbols'))/(2*n)

j=1;
for i=1:length(rx)
    if real(rx(i))>0
        output(j)=1;
    else
        output(j)=-1;
    end
    j = j+1;
end

 sum(abs(output - symbols'))/(2*n)

