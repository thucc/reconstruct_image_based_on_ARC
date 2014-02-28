clear all;close all;
origin_image = imread('image_to_restoration.bmp');
origin_spec = fft2(origin_image);
aliased_spec = [origin_spec,origin_spec;origin_spec,origin_spec];

res_image_no_D_opt = ifft2(ifftshift(aliased_spec));
res_image_no_D_opt = uint8(abs(res_image_no_D_opt));
figure;imshow(res_image_no_D_opt);title('restoration image without D\_opt')

D_opt = load('D_opt.mat');
D_opt = D_opt.D_opt;
spec_after_Dopt = aliased_spec.*D_opt;

H = load('H.mat');
H = H.H;
b = load('b.mat');
b = b.b;
a = load('a.mat');
a=a.a;
K = H./(H.^2.*(1+a.^2+b.^2));

res_image = ifft2(ifftshift(spec_after_Dopt.*K));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('restoration image with wiener filter')
