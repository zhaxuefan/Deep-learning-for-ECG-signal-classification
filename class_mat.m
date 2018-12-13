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
    imaged=strcat('D:\ECG\ECG资料\ex201705212012\class\',subdir(i).name,'\data\');
    imdir=dir(imaged);
    anname=strcat(channel,subdir(i).name,'\','annotation',subdir(i).name,'_2','.mat');
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

clc;clear
channel_a='D:\ECG\ECG资料\ex201705212012\answer\abnormal\';
subdir_a=dir(channel_a);  
len=length(subdir_a);
for i=3:len
data=strcat('D:\ECG\ECG资料\ex201705212012\answer\abnormal\',subdir_a(i).name);  
data_an=cell2mat(struct2cell(load(data)));
data_an(1,:)=[];
data_a=strcat('data_an')
save(data,data_a);
end
clc;clear
channel_b='D:\ECG\ECG资料\ex201705212012\answer\normal\';
subdir_b=dir(channel_b);  
len=length(subdir_b);
for i=3:len
data_n=strcat('D:\ECG\ECG资料\ex201705212012\answer\normal\',subdir_b(i).name);  
data_nor=cell2mat(struct2cell(load(data_n)));
data_nor(1,:)=[];
data_no=strcat('data_nor')
save(data_n,data_no);
end
