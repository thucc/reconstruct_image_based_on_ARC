clear all; close all;
c = pi;													%感光源尺寸
freq_bound = pi;										%初步计算的频率范围为-freq_bound:freq_bound
N = 512;												%频域上一个方向总的采样点数				
%H = abs(get_MTF( 0, 0, 0, 0, c, 0, freq_bound, N));%光学系统不理想的传输函数
%H = abs(get_MTF( 0, 0.14, 0, 0, c, 0.3, freq_bound, N));%光学系统不理想的传输函数
H = abs(get_MTF( 0, 0.14, 11/180*pi, 2.35*c, c, 0.3, freq_bound, N));%光学系统不理想的传输函数
save('H.mat','H');
figure;[C,h] = contour(linspace(-pi,pi,N),linspace(-pi,pi,N),H,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('ccd3');
%==========================================================================
theta_alias = 0;
theta_noise = 1000;
sigma = 0.5;
F = get_F(freq_bound,N);
HF = H.*F;
HF_alias = HF(1:256,1:256) + HF(1:256,257:512) + HF(257:512,1:256) + HF(257:512,257:512);
HF_alias = [HF_alias,HF_alias;HF_alias,HF_alias] - HF;  
a = HF_alias./HF;
b = sigma./HF;
save('b.mat','b');
save('a.mat','a');
D_opt_alias = 1 - dither(a - theta_alias);
D_opt_noise = 1 - dither(b - theta_noise);
D_opt = D_opt_alias.*D_opt_noise;
a = log10(a);
b = log10(b);
figure;imshow(D_opt);title('D\_opt')

save('D_opt.mat','D_opt');
