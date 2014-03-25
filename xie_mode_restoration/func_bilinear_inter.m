function func_bilinear_inter(N,ang)
%=======================================================================================================%
%                             双线性插值																%
%							ang:斜模式角度27or45														%
%=======================================================================================================%
	if ang == 27
		sample_image			= im2double(imread('./images/27_sampled_image.bmp'));
	elseif ang ==45
		sample_image			= im2double(imread('./images/45_sampled_image.bmp'));
	end
	[x,y,z]						= find(sample_image);
	[Y,X]						= meshgrid(1:N,1:N);
	method						= 'linear';
	sample_interpolation		= mat2gray(griddata(x,y,z,X,Y,method));

	K							= load('data_K.mat');
	sample_inter_spec			= fftshift(fft2(sample_interpolation));
	[PSNR(1),mssim(1),res_image1] = func_wiener_filter(sample_inter_spec,1,[num2str(ang),'_interpolation'],ang);
	[PSNR(2),mssim(2),res_image2] = func_wiener_filter(sample_inter_spec,K.K1,[num2str(ang),'_interpolation_wiener_filter'],ang);
	[PSNR(3),mssim(3),res_image3] = func_wiener_filter(sample_inter_spec,K.K2,[num2str(ang),'_interpolation_wiener_filter_consider_alias'],ang);

	PSNR
	mssim
	%figure;imshow(sample_interpolation);title([num2str(ang),' sample interpolation']);
	imwrite(sample_interpolation,['./images/',num2str(ang),'_sample_interpolation.bmp']);

	imwrite(res_image2,['./images/',num2str(ang),'_interpolation_wiener_filter.bmp']);
	imwrite(res_image3,['./images/',num2str(ang),'_interpolation_wiener_filter_consider_alias.bmp']);
end
