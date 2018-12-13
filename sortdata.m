function B=sortdata(A)
Max=max(A);
Min=min(A);
ymin=-1;ymax=1;
B=zeros(1,length(A));
for i=1:length(A)
   B(i)=(ymax-ymin)*(A(i)-Min)/(Max-Min)+ymin;
end

