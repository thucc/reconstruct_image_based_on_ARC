function [PSNR,mssim,res_image] = func_wiener_filter(spec,K,ang,avg_sample_image)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数
%%%			ang					:  	 	斜模式角度，27or45
%%%			avg_sample_image	:		采样图像的灰度均值

	res_image 					= mat2gray(abs(ifft2(ifftshift(spec.*K))));
	res_image					= res_image*avg_sample_image/mean(mean(res_image));
	res_image					= res_image.*(res_image<1) + double((res_image>1));
	if ang == 27
		hr_image	= im2double(imread('./images/27_img_hr.png'));
	elseif ang == 45
		hr_image	= im2double(imread('./images/45_img_hr.png'));
	end
	PSNR						= cal_SNR_PSNR(res_image,hr_image);
	mssim						= func_ssim(res_image,hr_image);
end

 
function PSNR = cal_SNR_PSNR(lr_image,hr_image)
	[M,N]		= size(hr_image);
	noise_power	= sum(sum((hr_image-lr_image).^2));
	PSNR		= 10*log10(255^2*M*N/noise_power);
end
