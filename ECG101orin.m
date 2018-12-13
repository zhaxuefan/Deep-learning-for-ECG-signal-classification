% This programm reads ECG data which are saved in format 212.
% (e.g., 100.dat from MIT-BIH-DB, cu01.dat from CU-DB,...)
% The data are displayed in a figure together with the annotations.
% The annotations are saved in the vector ANNOT, the corresponding
% times (in seconds) are saved in the vector ATRTIME.
% The annotations are saved as numbers, the meaning of the numbers can
% be found in the codetable "ecgcodes.h" available at www.physionet.org.
%
% ANNOT only contains the most important information, which is displayed
% with the program rdann (available on www.physionet.org) in the 3rd row.
% The 4th to 6th row are not saved in ANNOT.
%
%
%      created on Feb. 27, 2003 by
%      Robert Tratnig (Vorarlberg University of Applied Sciences)
%      (email: rtratnig@gmx.at),
%
%      algorithm is based on a program written by
%      Klaus Rheinberger (University of Innsbruck)
%      (email: klaus.rheinberger@uibk.ac.at)
%
% -------------------------------------------------------------------------

%------ SPECIFY DATA ------------------------------------------------------
clear all
PATH= 'F:\ECG\ECG\ex201705212012\MIT_BIH_ECG_DATA\101'; % path, where data are saved
 
HEADERFILE= '101.hea';      % header-file in text format
ATRFILE= '101.atr';         % attributes-file in binary format
DATAFILE='101.dat';         % data-file
SAMPLES2READ=6000;         % number of samples to be read
                            % in case of more than one signal:
                            % 2*SAMPLES2READ samples are read
%------ LOAD HEADER DATA --------------------------------------------------
fprintf(1,'\\n$> WORKING ON %s ...\n', HEADERFILE);
signalh= fullfile(PATH, HEADERFILE);
fid1=fopen(signalh,'r');
z= fgetl(fid1);
A= sscanf(z, '%*s %d %d %d',[1,3]);
nosig= A(1);  % number of signals
sfreq=A(2);   % sample rate of data
clear A;
for k=1:nosig
    z= fgetl(fid1);
    A= sscanf(z, '%*s %d %d %d %d %d',[1,5]);
    dformat(k)= A(1);           % format; here only 212 is allowed
    gain(k)= A(2);              % number of integers per mV
    bitres(k)= A(3);            % bitresolution
    zerovalue(k)= A(4);         % integer value of ECG zero point
    firstvalue(k)= A(5);        % first integer value of signal (to test for errors)
end;
fclose(fid1);
clear A;
%------ LOAD BINARY DATA --------------------------------------------------
if dformat~= [212,212], error('this script does not apply binary formats different to 212.'); end;
signald= fullfile(PATH, DATAFILE);            % data in format 212
fid2=fopen(signald,'r');
A= fread(fid2, [3, SAMPLES2READ], 'uint8')';  % matrix with 3 rows, each 8 bits long, = 2*12bit
fclose(fid2);
M2H= bitshift(A(:,2), -4);        %�ֽ���������λ����ȡ�ֽڵĸ���λ
M1H= bitand(A(:,2), 15);          %ȡ�ֽڵĵ���λ
PRL=bitshift(bitand(A(:,2),8),9);     % sign-bit   ȡ���ֽڵ���λ�����λ�������ƾ�λ
PRR=bitshift(bitand(A(:,2),128),5);   % sign-bit   ȡ���ֽڸ���λ�����λ����������λ
M( : , 1)= bitshift(M1H,8)+ A(:,1)-PRL;
M( : , 2)= bitshift(M2H,8)+ A(:,3)-PRR;
if M(1,:) ~= firstvalue, error('inconsistency in the first bit values'); end;
switch nosig
case 2
    M( : , 1)= (M( : , 1)- zerovalue(1))/gain(1);
    M( : , 2)= (M( : , 2)- zerovalue(2))/gain(2);
    TIME=(0:(SAMPLES2READ-1))/sfreq;
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
otherwise  % this case did not appear up to now!
    % here M has to be sorted!!!
    disp('Sorting algorithm for more than 2 signals not programmed yet!');
