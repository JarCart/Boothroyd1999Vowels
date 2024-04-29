close all; clear all; clc;
addpath('C:\Users\Public\Documents\MATLAB codes');

p_ref = 20/1000000; %sets reference for dB
dB = 70; %Chooses initial intensity in dB
p = p_ref*10.^(dB/20); %Sets intial intensity in dB

%                      Some Common Vowels
%               Vowel       f1      f2      f3
%                /a/        730    1090    2440
%                /i/        270    2290    3010
%                /u/        300     870    2240

dur= 0.800; %sets duration for vowl
Fs = 48828; %sampling rate
F0 = 150; %sets pitch at 150 Hz
t = linspace(0,dur,Fs*dur); %Time-based values
ramp=10; %ramps the stimuli for 10 ms
order=60; % sets the filter order

%The following sets the first vowel
    F1=270;
    F2=2290;
    F3=3010;

ii=rampstim(MakeVowel(fix(dur*Fs),F0,Fs,F1,F2,F3),ramp,Fs); %Makes the stimulus
ii=0.7*ii/max(ii); %normalize    
rmsii=sqrt(mean(ii.^2)); %Gets stimulus RMS

    F1=300;
    F2=870;
    F3=2240;

uu = rampstim(MakeVowel(fix(dur*Fs),F0,Fs,F1,F2,F3),ramp,Fs); %Makes the stimulus
uu = 0.7*uu/max(uu); %normalize
rmsuu = sqrt(mean(uu.^2)); %Gets stimulus RMS

setdBuu = (p/rmsuu)*uu; %Scales the /u/ stimulus to 70 dB
differences = [-5,-4,-3,-2,-1,0,1,2,3,4,5]; %Intensity differences between the first and second vowels

for r = 1:length(differences) %For all the differences we set
    dB_ii = dB + differences(r); %Changes the intensity by the specific amount
    p = p_ref*10.^(dB_ii/20); %references the new intensity
    setdBii = (p/rmsii)*ii; %sets the intensity

    stimuli(r,:) = [setdBuu,setdBii]; %concatenates the /u/ with the /i/
end

%This next block saves the concatenated stimuli
for i = 1:length(differences)
    if contains(string(differences(i)),'-')
        stimName = strcat('D:\MartinBoothroydStim\ui_',string(differences(i)),'.wav'); %Change this to the file location
    else
        stimName = strcat('D:\MartinBoothroydStim\ui_+',string(differences(i)),'.wav');%Change this to the file location
    end
audiowrite(stimName,stimuli(i,:),Fs)
end

%Does the same for the /u/ stimuli
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