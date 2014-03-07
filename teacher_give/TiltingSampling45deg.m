clear;
close all;
%%
% x1 = -256: 255;
% x2 =  -256: 255;
% [X2, X1] = meshgrid(x2, x1);
tic
p = 2;
% M = 10; N = 32;
M = 1023; N = 512;
O1 = [(N - 1) + (M - 1)] / 2; O2 = (N - 1) / 2; 
f = @(x1, x2) 127.5 + 127.5 * cos((1440./pi) ./ (1 + 512./sqrt(8 * ((x1 - O1).^2 + (x2 - O2).^2))));
% f = 127.5 + 127.5 * cos((1440/pi) / (1 + 512/sqrt(8 * (x1^2 + x2^2))));
%%
 x = []; y = []; z = [];
% e1 = [4p, 0]'; e2 = [2p, p]';

% v1_max = [(M - 1) + (N - 1)] * p; v2_max = (N - 1) * p;
for n1 = 0 : (M - 1) / p;
    for n2 = 0 : (N - 1) / p;
        %         n1, n2
        v1 = (n1 + n2) * p; v2 = n2 * p;
        I(v1 / p + 1, v2 / p + 1) = ( quad2d(f, v1, v1 + p, @(x1) (x1 - (v1 + p)) + v2, @(x1) - (x1 - (v1 + p)) + v2)  + ...
            quad2d(f, v1 - p, v1, @(x1) - (x1 - (v1 - p)) + v2, @(x1) (x1 - (v1 - p)) + v2) )/(2 * p^2);
        x = [x, v1 / p]; y = [y v2 / p];
        z = [z I(v1 / p + 1, v2 / p + 1)];
    end
end
imwrite(uint8(I), ['45 degree tilting mode sampling p = ', num2str(p), '.bmp'])
% xi = [0 : v1_max / p]; yi = [0 : v2_max / p];
% [Yi, Xi] = meshgrid( yi, xi);
% method = 'cubic';
% Zi = griddata(x, y, z, Xi, Yi, method);
% imwrite(uint8(Zi), ['45 degree tilting mode sampling_interpolated image p = ', num2str(p), method, '.bmp'])
t = toc;
%%
TSamp = uint8(I);
CroppedTSamp = TSamp( (N - 1) /p : (M - 1) / p, :);
imwrite(CroppedTSamp, ['45 degree tilting mode sampling_cropped p = ', num2str(p) '.bmp']);
[F,G] = FFTSpectrum(CroppedTSamp);
imwrite(G, ['45 degree tilting mode sampling_shifted FFT spetrum p = ', num2str(p) '.bmp'])

% Img = uint8(Zi);
% CroppedImg = Img( (N - 1) : (M - 1), :);
% imwrite(CroppedImg, ['45 degree tilting mode sampling_cropped interpolated image p = ', num2str(p), method, '.bmp']);
% [F,G] = FFTSpectrum(CroppedImg);
% imwrite(G, ['45 degree tilting mode sampling_interpolated image_shifted FFT spetrum p = ', num2str(p), method, '.bmp'])