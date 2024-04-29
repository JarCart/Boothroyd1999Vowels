close all; clear all; clc;
addpath('C:\Users\Public\Documents\MATLAB codes');
p_ref = 20/1000000;
dB = 70;
p = p_ref*10.^(dB/20);

%                      Some Common Vowels
%               Vowel       f1      f2      f3
%                /a/        730    1090    2440
%                /i/        270    2290    3010
%                /u/        300     870    2240

dur= 0.800;
Fs = 48828;
F0 = 165;
t = linspace(0,dur,Fs*dur);
ramp=10; 
order=60;

    F1=270;
    F2=2290;
    F3=3010;

ii=rampstim(MakeVowel(fix(dur*Fs),F0,Fs,F1,F2,F3),ramp,Fs);
ii=0.7*ii/max(ii); %normalize    
rmsii=sqrt(mean(ii.^2));

    F1=300;
    F2=870;
    F3=2240;

uu = rampstim(MakeVowel(fix(dur*Fs),F0,Fs,F1,F2,F3),ramp,Fs);
uu = 0.7*uu/max(uu); %normalize
rmsuu = sqrt(mean(uu.^2));

setdBuu = (p/rmsuu)*uu;
differences = [-5,-4,-3,-2,-1,0,1,2,3,4,5];

for r = 1:length(differences)
    dB_ii = dB + differences(r);
    p = p_ref*10.^(dB_ii/20);
    setdBii = (p/rmsii)*ii;

    stimuli(r,:) = [setdBuu,setdBii]; 
end

for i = 1:length(differences)
    if contains(string(differences(i)),'-')
        stimName = strcat('D:\MartinBoothroydStim\ui_',string(differences(i)),'.wav');
    else
        stimName = strcat('D:\MartinBoothroydStim\ui_+',string(differences(i)),'.wav');
    end
audiowrite(stimName,stimuli(i,:),Fs)
end

for r = 1:length(differences)
    dB_uu = dB + differences(r);
    p = p_ref*10.^(dB_uu/20);
    setdBu2 = (p/rmsuu)*uu;

    stimuli(r,:) = [setdBuu,setdBu2]; 
end

for i = 1:length(differences)
    if contains(string(differences(i)),'-')
        stimName = strcat('D:\MartinBoothroydStim\uu_',string(differences(i)),'.wav');
    else
        stimName = strcat('D:\MartinBoothroydStim\uu_+',string(differences(i)),'.wav');
    end
audiowrite(stimName,stimuli(i,:),Fs)
end