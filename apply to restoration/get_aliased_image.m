clear all;close all;
down_factor = 8;												%降采样倍数
N = 512;												%频域上一个方向总的采样点数				
%=======================================================获得原始图像的频谱==============================================
lena = double(imread('lena.bmp'));
lena_spec = fftshift(fft2(lena));
plot_spectrum(lena_spec,'origin lena spec')
%=======================================================获取降质图像====================================================
%(1)获得系统的调制传输函数MTF
c = pi;													%感光源尺寸
c_f = 2*pi/c;											%频域一个晶包的边长
freq_bound = pi;										%初步计算的频率范围为-freq_bound:freq_bound
H_ccd3 = get_MTF( 0, 0.14, -11/180*pi, 2.35*c, c, 0.3, freq_bound, N);%成像设备运动的传输函数
figure;[C,h] = contour(linspace(-pi,pi,N),linspace(-pi,pi,N),H_ccd3,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('ccd3');
%(2)原始高分辨率图像经过MTF的作用
lena_after_H_spec = lena_spec.*H_ccd3;
lena_after_H = abs(ifft2(ifftshift(lena_after_H_spec)));
figure;imshow(uint8(lena_after_H));title('lena after MTF')
%(3)降采样
lena_down_sample = lena_after_H(1:down_factor:N,1:down_factor:N);
figure;imshow(uint8(lena_down_sample));title('lena down sampling')
%(4)加噪声
sigma = 0.5;
noise = randn(N/down_factor)*sigma;
lena_with_noise = lena_down_sample + noise;
figure;imshow(uint8(lena_with_noise));title('lena with nose')

imwrite(uint8(lena_with_noise),'image_to_restoration.bmp','bmp');
