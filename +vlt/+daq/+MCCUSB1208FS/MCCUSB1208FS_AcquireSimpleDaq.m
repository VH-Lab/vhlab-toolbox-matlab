function [data,newsd] =MCCUSB1208FS_AcquireSimpleDaq(sd)
sd.ai.SampleRate=10000;
sd.ai.SamplesPerTrigger=(5*sd.ai.SampleRate);
sd
get(sd.ai)
set(sd.ai,'TriggerType', 'Immediate')
%set(sd.ai,'TriggerType','Manual');
data.starttime = clock;
start(sd.ai);
%trigger(sd.ai);
%wait(sd.ai,5)
[d, T]=getdata(sd.ai);
data.data{1} = [T';d'];
newsd=sd;
