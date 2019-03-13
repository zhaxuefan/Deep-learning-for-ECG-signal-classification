
file=dir('*.mat');
no_file=length(file);
y_test=[];
for i=1:no_file    
    [a,b,c]=fileparts(file(i).name);
    pat='abnormal';
    [o11,o22,o33]=regexpi(b,pat,'start','end','match');%输出起始位置和子串
    if strcmpi(o33,pat)==1
        labela=1; 
        y_test=[y_test,labela];
    else
        labelb=0;
        y_test=[y_test,labelb];
    end
end  

y_test=y_test.';
% cc=~y_test;
% % % %dd=zeros(no_file,8)
% y_test=[cc,y_test];