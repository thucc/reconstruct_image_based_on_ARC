close all;clear all; 
%image_path   = 'figures/calibrated_image/45_tilting/23.bmp';
%origin_image = im2double(imread(image_path));
%[Rows,Columns]= size(origin_image);
%image_center = origin_image(411:1180,1191:1960);
%figure;imshow(image_center);
%imwrite(image_center,'figures/pick_out_center/45_tilting/23.bmp');

%image_path   = 'figures/calibrated_image/27_tilting/31.bmp';
%origin_image = im2double(imread(image_path));
%[Rows,Columns]= size(origin_image);
%image_center = origin_image(861:2260,1441:2840);
%%figure;imshow(image_center);
%imwrite(image_center,'figures/pick_out_center/27_tilting/31.bmp');

%image_path   = 'figures/calibrated_image/90_tilting/21.bmp';
%origin_image = im2double(imread(image_path));
%[Rows,Columns]= size(origin_image);
%image_center = origin_image(441:970,221:750);
%figure;imshow(image_center);
%imwrite(image_center,'figures/pick_out_center/90_tilting/21.bmp');

image_path   = 'figures/Digital_cameral_image/IMG_5630.JPG';
origin_image = rgb2gray(imread(image_path));
[Rows,Columns]= size(origin_image);
image_center = origin_image(700:end-413,1369:end-1200);
figure;imshow(image_center);
imwrite(image_center,'figures/pick_out_center/digital_cameral/IMG_5630.bmp');
