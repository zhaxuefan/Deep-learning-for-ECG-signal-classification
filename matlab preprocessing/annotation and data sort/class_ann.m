clc;clear;
channel='F:\ECG\classification\channel1_single\208';
%subdir=dir(channel);
%len=length(subdir);
nor=strcat('F:\ECG\classification\answer\','normal');
        if ~exist(nor)
            mkdir(nor);
        end
type1=strcat('F:\ECG\classification\answer\','type1');
        if ~exist(type1)
            mkdir(type1);
        end
type2=strcat('F:\ECG\classification\answer\','type2');
        if ~exist(type2)
            mkdir(type2);
        end
type3=strcat('F:\ECG\classification\answer\','type3');
        if ~exist(type3)
            mkdir(type3);
        end
type4=strcat('F:\ECG\classification\answer\','type4');
        if ~exist(type4)
            mkdir(type4);
        end
abnor=strcat('F:\ECG\classification\answer\','abnormal');
        if ~exist(abnor)
            mkdir(abnor);
        end
imaged=strcat('F:\ECG\classification\channel1_single\208\images');
imdir=dir(imaged);
anname=strcat(channel,'\','annotation208_1','.mat');
an=cell2mat(struct2cell(load(anname)));
ann=an(2,:);
for j=1:length(ann)
    m=ann(j)
    imagename=strcat(imaged,imdir(j).name);
    if m==1
    copyfile(imagename,nor);
    elseif m==2
    copyfile(imagename,type1);
    elseif m==3
    copyfile(imagename,type2);
    elseif m==5
    copyfile(imagename,type3);
    elseif m==8
    copyfile(imagename,type4);
    else
    copyfile(imagename,abnor);
    end
end
  
    