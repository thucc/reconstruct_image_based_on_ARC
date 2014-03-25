clear all;close all;
choice_H					= 0;								%为0表示选择理想MTF，为1表示选择实际的MTF
choice_F					= 1;								%0=》统计模型；1=》27度斜模式采样真实频谱；2=》45度斜模式采样真实频谱;3=》经典倒易晶包内的频谱
choice_image				= 0;								%0=>对模拟生成图像降采样，1=》对现实场景图像降采样
N							= 400;								%采样点数目
N_45						= 2*round(N*sqrt(2/5));
bound						= 300;								%采样的空间范围
if choice_image == 1
	N		= min(size(imread('./images/real_image/test.bmp')));
	N_45	= N;
end
SNR							= 48;								%信噪比，db为单位
theta_alias					= 0.5;
theta_noise					= 5;

func_reconstruct(N,bound,SNR,choice_H,choice_F,theta_alias,theta_noise,27,choice_image);
func_bilinear_inter(N,27);

choice_F					= 2;
%func_reconstruct(N_45,bound,SNR,choice_H,choice_F,theta_alias,theta_noise,45,choice_image);
%func_bilinear_inter(N_45,45);


%func_quad_sample(bound,N)
