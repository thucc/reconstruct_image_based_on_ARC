function [sampling_image,sigma] = func_xie_mode_sampling(N,bound,H,SNR,ang,choice_image)
%===============================================================================================%
%							斜模式采样函数														%
%							N：采样点数目														%
%							bound:图像范围,-bound:p:bound的长度应为4的倍数						%
%							H:系统传输函数														%
%							ang:斜模式角度，27or45												%
%							choice_image:0=》模拟图像降采样重建，1=》真实场景图像降采样重建		%
%===============================================================================================%
hr_image				= mat2gray(get_hr_image(N,bound,choice_image));
sigma					= mean(mean(hr_image.^2))/(sqrt(10^(SNR/10)));
hr_image_S				= fftshift(fft2(hr_image));
hr_image_after_MTF_S	= hr_image_S.*H;
hr_image_after_MTF		= mat2gray(abs(ifft2(ifftshift(hr_image_after_MTF_S))));
sampling_image			= mat2gray(hr_image_after_MTF + randn(N)*sigma);
sampling_image			= sample(sampling_image,ang);

%figure;imshow(hr_image);title([num2str(ang),' high resolution image']);
imwrite(hr_image,['./images/',num2str(ang),'_hr_image.bmp']);
%figure;imshow(log10(1+abs(hr_image_S)),[]);title([num2str(ang),' high resolution image spectrum']);
imwrite(mat2gray(log10(1+abs(hr_image_S))),['./images/',num2str(ang),'_hr_image_Spectrum.bmp']);
%figure;imshow(log10(1+abs(hr_image_after_MTF_S)),[]);title([num2str(ang),' high resolution image after MTF spectrum']);
imwrite(mat2gray(log10(1+abs(hr_image_after_MTF_S))),['./images/',num2str(ang),'_hr_image_after_MTF_Spectrum.bmp']);
end

function hr_image = get_hr_image(N,bound,choice_image)
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
	hr_image= imread('./images/real_image/test.bmp');
end
end

function sampling_image = sample(input_image,ang)
%===============================================================================================%
%							对输入图像进行斜模式采样											%
%							input_image：输入图像												%
%							sampling_image：采样图像，没有采样的点补零							%
%===============================================================================================%
[M,N]					= size(input_image);
sampling_image			= zeros(M,N);
if ang == 27
	sampling_image(1:4:M,1:2:N) = input_image(1:4:N,1:2:N);
	sampling_image(3:4:M,2:2:N) = input_image(3:4:M,2:2:N);
elseif ang == 45
	sampling_image(1:2:M,1:2:N) = input_image(1:2:M,1:2:N);
end
end
