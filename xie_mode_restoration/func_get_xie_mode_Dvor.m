function Dvor = func_get_xie_mode_Dvor(N,ang)
%===================================================================%
%					获取斜模式采样的Dvor							%
%					N:倒易晶包的大小								%
%					ang:斜模式角度，27or45							%
%===================================================================%

Dvor		= zeros(N);
if ang == 27
	x			= linspace(-1,1,N);
	y			= linspace(-1,1,N);
	for ii = 1:N
		for jj = 1:N
			if(x(ii) > -5/8 && x(ii) < -3/8)
				if(abs(y(jj)) < 2*(x(ii)+5/8))
					Dvor(jj,ii) = 1;
				end
			elseif(x(ii) > -3/8 && x(ii) < 3/8)
				if(abs(y(jj)) <  0.5)
					Dvor(jj,ii) = 1;
				end
			elseif(x(ii) > 3/8 && x(ii) < 5/8)
				if(abs(y(jj)) < -2*(x(ii)-5/8))
					Dvor(jj,ii) = 1;
				end
			end
		end
	end
elseif ang == 45
	Dvor(floor(N/4)+1:floor(N/4)+N/2,floor(N/4)+1:floor(N/4)+N/2) = 1;
end
end
