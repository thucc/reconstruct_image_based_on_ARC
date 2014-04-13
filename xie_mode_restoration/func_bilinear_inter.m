function func_bilinear_inter(N,ang)
%=======================================================================================================%
%input:																									%
%                           双线性插值																	%
%							ang:斜模式角度27or45														%
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
	sample_inter_spec			= fftshift(fft2(sample_interpolation));

	imwrite(mat2gray(log10(1+abs(sample_inter_spec))),['./images/',num2str(ang),'_spec','_interpolation.png']);
	imwrite(sample_interpolation,['./images/',num2str(ang),'_img','_interpolation.png']);
end
