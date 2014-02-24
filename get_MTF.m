function [H] = get_MTF( beta_1, beta_2, theta, d, c, alpha, freq_bound)
%beta1 and beta2 stand for the conductivity between one sensor and its
%neighbour
%theta stands for the angle of moving direction
%d stands for the distance at direction
%c stands for the size of a sensor
%alpha indicates the optical system is like a low pass filter
%freq_bound limits the bound of freq

%==============================initialization==============================
xi = -freq_bound:0.01:freq_bound;
eta = freq_bound:-0.01:-freq_bound;
N = length(xi);                            
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
%==========================================================================
figure;
[C,h] = contour(eta',xi,H,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);
clabel(C,h);
end

