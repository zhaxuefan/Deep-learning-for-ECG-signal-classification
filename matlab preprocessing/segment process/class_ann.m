clc;clear;
channel='D:\ECG\ECG资料\ex201705212012\class\';
subdir=dir(channel);
len=length(subdir);
nor=strcat('D:\ECG\ECG资料\ex201705212012\answer\','normal');
        if ~exist(nor)
            mkdir(nor);
        end
abnor=strcat('D:\ECG\ECG资料\ex201705212012\answer\','abnormal');
        if ~exist(abnor)
            mkdir(abnor);
        end
for i=3:len
    imaged=strcat('D:\ECG\ECG资料\ex201705212012\class\',subdir(i).name,'\images\');
    imdir=dir(imaged);
    anname=strcat(channel,subdir(i).name,'\','annotation',subdir(i).name,'_1','.mat');
    an=cell2mat(struct2cell(load(anname)));
    ann=an(2,:);
    for j=1:length(ann)
        imagename=strcat(imaged,imdir(j+2).name);
        if ann~=1
        copyfile(imagename,abnor);
        else
        copyfile(imagename,nor);
        end
    end
end 
  
    