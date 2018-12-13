newf2=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\images\');
mkdir(newf2);
for i=1:(length(R_peak)-2)
    %i=96
    Pitdata=strcat(newf,'A',num2str(i),'_',NUM,'.mat')
    f=cell2mat(struct2cell(load(Pitdata)));
    axis on;
     plot(f(1,:),   f(2,:),'k','linewidth',3)
   ylim([-1,1]);
   %ylim([-2.6,2.2]);xlim([0,0.8])
   %set(gcf,'PaperUnits','inches','PaperPosition',[0 0 7 9])
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   %set(gcf,'unit','centimeters','position',[3 5 7 5])
   %set(gca,'Position',[.1 0.05 0.9 0.9]);
   axis off
   %imagename=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\images\',['A',num2str(i)],'.jpg')
   imagename=strcat(newf2,['A',num2str(i)],'_',NUM,'.jpg')
   %myFileName=['A',num2str(i),'.jpg']
   print('-djpeg',imagename,'-r100');
end

annot(:,length(annot))=[];annot(:,1)=[];
annotation=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\','annotation',NUM,'_1');
annota=strcat('annot');
save(annotation,annota);
         

