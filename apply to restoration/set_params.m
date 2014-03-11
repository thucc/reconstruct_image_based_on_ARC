clear all;close all;
down_factor 		= 2;												%降采样倍数
origin_hr_image 	= im2double(imread('./images/Build512B.bmp'));			%原始高分辨图像
N 					= size(origin_hr_image);							%频域一个方向上的采样点数目
N					= N(1);
sigma 				= 0.01;												%噪声标准差

c					= pi/4;												%感光源尺寸
c_f     		 	= 2*pi/c;											%频域一个晶包的边长
freq_bound 			= pi;												%初步计算的频率范围为-freq_bound:freq_bound
H 					= get_MTF( 0, 0.14, -11/180*pi, 2.35*c, c, 0.3, freq_bound, N);%成像设备运动的传输函数
figure;[C,h] = contour(linspace(-pi,pi,N),linspace(-pi,pi,N),H,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('MTF');

F_S 				= get_F(4,N)*N;										%图像频谱的统计模型
F_SA				= sum(sum(abs(F_S).^2));							%图像频谱统计模型的总能量
F_R	 				= abs(fftshift(fft2(origin_hr_image)));				%真实频谱
F_RA				= sum(sum(F_R.^2));									%真实频谱总能量
image_to_reconstruct= im2double(imread('./images/image_to_reconstruct.bmp')); %模拟的低分辨率图像
F_D					= abs(fftshift(fft2(image_to_reconstruct,N,N)));	%模拟的低分辨率图像的频谱		
F					= F_R;
theta_alias 		= 1.3;
theta_noise 		= 3;

[a,b,D_opt,HF_alias]= get_adapted_cell(down_factor,N,H,F,sigma,theta_alias,theta_noise);
save('params.mat','down_factor','N','origin_hr_image','H','sigma','F','theta_alias','theta_noise','a','b','D_opt','HF_alias');
