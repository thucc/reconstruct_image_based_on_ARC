close all;clear all;
c           = 1;                %感光源尺寸
L           = 10;               %线阵长度
y_length    = 10;               %推帚方向扫描长度
%%常规模式采样
theta       = 0.5*pi;
x_length    = L * sin(theta);
p           = c * sin(theta);   %空间网格宽度
x           = 0:p:x_length;
y           = 0:p:y_length;
figure;hold on;axis equal;
[X,Y] = meshgrid(x,y);
plot(X,Y,'rd')
axis([0 x_length 0 y_length])
plot(x,ones(1,length(x)))
annotation('arrow',[0.5 0.5],[0.19 0.39],'LineStyle','-','color',[0 0 0],'HeadStyle','plain');
saveas(gcf,'regular_sampling.png','png')
%%27度斜模式采样
theta       = atan(0.5);
x_length    = L * sin(theta);
p           = c * sin(theta);   %空间网格宽度
x           = 0:p:x_length;
y           = 0:p:y_length;
[X,Y] = meshgrid(x,y);
figure;hold on;axis equal; axis([0 x_length 0 y_length])
plot(X,Y,'gx')
for ii = 0:p:y_length
    y = 2*x + 4*ii;
    plot(x,y,'rd')
    y = 2*x - 4*ii;
    plot(x,y,'rd')
end
plot(x,2*x)
annotation('arrow',[0.5 0.5],[0.42 0.62],'LineStyle','-','color',[0 0 0],'HeadStyle','plain');
saveas(gcf,'27_tilting.png','png')
%%45度斜模式采样
theta       = 45*pi/180;
x_length    = L * sin(theta);
p           = c * sin(theta);   %空间网格宽度
x           = 0:p:x_length;
y           = 0:p:y_length;
[X,Y] = meshgrid(x,y);
figure;hold on;axis equal; axis([0 x_length 0 y_length])
for ii = 0:p:y_length
    y = x + ii;
    plot(x,y,'rd')
    y = x - ii;
    plot(x,y,'rd')
end
plot(x,x)
annotation('arrow',[0.5 0.5],[0.38 0.58],'LineStyle','-','color',[0 0 0],'HeadStyle','plain');
saveas(gcf,'45_tilting.png','png')