end;
clear A M1H M2H PRR PRL;
fprintf(1,'\\n$> LOADING DATA FINISHED \n');
%------ LOAD ATTRIBUTES DATA ----------------------------------------------
atrd= fullfile(PATH, ATRFILE);      % attribute file with annotation data
fid3=fopen(atrd,'r');
A= fread(fid3, [2, inf], 'uint8')';
fclose(fid3);
ATRTIME=[];
ANNOT=[];
sa=size(A);
saa=sa(1);
i=1;
while i<=saa
    annoth=bitshift(A(i,2),-2);
    if annoth==59
        ANNOT=[ANNOT;bitshift(A(i+3,2),-2)];
        ATRTIME=[ATRTIME;A(i+2,1)+bitshift(A(i+2,2),8)+...
                bitshift(A(i+1,1),16)+bitshift(A(i+1,2),24)];
        i=i+3;
    elseif annoth==60
        % nothing to do!
    elseif annoth==61
        % nothing to do!
    elseif annoth==62
        % nothing to do!
    elseif annoth==63
        hilfe=bitshift(bitand(A(i,2),3),8)+A(i,1);
        hilfe=hilfe+mod(hilfe,2);
        i=i+hilfe/2;
    else
        ATRTIME=[ATRTIME;bitshift(bitand(A(i,2),3),8)+A(i,1)];
        ANNOT=[ANNOT;bitshift(A(i,2),-2)];
   end;
   i=i+1;
end;
ANNOT(length(ANNOT))=[];       % last line = EOF (=0)
ATRTIME(length(ATRTIME))=[];   % last line = EOF
clear A;
ATRTIME= (cumsum(ATRTIME))/sfreq;
ind= find(ATRTIME <= TIME(end));
ATRTIMED= ATRTIME(ind);
ANNOT=round(ANNOT);
ANNOTD= ANNOT(ind);
%------ DISPLAY DATA ------------------------------------------------------
figure(1); clf, box on, hold on
plot(TIME, M(:,1),'r');
if nosig==2
    plot(TIME, M(:,2),'b');
end;
for k=1:length(ATRTIMED)
    text(ATRTIMED(k),0,num2str(ANNOTD(k)));
end;
xlim([TIME(1), TIME(end)]);
xlabel('Time / s'); ylabel('Voltage / mV');
string=['ECG signal ',DATAFILE];
title(string);
fprintf(1,'\\n$> DISPLAYING DATA FINISHED \n');
% -------------------------------------------------------------------------
fprintf(1,'\\n$> ALL FINISHED \n');

alpha=20;
TIME1=TIME(alpha*250:(alpha+10)*250);
M2=M(alpha*250:(alpha+10)*250,1);
plot(TIME1,M2);
axis([alpha,alpha+10,-3,3])



%�����˲�
Fs=1500;                        %����Ƶ��  
fp=80;fs=100;                    %ͨ����ֹƵ�ʣ������ֹƵ��  
rp=1.4;rs=1.6;                    %ͨ�������˥��  
wp=2*pi*fp;ws=2*pi*fs;     
[n,wn]=buttord(wp,ws,rp,rs,'s');     %'s'��ȷ��������˹ģ���˲����״κ�3dB  
                               %��ֹģ��Ƶ��  
[z,P,k]=buttap(n);   %��ƹ�һ��������˹ģ���ͨ�˲�����zΪ���㣬pΪ����kΪ����  
[bp,ap]=zp2tf(z,P,k)  %ת��ΪHa(p),bpΪ����ϵ����apΪ��ĸϵ��  
[bs,as]=lp2lp(bp,ap,wp) %Ha(p)ת��Ϊ��ͨHa(s)��ȥ��һ����bsΪ����ϵ����asΪ��ĸϵ��  
  
[hs,ws]=freqs(bs,as);         %ģ���˲����ķ�Ƶ��Ӧ  
[bz,az]=bilinear(bs,as,Fs);     %��ģ���˲���˫���Ա任  
[h1,w1]=freqz(bz,az);         %�����˲����ķ�Ƶ��Ӧ  
m=filter(bz,az,M2(:,1));  
  
%figure  
freqz(bz,az);title('������˹��ͨ�˲�����Ƶ����');  
        
%figure  
subplot(2,1,1);  
plot(TIME1,M2(:,1));  
xlabel('t(s)');ylabel('mv');title('ԭʼ�ĵ��źŲ���');grid;  
  
subplot(2,1,2);  
plot(TIME1,m);  
xlabel('t(s)');ylabel('mv');title('��ͨ�˲����ʱ��ͼ��');grid;  
     
N=512;
n=0:N-1;  
mf=fft(M2(:,1),N);               %����Ƶ�ױ任������Ҷ�任��  
mag=abs(mf);  
f=(0:length(mf)-1)*Fs/length(mf);  %����Ƶ�ʱ任  
  
%figure  
subplot(2,1,1)  
plot(f,mag);axis([0,1500,1,50]);grid;      %����Ƶ��ͼ  
xlabel('Ƶ��(HZ)');ylabel('��ֵ');title('�ĵ��ź�Ƶ��ͼ');  
  
