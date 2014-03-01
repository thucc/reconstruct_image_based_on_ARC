clear all;close all;
params						= load('params.mat');
origin_image				= imread('image_to_reconstruct.bmp');
origin_spec 				= fft2(origin_image);
down_factor					= params.down_factor;
aliased_spec 				= repmat(origin_spec,down_factor,down_factor);

D_opt 						= params.D_opt;
spec_after_Dopt 			= aliased_spec.*D_opt;
U_0 						= abs(ifft2(ifftshift(spec_after_Dopt)));
U_0 						= U_0/mean(mean(U_0))*mean(mean(origin_image));
figure;imshow(uint8(U_0));title('U\_0 initial restoration image');

H 							= params.H;
W 							= H.*D_opt;
step 						= 0.2;
iter 						= 10;
U 							= U_0;
chi 						= 10;
for i = 1:iter
	U_0_spec 				= fftshift(fft2(U_0));
	U_spec 					= fftshift(fft2(U));
	temp 					= W'.*(U_0_spec - W.*U_spec);
	temp 					= abs(ifft2(ifftshift(temp)));
	
	[gra_U_x, gra_U_y] 		= gradient(U);
	[div_gra_U_x,null] 		= gradient(gra_U_x);
	[null,div_gra_U_y] 		= gradient(gra_U_y);
	div_gra_U 				= div_gra_U_x + div_gra_U_y;
	
	norm_gra_U 				= sum(sum((abs(gra_U_x) + abs(gra_U_y))));
	flow 					= chi/(norm_gra_U^2)*div_gra_U + temp;
	U 						= U + step*flow;
end

U 							= U/mean(mean(U))*mean(mean(origin_image));
figure;imshow(uint8(U));title('restoration image with TV')
