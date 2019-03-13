clc;clear;
add1='D:\ECG\ECG资料\ex201705212012\data-10.12\1D\training\normal\';
subdir=dir([add1,'*mat']);
len=length(subdir);
for i=1:10
 mat_Name=strcat(add1,subdir(i).name);
 y=cell2mat(struct2cell(load(mat_Name)));
 
M2=y;
TIME1=0:0.0028:0.0028*(length(M2)-1)
%figure,plot(TIME1,M2);

Fs=100;                        %采样频率  
fp=30;fs=40;                    %通带截止频率，阻带截止频率  
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
m=filter(bz,az,M2);

figure  
subplot(2,1,1);  
plot(TIME1,M2);  
xlabel('t(s)');ylabel('mv');title('原始心电信号波形');grid;  
  
subplot(2,1,2);  
plot(TIME1,m);  
xlabel('t(s)');ylabel('mv');title('低通滤波后的时域图形');grid;  
end

% Wp=1.4*2/Fs;     %通带截止频率   
% Ws=0.6*2/Fs;     %阻带截止频率   
% devel=0.005;    %通带纹波   
% Rp=20*log10((1+devel)/(1-devel));   %通带纹波系数    
% Rs=20;                          %阻带衰减   
% [N Wn]=ellipord(Wp,Ws,Rp,Rs,'s');   %求椭圆滤波器的阶次   
% [b a]=ellip(N,Rp,Rs,Wn,'high');       %求椭圆滤波器的系数   
% [hw,w]=freqz(b,a,512);     
% result =filter(b,a,m1);   
%   
% figure  
% freqz(b,a);  
% figure  
% plot(TIME1,result);   
% xlabel('t(s)');ylabel('幅值');title('线性滤波后信号');grid  

