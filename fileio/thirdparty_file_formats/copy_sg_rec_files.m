function copy_sg_rec_files(filename_in,s0,s1,filename_out)
%COPY_SG_REC_FILES Shortens .rec files from sample to sample provided in
%arguments

fid_in = fopen(filename_in,'r');
fid_out = fopen(filename_out,'w');

if fid_out<0,
	error(['Could not open the file ' filename_out ' for writing.']);
end;

fileconfig = readTrodesFileConfig(filename_in);

configSize = length(fileconfig.configText);
headerSizeBytes = str2num(fileconfig.headerSize)*2; %int16 = 2 bytes
timestamp = 4; %4 byte timestamp
channelSizeBytes = str2num(fileconfig.numChannels)*2; %int16 = 2 bytes
blockSizeBytes = headerSizeBytes + 2 + channelSizeBytes;
numberOfSamples = blockSizeBytes * (s1-s0+1) * 2;

%At beginning of file
fseek(fid_in,0,'bof');
%read config before samples
initialConfig = fread(fid_in,configSize + headerSizeBytes + timestamp)';
fwrite(fid_out,initialConfig);
%fseek(fid_in,length(initialConfig),'bof');
%Go to desired s0
fseek(fid_in,(s0-1)*blockSizeBytes,'cof');
%read until s1
samples = fread(fid_in,numberOfSamples)';

%fwrite(fid_out,initialConfig);
fwrite(fid_out,samples);
%disp(numberOfSamples);

end

