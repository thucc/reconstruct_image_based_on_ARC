function func_bilinear_inter(sample_image,ang)
    N   = size(sample_image,1);
    if ang == 45
        temp = zeros(2*N);
        temp(1:2:2*N,1:2:2*N) = sample_image;
        sample_image = temp;
    end
	[x,y,z]						= find(sample_image);
    N                           = size(sample_image,1);
	[Y,X]						= meshgrid(1:N,1:N);
	method						= 'cubic';
	sample_interpolation		= mat2gray(griddata(x,y,z,X,Y,method));
	imwrite(sample_interpolation,['./images/',num2str(ang),'_interpolation.png']);
end
