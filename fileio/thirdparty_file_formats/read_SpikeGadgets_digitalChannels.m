function [recData, timestamps] = read_SpikeGadgets_digitalChannels(filename,NumChannels,channels,samplingRate,headerSize,s0,s1, configExists)  

%[recData, timestamps] = read_SpikeGadgets_digitalChannels(filename,NumChannels, channels, samplingRate,headerSize, configExists) )  

%Imports digital channel data in matlab from the raw data file
%
%INPUTS
%filename-- a string containing the name of the .dat file (raw file from SD card)
%NumChannels-- the number of channels in the recording (i.e., 32,64,96...)
%channels-- the digital channels you want to extract, designated as an N by 2 matrix [byte(1-based) bit(1-based)] 
%samplingRate-- the sampling rate of the recording, i.e 30000
%headerSize--the size, in int16's, of the header block of the data
%(contains DIO channels and aux analog channels).
%
%OUTPUTS
%timestamps--the system clock when each sample was taken
%recData-- a structure continaing the digital state of the channels

configsize = 0;
if (nargin < 8)
    configExists = 1;
end

fid = fopen(filename,'r');

if (configExists)
    junk = fread(fid,1000000,'char');
    configsize = strfind(junk','</Configuration>')+16;
    frewind(fid);
end

headerSizeBytes = str2num(headerSize) * 2; %int16 = 2 bytes
channelSizeBytes = str2num(NumChannels) * 2; %int16 = 2 bytes
%blockSizeBytes = headerSizeBytes + 2 + channelSizeBytes; needs edits in
%this case due to changes in bytes to read int32 or int8 for a few things
%samplingRate = str2num(samplingRate);

%get the timestamps

%junk = fread(fid,configsize,'char');
%junk = fread(fid,headerSize,'int16');
fseek(fid,configsize,'bof');
fseek(fid,headerSizeBytes,'cof');
timestamps = fread(fid,s1-s0+1,'1*uint32=>uint32',(headerSizeBytes)+(channelSizeBytes))';
timestamps = double(timestamps)/samplingRate;
%frewind(fid);

bytesToRead = unique(channels(:,1)); %find the list of unique bytes to read in, reads first col which stores bytes
recData = [];

%For length of these unique bytes
for i = 1:length(bytesToRead)  
    %junk = fread(fid,configsize,'char'); %skip config
    %junk = fread(fid,bytesToRead(i)-1,'char'); %skip bytes in header block up to the correct byte
    fseek(fid,configsize,'bof');
    fseek(fid,bytesToRead(i)-1,'cof');
    %read the actual data
    tmpData = fread(fid,s1-s0+1,'1*char=>uint8',(headerSizeBytes)+3+(channelSizeBytes))'; %3->2+1, extra byte comes from 
    %frewind(fid);
    
    %currentDigitalChannels stores the bytes to read 
    currentDigitalChannels = find(channels(:,1)==bytesToRead(i));  %all the channels that use the current byte (up to 8)
    for j = 1:length(currentDigitalChannels)
        %bitget accesses the bit given by channels(currentDigitalChannels(j),2)
        %recData(currentDigitalChannels(j)).data = logical(bitget(tmpData,channels(currentDigitalChannels(j),2)));
        recData = [recData; logical(bitget(tmpData,channels(currentDigitalChannels(j),2)))];
        %recData(currentDigitalChannels(j)).timeRange = [timestamps(1) timestamps(end)];
        %recData(currentDigitalChannels(j)).samplingRate = samplingRate;
    end
             
end

fclose(fid);

end



