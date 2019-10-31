function newsd = MCCUSB1208FS_OpenSimpleDaq(sd)
sd.ai=analoginput('mcc', 0);
sd.c1=addchannel(sd.ai,0,'EKG');
sd.c2=addchannel(sd.ai,1,'EEG');
sd
newsd = sd;


