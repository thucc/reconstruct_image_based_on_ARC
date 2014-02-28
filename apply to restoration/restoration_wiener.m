clear all;close all;
down_factor = 8;											%降采样倍数
origin_image = imread('image_to_restoration.bmp');
origin_spec = fft2(origin_image);
aliased_spec = repmat(origin_spec,down_factor,down_factor);
%======================不经过自适应倒易晶包，直接在频谱外补零，傅里叶逆变换得到恢复图像==================
[origin_size,origin_size] = size(origin_image);
origin_spec_zero_padding = zeros(origin_size*down_factor);
main_value_range = 1+origin_size*(down_factor/2-0.5):origin_size*(down_factor/2+0.5);
origin_spec_zero_padding(main_value_range,main_value_range) = fftshift(origin_spec);
res_image_no_D_opt = ifft2(ifftshift(origin_spec_zero_padding));
res_image_no_D_opt = abs(res_image_no_D_opt)/mean(mean(res_image_no_D_opt))*mean(mean(origin_image));
res_image_no_D_opt = uint8(res_image_no_D_opt);
figure;imshow(res_image_no_D_opt);title('directly reconstructed image on D\_vor')
%======================混叠谱经过自适应倒易晶包,然后傅里叶逆变换得到恢复图像=============================
D_opt = load('D_opt.mat');
D_opt = D_opt.D_opt;
spec_after_Dopt = aliased_spec.*D_opt;
res_image = ifft2(ifftshift(spec_after_Dopt));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('directly reconstructed image on D\_opt')
%======================维纳滤波==========================================================================
H = load('H.mat');
H = H.H;
b = load('b.mat');
b = b.b;
K = H./(H.^2.*(1+b.^2));
% (1): 在经典倒易晶包上做维纳滤波
res_image = ifft2(ifftshift(origin_spec_zero_padding));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('reconstructed image with wiener filter on D\_vor')
% (2): 在自适应倒易晶包上做维纳滤波
res_image = ifft2(ifftshift(spec_after_Dopt.*K));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('reconstructed image with wiener filter on D\_opt')
%======================考虑混叠的维纳滤波================================================================
a = load('a.mat');
a=a.a;
K = H./(H.^2.*(1+a.^2+b.^2));
% (1): 在经典倒易晶包上做维纳滤波
res_image = ifft2(ifftshift(origin_spec_zero_padding));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('reconstructed image with wiener filter(consider alias) on D\_vor')
% (2): 在自适应倒易晶包上做维纳滤波
res_image = ifft2(ifftshift(spec_after_Dopt.*K));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('reconstructed image with wiener filter(consider alias) on D\_opt')

