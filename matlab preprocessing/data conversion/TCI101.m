 h=1:7;
 t=1:360:2161;
  for k=1:7;
 a=t(k)+360;
 b=t(k)+720;
 c=t(k)+1080;
 d=t(k)+1440;
 
 e=h(k);
 l=h(k)+2;

mn=abs(M3(a:c));
[ma,I]=max(mn);
mmax=ma*0.2;
 for ins=t:d-1;
 if M3(ins)<mmax
     m3(ins)=0;
 else m3(ins)=1;
 end
 end
 subplot(2,1,2)
 plot(TIME3(t(k):d-1),m3(t(k):d-1));
 axis([0,10,-1,1.5]);
 subplot(2,1,1)
 plot(TIME3(t(k):d-1),M3(t(k):d-1));
 axis([0,10,-1,3]);

count=0;
if (m3(a)-m3(a-1))==1
    count=count+1;
else 
    count=count;
end
if ((m3(c)==1)&(m3(c+1)-m3(c)==0))
    count=count-1;
else count=count;
for j=a:c-1;
    m5(j)=m3(j+1)-m3(j);
       if m5(j)==1;
            count=count+1;
       else
            count=count+0;   
       end
end
end    


for i=a:-1:1
    if (m3(a+1)+m3(a)==2)
        if (m3(i)-m3(i-1)==-1)
        N=TIME3(i-1)
        break
        end
    else if m3(i)==1
            N=TIME3(i)
            break
    end
    end
end
t1=e-N;%t1

for i=a:d-1
    if (m3(a)+m3(a-1)==2)
        if (m3(i+1)-m3(i)==1)
        N=TIME3(i+1)
        break 
        end
    else if m3(i)==1
            N=TIME3(i);
            break
        end
    end
end
t2= N-e;%t2


for i=c:-1:1
    if (m3(c+1)+m3(c)==2)
        if (m3(i)-m3(i-1)==-1)
        N=TIME3(i-1)
        break
        end
    else if m3(i)==1
            N=TIME3(i)
            break
    end
    end
end
t3=l-N;%t3

for i=c:d-1
    if (m3(c)+m3(c-1)==2)
        if (m3(i+1)-m3(i)==1)
        N=TIME3(i+1)
        break 
        end
    else if m3(i)==1
            N=TIME3(i);
            break
        end
    end
end
t4= N-l;%t4

TCI(k)=2000/((count-1)+t2/(t1+t2)+t3/(t3+t4))
  end




