clear all;close all;

N						= 400;
bound					= 127;
p						= 2*bound/N;
H						= ones(N);
%H 						= get_MTF( 0, 0.14, -11/180*pi, 2.35*sqrt(5)*(p), sqrt(5)*(p), 0.3, pi/(p), N);
sigma					= 0.05;
sampling_image			= xie_mode_sampling(N,bound,H,sigma);
figure;imshow(sampling_image);title('sampled image(27 degree)')

theta_alias				= 4;
theta_noise				= 3;
F						= get_F(pi/p,N);
[Dopt,a,b]				= get_xie_mode_Dopt(H.*F,sigma,theta_noise,theta_alias);
F_alias					= fftshift(fft2(sampling_image));
figure;imshow(log10(1+abs(F_alias)));title('sample image spectrum')
F_after_Dopt	= F_alias.*Dopt;
figure;imshow(log10(1+abs(F_after_Dopt)));title('sample image spectrum after Dopt')

SNR						= zeros(1,3);
PSNR					= SNR;
[SNR(1),PSNR(1),res_image] = wiener_filter(F_after_Dopt,ones(N),'directly restore on Dopt');
K						= H./(H.^2.*(1+b.^2));
[SNR(2),PSNR(2),res_image] = wiener_filter(F_after_Dopt,K,'wiener filter on Dopt');
K 						= H./(H.^2.*(1+a.^2+b.^2));
[SNR(3),PSNR(3),res_image] = wiener_filter(F_after_Dopt,K,'wiener filter consider alias on Dopt');

%=======================================================================================================%
%                             和常规模式采样作比较														%
%=======================================================================================================%
p_regular				= sqrt(5)*p;
regular_sampling_image  = regular_mode_sampling(p_regular,bound);
figure;imshow(regular_sampling_image);title('regular sampling image');
regular_sampling_image_S= abs(fftshift(fft2(regular_sampling_image)));
figure;imshow(log10(1+regular_sampling_image_S),[]);title('regular sampling image''s spectrum');
%=======================================================================================================%
%                             和45度斜模式采样作比较													%
%=======================================================================================================%
p_45					= sqrt(5/2)*p;
xie_45_sampling_image  = regular_mode_sampling(p_45,bound);
figure;imshow(xie_45_sampling_image);title('xie_45 sampling image');
xie_45_sampling_image_S= abs(fftshift(fft2(xie_45_sampling_image)));
figure;imshow(log10(1+xie_45_sampling_image_S),[]);title('xie_45 sampling image''s spectrum');
