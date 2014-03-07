clear all;close all;
params 						= load('params.mat');
down_factor 				= params.down_factor;						%降采样倍数
N 							= params.N;									%频域上一个方向总的采样点数				
origin_hr_image 			= params.origin_hr_image;					%原始高分辨率图像	
%=======================================================获得原始图像的频谱==============================================
origin_hr_spec 				= fftshift(fft2(origin_hr_image));
figure;imshow(origin_hr_image);title('origin high resolution image');
figure;imshow(log10(1+abs(origin_hr_spec)));title('origin high resolution image''s spec');
%=======================================================获取降质图像====================================================
%(1)获得系统的调制传输函数MTF
H 							= params.H;
%(2)原始高分辨率图像经过MTF的作用
hr_image_after_MTF_spec 	= origin_hr_spec.*H;
hr_image_after_MTF 			= abs(ifft2(ifftshift(hr_image_after_MTF_spec)));
figure;imshow(hr_image_after_MTF);title('image after MTF');
%(3)降采样
image_down_sample 			= hr_image_after_MTF(1:down_factor:N,1:down_factor:N);
figure;imshow(image_down_sample);title('image after MTF and down sampling')
%(4)加噪声
sigma 						= params.sigma;
noise 						= randn(N/down_factor)*sigma;
image_with_noise 			= image_down_sample + noise;
figure;imshow(image_with_noise);title('image with nose')

imwrite(image_with_noise,'./images/image_to_reconstruct.bmp','bmp');