mfa=fft(m,N);                    %����Ƶ�ױ任������Ҷ�任��  
maga=abs(mfa);  
fa=(0:length(mfa)-1)*Fs/length(mfa);  %����Ƶ�ʱ任  
subplot(2,1,2)  
plot(fa,maga);axis([0,1500,1,50]);grid;  %����Ƶ��ͼ  
xlabel('Ƶ��(HZ)');ylabel('��ֵ');title('��ͨ�˲����ĵ��ź�Ƶ��ͼ');  
      
wn=M2(:,1);  
P=10*log10(abs(fft(wn).^2)/N);  
f=(0:length(P)-1)/length(P);  
%figure  
plot(f,P);grid  
xlabel('��һ��Ƶ��');ylabel('����(dB)');title('�ĵ��źŵĹ�����');  
%-----------------�����˲������ƹ�Ƶ����-------------------  
%50Hz�ݲ�������һ����ͨ�˲�������һ����ͨ�˲������  
%����ͨ�˲�����һ��ȫͨ�˲�����ȥһ����ͨ�˲�������  
Me=100;               %�˲�������  
L=100;                %���ڳ���  
beta=100;             %˥��ϵ��  
Fs=1500;  
wc1=49/Fs*pi;     %wc1Ϊ��ͨ�˲�����ֹƵ�ʣ���Ӧ51Hz  
wc2=51/Fs*pi     ;%wc2Ϊ��ͨ�˲�����ֹƵ�ʣ���Ӧ49Hz  
h=ideal_lp(0.132*pi,Me)-ideal_lp(wc1,Me)+ideal_lp(wc2,Me); %hΪ�ݲ���  
                                                            %�����Ӧ  
w=kaiser(L,beta);  
y=h.*rot90(w);         %yΪ50Hz�ݲ��������Ӧ����  
m1=filter(y,1,m);  
  
%figure  
subplot(2,1,1);plot(abs(h));axis([0 100 0 0.2]);  
xlabel('Ƶ��(Hz)');ylabel('����(mv)');title('�ݲ���������');grid;  
N=512;  
P=10*log10(abs(fft(y).^2)/N);  
f=(0:length(P)-1);  
subplot(2,1,2);plot(f,P);  
xlabel('Ƶ��(Hz)');ylabel('����(dB)');title('�ݲ���������');grid;  
     
%figure  
subplot (2,1,1); plot(TIME1,m);  
xlabel('t(s)');ylabel('��ֵ');title('ԭʼ�ź�');grid;  
subplot(2,1,2);plot(TIME1,m1);  
xlabel('t(s)');ylabel('��ֵ');title('�����˲����ź�');grid;  
    
%figure  
N=512  
subplot(2,1,1);plot(abs(fft(m))*2/N);axis([0 100 0 1]);  
xlabel('t(s)');ylabel('��ֵ');title('ԭʼ�ź�Ƶ��');grid;  
subplot(2,1,2);plot(abs(fft(m1))*2/N);axis([0 100 0 1]);  
xlabel('t(s)');ylabel('��ֵ');title('�����˲����ź�Ƶ��');grid;    
  
%------------------IIR�����������˲�����������Ư��-------------------  
Wp=1.4*2/Fs;     %ͨ����ֹƵ��   
Ws=0.6*2/Fs;     %�����ֹƵ��   
devel=0.005;    %ͨ���Ʋ�   
Rp=20*log10((1+devel)/(1-devel));   %ͨ���Ʋ�ϵ��    
Rs=20;                          %���˥��   
[N Wn]=ellipord(Wp,Ws,Rp,Rs,'s');   %����Բ�˲����Ľ״�   
[b a]=ellip(N,Rp,Rs,Wn,'high');       %����Բ�˲�����ϵ��   
[hw,w]=freqz(b,a,512);     
result =filter(b,a,m1);   
  
%figure  
freqz(b,a);  
%figure  
plot(TIME1,result);   
xlabel('t(s)');ylabel('��ֵ');title('�����˲����ź�');grid  



%Ѱ��r���Լ����б�ע
ECG_1=result;
threshold=0.4;
for i=1:2501
    if ECG_1(i)>threshold
     ECG_2(i)=ECG_1(i);
    else 
     ECG_2(i)=0;
    end
end    
 plot(TIME1,ECG_2)
max=imregionalmax(ECG_2);
YLOC=1:size(ECG_2,2);
maxloc=YLOC(max)
for i=1:length(maxloc)
    ecgvalue(i)=ECG_2(maxloc(i))
end
hold on
plot(TIME1(maxloc),ecgvalue,'or')

tt=TIME1(maxloc);
for i=2:length(ecgvalue)
    rrtime(i-1)=tt(i)-tt(i-1)
end

