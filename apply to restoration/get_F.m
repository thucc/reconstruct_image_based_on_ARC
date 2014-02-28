function F = get_F(freq_bound,N)
% freq_bound: limit of the frequency
% N: number of the frequency point
% F: spectrum of an image(in the sense of statistic)

%==============================initialization==============================
xi  = linspace(-freq_bound,freq_bound,N)+eps;
eta = linspace(freq_bound,-freq_bound,N)+eps;

F = (kron((eta.^2)',ones(1,N)) + kron(xi.^2,ones(N,1))).^(-0.8);
end

