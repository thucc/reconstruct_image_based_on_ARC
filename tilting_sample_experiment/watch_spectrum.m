close all;clear all;
%tilting_90_image_path   = 'figures/pick_out_center/90_tilting/19.bmp';
%tilting_45_image_path   = 'figures/pick_out_center/45_tilting/25.bmp';
%tilting_27_image_path   = 'figures/pick_out_center/27_tilting/27.bmp';
%digital_cameral_path    = 'figures/pick_out_center/digital_cameral/IMG_5630.bmp';

tilting_90_image_path   = 'figures/pick_out_center/90_tilting/21.bmp';
tilting_45_image_path   = 'figures/pick_out_center/45_tilting/23.bmp';
tilting_27_image_path   = 'figures/pick_out_center/27_tilting/31.bmp';
digital_cameral_path    = 'figures/pick_out_center/digital_cameral/IMG_5630.bmp';

tilting_90_image    = im2double(imread(tilting_90_image_path));
tilting_90_spec     = fftshift(fft2(tilting_90_image));
%figure;imshow((log10(1+abs(tilting_90_spec))));title('90 tilting image spec')
imwrite(log10(1+abs(tilting_90_spec)),'90 spec.png','png')

tilting_45_image    = im2double(imread(tilting_45_image_path));
tilting_45_spec     = fftshift(fft2(tilting_45_image));
%figure;imshow((log10(1+abs(tilting_45_spec))));title('45 tilting image spec')
imwrite(log10(1+abs(tilting_45_spec)),'45 spec.png','png')

tilting_27_image    = im2double(imread(tilting_27_image_path));
tilting_27_spec     = fftshift(fft2(tilting_27_image));
%figure;imshow((log10(1+abs(tilting_27_spec))));title('27 tilting image spec')
imwrite(log10(1+abs(tilting_27_spec)),'60 spec.png','png')

digital_image       = im2double(imread(digital_cameral_path));
digital_spec        = fftshift(fft2(digital_image));
%figure;imshow(mat2gray(log10(1+abs(digital_spec))));title('digital image spec')
imwrite(log10(1+abs(digital_spec)),'digital spec.png','png')
