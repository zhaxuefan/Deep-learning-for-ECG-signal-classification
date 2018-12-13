
%寻找r波以及进行标注
ECG_1=val;
plot(val)
threshold=400;
TIME1=1:9000
for i=1:9000
    if ECG_1(i)>threshold
     ECG_2(i)=ECG_1(i);
    else 
     ECG_2(i)=0;
    end
end    
max=imregionalmax(ECG_2);
YLOC=1:size(ECG_2,2);
maxloc=YLOC(max)
for i=1:length(maxloc)
     ecgvalue(i)=ECG_2(maxloc(i))
 end
hold on
plot(maxloc,ecgvalue,'or')
tt=TIME1(maxloc);
figure
for i=2:length(ecgvalue)
    rrtime(i-1)=tt(i)-tt(i-1);
    x1(i-1)=tt(i)-round(0.5*rrtime(i-1));
    x2(i-1)=tt(i)+round(0.5*rrtime(i-1));
end
newf='F:\MIT数据处理\training2017\img';
for i=1:length(x1)
     img=ECG_1(x1(i):x2(i))
     m=plot(img)
     axis off
     saveas(m,strcat('A',num2str(i),'.jpg'))
     %savefile=strcat('A',num2str(i));
     %file=strcat(newf,['A',num2str(i)])
     %save(file,savefile);
end

