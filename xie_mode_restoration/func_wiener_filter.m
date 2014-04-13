function res_image = func_wiener_filter(spec,K,avg_sample_image)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数
%%%			avg_sample_image	:		采样图像的灰度均值

	res_image 					= mat2gray(abs(ifft2(ifftshift(spec.*K))));
	res_image					= res_image*avg_sample_image/mean(mean(res_image));
	res_image					= res_image.*(res_image<1) + double((res_image>1));
end
