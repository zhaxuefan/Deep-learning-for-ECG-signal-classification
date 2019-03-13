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
PATH= 'C:\Users\doublew.lenovo\Desktop\新建文件夹'; % path, where data are saved
 
HEADERFILE= '100.hea';      % header-file in text format
ATRFILE= '100.atr';         % attributes-file in binary format
DATAFILE='100.dat';         % data-file
SAMPLES2READ=30000;         % number of samples to be read
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
M2H= bitshift(A(:,2), -4);        %字节向右移四位，即取字节的高四位
M1H= bitand(A(:,2), 15);          %取字节的低四位
PRL=bitshift(bitand(A(:,2),8),9);     % sign-bit   取出字节低四位中最高位，向右移九位
PRR=bitshift(bitand(A(:,2),128),5);   % sign-bit   取出字节高四位中最高位，向右移五位
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

alpha=10;
TIME1=TIME(alpha*360:(alpha+10)*360);
M2=M(alpha*360:(alpha+10)*360,1);
plot(TIME1,M2);
axis([alpha,alpha+10,-3,3])



%进行滤波
Fs=1500;                        %采样频率  
fp=80;fs=100;                    %通带截止频率，阻带截止频率  
rp=1.4;rs=1.6;                    %通带、阻带衰减  
wp=2*pi*fp;ws=2*pi*fs;     
[n,wn]=buttord(wp,ws,rp,rs,'s');     %'s'是确定巴特沃斯模拟滤波器阶次和3dB  
                               %截止模拟频率  
[z,P,k]=buttap(n);   %设计归一化巴特沃斯模拟低通滤波器，z为极点，p为零点和k为增益  
[bp,ap]=zp2tf(z,P,k)  %转换为Ha(p),bp为分子系数，ap为分母系数  
[bs,as]=lp2lp(bp,ap,wp) %Ha(p)转换为低通Ha(s)并去归一化，bs为分子系数，as为分母系数  
  
[hs,ws]=freqs(bs,as);         %模拟滤波器的幅频响应  
[bz,az]=bilinear(bs,as,Fs);     %对模拟滤波器双线性变换  
[h1,w1]=freqz(bz,az);         %数字滤波器的幅频响应  
m=filter(bz,az,M2(:,1));  
  
%figure  
freqz(bz,az);title('巴特沃斯低通滤波器幅频曲线');  
        
%figure  
subplot(2,1,1);  
plot(TIME1,M2(:,1));  
xlabel('t(s)');ylabel('mv');title('原始心电信号波形');grid;  
  
subplot(2,1,2);  
plot(TIME1,m);  
xlabel('t(s)');ylabel('mv');title('低通滤波后的时域图形');grid;  
     
N=512;
n=0:N-1;  
mf=fft(M2(:,1),N);               %进行频谱变换（傅里叶变换）  
mag=abs(mf);  
f=(0:length(mf)-1)*Fs/length(mf);  %进行频率变换  
  
%figure  
subplot(2,1,1)  
plot(f,mag);axis([0,1500,1,50]);grid;      %画出频谱图  
xlabel('频率(HZ)');ylabel('幅值');title('心电信号频谱图');  
  
mfa=fft(m,N);                    %进行频谱变换（傅里叶变换）  
maga=abs(mfa);  
fa=(0:length(mfa)-1)*Fs/length(mfa);  %进行频率变换  
subplot(2,1,2)  
plot(fa,maga);axis([0,1500,1,50]);grid;  %画出频谱图  
xlabel('频率(HZ)');ylabel('幅值');title('低通滤波后心电信号频谱图');  
      
wn=M2(:,1);  
P=10*log10(abs(fft(wn).^2)/N);  
f=(0:length(P)-1)/length(P);  
%figure  
plot(f,P);grid  
xlabel('归一化频率');ylabel('功率(dB)');title('心电信号的功率谱');  
%-----------------带陷滤波器抑制工频干扰-------------------  
%50Hz陷波器：由一个低通滤波器加上一个高通滤波器组成  
%而高通滤波器由一个全通滤波器减去一个低通滤波器构成  
Me=100;               %滤波器阶数  
L=100;                %窗口长度  
beta=100;             %衰减系数  
Fs=1500;  
wc1=49/Fs*pi;     %wc1为高通滤波器截止频率，对应51Hz  
wc2=51/Fs*pi     ;%wc2为低通滤波器截止频率，对应49Hz  
h=ideal_lp(0.132*pi,Me)-ideal_lp(wc1,Me)+ideal_lp(wc2,Me); %h为陷波器  
                                                            %冲击响应  
w=kaiser(L,beta);  
y=h.*rot90(w);         %y为50Hz陷波器冲击响应序列  
m1=filter(y,1,m);  
  
%figure  
subplot(2,1,1);plot(abs(h));axis([0 100 0 0.2]);  
xlabel('频率(Hz)');ylabel('幅度(mv)');title('陷波器幅度谱');grid;  
N=512;  
P=10*log10(abs(fft(y).^2)/N);  
f=(0:length(P)-1);  
subplot(2,1,2);plot(f,P);  
xlabel('频率(Hz)');ylabel('功率(dB)');title('陷波器功率谱');grid;  
     
%figure  
subplot (2,1,1); plot(TIME1,m);  
xlabel('t(s)');ylabel('幅值');title('原始信号');grid;  
subplot(2,1,2);plot(TIME1,m1);  
xlabel('t(s)');ylabel('幅值');title('带阻滤波后信号');grid;  
    
%figure  
N=512  
subplot(2,1,1);plot(abs(fft(m))*2/N);axis([0 100 0 1]);  
xlabel('t(s)');ylabel('幅值');title('原始信号频谱');grid;  
subplot(2,1,2);plot(abs(fft(m1))*2/N);axis([0 100 0 1]);  
xlabel('t(s)');ylabel('幅值');title('带阻滤波后信号频谱');grid;    
  
%------------------IIR零相移数字滤波器纠正基线漂移-------------------  
Wp=1.4*2/Fs;     %通带截止频率   
Ws=0.6*2/Fs;     %阻带截止频率   
devel=0.005;    %通带纹波   
Rp=20*log10((1+devel)/(1-devel));   %通带纹波系数    
Rs=20;                          %阻带衰减   
[N Wn]=ellipord(Wp,Ws,Rp,Rs,'s');   %求椭圆滤波器的阶次   
[b a]=ellip(N,Rp,Rs,Wn,'high');       %求椭圆滤波器的系数   
[hw,w]=freqz(b,a,512);     
result =filter(b,a,m1);   
  
%figure  
freqz(b,a);  
%figure  
plot(TIME1,result);   
xlabel('t(s)');ylabel('幅值');title('线性滤波后信号');grid  



%寻找r波以及进行标注
ECG_1=result;
threshold=0.4;
for i=1:3601
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

plot(TIME1(maxloc),ecgvalue,'or')
tt=TIME1(maxloc);
for i=2:length(ecgvalue)
    rrtime(i-1)=tt(i)-tt(i-1)
end

plot(TIME1,ECG_1)
hold on
plot(TIME1(maxloc),ecgvalue,'or')


