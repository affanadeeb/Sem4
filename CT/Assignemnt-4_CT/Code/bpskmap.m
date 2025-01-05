
function y = bpskmap(x)
y = ones(size(x));
for i = 1:length(x)
    if(x(i)==0)
        y(i) = -1;
    end
end
end


%bits = [1, 0, 1]; % For three bits
%bpsk_symbol = bpskmaps(bits);

%disp(bpsk_symbol);

%function y = bpskmaps(x)
%y = ones(size(x));
%for i = 1:length(x)
   % if(x(i)==0)
  %      y(i) = -1;
 %   end
%end
%end