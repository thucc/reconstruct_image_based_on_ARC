function func_quad_sample(bound,N)
%=======================================================================================================%
%                             积分采样																	%
%=======================================================================================================%
%	image_27		= quad_sample(bound,N,0);
%	imwrite(image_27,'./images/quad_sample_27.bmp','bmp');
%	image_45		= quad_sample(bound,round(N*sqrt(2/5)),1);
%	imwrite(image_45,'./images/quad_sample_45.bmp','bmp');
	image_reg		= quad_sample(bound,round(N*sqrt(1/5)),2);
	imwrite(image_reg,'./images/quad_sample_reg.bmp','bmp');
end

function I = quad_sample(bound,N,choice)
%===========================================================================================================%
%							对像元所在的一个邻域积分作为该像元的灰度值，不是理想采样						%
%							bound:图像范围																	%
%							N:像素个数																		%
%							method:采样方式，0：27度斜模式;1：45度斜模式;2：常规模式						%
%===========================================================================================================%
p 			= 	bound/N;			%像素间距
O			= 	(bound - 1)/2; 		%对称中心
f = @(x1, x2) 127.5 + 127.5 * cos((1440./pi) ./ (1 + 512./sqrt(8 * ((x1 - O).^2 + (x2 - O).^2))));
I = zeros(N);
if choice == 0
	for n1 = 1 : 4 : N;
	    for n2 = 1 : 2: N;
	        v1 = n1 * p; v2 = n2 * p;
	        I(n1 , n2 ) = ( quad2d(f, v1 - 1.5 *p, v1 - 0.5 * p, @(x1) -2 * (x1 - (v1 - 1.5 * p)) + (v2 + 0.5 * p), @(x1) 0.5 * (x1 - (v1 - 1.5 * p)) + (v2 + 0.5 * p))  + ...
	            quad2d(f, v1 - 0.5 *p, v1 + 0.5 * p, @(x1) 0.5 * (x1 - (v1 - 0.5 * p)) + (v2 - 1.5 * p), @(x1) 0.5 * (x1 - (v1 + 0.5 * p)) + (v2 + 1.5 * p)) + ...
	            quad2d(f,  v1 + 0.5 *p, v1 + 1.5 * p, @(x1) 0.5 * (x1 - (v1 + 1.5 * p)) + (v2 - 0.5 * p), @(x1) -2 * (x1 - (v1 + 1.5 * p)) + (v2 - 0.5 * p)) )/(5 * p^2);
	    end
	end
	for n1 = 3 : 4 : N;
	    for n2 = 2 : 2: N;
	        v1 = n1 * p; v2 = n2 * p;
	        I(n1, n2) = ( quad2d(f, v1 - 1.5 *p, v1 - 0.5 * p, @(x1) -2 * (x1 - (v1 - 1.5 * p)) + (v2 + 0.5 * p), @(x1) 0.5 * (x1 - (v1 - 1.5 * p)) + (v2 + 0.5 * p))  + ...
	            quad2d(f, v1 - 0.5 *p, v1 + 0.5 * p, @(x1) 0.5 * (x1 - (v1 - 0.5 * p)) + (v2 - 1.5 * p), @(x1) 0.5 * (x1 - (v1 + 0.5 * p)) + (v2 + 1.5 * p)) + ...
	            quad2d(f,  v1 + 0.5 *p, v1 + 1.5 * p, @(x1) 0.5 * (x1 - (v1 + 1.5 * p)) + (v2 - 0.5 * p), @(x1) -2 * (x1 - (v1 + 1.5 * p)) + (v2 - 0.5 * p)) )/(5 * p^2);
	    end
	end
elseif choice == 1
	for n1 = 1 : N;
	    for n2 = 1 : N;
	        v1 = n1 * p; v2 = n2 * p;
	        I(n1 , n2 ) = ( quad2d(f, v1, v1 + p, @(x1) (x1 - (v1 + p)) + v2, @(x1) - (x1 - (v1 + p)) + v2)  + ...
	            quad2d(f, v1 - p, v1, @(x1) - (x1 - (v1 - p)) + v2, @(x1) (x1 - (v1 - p)) + v2) )/(2 * p^2);
	    end
	end
else
	for n1 = 1 : N;
	    for n2 = 1 : N;
	        v1 = n1 * p; v2 = n2 * p;
	        I(n1 , n2 ) = ( quad2d(f, v1 - 0.5*p, v1 + 0.5*p, v2 - 0.5*p, v2 + 0.5*p))/(p^2);
	    end
	end
end
I = mat2gray(I);
end
