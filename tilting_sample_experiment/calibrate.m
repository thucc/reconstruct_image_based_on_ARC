clear all;close all;
%% L-R scan image calibrate
%% 45 tilting sample image calibrate
figures_path        = 'figures/origin_image/45_tilting/L-R/*.bmp';
origin_images       = dir(figures_path);
origin_images       = {origin_images.name};
image_num           = length(origin_images);
for n = 1 : image_num
    origin_image_path   = cell2mat(origin_images(n));
    origin_image        = imread(['figures/origin_image/45_tilting/L-R/',origin_image_path]);
    origin_image_gray   = origin_image;
    [Rows , Columns]    = size(origin_image_gray);
    calibrated_image    = zeros(Rows , Rows + Columns - 1);
    for r = 1 : Rows
        calibrated_image(r , Rows - r + 1 : Rows - r + Columns) = origin_image_gray(r ,:);
    end
    imwrite(mat2gray(calibrated_image) , ['figures/calibrated_image/45_tilting/',origin_image_path]);
end
%% 63 tilting sample image calibrate
figures_path        = 'figures/origin_image/63_tilting/L-R/*.bmp';
origin_images       = dir(figures_path);
origin_images       = {origin_images.name};
image_num           = length(origin_images);
for n = 1 : image_num
    origin_image_path   = cell2mat(origin_images(n));
    origin_image        = imread(['figures/origin_image/63_tilting/L-R/',origin_image_path]);
    origin_image_gray   = origin_image;
    [Rows , Columns]    = size(origin_image_gray);
    calibrated_image    = zeros(2 * Rows - 1 , Rows - 1 + 2 * Columns -1);
    for r = 1 : Rows
        calibrated_image(2 * r - 1 , Rows - r + 1 : 2 : Rows - r + 1 + 2 * (Columns -1 )) = origin_image_gray(r ,:);
    end
    imwrite(mat2gray(calibrated_image) , ['figures/calibrated_image/27_tilting/',origin_image_path]);
end

%% R-L scan image calibrate
%% 45 tilting sample image calibrate
figures_path        = 'figures/origin_image/45_tilting/R-L/*.bmp';
origin_images       = dir(figures_path);
origin_images       = {origin_images.name};
image_num           = length(origin_images);
for n = 1 : image_num
    origin_image_path   = cell2mat(origin_images(n));
    origin_image        = imread(['figures/origin_image/45_tilting/R-L/',origin_image_path]);
    origin_image_gray   = origin_image;
    [Rows , Columns]    = size(origin_image_gray);
    calibrated_image    = zeros(Rows , Rows + Columns - 1);
    for r = 1 : Rows
        calibrated_image(r , r : r + Columns - 1) = origin_image_gray(r ,:);
    end
    imwrite(mat2gray(calibrated_image) , ['figures/calibrated_image/45_tilting/',origin_image_path]);
end
%% 63 tilting sample image calibrate
figures_path        = 'figures/origin_image/63_tilting/R-L/*.bmp';
origin_images       = dir(figures_path);
origin_images       = {origin_images.name};
image_num           = length(origin_images);
for n = 1 : image_num
    origin_image_path   = cell2mat(origin_images(n));
    origin_image        = imread(['figures/origin_image/63_tilting/R-L/',origin_image_path]);
    origin_image_gray   = origin_image;
    [Rows , Columns]    = size(origin_image_gray);
    calibrated_image    = zeros(2 * Rows - 1, Rows - 1  + 2 * Columns -1);
    for r = 1 : Rows
        calibrated_image(2 * r - 1 , r : 2 : r + 2 * (Columns -1 )) = origin_image_gray(r ,:);
    end
    imwrite(mat2gray(calibrated_image) , ['figures/calibrated_image/27_tilting/',origin_image_path]);
end
