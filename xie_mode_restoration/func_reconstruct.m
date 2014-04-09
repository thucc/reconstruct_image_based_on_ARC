function index = func_reconstruct(N,bound,SNR,choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path)
%===========================================================================================================%
%input:																										%
%				斜模式采样重建函数																			%
%				N:采样点数目																				%
%				bound:采样的空间范围																		%
%				SNR:信噪比																					%
%				choice_H:为0表示选择理想MTF，为1表示选择实际的MTF											%
%				choice_F:0=》统计模型；1=》27度斜模式采样真实频谱；2=》45度斜模式采样真实频谱;				%
%				theta_alias,theta_noise:混叠和噪声阈值														%
%				ang:斜模式角度，27or45																		%
%				choice_image:0=》对生成的模拟图像降采样重建，1=》对真实场景图像降采样重建					%
%				image_path:choice_image为1时表示真实场景图像的存储位置										%
%output:																									%
%				index:复原评价指标，2行，第一行为PSNR，第二行为ssim											%
%===========================================================================================================%
	p							= bound/N;							%采样点间距
	H 							= func_get_MTF( choice_H, 0.14, 0, ang/180*pi, 0*p, sqrt(5)*(p), 0.3, 1*pi/(p), N, ang);
	[sample_image,sigma]		= func_xie_mode_sampling(N,bound,H,SNR,ang,choice_image,image_path);
	sample_spec					= fftshift(fft2(sample_image));
	
	Dvor						= func_get_xie_mode_Dvor(N,ang);
	spec_on_Dvor				= sample_spec.*Dvor;
	F							= func_get_F(choice_F, pi/p,N);
	[Dopt,a,b]					= func_get_xie_mode_Dopt(H.*F,sigma,theta_noise,theta_alias,ang);
	spec_on_Dopt				= sample_spec.*Dopt;

	avg_sample_image			= mean(mean(sample_image))*4;

	PSNR						= zeros(1,6);
	mssim						= zeros(1,6);
	[PSNR(1),mssim(1),res_image1] = func_wiener_filter(spec_on_Dopt,ones(N),ang,avg_sample_image);
	[PSNR(2),mssim(2),res_image2] = func_wiener_filter(spec_on_Dvor,ones(N),ang,avg_sample_image);
	K1		      				= H./(H.^2.*(1+b.^2));
	[PSNR(3),mssim(3),res_image3] = func_wiener_filter(spec_on_Dopt,K1,ang,avg_sample_image);
	[PSNR(4),mssim(4),res_image4] = func_wiener_filter(spec_on_Dvor,K1,ang,avg_sample_image);
	K2	 	    				= H./(H.^2.*(1+a.^2+b.^2));
	[PSNR(5),mssim(5),res_image5] = func_wiener_filter(spec_on_Dopt,K2,ang,avg_sample_image);
	[PSNR(6),mssim(6),res_image6] = func_wiener_filter(spec_on_Dvor,K2,ang,avg_sample_image);
	
	save('data_K.mat','K1','K2');

	index						= [PSNR;mssim];

%	xi 							= linspace(-pi/p,pi/p,N);
%	eta 						= linspace(pi/p,-pi/p,N);
%	[Xi,Eta]					= meshgrid(xi,eta);
%	figure;	subplot(1,2,1);mesh(Xi,Eta,K1);
%	       	subplot(1,2,2);mesh(Xi,Eta,K2);

	imwrite(sample_image,['./images/',num2str(ang),'_img','_sample.png']);
	imwrite(mat2gray(log10(1+abs(sample_spec))),['./images/',num2str(ang),'_spec','_sample.png']);
	imwrite(mat2gray(log10(1+abs(spec_on_Dvor))),['./images/',num2str(ang),'_spec','_on_Dvor.png']);
	imwrite(mat2gray(log10(1+abs(spec_on_Dopt))),['./images/',num2str(ang),'_spec','_on_Dopt.png']);
	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image3))))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dopt.png']);
	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image4))))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dvor.png']);
	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image5))))),['./images/',num2str(ang),'_spec','_wiener_filter_consider_alias_on_Dopt.png']);
	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image6))))),['./images/',num2str(ang),'_spec','_wiener_filter_consider_alias_on_Dvor.png']);
	imwrite(res_image1,['./images/',num2str(ang),'_img','_directly_restore_on_Dopt.png']);
	imwrite(res_image2,['./images/',num2str(ang),'_img','_directly_restore_on_Dvor.png']);
	imwrite(res_image3,['./images/',num2str(ang),'_img','_wiener_filter_on_Dopt.png']);
	imwrite(res_image4,['./images/',num2str(ang),'_img','_wiener_filter_on_Dvor.png']);
	imwrite(res_image5,['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dopt.png']);
	imwrite(res_image6,['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dvor.png']);
end
