close all;clear all;
f					= im2double(imread('Zone256B.bmp'));
N					= size(f);
N					= N(1);
c					= pi/8;									
c_f     		 	= 2*pi/c;								
freq_bound 			= pi;									
H 					= get_MTF( 0, 0.14, -11/180*pi, 2.35*c, c, 0.3, freq_bound, N);
h					= real(fftshift(ifft2(ifftshift(H))));

F					= fftshift(fft2(f));
F_H					= F.*H;
f_h					= abs(ifft2(ifftshift(F_H)));

sigma				= 0;
noise				= randn(N)*sigma;
f_h_n				= f_h + noise;
fr1					= deconvwnr(f_h_n,h);
figure;imshow(fr1);

sigma				= 0.5;
noise				= randn(N)*sigma;
f_h_n				= f_h + noise;
fr2					= deconvwnr(f_h_n,h);
figure;imshow(fr2);

R					= sigma^2/(sum(sum(f.^2))/N^2);
fr3					= deconvwnr(f_h_n,h,R);
figure;imshow(fr3);

Sn					= abs(fft2(noise)).^2;
nA					= sum(Sn(:))/N^2;
Sf					= abs(fft2(f)).^2;
fA					= sum(Sf(:))/N^2;
R					= nA/fA;
fr4					= deconvwnr(f_h_n,h,R);
figure;imshow(fr4);

NCORR				= fftshift(real(ifft2(Sn)));
ICORR				= fftshift(real(ifft2(Sf)));
fr5					= deconvwnr(f_h_n,h,NCORR,ICORR);
figure;imshow(fr5)

%========================================my own wiener filter=====================
K					= 1./H.*(H.^2./(H.^2 + fftshift(Sn)./fftshift(Sf)));
F_H_N				= fftshift(fft2(f_h_n));
FR					= F_H_N.*K;
fr6					= abs(ifft2(ifftshift(FR)));
figure;imshow(fr6)
