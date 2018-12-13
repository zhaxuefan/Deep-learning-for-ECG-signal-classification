clc;
clear;

%------ SPECIFY DATA ------------------------------------------------------
PATH = strcat(pwd,'\MIT_BIH_ECG_DATA'); % path, where data are saved
NUM = '234';
HEADERFILE = strcat('\hea\', NUM, '.hea'); % header-file in text format
ATRFILE = strcat('\atr\', NUM, '.atr'); % attributes-file in binary format
DATAFILE = strcat('\dat\', NUM,'.dat'); % data-file
SAMPLES2READ = 30000; % number of samples to be read
                      % in case of more than one signal:
                      % 2*SAMPLES2READ samples are read

%------ LOAD HEADER DATA --------------------------------------------------
fprintf(1,'\\n$> WORKING ON %s ...\n', HEADERFILE); % fprintf
signalh = fullfile(PATH, HEADERFILE); % fullfile
fid1 = fopen(signalh,'r'); % fopen
z = fgetl(fid1); % fgetl
A = sscanf(z, '%*s %d %d %d',[1,3]); 
nosig = A(1); % number of signals
sfreq = A(2); % sample rate of data
clear A;
for k = 1:nosig
    z = fgetl(fid1);
    A = sscanf(z, '%*s %d %d %d %d %d',[1,5]);
    dformat(k)= A(1); % format; here only 212 is allowed
    gain(k)= A(2); % number of integers per mV
    bitres(k)= A(3); % bitresolution
    zerovalue(k)= A(4); % integer value of ECG zero point
    firstvalue(k)= A(5); % first integer value of signal (to test for errors)
end;
fclose(fid1);
clear A;

%------ LOAD BINARY DATA --------------------------------------------------
if dformat ~= [212, 212]
    error('this script does not apply binary formats different to 212.');
end
signald = fullfile(PATH, DATAFILE); % data in format 212
fid2 = fopen(signald,'r');
A = fread(fid2, [3, SAMPLES2READ], 'uint8')'; % matrix with 3 rows, each 8 bits long, = 2*12bit
fclose(fid2);
M2H = bitshift(A(:,2), -4); % bitshift
M1H = bitand(A(:,2), 15); % bitand
PRL = bitshift(bitand(A(:,2),8),9); % sign-bit
PRR = bitshift(bitand(A(:,2),128),5); % sign-bit
M( : , 1) = bitshift(M1H,8)+ A(:,1)-PRL;
M( : , 2) = bitshift(M2H,8)+ A(:,3)-PRR;
if M(1,:) ~= firstvalue
    error('inconsistency in the first bit values');
end
switch nosig
case 2
    M( : , 1) = (M( : , 1)- zerovalue(1))/gain(1);
    M( : , 2) = (M( : , 2)- zerovalue(2))/gain(2);
    TIME =(0:(SAMPLES2READ - 1)) / sfreq;
case 1
    M( : , 1)= (M( : , 1)- zerovalue(1));
    M( : , 2)= (M( : , 2)- zerovalue(1));
    M=M';
    M(1)=[];
    sM=size(M);
    sM=sM(2)+1;
    M(sM)=0;
    M=M';
    M=M/gain(1);
    TIME=(0:2*(SAMPLES2READ)-1)/sfreq;
otherwise % this case did not appear up to now!
    % here M has to be sorted!!!
    disp('Sorting algorithm for more than 2 signals not programmed yet!');
end;
clear A M1H M2H PRR PRL;
fprintf(1,'\\n$> LOADING DATA FINISHED \n');

%------ LOAD ATTRIBUTES DATA ----------------------------------------------
atrd = fullfile(PATH, ATRFILE); % attribute file with annotation data
fid3 = fopen(atrd,'r');
A = fread(fid3, [2, inf], 'uint8')';
fclose(fid3);
ATRTIME = [];
ANNOT = [];
sa = size(A);
saa = sa(1);
i = 1;
while i <= saa
   %while i<=3 
    annoth = bitshift(A(i,2),-2);
    if annoth == 59
        ANNOT = [ANNOT;bitshift(A(i+3,2),-2)];
        ATRTIME = [ATRTIME;A(i+2,1)+bitshift(A(i+2,2),8)+...
                bitshift(A(i+1,1),16)+bitshift(A(i+1,2),24)];
        i = i + 3;
    elseif annoth == 60
        % nothing to do!
    elseif annoth == 61
        % nothing to do!
    elseif annoth == 62
        % nothing to do!
    elseif annoth == 63
        hilfe = bitshift(bitand(A(i,2),3),8) + A(i,1);
        hilfe = hilfe + mod(hilfe,2);
        i = i + hilfe / 2;
    else
        ATRTIME = [ATRTIME;bitshift(bitand(A(i,2),3),8)+A(i,1)];
        ANNOT = [ANNOT;bitshift(A(i,2),-2)];
   end;
   i = i + 1;
end;
ANNOT(length(ANNOT))=[];       % last line = EOF (=0)
ATRTIME(length(ATRTIME))=[];   % last line = EOF
clear A;
ATRTIME= (cumsum(ATRTIME))/sfreq;
ind= find(ATRTIME <= TIME(end));
ATRTIMED= ATRTIME(ind);
ANNOT=round(ANNOT);
ANNOTD= ANNOT(ind);

%NORMAL 1	/* normal beat */ 
%PVC 5	/* premature ventricular contraction */
%RHYTHM	28	/* rhythm change */
%找QRS波峰值点，在每一个注释点（不等于28）左右（正负15个点）找，横坐标纵坐标分别存放R_peak矩阵中

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
        [c,t]=max(TIME_M(2,(j-25):(j+25)));
        R_peak(1,k)=TIME_M(1,(j-26+t));
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
        %Ak=zeros(2,960);
         %Ak(1,:)=TIME_M(1,1:960);
         %x1=index(j-1);x2=index(j+1);
         %l=length(TIME_M(x1:x2));
         %t=round(0.5*l);
         %Ak(1,(300-t):(299-t+length(TIME_M(index(j-1):index(j+1)))))= TIME_M(1,(index(j-1):index(j+1)));
         %Ak(2,(480-t):(479-t+l))= TIME_M(2,(x1:x2));
         Ak=[];
         Ak(2,:)=TIME_M(2,((index(j-1):index(j+1))));
         Ak(1,:)=TIME_M(1,1:length(Ak));
         assignin('base',['A',num2str(k)],Ak); 
         k=k+1;
     end
     end
end
newf=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\data\');
mkdir(newf);
 for i=1:(length(R_peak)-2)
savefile=strcat('A',num2str(i));
file=strcat(newf,['A',num2str(i),'_',NUM,'_1'])
save(file,savefile);
end
  e=1
newf2=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\images\');
mkdir(newf2);
for i=1:(length(R_peak)-2)
    Pitdata=strcat(newf,'A',num2str(i),'_',NUM,'_1','.mat')
    f=cell2mat(struct2cell(load(Pitdata)));
    axis on;
     plot(f(1,:),f(2,:),'k','linewidth',3)
   ylim([-1,1])
   %ylim([-2.6,2.2]);xlim([0,0.8])
   %set(gcf,'PaperUnits','inches','PaperPosition',[0 0 7 9])
   set(gcf,'PaperUnits','inches','PaperPosition',[0 0 14 10])
   %set(gcf,'unit','centimeters','position',[3 5 7 5])
   %set(gca,'Position',[.05 0.05 1 1]);
   axis off
   %imagename=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\images\',['A',num2str(i)],'.jpg')
   imagename=strcat(newf2,['A',num2str(i)],'_',NUM,'_1','.jpg')
   %myFileName=['A',num2str(i),'.jpg']
   print('-djpeg',imagename,'-r100');
end

annot(:,length(annot))=[];annot(:,1)=[];
annotation=strcat('D:\ECG\ECG资料\ex201705212012\channel1\',NUM,'\','annotation',NUM,'_1');
annota=strcat('annot');
save(annotation,annota);
         

%------ SPECIFY DATA ------------------------------------------------------
PATH = strcat(pwd,'\MIT_BIH_ECG_DATA'); % path, where data are saved
HEADERFILE = strcat('\hea\', NUM, '.hea'); % header-file in text format
ATRFILE = strcat('\atr\', NUM, '.atr'); % attributes-file in binary format
DATAFILE = strcat('\dat\', NUM,'.dat'); % data-file
SAMPLES2READ = 30000; % number of samples to be read
                      % in case of more than one signal:
                      % 2*SAMPLES2READ samples are read

%------ LOAD HEADER DATA --------------------------------------------------
fprintf(1,'\\n$> WORKING ON %s ...\n', HEADERFILE); % fprintf
signalh = fullfile(PATH, HEADERFILE); % fullfile
fid1 = fopen(signalh,'r'); % fopen
z = fgetl(fid1); % fgetl
A = sscanf(z, '%*s %d %d %d',[1,3]); 
nosig = A(1); % number of signals
sfreq = A(2); % sample rate of data
clear A;
for k = 1:nosig
    z = fgetl(fid1);
    A = sscanf(z, '%*s %d %d %d %d %d',[1,5]);
    dformat(k)= A(1); % format; here only 212 is allowed
    gain(k)= A(2); % number of integers per mV
    bitres(k)= A(3); % bitresolution
    zerovalue(k)= A(4); % integer value of ECG zero point
    firstvalue(k)= A(5); % first integer value of signal (to test for errors)
end;
fclose(fid1);
clear A;

%------ LOAD BINARY DATA --------------------------------------------------
if dformat ~= [212, 212]
    error('this script does not apply binary formats different to 212.');
end
signald = fullfile(PATH, DATAFILE); % data in format 212
fid2 = fopen(signald,'r');
A = fread(fid2, [3, SAMPLES2READ], 'uint8')'; % matrix with 3 rows, each 8 bits long, = 2*12bit
fclose(fid2);
M2H = bitshift(A(:,2), -4); % bitshift
M1H = bitand(A(:,2), 15); % bitand
PRL = bitshift(bitand(A(:,2),8),9); % sign-bit
PRR = bitshift(bitand(A(:,2),128),5); % sign-bit
M( : , 1) = bitshift(M1H,8)+ A(:,1)-PRL;
M( : , 2) = bitshift(M2H,8)+ A(:,3)-PRR;
if M(1,:) ~= firstvalue
    error('inconsistency in the first bit values');
end
switch nosig
case 2
    M( : , 1) = (M( : , 1)- zerovalue(1))/gain(1);
    M( : , 2) = (M( : , 2)- zerovalue(2))/gain(2);
    TIME =(0:(SAMPLES2READ - 1)) / sfreq;
case 1
    M( : , 1)= (M( : , 1)- zerovalue(1));
    M( : , 2)= (M( : , 2)- zerovalue(1));
    M=M';
    M(1)=[];
    sM=size(M);
    sM=sM(2)+1;
    M(sM)=0;
    M=M';
    M=M/gain(1);
    TIME=(0:2*(SAMPLES2READ)-1)/sfreq;
otherwise % this case did not appear up to now!
    % here M has to be sorted!!!
    disp('Sorting algorithm for more than 2 signals not programmed yet!');
end;
clear A M1H M2H PRR PRL;
fprintf(1,'\\n$> LOADING DATA FINISHED \n');

%------ LOAD ATTRIBUTES DATA ----------------------------------------------
atrd = fullfile(PATH, ATRFILE); % attribute file with annotation data
fid3 = fopen(atrd,'r');
A = fread(fid3, [2, inf], 'uint8')';
fclose(fid3);
ATRTIME = [];
ANNOT = [];
sa = size(A);
saa = sa(1);
i = 1;
while i <= saa
   %while i<=3 
    annoth = bitshift(A(i,2),-2);
    if annoth == 59
        ANNOT = [ANNOT;bitshift(A(i+3,2),-2)];
        ATRTIME = [ATRTIME;A(i+2,1)+bitshift(A(i+2,2),8)+...
                bitshift(A(i+1,1),16)+bitshift(A(i+1,2),24)];
        i = i + 3;
    elseif annoth == 60
        % nothing to do!
    elseif annoth == 61
        % nothing to do!
    elseif annoth == 62
        % nothing to do!
    elseif annoth == 63
        hilfe = bitshift(bitand(A(i,2),3),8) + A(i,1);
        hilfe = hilfe + mod(hilfe,2);
        i = i + hilfe / 2;
    else
        ATRTIME = [ATRTIME;bitshift(bitand(A(i,2),3),8)+A(i,1)];
        ANNOT = [ANNOT;bitshift(A(i,2),-2)];
   end;
   i = i + 1;
end;
ANNOT(length(ANNOT))=[];       % last line = EOF (=0)
ATRTIME(length(ATRTIME))=[];   % last line = EOF
clear A;
ATRTIME= (cumsum(ATRTIME))/sfreq;
ind= find(ATRTIME <= TIME(end));
ATRTIMED= ATRTIME(ind);
ANNOT=round(ANNOT);
ANNOTD= ANNOT(ind);

%save data
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
        [c,t]=max(TIME_M(2,(j-25):(j+25)));
        R_peak(1,k)=TIME_M(1,(j-26+t));
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
newf=strcat('D:\ECG\ECG资料\ex201705212012\channel1_single\',NUM,'\data\');
mkdir(newf);
 for i=1:(length(R_peak)-2)
savefile=strcat('A',num2str(i));
file=strcat(newf,['A',num2str(i),'_',NUM,'_1'])
save(file,savefile);
end

 
newf2=strcat('D:\ECG\ECG资料\ex201705212012\channel1_single\',NUM,'\images\');
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
annotation=strcat('D:\ECG\ECG资料\ex201705212012\channel1_single\',NUM,'\','annotation',NUM,'_1');
annota=strcat('annot');
save(annotation,annota);



  
     

