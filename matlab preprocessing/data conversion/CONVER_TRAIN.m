file=dir('*.jpg');
x_test=[];
for i=1:length(file)
    picture=file(i).name;
    b=imread(picture);
    b=rgb2gray(b);
    b1=imresize(b,[250,250]);
    A1=reshape(b1,1,62500);
    x_test=[x_test;A1];
end
