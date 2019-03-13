%1111111111111111111111111111111111111111111111111111
clc;clear;
add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\normal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\abnormal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\normal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\abnormal\';
subdir=dir([add1,'*mat']);
len=length(subdir);

noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\normal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\abnormal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\normal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\abnormal\');
 if ~exist(noise_add1)
            mkdir(noise_add1);
 end
noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\normal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\abnormal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\normal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\abnormal\');
 if ~exist(noise_add2)
            mkdir(noise_add2);
 end
 
 imgIds={subdir.name}
for i = 1:len
  imgIds{i} = imgIds{i}(1:end-4) ;
end
 
 for i=1:len
    mat_Name=strcat(add1,subdir(i).name);
     y=cell2mat(struct2cell(load(mat_Name)));
     Y=awgn(y,20);               %加噪声,SNR=25
     mat_name=strcat(noise_add1,subdir(i).name)
     mat_na=strcat('Y')
     save(mat_name,mat_na)
      axis on;
     plot(0:0.0028:0.0028*(length(Y)-1),Y,'k','linewidth',3);
      %plot(0:0.0028:0.0028*(length(y)-1),y,'g','linewidth',3);
      ylim([-1,1]);
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   axis off
   imagename=strcat(noise_add2,imgIds{i},'.jpg')
   print('-djpeg',imagename,'-r100');
   i
 end
%222222222222222222222222222222222222222222222222222222222222222222222222222
 clc;clear;
% add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\normal\';
add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\abnormal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\normal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\abnormal\';
subdir=dir([add1,'*mat']);
len=length(subdir);

% noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\normal\');
noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\abnormal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\normal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\abnormal\');
 if ~exist(noise_add1)
            mkdir(noise_add1);
 end
% noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\normal\');
noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\abnormal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\normal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\abnormal\');
 if ~exist(noise_add2)
            mkdir(noise_add2);
 end
 
 imgIds={subdir.name}
for i = 1:len
  imgIds{i} = imgIds{i}(1:end-4) ;
end
 
 for i=1:len
    mat_Name=strcat(add1,subdir(i).name);
     y=cell2mat(struct2cell(load(mat_Name)));
     Y=awgn(y,20);               %加噪声,SNR=25
     mat_name=strcat(noise_add1,subdir(i).name)
     mat_na=strcat('Y')
     save(mat_name,mat_na)
      axis on;
     plot(0:0.0028:0.0028*(length(Y)-1),Y,'k','linewidth',3);
     %hold on
      %plot(0:0.0028:0.0028*(length(y)-1),y,'g','linewidth',3);
      ylim([-1,1]);
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   axis off
   imagename=strcat(noise_add2,imgIds{i},'.jpg')
   print('-djpeg',imagename,'-r100');i
 end
 
 %333333333333333333333333333333333333333333333333333333
   clc;clear;
% add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\normal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\abnormal\';
add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\normal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\abnormal\';
subdir=dir([add1,'*mat']);
len=length(subdir);

% noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\normal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\abnormal\');
noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\normal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\abnormal\');
 if ~exist(noise_add1)
            mkdir(noise_add1);
 end
% noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\normal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\abnormal\');
noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\normal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\abnormal\');
 if ~exist(noise_add2)
            mkdir(noise_add2);
 end
 
 imgIds={subdir.name}
for i = 1:len
  imgIds{i} = imgIds{i}(1:end-4) ;
end
 
 for i=1:len
    mat_Name=strcat(add1,subdir(i).name);
     y=cell2mat(struct2cell(load(mat_Name)));
     Y=awgn(y,20);               %加噪声,SNR=25
     mat_name=strcat(noise_add1,subdir(i).name)
     mat_na=strcat('Y')
     save(mat_name,mat_na)
      axis on;
     plot(0:0.0028:0.0028*(length(Y)-1),Y,'k','linewidth',3);
      %plot(0:0.0028:0.0028*(length(y)-1),y,'g','linewidth',3);
      ylim([-1,1]);
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   axis off
   imagename=strcat(noise_add2,imgIds{i},'.jpg')
   print('-djpeg',imagename,'-r100');i
 end
%444444444444444444444444444444444444444444444444444444444444444444444444444444444444
clc;clear;
% add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\normal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\abnormal\';
%add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\normal\';
add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\testing\abnormal\';
subdir=dir([add1,'*mat']);
len=length(subdir);

% noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\normal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\training\abnormal\');
%noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\normal\');
noise_add1=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\1D_noise\testing\abnormal\');
 if ~exist(noise_add1)
            mkdir(noise_add1);
 end
% noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\normal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\training\abnormal\');
%noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\normal\');
noise_add2=strcat('D:\ECG\ECG资料\ex201705212012\data-10.12\2D_noise\testing\abnormal\');
 if ~exist(noise_add2)
            mkdir(noise_add2);
 end
 
 imgIds={subdir.name}
for i = 1:len
  imgIds{i} = imgIds{i}(1:end-4) ;
end
 
 for i=1:len
    mat_Name=strcat(add1,subdir(i).name);
     y=cell2mat(struct2cell(load(mat_Name)));
     Y=awgn(y,20);               %加噪声,SNR=25
     mat_name=strcat(noise_add1,subdir(i).name)
     mat_na=strcat('Y')
     save(mat_name,mat_na)
      axis on;
     plot(0:0.0028:0.0028*(length(Y)-1),Y,'k','linewidth',3);
      %plot(0:0.0028:0.0028*(length(y)-1),y,'g','linewidth',3);
      ylim([-1,1]);
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   axis off
   imagename=strcat(noise_add2,imgIds{i},'.jpg')
   print('-djpeg',imagename,'-r100');i
 end

