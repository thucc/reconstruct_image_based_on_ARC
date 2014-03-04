clear all;close all;
down_factor 		= 2;									%降采样倍数
N 					= 256;									%频域一个方向上的采样点数目
origin_hr_image 	= imread('./images/Zone256B.bmp');		%原始高分辨图像
sigma 				= 5;									%噪声标准差

c					= pi;									%感光源尺寸
c_f     		 	= 2*pi/c;								%频域一个晶包的边长
freq_bound 			= pi;									%初步计算的频率范围为-freq_bound:freq_bound
H 					= get_MTF( 0, 0.14, -11/180*pi, 2.35*c, c, 0.3, freq_bound, N);%成像设备运动的传输函数
figure;[C,h] = contour(linspace(-pi,pi,N),linspace(-pi,pi,N),H,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('MTF');

F 					= get_F(freq_bound,N);					%图像频谱的统计模型
theta_alias = 1;
theta_noise = 3;

%[a,b,D_opt]		=get_adapted_cell(down_factor,N,abs(H),F,sigma,theta_alias,theta_noise);
%save('params.mat','down_factor','N','origin_hr_image','H','sigma','F','theta_alias','theta_noise','a','b','D_opt');

F	 				= abs(fftshift(fft2(double(origin_hr_image))));
[a,b,D_opt]			= get_adapted_cell(down_factor,N,abs(H),F,sigma,theta_alias,theta_noise);
save('params.mat','down_factor','N','origin_hr_image','H','sigma','F','theta_alias','theta_noise','a','b','D_opt');
