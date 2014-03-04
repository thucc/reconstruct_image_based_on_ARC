function [a,b,D_opt] = get_adapted_cell(down_factor,N,H,F,sigma,theta_alias,theta_noise)

 	HF = H.*F;
 	HF_alias = zeros(N/down_factor);
 	for ii = 1:N/down_factor:N
 		for jj = 1:N/down_factor:N
 		HF_alias = HF_alias + HF(ii:ii+N/down_factor-1,jj:jj+N/down_factor-1);
 		end
 	end
 	HF_alias = repmat(HF_alias,down_factor,down_factor) - HF;
 	a = HF_alias./HF;
 	b = sigma./HF;
 	D_opt_alias = 1 - double((a - theta_alias) > theta_alias);
 	D_opt_noise = 1 - double((b - theta_noise) > theta_noise);
 	D_opt = D_opt_alias.*D_opt_noise;
 	figure;subplot(2,2,1);imshow(a);title('relative alias');
		   subplot(2,2,2);imshow(b);title('relative noise');
		   subplot(2,2,3);imshow(D_opt);title('D\_opt')

end
