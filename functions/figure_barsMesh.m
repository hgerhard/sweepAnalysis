
close all;
x = 0:0.1:8*pi;
y = sin(x);
y2 = double(y>0);

zz = repmat(y2,[round(length(y2)/2) 1]);

[xx,yy] = meshgrid(1:length(y2),1:length(y2));

figure; surf(zz)
%colormap([0 0 0])
colormap gray
axis on
%view()