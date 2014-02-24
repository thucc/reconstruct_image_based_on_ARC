clear all;
c = 2*pi;
freq_bound = 6;
H_ccd1 = get_MTF( 0, 0, 0, 0, c, 0, freq_bound );
H_ccd2 = get_MTF( 0, 0.14, 0, 0, c, 0.3, freq_bound );
H_ccd3 = get_MTF( 0, 0.14, -11/180*pi, 2.35*c, c, 0.3, freq_bound );
close all;
%==========================================================================
% theta_alias = 0;
% theta_noise = 20;
% sigma = 0.5;
% F = get_F(freq_bound);
% H = H_ccd3;
% HF = H.*F;
% HF_alias = get_alias(HF.^2);
% HF_main = abs(HF(401:801,401:801));
% a = HF_alias./HF_main;
% b = sigma./HF_main;
% D_opt_alias = 1 - dither(a - theta_alias);
% D_opt_noise = 1 - dither(b - theta_noise);
% D_opt = D_opt_alias.*D_opt_noise;
% a = log10(a);
% b = log10(b);
% imshow(D_opt)
% imshow(D_opt_noise)
% %contour(2:-0.01:-2,-2:0.01:2,D_opt)
%==============================get super mode's reciprocal cell============
theta_alias = 0;
theta_noise = 20;
sigma = 0.5;
F = get_F(freq_bound);
H = H_ccd2;
HF = H.*F;
HF_alias = get_alias_super_mode(HF.^2);
HF_main = abs(HF(401:801,401:801));
a = HF_alias./HF_main;
b = sigma./HF_main;
D_opt_alias = 1 - dither(a - theta_alias);
D_opt_noise = 1 - dither(b - theta_noise);
D_opt = D_opt_alias.*D_opt_noise;
a = log10(a);
b = log10(b);
imshow(D_opt)
imshow(D_opt_noise)