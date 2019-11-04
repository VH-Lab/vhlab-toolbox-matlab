function [recData, timestamps] = read_SpikeGadgets_trodeChannels(filename,NumChannels,channels,samplingRate,headerSize,s0,s1)
% [recData, timestamps] = read_SpikeGadgets_trodeChannels(filename,NumChannels,channels,samplingRate,headerSize, configExists) )
% Imports channel data in matlab from the raw data file
%
% INPUTS
% filename-- a string containing the name of the .dat file (raw file from SD card)
% NumChannels-- the number of channels in the recording (i.e., 32,64,96...)
% channels-- the channels you want to extract (extracting all channels at
% once may overload memory) numbers 1-120 which belong to each 4 of the 30 tetrodes
% samplingRate-- the sampling rate of the recording, i.e 30000
% headerSize--the size, in int16's, of the header block of the data
% (contains DIO channels and aux analog channels). calculated from (MCUnumbytes + ECUnumbytes + 1) / 2 = 17
%
% OUTPUTS
% timestamps--the system clock when each sample was taken
% recData-- an N by M matrix with N data points and M channels (M is equal to the number of channels in the input)

configsize = 0;
if (nargin < 8)
    configExists = 1;
end
% We open file
fid = fopen(filename,'r');

% Store config text
if (configExists)
    junk = fread(fid,30000,'char');
    configsize = strfind(junk','</Configuration>')+16;
end

headerSizeBytes = str2num(headerSize) * 2; % int16 = 2 bytes
channelSizeBytes = str2num(NumChannels) * 2; % int16 = 2 bytes
blockSizeBytes = headerSizeBytes + 2 + channelSizeBytes;

if (nargout > 1)
    junk = fread(fid,configsize,'char');
    fseek(fid,configsize,'bof'); % seek to configsize length from beginning of file
    fseek(fid,headerSizeBytes,'cof'); % seek to headerSizeBytes length from current position in file
    timestamps = (fread(fid,s1-s0+1,'1*uint32=>double',(headerSizeBytes)+(channelSizeBytes))') / samplingRate;
end

recData = [];

for i = 1:length(channels)
    fseek(fid, configsize, 'bof'); % seek to configsize length from beginning of file
    fseek(fid, headerSizeBytes, 'cof'); % seek to headerSizeBytes length from current position in file
    fseek(fid, 4, 'cof'); % timestamp uint32 = 4 bytes
    fseek(fid, 2*(channels(i) - 1), 'cof'); % int16 = 2 bytes
    fseek(fid, (s0-1) * blockSizeBytes, 'cof'); % goes to correct s0

    % Read actual data for desired size from sample numbers inputed s1-s0+1, skipping block each time
    channelData = fread(fid, s1-s0+1, '1*int16=>int16', blockSizeBytes)'; % transposed from vertical to horizontal
    channelData = double(channelData); % spike points down
    channelData = channelData * 12780; % convert to uV (for Intan digital chips)
    channelData = channelData / 65536;
    recData = [recData; channelData]; % append in a new row to recData

end

recData = recData';

fclose(fid);

end
