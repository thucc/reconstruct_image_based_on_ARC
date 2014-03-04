function [SNR,PSNR] = wiener_filter(spec,K,origin_hr_image,origin_image,description)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数
%%%			origin_hr_image		:		最初的高分辨率图像
%%%			origin_image		:		降采样且加噪的图像

	res_image 					= ifft2(ifftshift(spec.*K));
	res_image 					= abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
	res_image 					= uint8(res_image);
	figure;imshow(res_image);title(description)
	[SNR,PSNR]					= cal_SNR_PSNR(origin_hr_image,res_image);
end
