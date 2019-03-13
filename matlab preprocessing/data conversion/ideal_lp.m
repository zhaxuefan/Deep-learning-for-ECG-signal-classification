%其中，ideal_lp（）函数在另一个M文件中，具体如下：  
%理想低通滤波器  
%截止角频率wc，阶数Me  
function hd=ideal_lp(wc,Me)  
alpha=(Me-1)/2;  
n=[0:Me-1];  
p=n-alpha+eps;              %eps为很小的数，避免被0除  
hd=sin(wc*p)./(pi*p);       %用Sin函数产生冲击响应  
