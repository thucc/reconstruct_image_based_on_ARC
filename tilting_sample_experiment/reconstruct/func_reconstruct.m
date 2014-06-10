function  func_reconstruct(sample_image,SNR,choice_H,theta_alias,theta_noise,ang)
%===========================================================================================================%
%input:																										%
%				斜模式采样重建函数									        								%
%				sample_image:采样图像
%				SNR:信噪比																					%
%				choice_H:为0表示选择理想MTF，为1表示选择实际的MTF											%
%				theta_alias,theta_noise:混叠和噪声阈值														%
%				ang:斜模式角度，27or45																		%
%===========================================================================================================%
    N                           = size(sample_image,1);
	sample_spec					= fftshift(fft2(sample_image));
    if ang == 45
        temp = zeros(2*N);
        temp(1:2:2*N,1:2:2*N) = sample_image;
        sample_image = temp;
        N = 2*N;
	    sample_spec					= fftshift(fft2(sample_image));
    end
	
	Dvor						= func_get_xie_mode_Dvor(N,ang);
	spec_on_Dvor				= sample_spec.*Dvor;
    c                           = 3;
    if ang == 27
        p = c * sin(ang/180*pi);
        freq_bound = pi/p;
    elseif ang ==45
        p = c * sin(ang/180*pi)/2;
        freq_bound = pi/p;
    end
	H 							= func_get_MTF( choice_H, 0.7, 0, ang/180*pi, 5.25*p, c, 0.1, freq_bound, N, ang);
	F							= func_get_F(freq_bound ,N);
    sigma					    = mean(mean((sample_image*5).^2))/(sqrt(10^(SNR/10)));
	[Dopt,a,b]					= func_get_xie_mode_Dopt(H.*F,sigma,theta_noise,theta_alias,ang);
	spec_on_Dopt				= sample_spec.*Dopt;

    res_image1 = func_wiener_filter(spec_on_Dopt,ones(N));
	res_image2 = func_wiener_filter(spec_on_Dvor,ones(N));
	K1		      				= H./(H.^2.*(1+b.^2));
	res_image3 = func_wiener_filter(spec_on_Dopt,K1);
	res_image4 = func_wiener_filter(spec_on_Dvor,K1);
%	K2	 	    				= H./(H.^2.*(1+a.^2+b.^2));
%	res_image5 = func_wiener_filter(spec_on_Dopt,K2);
%	res_image6 = func_wiener_filter(spec_on_Dvor,K2);
	
	opts.maxit					= 50;
    opts.tol   					= 5^10^(-5);
    opts.bmax  					= 2^20;
    opts.bmin  					= 1;
    opts.IncreaseRate			= 2;
    opts.disp  					= 0;
	[res_image7,iter] 			= func_TV(ifftshift(H),res_image1,10000000,2,opts,ifftshift(Dopt));
	[res_image8,iter] 			= func_TV(ifftshift(H),res_image2,10000000,2,opts,ifftshift(Dvor));

	figure; subplot(1,2,1);imshow((Dopt-Dvor)>0);title('Dopt include while Dvor doesn''t')
			subplot(1,2,2);imshow((Dopt-Dvor)<0);title('Dvor include while Dopt doesn''t')
   saveas(gcf,'27_Dvor_Dopt.png','png')

	imwrite(mat2gray(log(1+abs(sample_spec))),['./images/',num2str(ang),'_spec','_sample.png']);
	imwrite(mat2gray(log(1+abs(spec_on_Dvor))),['./images/',num2str(ang),'_spec','_on_Dvor.png']);
	imwrite(mat2gray(log(1+abs(spec_on_Dopt))),['./images/',num2str(ang),'_spec','_on_Dopt.png']);
%	imwrite(mat2gray(log(1+abs(fftshift(fft2(res_image3))))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dopt.png']);
%	imwrite(mat2gray(log(1+abs(fftshift(fft2(res_image4))))),['./images/',num2str(ang),'_spec','_wiener_filter_on_Dvor.png']);
%	imwrite(mat2gray(log(1+abs(fftshift(fft2(res_image5))))),['./images/',num2str(ang),'_spec','_wiener_filter_consider_alias_on_Dopt.png']);
%	imwrite(mat2gray(log(1+abs(fftshift(fft2(res_image6))))),['./images/',num2str(ang),'_spec','_wiener_filter_consider_alias_on_Dvor.png']);
	imwrite(res_image1,['./images/',num2str(ang),'_img','_directly_restore_on_Dopt.png']);
	imwrite(res_image2,['./images/',num2str(ang),'_img','_directly_restore_on_Dvor.png']);
	imwrite(res_image3,['./images/',num2str(ang),'_img','_wiener_filter_on_Dopt.png']);
	imwrite(res_image4,['./images/',num2str(ang),'_img','_wiener_filter_on_Dvor.png']);
%	imwrite(res_image5,['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dopt.png']);
%	imwrite(res_image6,['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dvor.png']);
	imwrite(res_image7,['./images/',num2str(ang),'_img','_TV_on_Dopt.png']);
	imwrite(res_image8,['./images/',num2str(ang),'_img','_TV_on_Dvor.png']);
end
