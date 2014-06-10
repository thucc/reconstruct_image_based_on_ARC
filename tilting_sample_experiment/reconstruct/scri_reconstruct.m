clear all;close all;
image_path					= './images/origin_image/25.bmp';
sample_image                = im2double(imread(image_path));

SNR							= 48;								%信噪比，db为单位
choice_H					= 1;								%为0表示选择理想MTF，为1表示选择实际的MTF
theta_alias					= 0.2;
theta_noise					= 5;
ang							= 45;
func_reconstruct(sample_image,SNR,choice_H,theta_alias,theta_noise,ang)
%func_bilinear_inter(sample_image,ang);

%sample_image_90             = im2double(imread('./images/origin_image/19.bmp'));
%sample_spec_90              = fftshift(fft2(sample_image_90));
%imwrite(mat2gray(log(1+abs(sample_spec_90))),'./images/90_spec_sample.png');
%sample_image_45             = im2double(imread('./images/origin_image/25.bmp'));
%sample_spec_45              = fftshift(fft2(sample_image_45));
%imwrite(mat2gray(log(1+abs(sample_spec_45))),'./images/45_spec_sample.png');
