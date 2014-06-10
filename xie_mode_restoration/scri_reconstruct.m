clear all;close all;
choice_H					= 1;								%为0表示选择理想MTF，为1表示选择实际的MTF
choice_F					= 0;								%0=》统计模型；1=》27度斜模式采样真实频谱；2=》45度斜模式采样真实频谱;3=》从采样图像谱中得到真实F的近似
choice_image				= 1;								%0=>对模拟生成图像降采样，1=》对现实场景图像降采样
image_path					= './images/real_image/new_test4.bmp';
N							= 180;								%采样点数目
bound						= 500;								%采样的空间范围
if choice_image == 1
	N		= min(size(imread(image_path)));
end
SNR							= 48;								%信噪比，db为单位
theta_alias					= 0.2;
theta_noise					= 5;
%ang							= 27;
ang							= 45;
rec_or_hex_27				= 'hex';
func_reconstruct(N,bound,SNR,choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path,rec_or_hex_27,0.6,0.1)
%func_bilinear_inter(N,ang);
index = func_get_all_index(ang)


%SNR = 48:-2:10
%l   = length(SNR);
%PSNR = zeros(l,7);
%PSNR(:,1) = SNR';
%mssim = PSNR;
%for ii=1:l
%    func_reconstruct(N,bound,SNR(ii),choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path,rec_or_hex_27,0.6,0.1)
%    index = func_get_all_index(ang);
%    PSNR(ii,2:7) = index(1,:);
%    mssim(ii,2:7) = index(2,:);
%end

%beta = 0.1:0.1:1;
%l = length(beta);
%PSNR = zeros(l,7);
%PSNR(:,1) = beta';
%mssim = PSNR;
%for ii=1:l
%    func_reconstruct(N,bound,48,choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path,rec_or_hex_27,beta(ii),0.1)
%    index = func_get_all_index(ang);
%    PSNR(ii,2:7) = index(1,:);
%    mssim(ii,2:7) = index(2,:);
%end
%alpha = 0.1:0.1:1;
%l = length(alpha);
%PSNR = zeros(l,7);
%PSNR(:,1) = alpha';
%mssim = PSNR;
%for ii=1:l
%    func_reconstruct(N,bound,48,choice_H,choice_F,theta_alias,theta_noise,ang,choice_image,image_path,rec_or_hex_27,0.6,alpha(ii))
%    index = func_get_all_index(ang);
%    PSNR(ii,2:7) = index(1,:);
%    mssim(ii,2:7) = index(2,:);
%end
%figure;hold on;plot(SNR,mssim(:,2));plot(SNR,mssim(:,3),'r');xlabel('SNR(db)');ylabel('mssim');legend('D_{vor} wiener filter','D_{opt} wiener filter');
%figure;hold on;plot(SNR,mssim(:,4));plot(SNR,mssim(:,5),'r');xlabel('SNR(db)');ylabel('mssim');legend('D_{vor} wiener filter consider alias','D_{opt} wiener filter consider alias');
%figure;hold on;plot(SNR,mssim(:,6));plot(SNR,mssim(:,7),'r');xlabel('SNR(db)');ylabel('mssim');legend('D_{vor} TV','D_{opt} TV');
