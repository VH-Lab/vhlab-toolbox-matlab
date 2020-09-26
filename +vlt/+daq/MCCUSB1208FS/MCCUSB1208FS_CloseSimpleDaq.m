function newsd = MCCUSB1208FS_CloseSimpleDaq(sd)
delete (sd.ai)
sd=rmfield(sd,'ai');
sd=rmfield(sd,'c1');
sd=rmfield(sd,'c2');
newsd = sd;


