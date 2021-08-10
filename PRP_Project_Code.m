source3 = 'wireless communication'; % source data
symbols3 = unique(source3); % unique elements in source
A3 = cellstr(num2cell(source3));
B3 = cellstr(num2cell(symbols3));
G3 = B3;
G3(1) = {'space'};
C3 = categorical(A3,B3,G3);
h3 = histogram(C3,'Normalization','probability');
p3 = h3.Values; % probability of each symbol
dict3 = huffmandict(B3,p3); % generating code dict
code3 = huffmanenco(source3,dict3); % source encoding

r = 13;
m = reshape(repmat(code3,r,1),1,r*numel(code3)); % repeated message bits
t = 1:length(m);
subplot(4,1,1)
plot(t,m);
xlabel('t');
ylabel('m');
subplot(4,1,2)
A = 10; % amplitude to boost SNR
f = 1/(2*pi*13); % frequency of attentutation wave
x = (A*sin(2*pi*t*f)).*m; % transmitted signal
plot(t,x);
xlabel('t');
ylabel('x');
subplot(4,1,3)
n = randn(1,length(t)); % gaussian noise
y = x+n; % received signal
plot(t,y);
xlabel('t');
ylabel('y');
subplot(4,1,4)
z = abs(round(y./(A*sin(2*pi*t*f)))); % estimation of bits
for k = 1:length(z)
    if z(k) > 1
        z(k) = 1;
    end
end
plot(t,z);
xlabel('t');
ylabel('z');

zz = reshape(z,[r,length(code3)])'; % removing repetition bits
ss = sum(zz,2);
c = zeros(size(code3));
for k = 1:length(c)
    if (ss(k) > r/2)
        c(k) = 1;
    else
        c(k) = 0;
    end
end

message3 = strjoin(huffmandeco(c,dict3),""); % message decoding
char_flips = 0;
if length(source3) > length(message3)
    N = length(message3);
else
    N = length(source3);
end
for k = 1:N
    if message3(k) ~= source3(k)
        char_flips = char_flips + 1;
    end
end
disp('Percentage error = ')
disp(char_flips*100/length(source3));
% In case of lower SNR < 10, or lower repetion r < 10, there are high bit flips, which can be          
% estimated better using a minimum distance decoder, or else it will give high percentage error.