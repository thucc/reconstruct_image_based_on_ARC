function  func_reconstruct(N,bound,SNR,choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path,rec_or_hex_27,beta,alpha)
%===========================================================================================================%
%input:																										%
%				斜模式采样重建函数									        								%
%				N:采样点数目																				%
%				bound:采样的空间范围																		%
%				SNR:信噪比																					%
%				choice_H:为0表示选择理想MTF，为1表示选择实际的MTF											%
%				choice_F:0=》统计模型；1=》27度斜模式采样真实频谱；2=》45度斜模式采样真实频谱;				%
%				theta_alias,theta_noise:混叠和噪声阈值														%
%				ang:斜模式角度，27or45																		%
%				choice_image:0=》对生成的模拟图像降采样重建，1=》对真实场景图像降采样重建					%
%				image_path:choice_image为1时表示真实场景图像的存储位置										%
%				rec_or_hex_27:27度斜模式采样形成的网格是正方形还是六边形									%
%===========================================================================================================%
	p							= bound/N;							%采样点间距
	if ang == 27 && strcmp(rec_or_hex_27 , 'hex')
		c = sqrt(5)*p;
		freq_bound	= pi/p;
	elseif ang == 27 && strcmp(rec_or_hex_27 , 'rec')
		c = sqrt(5)*p;
		freq_bound	= 2*pi/p;
	elseif ang ==45
		c = sqrt(2)*p;
		freq_bound	= 2*pi/p;
	end
	H 							= func_get_MTF( choice_H, beta, 0, ang/180*pi, 5.25*p, c, alpha, freq_bound, N, ang,rec_or_hex_27);
	[sample_image,sigma]		= func_xie_mode_sampling(N,bound,H,SNR,ang,choice_image,image_path,rec_or_hex_27);
	sample_spec					= fftshift(fft2(sample_image));
	
	Dvor						= func_get_xie_mode_Dvor(N,ang,rec_or_hex_27);
	spec_on_Dvor				= sample_spec.*Dvor;
	F							= func_get_F(choice_F, freq_bound ,N,sample_spec);
	[Dopt,a,b]					= func_get_xie_mode_Dopt(H.*F,sigma,theta_noise,theta_alias,ang,rec_or_hex_27);
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
	
	opts.maxit					= 50;
    opts.tol   					= 5^10^(-5);
    opts.bmax  					= 2^20;
    opts.bmin  					= 1;
    opts.IncreaseRate			= 2;
    opts.disp  					= 0;
	[res_image7,iter] 			= func_TV(ifftshift(H),res_image1,10000000,2,opts,ifftshift(Dopt));
	[res_image8,iter] 			= func_TV(ifftshift(H),res_image2,10000000,2,opts,ifftshift(Dvor));

%	figure; subplot(1,2,1);imshow((Dopt-Dvor)>0);title('Dopt include while Dvor doesn''t')
%			subplot(1,2,2);imshow((Dopt-Dvor)<0);title('Dvor include while Dopt doesn''t')
%    saveas(gcf,[num2str(ang),'_Dvor_Dopt.png'],'png')

    
	imwrite(Dopt,['./images/',num2str(ang),'_Dopt.png']);
	imwrite(Dvor,['./images/',num2str(ang),'_Dvor.png']);
	imwrite(sample_image,['./images/',num2str(ang),'_img','_sample.png']);
	imwrite(mat2gray(log10(1+abs(sample_spec))),['./images/',num2str(ang),'_spec','_sample.png']);
	imwrite(mat2gray(log10(1+abs(spec_on_Dvor))),['./images/',num2str(ang),'_spec','_on_Dvor.png']);
	imwrite(mat2gray(log10(1+abs(spec_on_Dopt))),['./images/',num2str(ang),'_spec','_on_Dopt.png']);
%	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image3))))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dopt.png']);
%	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image4))))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dvor.png']);
	imwrite(log10(1+abs(fftshift(fft2(res_image3)))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dopt.png']);
	imwrite(log10(1+abs(fftshift(fft2(res_image4)))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dvor.png']);
%	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image5))))),['./images/',num2str(ang),'_spec','_wiener_filter_consider_alias_on_Dopt.png']);
%	imwrite(mat2gray(log10(1+abs(fftshift(fft2(res_image6))))),['./images/',num2str(ang),'_spec','_wiener_filter_consider_alias_on_Dvor.png']);
	imwrite(res_image1,['./images/',num2str(ang),'_img','_directly_restore_on_Dopt.png']);
	imwrite(res_image2,['./images/',num2str(ang),'_img','_directly_restore_on_Dvor.png']);
	imwrite(res_image3,['./images/',num2str(ang),'_img','_wiener_filter_on_Dopt.png']);
	imwrite(res_image4,['./images/',num2str(ang),'_img','_wiener_filter_on_Dvor.png']);
	imwrite(res_image5,['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dopt.png']);
	imwrite(res_image6,['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dvor.png']);
	imwrite(res_image7,['./images/',num2str(ang),'_img','_TV_on_Dopt.png']);
	imwrite(res_image8,['./images/',num2str(ang),'_img','_TV_on_Dvor.png']);
    imwrite(res_image3(round(N/4):round(N/4*3),round(N/4):round(N/4*3)),['./images/',num2str(ang),'_img_expand','_wiener_filter_on_Dopt.png'])
    imwrite(res_image4(round(N/4):round(N/4*3),round(N/4):round(N/4*3)),['./images/',num2str(ang),'_img_expand','_wiener_filter_on_Dvor.png'])
    imwrite(res_image5(round(N/4):round(N/4*3),round(N/4):round(N/4*3)),['./images/',num2str(ang),'_img_expand','_wiener_filter_consider_alias_on_Dopt.png'])
    imwrite(res_image6(round(N/4):round(N/4*3),round(N/4):round(N/4*3)),['./images/',num2str(ang),'_img_expand','_wiener_filter_consider_alias_on_Dvor.png'])
    imwrite(res_image7(round(N/4):round(N/4*3),round(N/4):round(N/4*3)),['./images/',num2str(ang),'_img_expand','_TV_on_Dopt.png'])
    imwrite(res_image8(round(N/4):round(N/4*3),round(N/4):round(N/4*3)),['./images/',num2str(ang),'_img_expand','_TV_on_Dvor.png'])
end
