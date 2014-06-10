function F = func_get_F(freq_bound,N)

	xi  		= linspace(-freq_bound,freq_bound,N)+eps;
	eta 		= linspace(freq_bound,-freq_bound,N)+eps;
	F 			= (N/5)*(kron((eta.^2)',ones(1,N)) + kron(xi.^2,ones(N,1))).^(-0.8);
end
