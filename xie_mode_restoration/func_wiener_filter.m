function [PSNR,res_image] = func_wiener_filter(spec,K,description,ang)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数
%%%			ang					:  	 	斜模式角度，27or45

	res_image 					= mat2gray(abs(ifft2(ifftshift(spec.*K))));
	%figure;imshow(res_image);title(description)
	PSNR						= cal_SNR_PSNR(res_image,ang);
end

 
function PSNR = cal_SNR_PSNR(lr_image,ang)
	if ang == 27
		hr_image	= im2double(imread('./images/27_hr_image.bmp'));
	elseif ang == 45
		hr_image	= im2double(imread('./images/45_hr_image.bmp'));
	end
	[M,N]		= size(hr_image);
	noise_power	= sum(sum((hr_image-lr_image).^2));
	PSNR		= 10*log10(255^2*M*N/noise_power);
end
