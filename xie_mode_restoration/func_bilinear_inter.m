function index = func_bilinear_inter(N,ang)
%=======================================================================================================%
%input:																									%
%                           双线性插值																%
%							ang:斜模式角度27or45														%
%output:																								%
%							index:插值结果和真实参考图像的比较结果，包括PSNR和ssim						%
%=======================================================================================================%
	if ang == 27
		sample_image			= im2double(imread('./images/27_img_sample.png'));
	elseif ang ==45
		sample_image			= im2double(imread('./images/45_img_sample.png'));
	end
	[x,y,z]						= find(sample_image);
	[Y,X]						= meshgrid(1:N,1:N);
	method						= 'cubic';
	sample_interpolation		= mat2gray(griddata(x,y,z,X,Y,method));

	avg_sample_image			= mean(mean(sample_image))*4;

	K							= load('data_K.mat');
	sample_inter_spec			= fftshift(fft2(sample_interpolation));
	[PSNR(1),mssim(1),res_image1] = func_wiener_filter(sample_inter_spec,1,ang,avg_sample_image);
%	[PSNR(2),mssim(2),res_image2] = func_wiener_filter(sample_inter_spec,K.K1,ang,avg_sample_image);
%	[PSNR(3),mssim(3),res_image3] = func_wiener_filter(sample_inter_spec,K.K2,ang,avg_sample_image);
%	res_image2_spec				= fftshift(fft2(res_image2));
%	res_image3_spec				= fftshift(fft2(res_image3));

	index						= [PSNR;mssim];

	imwrite(mat2gray(log10(1+abs(sample_inter_spec))),['./images/',num2str(ang),'_spec','_interpolation.png']);
%	imwrite(mat2gray(log10(1+abs(res_image2_spec))),['./images/',num2str(ang),'_spec','_interpolation_wiener_filter.png']);
%	imwrite(mat2gray(log10(1+abs(res_image3_spec))),['./images/',num2str(ang),'_spec','_interpolation_wiener_filter_consider_alias.png']);

	imwrite(sample_interpolation,['./images/',num2str(ang),'_img','_interpolation.png']);
%	imwrite(res_image2,['./images/',num2str(ang),'_img','_interpolation_wiener_filter.png']);
%	imwrite(res_image3,['./images/',num2str(ang),'_img','_interpolation_wiener_filter_consider_alias.png']);
end
