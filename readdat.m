ecg=fopen('n01.dat','r');
N=1201;
data=fread(ecg,[3, N], 'int16');
save ECGdata A;
fclose(ecg);
 x=0:0.004:4.8;
figure(1);
% %subplot(321);
 plot(x,data);
% M2H = bitshift(A(:,2), -4); % bitshift
% M1H = bitand(A(:,2), 15); % bitand
% PRL = bitshift(bitand(A(:,2),8),9); % sign-bit
% PRR = bitshift(bitand(A(:,2),128),5); % sign-bit
% M( : , 1) = bitshift(M1H,8)+ A(:,1)-PRL;
% M( : , 2) = bitshift(M2H,8)+ A(:,3)-PRR;
% if M(1,:) ~= firstvalue
%     error('inconsistency in the first bit values');
% end
% switch nosig
% case 2
%     M( : , 1) = (M( : , 1)- zerovalue(1))/gain(1);
%     M( : , 2) = (M( : , 2)- zerovalue(2))/gain(2);
%     TIME =(0:(SAMPLES2READ - 1)) / sfreq;
% case 1
%     M( : , 1)= (M( : , 1)- zerovalue(1));
%     M( : , 2)= (M( : , 2)- zerovalue(1));
%     M=M';
%     M(1)=[];
%     sM=size(M);
%     sM=sM(2)+1;
%     M(sM)=0;
%     M=M';
%     M=M/gain(1);
%     TIME=(0:2*(SAMPLES2READ)-1)/sfreq;
% otherwise % this case did not appear up to now!
%     % here M has to be sorted!!!
%     disp('Sorting algorithm for more than 2 signals not programmed yet!');
% end;
% clear A M1H M2H PRR PRL;
% fprintf(1,'\\n$> LOADING DATA FINISHED \n');
