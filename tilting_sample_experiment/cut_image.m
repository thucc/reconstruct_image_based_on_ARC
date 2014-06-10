%function img_cut    = cut_image(origin_image)
%    [Rows , Columns] = size(origin_image);
%    for c = 1:Columns-1
%        temp = origin_image(:,c) - origin_image(:,c+1);
%        temp = sum(abs(temp)>2);
%        if temp > 5
%            break
%        end
%    end
%    start_c = c;
%    for c = Columns : -1 : 2
%        temp = origin_image(:,c) - origin_image(:,c-1);
%        temp = sum(abs(temp)>2);
%        if temp > 80
%            break
%        end
%    end
%    end_c = c;
%    img_cut = origin_image(:,start_c:end_c);
%end


    close all;clear all;
    image_path      = 'figures/quanse_bmp/21.bmp';
    origin_image    = imread(image_path);
    origin_image    = rgb2gray(origin_image);
    [Rows , Columns]    = size(origin_image);
    for c = 1:Columns-1
        temp = origin_image(:,c) - origin_image(:,c+1);
        temp = sum(abs(temp)>2);
        if temp > 40
            break
        end
    end
    start_c = c;
    for c = Columns : -1 : 2
        temp = origin_image(:,c) - origin_image(:,c-1);
        temp = sum(abs(temp)>2);
        if temp > 50
            break
        end
    end
    end_c = c;
    img_cut = origin_image(:,start_c:end_c);
    figure;imshow(origin_image);
    figure;imshow(img_cut);
    imwrite(img_cut , 'figures/origin_image/21.bmp');
