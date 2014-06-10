orig_path = 'reconstruct/images/origin_image/25.bmp';
Dopt_path = 'reconstruct/images/45_img_TV_on_Dopt.png';
Dvor_path = 'reconstruct/images/45_img_TV_on_Dvor.png';

orig = imread(orig_path);
Dopt = imread(Dopt_path);
Dvor = imread(Dvor_path);

expand_orig = orig(120:225,550:655);
imwrite(expand_orig,'reconstruct/images/expand_origin_image.png')
expand_Dopt = Dopt(240:450,1100:1310);
imwrite(expand_Dopt,'reconstruct/images/expand_TV_Dopt.png')
expand_Dvor = Dvor(240:450,1100:1310);
imwrite(expand_Dvor,'reconstruct/images/expand_TV_Dvor.png')
