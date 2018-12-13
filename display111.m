
%------ DISPLAY DATA ------------------------------------------------------
figure(1); clf, box on, hold on
plot(TIME, M(:,1),'r');
plot(TIME(1:30000), M(1:30000,1),'r');
if nosig==2
   plot(TIME, M(:,2),'b');
   plot(TIME(1:30000), M(1:30000,2),'b');
end;
figure,plot(TIME_M(1,1:30000),TIME_M(2,1:30000))
%for k=1:length(ATRTIMED)
for k=1:length(ATRTIMED)
   text(ATRTIMED(k),0,num2str(ANNOTD(k)));
end;
for k=1:length(R_peak)
   text(R_peak(1,k),R_peak(2,k),'o')
end

xlim([TIME(1), TIME(end)]);
xlabel('Time / s'); ylabel('Voltage / mV');
%string=['ECG signal ',DATAFILE];
string = strcat('ECG signal', ' "', DATAFILE(6:end), '"');
title(string);
fprintf(1,'\\n$> DISPLAYING DATA FINISHED \n');
% -------------------------------------------------------------------------
fprintf(1,'\\n$> ALL FINISHED \n');

figure,plot(A1(1,:),A1(2,:))