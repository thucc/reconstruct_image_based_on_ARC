function index = func_get_all_index(ang)
	hr_image 	= im2double(imread(['images/',num2str(ang),'_img_hr.png']));
	res_image1 	= im2double(imread(['./images/',num2str(ang),'_img','_directly_restore_on_Dopt.png']));
	res_image2 	= im2double(imread(['./images/',num2str(ang),'_img','_directly_restore_on_Dvor.png']));
	res_image3 	= im2double(imread(['./images/',num2str(ang),'_img','_wiener_filter_on_Dopt.png']));
	res_image4 	= im2double(imread(['./images/',num2str(ang),'_img','_wiener_filter_on_Dvor.png']));
	res_image5 	= im2double(imread(['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dopt.png']));
	res_image6 	= im2double(imread(['./images/',num2str(ang),'_img','_wiener_filter_consider_alias_on_Dvor.png']));
	res_image7 	= im2double(imread(['./images/',num2str(ang),'_img','_TV_on_Dopt.png']));
	res_image8 	= im2double(imread(['./images/',num2str(ang),'_img','_TV_on_Dvor.png']));
	res_image9	= im2double(imread(['./images/',num2str(ang),'_img','_interpolation.png']));
	index1 	 	= func_cal_index(res_image1,hr_image);
	index2 	 	= func_cal_index(res_image2,hr_image);
	index3 	 	= func_cal_index(res_image3,hr_image);
	index4 	 	= func_cal_index(res_image4,hr_image);
	index5 	 	= func_cal_index(res_image5,hr_image);
	index6 	 	= func_cal_index(res_image6,hr_image);
	index7 	 	= func_cal_index(res_image7,hr_image);
	index8 	 	= func_cal_index(res_image8,hr_image);
	index9 	 	= func_cal_index(res_image9,hr_image);

	index		= [index1,index2,index3,index4,index7,index8,index9];
end
