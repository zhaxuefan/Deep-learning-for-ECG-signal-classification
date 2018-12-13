annot(:,length(annot))=[];annot(:,1)=[];
annotation=strcat('D:\ECG\ECG资料\ex201705212012\channel1_single\',NUM,'\','annotation',NUM,'_1')
annota=strcat('annot')
save(annotation,annota);
annot(:,length(annot))=[];annot(:,1)=[];
annotation=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\','annotation',NUM,'_1');
annota=strcat('annot');
save(annotation,annota);
         