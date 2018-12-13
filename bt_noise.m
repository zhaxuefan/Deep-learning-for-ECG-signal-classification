clc;clear;
add1='D:\ECG\ECG����\ex201705212012\data-10.12\1D\training\normal\';
subdir=dir([add1,'*mat']);
len=length(subdir);
for i=1:10
 mat_Name=strcat(add1,subdir(i).name);
 y=cell2mat(struct2cell(load(mat_Name)));
 
M2=y;
TIME1=0:0.0028:0.0028*(length(M2)-1)
%figure,plot(TIME1,M2);

Fs=100;                        %����Ƶ��  
fp=30;fs=40;                    %ͨ����ֹƵ�ʣ������ֹƵ��  
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
m=filter(bz,az,M2);

figure  
subplot(2,1,1);  
plot(TIME1,M2);  
xlabel('t(s)');ylabel('mv');title('ԭʼ�ĵ��źŲ���');grid;  
  
subplot(2,1,2);  
plot(TIME1,m);  
xlabel('t(s)');ylabel('mv');title('��ͨ�˲����ʱ��ͼ��');grid;  
end

% Wp=1.4*2/Fs;     %ͨ����ֹƵ��   
% Ws=0.6*2/Fs;     %�����ֹƵ��   
% devel=0.005;    %ͨ���Ʋ�   
% Rp=20*log10((1+devel)/(1-devel));   %ͨ���Ʋ�ϵ��    
% Rs=20;                          %���˥��   
% [N Wn]=ellipord(Wp,Ws,Rp,Rs,'s');   %����Բ�˲����Ľ״�   
% [b a]=ellip(N,Rp,Rs,Wn,'high');       %����Բ�˲�����ϵ��   
% [hw,w]=freqz(b,a,512);     
% result =filter(b,a,m1);   
%   
% figure  
% freqz(b,a);  
% figure  
% plot(TIME1,result);   
% xlabel('t(s)');ylabel('��ֵ');title('�����˲����ź�');grid  

