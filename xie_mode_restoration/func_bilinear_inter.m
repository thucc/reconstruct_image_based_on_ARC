function func_bilinear_inter(N,ang)
%=======================================================================================================%
%                             双线性插值																%
%							ang:斜模式角度27or45														%
%=======================================================================================================%
	if ang == 27
		sample_image				= im2double(imread('./images/27_sampled_image.bmp'));
	elseif ang ==45
		sample_image				= im2double(imread('./images/45_sampled_image.bmp'));
	end
	[x,y,z]						= find(sample_image);
	[Y,X]						= meshgrid(1:N,1:N);
	method						= 'linear';
	sample_interpolation		= griddata(x,y,z,X,Y,method);
	figure;imshow(sample_interpolation);title([num2str(ang),' sample interpolation']);
	imwrite(sample_interpolation,['./images/',num2str(ang),'_sample_interpolation.bmp']);

end
