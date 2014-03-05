function [a,b,D_opt,HF_alias] = get_adapted_cell(down_factor,N,H,F,sigma,theta_alias,theta_noise)

 	HF = H.*F;
 	HF_alias = zeros(N/down_factor);
 	for ii = 1:N/down_factor:N
 		for jj = 1:N/down_factor:N
 		HF_alias = HF_alias + HF(ii:ii+N/down_factor-1,jj:jj+N/down_factor-1);
 		end
 	end
 	HF_alias = repmat(HF_alias,down_factor,down_factor) - HF;
	HF_alias = abs(HF_alias);
	HF 		 = abs(HF);
 	a = HF_alias./HF;
 	b = sigma./HF;
	b = abs(fftshift(fft2(randn(N)*sigma)))./HF;
 	D_opt_alias = 1 - double((a - theta_alias) > 0);
 	D_opt_noise = 1 - double((b - theta_noise) > 0);
 	D_opt = D_opt_alias.*D_opt_noise;

	plot_a		= log10(a);
	plot_a		= log10(a)-min(min(plot_a));
	plot_a		= plot_a/max(max(plot_a));
	plot_b		= log10(b);
	plot_b		= log10(b)-min(min(plot_b));
	plot_b		= plot_b/max(max(plot_b));
 	figure;subplot(3,2,1);imshow(plot_a);title('relative alias');
		   subplot(3,2,2);imshow(plot_b);title('relative noise');
		   subplot(3,2,3);imshow(D_opt_alias);title('D\_opt\_alias');
		   subplot(3,2,4);imshow(D_opt_noise);title('D\_opt\_noise');
	 	   subplot(3,2,5);imshow(D_opt);title('D\_opt')

end
