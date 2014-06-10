function [sampling_image,sigma] = func_xie_mode_sampling(N,bound,H,SNR,ang,choice_image,image_path,rec_or_hex_27)
%===============================================================================================%
%							斜模式采样函数														%
%							N：采样点数目														%
%							bound:图像范围,-bound:p:bound的长度应为4的倍数						%
%							H:系统传输函数														%
%							ang:斜模式角度，27or45												%
%							choice_image:0=》模拟图像降采样重建，1=》真实场景图像降采样重建		%
%							image_path:choice_image为1时表示真实场景图像的存储位置				%
%							rec_or_hex_27:27度斜模式采样形成的网格是正方形还是六边形			%
%===============================================================================================%
hr_image				= mat2gray(get_hr_image(N,bound,choice_image,image_path));
sigma					= mean(mean(hr_image.^2))/(sqrt(10^(SNR/10)));
hr_image_S				= fftshift(fft2(hr_image));
hr_image_after_MTF_S	= hr_image_S.*H;
hr_image_after_MTF		= mat2gray(abs(ifft2(ifftshift(hr_image_after_MTF_S))));
sampling_image_1		= mat2gray(hr_image_after_MTF + randn(N)*sigma);
sampling_image			= sample(sampling_image_1,ang,rec_or_hex_27);

imwrite(hr_image,['./images/',num2str(ang),'_img','_hr.png']);
imwrite(sampling_image_1,['./images/',num2str(ang),'_img','_hr_after_MTF_and_noise.png']);
imwrite(mat2gray(log(1+abs(hr_image_S))),['./images/',num2str(ang),'_spec','_hr.png']);
imwrite(mat2gray(log(1+abs(fftshift(fft2(sampling_image_1))))),['./images/',num2str(ang),'_spec','_hr_after_MTF_and_noise.png']);
imwrite(mat2gray(log(1+abs(hr_image_after_MTF_S))),['./images/',num2str(ang),'_spec','_hr_after_MTF.png']);
end

function hr_image = get_hr_image(N,bound,choice_image,image_path)
%===============================================================================================%
%       					获取高分辨率图像，近似认为是原始连续图像							%
%							N：采样点数目														%
%							bound:图像范围														%
%							choice_image:0=》模拟图像降采样重建，1=》真实场景图像降采样重建		%
%===============================================================================================%
if choice_image == 0
	x1		= linspace(1,bound,N)';			
	x1		= repmat(x1,1,N);				%水平方向坐标
	x2		= x1';							%垂直方向坐标
	O		= (bound-1)/2;
%	O		= 0;
	hr_image= uint8(127.5 + 127.5 * cos((1440./pi) ./ (1 + 512./sqrt(8 * ((x1-O).^2 + (x2-O).^2)))));
elseif choice_image == 1
	hr_image= imread(image_path);
end
end

function sampling_image = sample(input_image,ang,rec_or_hex_27)
%===============================================================================================%
%							对输入图像进行斜模式采样											%
%							input_image：输入图像												%
%							sampling_image：采样图像，没有采样的点补零							%
%							rec_or_hex_27:27度斜模式采样形成的网格是正方形还是六边形			%
%===============================================================================================%
[M,N]					= size(input_image);
sampling_image			= zeros(M,N);
if ang == 27 && strcmp(rec_or_hex_27 , 'hex')
	sampling_image(1:4:M,1:2:N) = input_image(1:4:N,1:2:N);
	sampling_image(3:4:M,2:2:N) = input_image(3:4:M,2:2:N);
elseif ang == 27 && strcmp(rec_or_hex_27 , 'rec')
	sampling_image(1:2:M,1:2:N) = input_image(1:2:M,1:2:N);
elseif ang == 45
	sampling_image(1:2:M,1:2:N) = input_image(1:2:M,1:2:N);
end
end
