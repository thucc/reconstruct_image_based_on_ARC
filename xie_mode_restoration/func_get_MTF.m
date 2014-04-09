function H = func_get_MTF( choice, beta_1, beta_2, theta, d, c, alpha, freq_bound, N,ang)
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
%						ang:斜模式角度，27or45													%
%===============================================================================================%
	if choice == 0
		H	= ones(N);
	else
		%==============================initialization==============================
		xi = linspace(-freq_bound,freq_bound,N);
		eta = linspace(freq_bound,-freq_bound,N);
		[Xi,Eta]	= meshgrid(xi,eta);
		Xi_rotate	= cos(-theta)*Xi + sin(-theta)*Eta;
		Eta_rotate	= -sin(-theta)*Xi + cos(-theta)*Eta;
		%=================================get MTF resulted from sensor=============
		H_sen_1 = sinc(Eta_rotate*c/2/pi).*sinc(Xi_rotate*c/2/pi);
		H_sen_2 = exp(-beta_2*c*abs(Eta_rotate)).*exp(-beta_1*c*abs(Xi_rotate));
		H_sen = H_sen_1.*H_sen_2;
		%=================================get MTF resulted from moving=============
		H_mov = sinc(Eta*d/2/pi);
		%=================================get MTF resulted from optical============
		H_opt = exp(-alpha*c*sqrt(Eta.^2 + Xi.^2));
		%=================================get final MTF============================
		H = H_sen .* H_mov .* H_opt;
		plot_H(xi,eta,H,ang,freq_bound,N);
	end
end

function plot_H(xi,eta,H,ang,freq_bound,N)
	[Xi,Eta]	= meshgrid(xi,eta);
	figure;	subplot(1,2,1);mesh(Xi,Eta,H);
			subplot(1,2,2);[c,h] = contour(Xi,Eta,H,[1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1 0 -0.1 -0.01 -0.001]);clabel(c,h);hold on;axis equal
	if ang == 27
	x	    	= linspace(-freq_bound,freq_bound,N);
	y1			= zeros(1,N);
	y2			= zeros(1,N);
	y3			= ones(1,N)*freq_bound;
	y4			= -ones(1,N)*freq_bound;
	for ii = 1:N
		for jj = 1:N
			if(x(ii) > -5/8*freq_bound && x(ii) < -3/8*freq_bound)
				y1(ii)= 2*(x(ii)+5/8*freq_bound);
				y2(ii)= -2*(x(ii)+5/8*freq_bound);
				y3(ii)= y2(ii)+1*freq_bound;
				y4(ii)= y1(ii)-1*freq_bound;
			elseif(x(ii) > -3/8*freq_bound && x(ii) < 3/8*freq_bound)
				y1(ii)= 0.5*freq_bound;
				y2(ii)= -0.5*freq_bound;
				y3(ii)= 0.5*freq_bound;
				y4(ii)= -0.5*freq_bound;
			elseif(x(ii) > 3/8*freq_bound && x(ii) < 5/8*freq_bound)
				y1(ii)= -2*(x(ii)-5/8*freq_bound);
				y2(ii)= 2*(x(ii)-5/8*freq_bound);
				y3(ii)= y2(ii)+1*freq_bound;
				y4(ii)= y1(ii)-1*freq_bound;
			end
		end
	end
	plot(x,y1,'--b');
	plot(x,y2,'--b');
	plot(x,y3,'--b');
	plot(x,y4,'--b');
	elseif ang == 45
		plot(xi(floor(N/4)+1),eta,'--');
		plot(xi(floor(N/4)+N/2),eta,'--');
		plot(xi,eta(floor(N/4)+1),'--');
		plot(xi,eta(floor(N/4)+N/2),'--');
	end		
end
