function F = func_get_F(choice_F,freq_bound,N)

if choice_F	== 0
	xi  		= linspace(-freq_bound,freq_bound,N)+eps;
	eta 		= linspace(freq_bound,-freq_bound,N)+eps;
	F 			= (N/5)*(kron((eta.^2)',ones(1,N)) + kron(xi.^2,ones(N,1))).^(-0.8);
elseif choice_F	== 1
	hr_image	= im2double(imread('./images/27_hr_image.bmp'));
	F			= abs(fftshift(fft2(hr_image)));
elseif choice_F == 2
	hr_image_45	= im2double(imread('./images/45_hr_image.bmp'));
	F 			= abs(fftshift(fft2(hr_image_45)));
end

end
