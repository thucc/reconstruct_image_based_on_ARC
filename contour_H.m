H_ccd1_plot = H_ccd1(4*c_f*sample_per_unit+1:8*c_f*sample_per_unit, 4*c_f*sample_per_unit+1:8*c_f*sample_per_unit);
H_ccd2_plot = H_ccd2(4*c_f*sample_per_unit+1:8*c_f*sample_per_unit, 4*c_f*sample_per_unit+1:8*c_f*sample_per_unit);
H_ccd3_plot = H_ccd3(4*c_f*sample_per_unit+1:8*c_f*sample_per_unit, 4*c_f*sample_per_unit+1:8*c_f*sample_per_unit);
figure;[C,h] = contour(linspace(-2*c_f,2*c_f,4*c_f*sample_per_unit),linspace(-2*c_f,2*c_f,4*c_f*sample_per_unit),H_ccd1_plot,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('ccd1');
figure;[C,h] = contour(linspace(-2*c_f,2*c_f,4*c_f*sample_per_unit),linspace(-2*c_f,2*c_f,4*c_f*sample_per_unit),H_ccd2_plot,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('ccd2');
figure;[C,h] = contour(linspace(-2*c_f,2*c_f,4*c_f*sample_per_unit),linspace(-2*c_f,2*c_f,4*c_f*sample_per_unit),H_ccd3_plot,[0.8,0.6,0.4,0.2,0.1,0.01,0,-0.1,-0.2,-0.01,-0.001]);clabel(C,h);title('ccd3');
clear H_ccd1_plot;
clear H_ccd2_plot;
clear H_ccd3_plot;
