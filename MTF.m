clear all;
%==============================initialization==============================
freq_bound = 2;
xi = -freq_bound:0.01:freq_bound;
eta = xi;
N = length(xi);
c = 1;                               %size of sensor
%=================================get MTF resulted from sensor=============
beta_1 = 0;
beta_2 = 0.14;
H_sen_1 = sinc(eta*c/2)'*sinc(xi*c/2);
H_sen_2 = exp(-beta_1*c*abs(eta))'*exp(-beta_2*c*abs(xi));
H_sen = H_sen_1.*H_sen_2;
%=================================get MTF resulted from moving=============
theta = 11/180*pi;
d = 2.35*c;
temp = kron((eta*sin(theta))',ones(1,N)) + kron(xi*cos(theta),ones(N,1));
H_mov = sinc(temp*d/2);
%=================================get MTF resulted from optical============
alpha = 0.3;
H_opt = exp(-alpha*c*sqrt(kron((xi.^2)',ones(1,N)) + kron(eta.^2,ones(N,1))));
%=================================get final MTF============================
H = H_sen .* H_mov .* H_opt;
%==========================================================================
[C,h] = contour(eta,xi',H);
clabel(C,h);