clear all;close all;
origin_image = imread('image_to_restoration.bmp');
origin_spec = fft2(origin_image);
aliased_spec = [origin_spec,origin_spec;origin_spec,origin_spec];
plot_spectrum(aliased_spec,'aliased spectrum')

res_image_no_D_opt = ifft2(ifftshift(aliased_spec));
res_image_no_D_opt = uint8(abs(res_image_no_D_opt));
figure;imshow(res_image_no_D_opt);title('restoration image without D\_opt')

D_opt = load('D_opt.mat');
D_opt = D_opt.D_opt;
spec_after_Dopt = aliased_spec.*D_opt;
plot_spectrum(spec_after_Dopt,'spec after Dopt')

res_image = ifft2(ifftshift(spec_after_Dopt));
res_image = abs(res_image)/mean(mean(res_image))*mean(mean(origin_image));
res_image = uint8(res_image);
figure;imshow(res_image);title('restoration image')

