xx=imread('1.jpg'); %读入一张有颜色的图片
xxgray=rgb2gray(xx);     %将其转换为灰度值
cmap=colormap;            %获得当前色谱
xxcolormap=rgb2ind(xx,cmap); %将xx转换为0~1的色彩值，备用
xxgray=double(xxgray);   %这两个值原本为unit8类型数值
xxcolormap=double(xxcolormap);  %而mesh需要double类型，故转一下类型
figure
mesh(xxgray,xxcolormap);   %这样就得到一张有灰度决定高低，原图颜色覆盖的三维图了