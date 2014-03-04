clear all;close all;
params 						= load('params.mat');
down_factor 				= params.down_factor;
origin_image 				= imread('./images/image_to_reconstruct.bmp');
origin_spec 				= fft2(origin_image);
aliased_spec 				= repmat(origin_spec,down_factor,down_factor);
origin_hr_image				= params.origin_hr_image;
D_opt 						= params.D_opt;
N							= params.N;
figure;imshow(uint8(origin_hr_image));title('origin high resolution image');

spec_after_Dvor			 	= zeros(N);
main_value_range 			= 1+N*(down_factor-1)/(2*down_factor):N*(down_factor+1)/(2*down_factor);
spec_after_Dvor(main_value_range,main_value_range) ...,
							= aliased_spec(main_value_range,main_value_range);
plot_spectrum(spec_after_Dvor,'spec\_after\_Dvor');
spec_after_Dopt 			= aliased_spec.*D_opt;
plot_spectrum(spec_after_Dopt,'spec\_after\_Dopt');
SNR							=zeros(6,1);
PSNR						=zeros(6,1);
%=======================直接逆变换========================================================================
[SNR(1),PSNR(1)]			= wiener_filter(spec_after_Dvor,ones(N), ... 
											origin_hr_image,origin_image,'directly reconstructed image on D\_vor');
[SNR(2),PSNR(2)]			= wiener_filter(spec_after_Dopt,ones(N), ... 
											origin_hr_image,origin_image,'directly reconstructed image on D\_opt');
%%======================维纳滤波==========================================================================
H 							= params.H;
b 							= params.b;
K 							= H./(H.^2.*(1+b.^2));
[SNR(3),PSNR(3)]			= wiener_filter(spec_after_Dvor,K, ... 
											origin_hr_image,origin_image,'reconstructed image with wiener filter on D\_vor');
[SNR(4),PSNR(4)]			= wiener_filter(spec_after_Dopt,K, ... 
											origin_hr_image,origin_image,'reconstructed image with wiener filter on D\_opt');
%======================考虑混叠的维纳滤波================================================================
a 							= params.a;
K 							= H./(H.^2.*(1+a.^2+b.^2));
[SNR(5),PSNR(5)]			= wiener_filter(spec_after_Dvor,K, ... 
											origin_hr_image,origin_image,'reconstructed image with wiener filter(consider alias) on D\_vor');
[SNR(6),PSNR(6)]			= wiener_filter(spec_after_Dopt,K, ... 
											origin_hr_image,origin_image,'reconstructed image with wiener filter(consider alias) on D\_opt');
