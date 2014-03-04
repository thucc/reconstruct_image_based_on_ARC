function [SNR,PSNR] = cal_SNR_PSNR(hr_image,lr_image)

	[M,N]		= size(hr_image);
	hr_power	= sum(sum(hr_image.^2));
	noise_power	= sum(sum((hr_image-lr_image).^2));
	SNR			= 10*log10(hr_power/noise_power);
	PSNR		= 10*log10(255^2*M*N/noise_power);
end
