function [D_opt,a,b] = get_xie_mode_Dopt(HF,sigma,theta_noise,theta_alias)
%===============================================================================================%
%							获取27度斜模式采样的最优倒易晶包									%
%							HF：MTF.*F															%
%							sigma:噪声标准差													%
%							theta_noise:噪声阈值，超过该阈值的区域不属于最优倒易晶包			%
%							theta_alias:混叠阈值，超过该阈值的区域不属于最优倒易晶包			%
%===============================================================================================%
	aliased_spec	= get_xie_mode_alias(HF);
	N				= size(HF);
	N				= N(1);
	a				= abs(aliased_spec - HF)./abs(HF);
	b				= sigma*N./abs(HF); 
	D_opt_alias		= double(a < theta_alias);
	D_opt_noise		= double(b < theta_noise);
	D_opt			= D_opt_alias.*D_opt_noise;
	figure;	subplot(3,2,1);imshow(log10(1+a),[]);title('relative alias');
   			subplot(3,2,2);imshow(log10(1+b),[]);title('relative noise');
			subplot(3,2,3);imshow(D_opt_alias,[]);title('D opt alias');
   			subplot(3,2,4);imshow(D_opt_noise,[]);title('D opt noise');
   			subplot(3,2,5);imshow(D_opt,[]);title('Dopt');
end
function aliased_spec = get_xie_mode_alias(HF)
%===============================================================================================%
%							获取27度斜模式采样的混叠谱											%
%===============================================================================================%
	[M,N] 			= size(HF);
	A				= HF(1:0.25*M,1:0.5*N);
	B				= HF(1:0.25*M,0.5*N+1:N);
	C				= HF(0.25*M+1:0.5*M,1:0.5*N);
	D				= HF(0.25*M+1:0.5*M,0.5*N+1:N);
	E				= HF(0.5*M+1:0.75*M,1:0.5*N);
	F				= HF(0.5*M+1:0.75*M,0.5*N+1:N);
	G				= HF(0.75*M+1:M,1:0.5*N);
	H				= HF(0.75*M+1:M,0.5*N+1:N);
	
	temp1			= A+D+E+H;
	temp2			= B+C+F+G;
	aliased_spec	= repmat([temp1,temp2;temp2,temp1],2,1);
end
