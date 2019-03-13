file=dir('*.mat');
no_file=length(file)
for i=1:no_file
    oldname=file(i).name;
    newname=[num2str(i),'abnormal','.mat'];
    eval(['!rename' 32 oldname 32 newname]);
end  