function [data,newsd] = dummyekgeegdaq_AcquireSimpleDaq(sd)

newsd = sd;

data.starttime = clock;

T = 0:0.001:5;

rate = 330/60;

freq = 10;

ekg_sin = sin(2*pi*rate*T);
ekg = 0*T;

ekg(find(ekg_sin>0.95)) = 1;

eeg = sin(2*pi*freq*T);

data.data{1} = [T;ekg;eeg];

pause(5);
