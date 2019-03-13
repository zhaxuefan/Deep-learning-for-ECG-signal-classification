
file=dir('*.mat');
% vector=[];
x_test=[];
% for i=1:length(file)
%     c=cell2mat(struct2cell(load(file(i).name)));
%     l=length(c);
%     vector=[vector;l];
%     
% end
%max_num=max(vector);
max_num=820;
for i=1:length(file)
    c=cell2mat(struct2cell(load(file(i).name)));
    if length(c)<max_num
        c=[c,zeros(1,max_num-length(c))];
    else
        c=c;
    end
    x_test=[x_test;c];
end

