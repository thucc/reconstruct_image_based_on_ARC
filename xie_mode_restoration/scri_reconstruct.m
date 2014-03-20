clear all;close all;
N							= 400;								%采样点数目
bound						= 300;								%采样的空间范围
choice_H					= 0;								%为0表示选择理想MTF，为1表示选择实际的MTF
sigma						= 0;
choice_F					= 1;								%0=》统计模型；1=》27度斜模式采样真实频谱；2=》45度斜模式采样真实频谱;3=》经典倒易晶包内的频谱
theta_alias					= 1;
theta_noise					= 1;
func_reconstruct(N,bound,sigma,choice_H,choice_F,theta_alias,theta_noise,27);
%func_bilinear_inter(N,27);

N_45						= 2*round(N*sqrt(2/5));
choice_F					= 2;
func_reconstruct(N_45,bound,sigma,choice_H,choice_F,theta_alias,theta_noise,45);
%func_bilinear_inter(N_45,45);


%func_quad_sample(bound,N)
