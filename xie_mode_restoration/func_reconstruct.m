function func_reconstruct(N,bound,sigma,choice_H,choice_F,theta_alias,theta_noise,ang)
%===========================================================================================================%
%				斜模式采样重建函数																			%
%				N:采样点数目																				%
%				bound:采样的空间范围																		%
%				sigma:噪声标准差																			%
%				choice_H:为0表示选择理想MTF，为1表示选择实际的MTF											%
%				choice_F:0=》统计模型；1=》27度斜模式采样真实频谱；2=》45度斜模式采样真实频谱;				%
%				theta_alias,theta_noise:混叠和噪声阈值														%
%				ang:斜模式角度，27or45																		%
%===========================================================================================================%
	p							= bound/N;							%采样点间距
	H 							= func_get_MTF( choice_H, 0, 0.14, -11/180*pi, 2.35*sqrt(5)*(p), sqrt(5)*(p), 0.3, pi/(p), N);
	sample_image				= func_xie_mode_sampling(N,bound,H,sigma,ang);
	sample_spec					= fftshift(fft2(sample_image));
	
	Dvor						= func_get_xie_mode_Dvor(N,ang);
	spec_on_Dvor				= sample_spec.*Dvor;
	F							= func_get_F(choice_F, pi/p,N);
	[Dopt,a,b]					= func_get_xie_mode_Dopt(H.*F,sigma,theta_noise,theta_alias,ang);
	spec_on_Dopt				= sample_spec.*Dopt;
	
	SNR							= zeros(1,6);
	PSNR						= SNR;
%	[SNR(1),PSNR(1),res_image1] = func_wiener_filter(spec_on_Dopt,ones(N),[num2str(ang),' directly restore on Dopt']);
%	[SNR(2),PSNR(2),res_image2] = func_wiener_filter(spec_on_Dvor,ones(N),[num2str(ang),' directly restore on Dvor']);
%	K							= H./(H.^2.*(1+b.^2));
%	[SNR(3),PSNR(3),res_image3] = func_wiener_filter(spec_on_Dopt,K,[num2str(ang),' wiener filter on Dopt']);
%	[SNR(4),PSNR(4),res_image4] = func_wiener_filter(spec_on_Dvor,K,[num2str(ang),' wiener filter on Dvor']);
	K	 						= H./(H.^2.*(1+a.^2+b.^2));
	[SNR(5),PSNR(5),res_image5] = func_wiener_filter(spec_on_Dopt,K,[num2str(ang),' wiener filter consider alias on Dopt']);
%	[SNR(6),PSNR(6),res_image6] = func_wiener_filter(spec_on_Dvor,K,[num2str(ang),' wiener filter consider alias on Dvor']);
	
%	figure;imshow(sample_image);title(['sampled image(',num2str(ang),' degree)']);imwrite(sample_image,['./images/',num2str(ang),'_sampled_image.bmp']);
	figure;imshow(log10(1+abs(sample_spec)));title(['sampled image spectrum(',num2str(ang),' degree)']);
%	figure;	subplot(1,2,1);imshow(log10(1+abs(spec_on_Dvor)));title(['sample image spectrum after Dvor',num2str(ang)]);
%			subplot(1,2,2);imshow(log10(1+abs(spec_on_Dopt)));title(['sample image spectrum after Dopt',num2str(ang)]);
	imwrite(mat2gray(log10(1+abs(sample_spec))),['./images/',num2str(ang),'_sample_spec.bmp']);
	imwrite(mat2gray(log10(1+abs(spec_on_Dvor))),['./images/',num2str(ang),'_spec_on_Dvor.bmp']);
	imwrite(mat2gray(log10(1+abs(spec_on_Dopt))),['./images/',num2str(ang),'_spec_on_Dopt.bmp']);
%	imwrite(res_image1,['./images/',num2str(ang),'_directly_restore_on_Dopt.bmp']);
%	imwrite(res_image2,['./images/',num2str(ang),'_directly_restore_on_Dvor.bmp']);
%	imwrite(res_image3,['./images/',num2str(ang),'_wiener_filter_on_Dopt.bmp']);
%	imwrite(res_image4,['./images/',num2str(ang),'_wiener_filter_on_Dvor.bmp']);
	imwrite(res_image5,['./images/',num2str(ang),'_wiener_filter_consider_alias_on_Dopt.bmp']);
%	imwrite(res_image6,['./images/',num2str(ang),'_wiener_filter_consider_alias_on_Dvor.bmp']);
end
