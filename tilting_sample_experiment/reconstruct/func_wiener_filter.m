function res_image = func_wiener_filter(spec,K)
%%%			spec				:   	待恢复图像的频谱
%%%			K					:		维纳滤波器的系统函数

	res_image 					= mat2gray(real(ifft2(ifftshift(spec.*K))));
end
