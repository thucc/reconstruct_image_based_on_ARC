function [SNR,PSNR,res_image] = wiener_filter(spec,K,origin_hr_image,origin_image,description)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数
%%%			origin_hr_image		:		最初的高分辨率图像
%%%			origin_image		:		降采样且加噪的图像

	res_image 					= abs(ifft2(ifftshift(spec.*K)));
	res_image					= (res_image-min(min(res_image)))/(max(max(res_image))-min(min(res_image)));
	figure;imshow(res_image);title(description)
	[SNR,PSNR]					= cal_SNR_PSNR(origin_hr_image,res_image);
end

 
function [SNR,PSNR] = cal_SNR_PSNR(hr_image,lr_image)

	[M,N]		= size(hr_image);
	hr_power	= sum(sum(hr_image.^2));
	noise_power	= sum(sum((hr_image-lr_image).^2));
	SNR			= 10*log10(hr_power/noise_power);
	PSNR		= 10*log10(255^2*M*N/noise_power);
end
