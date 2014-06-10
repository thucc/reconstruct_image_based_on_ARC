function F  = func_F_morph(spec_sam)
    [M,N]   = size(spec_sam);

    abs_spec_sam = abs(spec_sam);
    abs_spec_sam = log10(1+abs_spec_sam);
    abs_spec_sam = mat2gray(abs_spec_sam);
    abs_spec_sam  = medfilt2(abs_spec_sam,[4,4]);
    bw_spec_sam  = im2bw(abs_spec_sam,graythresh(abs_spec_sam));
    bw_spec_sam  = imclose(bw_spec_sam,strel('disk', 2));
    bw_spec_sam  = medfilt2(bw_spec_sam,[4,4]);

    L = bwlabel(bw_spec_sam);
    stats = regionprops(L,'centroid','Area');
    centroids = cat(1,stats.Centroid);
    L_select = ismember(L,find([stats.Area] > 0.04*N*N));
    F = L_select;

    figure;imshow(L);hold on; plot(centroids(:,1),centroids(:,2),'+r')
    figure;imshow(bw_spec_sam)
    figure;imshow(L_select)
end
