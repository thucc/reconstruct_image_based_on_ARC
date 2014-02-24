clear all;
c = 2*pi;												%感光源尺寸
c_f = 2*pi/c;											%频域一个晶包的边长
freq_bound = 6*c_f;										%初步计算的频率范围为-freq_bound:freq_bound
sample_per_unit = 100;									%频率域上单位长度用100个采样点表示
N = 2*freq_bound*sample_per_unit;						%频域上一个方向总的采样点数				
H_ccd1 = get_MTF( 0, 0, 0, 0, c, 0, freq_bound, N);		%理想光学系统，成像设备静止的传输函数
H_ccd2 = get_MTF( 0, 0.14, 0, 0, c, 0.3, freq_bound, N);%光学系统不理想的传输函数
H_ccd3 = get_MTF( 0, 0.14, -11/180*pi, 2.35*c, c, 0.3, freq_bound, N);%成像设备运动的传输函数
contour_H;												%画出上面3种情况下H的等高线
%==========================================================================
theta_alias = 0;
theta_noise = 20;
sigma = 0.5;
F = get_F(freq_bound,N);
H = H_ccd3;
HF = H.*F;
i_shift = -N:sample_per_unit:N;
j_shift = -N:sample_per_unit:N;
HF_alias = get_alias(HF.^2, i_shift, j_shift);
HF_alias = HF_alias(4*c_f*sample_per_unit+1:8*c_f*sample_per_unit, 4*c_f*sample_per_unit+1:8*c_f*sample_per_unit);
HF_main = abs(HF(4*c_f*sample_per_unit+1:8*c_f*sample_per_unit, 4*c_f*sample_per_unit+1:8*c_f*sample_per_unit));
a = HF_alias./HF_main;
b = sigma./HF_main;
D_opt_alias = 1 - dither(a - theta_alias);
D_opt_noise = 1 - dither(b - theta_noise);
D_opt = D_opt_alias.*D_opt_noise;
a = log10(a);
b = log10(b);
imshow(D_opt)
%==============================get super mode's reciprocal cell============
%theta_alias = 0;
%theta_noise = 20;
%sigma = 0.5;
%F = get_F(freq_bound);
%H = H_ccd2;
%HF = H.*F;
%HF_alias = get_alias_super_mode(HF.^2);
%HF_main = abs(HF(401:801,401:801));
%a = HF_alias./HF_main;
%b = sigma./HF_main;
%D_opt_alias = 1 - dither(a - theta_alias);
%D_opt_noise = 1 - dither(b - theta_noise);
%D_opt = D_opt_alias.*D_opt_noise;
%a = log10(a);
%b = log10(b);
%imshow(D_opt)
%imshow(D_opt_noise)
