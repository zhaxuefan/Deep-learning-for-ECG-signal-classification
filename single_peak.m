j=1;annot=[];%annot(1,:)=注释横坐标（去除值为28的点），annot(2,:)=注释值
for i=1:length(ANNOTD)
    if ANNOTD(i)~=28&ANNOTD(i)~=14
        annot(1,(j))=ATRTIMED(i);
        annot(2,(j))=ANNOTD(i);
        j=j+1;
    end
end
M_map = sortdata(M(:,1));
k=1;R_peak=[];TIME_M=[];%TIME_M矩阵用于存放心电波形的横纵坐标
TIME_M(1,:)=TIME(:);
TIME_M(2,:)=M_map;
%TIME_M(2,:)=M(:,1);
index=[];
for i=1:length(annot)
    for j=1:length(TIME_M)
        if TIME_M(1,(j))==annot(1,(i))
        [c,t]=max(TIME_M(2,(j-5):(j+5)));
        R_peak(1,k)=TIME_M(1,(j-6+t));
        R_peak(2,k)=c;
       index(k)=j-26+t;%峰值点在TIME_M中的序号
       k=k+1;
        end
        continue;
    end
end
%以前一个波峰为起点，后一个波峰为终点，截取中间QRS波
k=1;
for j=2:length(R_peak)-1
     for i=1:length(TIME_M)
     if i==index(j)
         %str=strcat('A',num2str(k))
         %Ak=zeros(2,480);
         %Ak(1,:)=TIME_M(1,1:480);
         d1=index(j)-index(j-1);d2=index(j+1)-index(j);
         x1=index(j)-round(0.5*d1);x2=index(j)+round(0.5*d2);
        % l=length(TIME_M(x1:x2));
         %t=round(0.5*length(TIME_M(x1:x2)));
        %Ak(1,(300-t):(299-t+length(TIME_M(index(j-1):index(j+1)))))= TIME_M(1,(index(j-1):index(j+1)));
         Ak=[];
         Ak(2,:)= TIME_M(2,(x1:x2));
         Ak(1,:)=TIME_M(1,1:length(Ak));
         assignin('base',['A',num2str(k)],Ak); 
         k=k+1;
     end
     end
 end
newf=strcat('F:\classification\channel1_single\',NUM,'\data\');
mkdir(newf);
 for i=1:(length(R_peak)-2)
savefile=strcat('A',num2str(i));
file=strcat(newf,['A',num2str(i),'_',NUM,'_1'])
save(file,savefile);
end

 
newf2=strcat('F:\classification\channel1_single\',NUM,'\images\');
mkdir(newf2);
for i=1:(length(R_peak)-2)
    Pitdata=strcat(newf,'A',num2str(i),'_',NUM,'_1','.mat')
    f=cell2mat(struct2cell(load(Pitdata)));
    axis on;
     plot(f(1,:),f(2,:),'k','linewidth',3)
   ylim([-1,1])
   %ylim([-2.6,2.2]);xlim([0,0.8])
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 7 9])
   %set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   %set(gcf,'unit','centimeters','position',[3 5 7 5])
   %set(gca,'Position',[.025 0 1 1]);
   axis off
   imagename=strcat(newf2,['A',num2str(i)],'_',NUM,'_1','.jpg')
   %myFileName=['A',num2str(i),'.jpg']
   print('-djpeg',imagename,'-r100');
end

annot(:,length(annot))=[];annot(:,1)=[];
annotation=strcat('F:\classification\channel1_single\',NUM,'\','annotation',NUM,'_1');
annota=strcat('annot');
save(annotation,annota);



  
     

