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
clc;
clear;

%------ SPECIFY DATA ------------------------------------------------------
PATH= 'G:\ECG\�ĵ�����'; % path, where data are saved
NUM = '100';
HEADERFILE = strcat(NUM, '.hea'); % header-file in text format
ATRFILE = strcat(NUM, '.qrs'); % attributes-file in binary format
DATAFILE = strcat(NUM,'.dat'); % data-file
SAMPLES2READ = 6000; % number of samples to be read
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
% if dformat ~= [212, 212]
%     error('this script does not apply binary formats different to 212.');
% end
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
% if M(1,:) ~= firstvalue
%     error('inconsistency in the first bit values');
% end
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

% %------ LOAD ATTRIBUTES DATA ----------------------------------------------
atrd = fullfile(PATH, ATRFILE); % attribute file with annotation data
fid3 = fopen(atrd,'r');
A = fread(fid3, [2, inf], 'unit8')';
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
% 



