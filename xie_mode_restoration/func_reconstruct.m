function  func_reconstruct(N,bound,SNR,choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path)
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
%===========================================================================================================%
	p							= bound/N;							%采样点间距
	H 							= func_get_MTF( choice_H, 0.14, 0, ang/180*pi, 0*p, sqrt(5)*(p), 0.3, 1*pi/(p), N, ang);
	F							= func_get_F(choice_F, pi/p,N);
	[sample_image,sigma]		= func_xie_mode_sampling(N,bound,H,SNR,ang,choice_image,image_path);
	sample_spec					= fftshift(fft2(sample_image));
	
	Dvor						= func_get_xie_mode_Dvor(N,ang);
	spec_on_Dvor				= sample_spec.*Dvor;
	[Dopt,a,b]					= func_get_xie_mode_Dopt(H.*F,sigma,theta_noise,theta_alias,ang);
	spec_on_Dopt				= sample_spec.*Dopt;

	avg_sample_image			= mean(mean(sample_image))*4;

	res_image1 = func_wiener_filter(spec_on_Dopt,ones(N),avg_sample_image);
	res_image2 = func_wiener_filter(spec_on_Dvor,ones(N),avg_sample_image);
	K1		      				= H./(H.^2.*(1+b.^2));
	res_image3 = func_wiener_filter(spec_on_Dopt,K1,avg_sample_image);
	res_image4 = func_wiener_filter(spec_on_Dvor,K1,avg_sample_image);
	K2	 	    				= H./(H.^2.*(1+a.^2+b.^2));
	res_image5 = func_wiener_filter(spec_on_Dopt,K2,avg_sample_image);
	res_image6 = func_wiener_filter(spec_on_Dvor,K2,avg_sample_image);
	
	opts.maxit					= 100;
	[res_image7,iter] 			= func_TV(ifftshift(H),res_image1,10000000,2,opts,ifftshift(Dopt));
	[res_image8,iter] 			= func_TV(ifftshift(H),res_image2,10000000,2,opts,ifftshift(Dvor));

	figure; subplot(1,2,1);imshow((Dopt-Dvor)>0);title('Dopt include while Dvor doesn''t')
			subplot(1,2,2);imshow((Dopt-Dvor)<0);title('Dvor include while Dopt doesn''t')

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
	imwrite(res_image7,['./images/',num2str(ang),'_img','_TV_on_Dopt.png']);
	imwrite(res_image8,['./images/',num2str(ang),'_img','_TV_on_Dvor.png']);
end
