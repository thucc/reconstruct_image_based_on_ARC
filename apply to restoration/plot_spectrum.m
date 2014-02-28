function plot_spectrum(image_fft,description)
% image_fft:	图像的FFT
% description:	figure上显示的标题描述信息

image_spec = abs(image_fft+eps);
image_spec= log(image_spec);
min_value = min(min(image_spec));
max_value = max(max(image_spec));
image_spec = (image_spec-min_value)/(max_value-min_value);
figure;
imshow(image_spec)
title(description)

end 
