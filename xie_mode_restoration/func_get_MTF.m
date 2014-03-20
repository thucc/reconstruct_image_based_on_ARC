function H = func_get_MTF( choice, beta_1, beta_2, theta, d, c, alpha, freq_bound, N)
%===============================================================================================%
%							获取系统传输函数													%
%						choice:0=>理想MTF，全通;1=>实际的MTF									%
%						beta1 and beta2: the conductivity between one sensor and its neighbour	%
%						theta: the angle of moving direction									%	
%						d: the distance at direction											%
%						c: the size of a sensor													%
%						alpha: the optical system is like a low pass filter						%		
%						freq_bound: bound of frequency											$
%						N: number of frequency points											%
%						H: MTF of the given system												%
%===============================================================================================%

if choice == 0 
	H	= ones(N);
else
	%==============================initialization==============================
	xi = linspace(-freq_bound,freq_bound,N);
	eta = linspace(freq_bound,-freq_bound,N);
	%=================================get MTF resulted from sensor=============
	H_sen_1 = sinc(eta*c/2/pi)'*sinc(xi*c/2/pi);
	H_sen_2 = exp(-beta_2*c*abs(eta))'*exp(-beta_1*c*abs(xi)); 
	H_sen = H_sen_1.*H_sen_2;
	%=================================get MTF resulted from moving=============
	temp = kron((eta*sin(theta))',ones(1,N)) + kron(xi*cos(theta),ones(N,1));
	H_mov = sinc(temp*d/2/pi);
	%=================================get MTF resulted from optical============
	H_opt = exp(-alpha*c*sqrt(kron((eta.^2)',ones(1,N)) + kron(xi.^2,ones(N,1))));
	%=================================get final MTF============================
	H = H_sen .* H_mov .* H_opt;
end

end
