function sampling_image = xie_mode_sampling(N,bound,H,sigma)
%===============================================================================================%
%							斜模式采样函数														%
%							N：采样点数目														%
%							bound:图像范围,-bound:p:bound的长度应为4的倍数						%
%							H:系统传输函数														%
%===============================================================================================%

hr_image				= get_hr_image(N,bound);
imwrite(hr_image,'./images/hr_image.bmp','bmp');
figure;imshow(hr_image);title('high resolution image');

hr_image_S				= fftshift(fft2(hr_image));
figure;imshow(log10(1+abs(hr_image_S)),[]);title('high resolution image spectrum');
hr_image_after_MTF_S	= hr_image_S.*H;
figure;imshow(log10(1+abs(hr_image_after_MTF_S)),[]);title('high resolution image after MTF spectrum');
hr_image_after_MTF		= abs(ifft2(ifftshift(hr_image_after_MTF_S)));
hr_image_after_MTF		= (hr_image_after_MTF - min(min(hr_image_after_MTF)))/(max(max(hr_image_after_MTF))-min(min(hr_image_after_MTF)));

sampling_image			= hr_image_after_MTF + randn(N)*sigma;
sampling_image			= mat2gray(sampling_image);
sampling_image			= sample(sampling_image);
end

function hr_image = get_hr_image(N,bound)
%===============================================================================================%
%       					获取高分辨率图像，近似认为是原始连续图像							%
%							N：采样点数目														%
%							bound:图像范围														%
%===============================================================================================%
	x1		= linspace(-bound,bound,N)';			
	x1		= repmat(x1,1,N);				%水平方向坐标
	x2		= x1';							%垂直方向坐标
	hr_image= uint8(127.5 + 127.5 * cos((1440./pi) ./ (1 + 512./sqrt(8 * (x1.^2 + x2.^2)))));
end

function sampling_image = sample(input_image)
%===============================================================================================%
%							对输入图像进行斜模式采样											%
%							input_image：输入图像												%
%							sampling_image：采样图像，没有采样的点补零							%
%===============================================================================================%
[M,N]					= size(input_image);
sampling_image			= zeros(M,N);
sampling_image(1:4:M,1:2:N) = input_image(1:4:N,1:2:N);
sampling_image(3:4:M,2:2:N) = input_image(3:4:M,2:2:N);
end
