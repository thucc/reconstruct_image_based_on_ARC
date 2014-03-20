function [SNR,PSNR,res_image] = wiener_filter(spec,K,description)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数

	res_image 					= mat2gray(abs(ifft2(ifftshift(spec.*K))));
	figure;imshow(res_image);title(description)
	%[SNR,PSNR]					= cal_SNR_PSNR(res_image);
	SNR=0;PSNR=0;
end

 
function [SNR,PSNR] = cal_SNR_PSNR(lr_image)
	hr_image	= im2double(imread('./images/hr_image.bmp'));
	[M,N]		= size(hr_image);
	hr_power	= sum(sum(hr_image.^2));
	noise_power	= sum(sum((hr_image-lr_image).^2));
	SNR			= 10*log10(hr_power/noise_power);
	PSNR		= 10*log10(255^2*M*N/noise_power);
end
