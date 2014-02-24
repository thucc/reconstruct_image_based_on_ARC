function F = get_F(freq_bound)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%==============================initialization==============================
xi  = -freq_bound:0.01:freq_bound;
eta = freq_bound:-0.01:-freq_bound;
N = length(xi);                             

F = (kron((eta.^2)',ones(1,N)) + kron(xi.^2,ones(N,1))).^(-0.8);
F(601,601) = F(600,601);
end

