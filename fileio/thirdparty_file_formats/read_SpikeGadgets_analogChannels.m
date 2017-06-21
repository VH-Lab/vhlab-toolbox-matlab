function [recData, timestamps] = read_SpikeGadgets_analogChannels(filename,NumChannels, channels, samplingRate,headerSize,s0,s1, configExists)

% [recData, timestamps] = read_SpikeGadgets_analogChannels(filename,NumChannels, channels, samplingRate,headerSize, configExists) )
% Imports digital channel data in matlab from the raw data file
%
% INPUTS
% filename-- a string containing the name of the .dat file (raw file from SD card)
% NumChannels-- the number of channels in the recording (i.e., 32,64,96...)
% channels-- the analog channels you want to extract, designated by the byte location (1-based), i.e., [3 5 7]
% samplingRate-- the sampling rate of the recording, i.e 30000
% headerSize--the size, in int16's, of the header block of the data
% (contains DIO channels and aux analog channels).
%
% OUTPUTS
% timestamps--the system clock when each sample was taken
% recData-- an N by M matrix with N data points and M channels (M is equal to the number of channels in the input)

configsize = 0;
if (nargin < 8)
    configExists = 1;
end

fid = fopen(filename,'r');

%Store config text
if (configExists)
    junk = fread(fid,30000,'char');
    configsize = strfind(junk','</Configuration>')+16;
end

%Number of bytes we will read
headerSizeBytes = str2num(headerSize) * 2; %int16 = 2 bytes
channelSizeBytes = str2num(NumChannels) * 2; %int16 = 2 bytes
blockSizeBytes = headerSizeBytes + 2 + channelSizeBytes;

%get the timestamps
%junk = fread(fid,configsize,'char');
%junk = fread(fid,headerSize,'int16');
fseek(fid,configsize,'bof'); %seek to configsize length from beginning of file
fseek(fid,headerSizeBytes,'cof'); %seek to headerSizeBytes length from current position in file
timestamps = fread(fid,[1,inf],'1*uint32=>uint32',(headerSizeBytes)+(channelSizeBytes))';
timestamps = double(timestamps)/samplingRate;


bytesToRead = channels; %find the list of unique bytes to read in
recData = [];
for i = 1:length(bytesToRead)
    %junk = fread(fid,configsize,'char'); %skip config
    %junk = fread(fid,bytesToRead(i)-1,'char'); %skip bytes in header block up to the correct byte
    fseek(fid,configsize,'bof'); %seek to configsize length from beginning of file
    fseek(fid,bytesToRead(i)-1,'cof'); %seek to headerSizeBytes length from current position in file
    %Read actual data for desired size from sample numbers inputed s1-s0+1, skipping block each time
    tmpData = fread(fid,s1-s0+1,'1*int16=>int16',blockSizeBytes)'; %transposed from vertical to horizontal

    recData = [recData; tmpData]; %append in a new row to recData

end

fclose(fid);

end
