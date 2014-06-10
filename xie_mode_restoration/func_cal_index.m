function index = func_cal_index(res_image,hr_image)
    [h,w] = size(res_image);
    b_row = 5;
    b_col = 5;
    res_image = res_image(b_row+1:h-b_row,b_col+1:w-b_col);
    hr_image = hr_image(b_row+1:h-b_row,b_col+1:w-b_col);
	index = [func_PSNR(res_image,hr_image);func_ssim(res_image,hr_image)];
end

function PSNR	= func_PSNR(res_image,hr_image)
	[M,N]				= size(hr_image);
	noise_power			= sum(sum((hr_image-res_image).^2));
	PSNR				= 10*log10(1^2*M*N/noise_power);
end

function mssim	= func_ssim(image1,image2,K)
%input: image1	=>	the first image to be compared
%		image2	=>	the second image to be compared
%		K		=>	constants in SSIM index formula,default value:K=[0.01,0.03]
%output:mssim	=>	the mean SSIM index value between 2 images.
%       If one of the images being compared is regarded as perfect quality, then mssim can be considered as the quality measure of the other image.
%       If image1 = image2, then mssim = 1.

	if (nargin < 2 || nargin > 3)
		mssim = -Inf
		return
	end
	if (nargin == 2)
		K		= [0.01,0.03];
	end
	[M,N] 	= size(image1);
	len		= 11;
	mssim	= 0;
	for ii = 1+len:len:M
		for jj = 1+len:len:N
			mssim = mssim + ssim(image1(ii-len:ii-1,jj-len:jj-1),image2(ii-len:ii-1,jj-len:jj-1),K);
		end
	end
	mssim = mssim/(length(1+len:len:M)*length(1+len:len:N));
end

function re = ssim(x,y,K)
	ux	= mean(mean(x));
	uy	= mean(mean(y));
	sigma2_x	= mean(mean((x-ux).^2));
	sigma2_y	= mean(mean((y-uy).^2));
	sigma_xy	= mean(mean((x-ux).*(y-uy)));

	c1		  	= K(1).^2;
	c2			= K(2).^2;
	c3			= c2/2;

	L			= (2*ux*uy+c1)/(ux^2+uy^2+c1);
	C			= (2*sqrt(sigma2_x*sigma2_y)+c2)/(sigma2_x+sigma2_y+c2);
	S			= (sigma_xy+c3)/(sqrt(sigma2_x*sigma2_y)+c3);

	re			= L*C*S;
end
