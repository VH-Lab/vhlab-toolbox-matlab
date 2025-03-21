function data = read_IntanRHD2000_one_file_per_channel_type(directory_name, channel_type, channel_index, num_channels, s0, s1)
    % read_IntanRHD2000_one_file_per_channel_type Reads data from Intan RHD2000 files.
    %
    %   DATA = read_IntanRHD2000_one_file_per_channel_type(DIRECTORY_NAME, CHANNEL_TYPE, CHANNEL_INDEX, NUM_CHANNELS, S0, S1)
    %   reads data from Intan RHD2000 files where each channel type is stored in a separate file.
    %
    %   DIRECTORY_NAME is the directory containing the data files.
    %   CHANNEL_TYPE is an integer specifying the type of data to read:
    %       1: time.dat
    %       2: amplifier.dat
    %       3: auxin.dat
    %       4: supply.dat
    %       5: temp.dat
    %       6: analogin.dat
    %       7: digitalin.dat
    %       8: digitalout.dat
    %   CHANNEL_INDEX is the index of the channel to read (1-based).
    %   NUM_CHANNELS is the total number of channels of the specified type.
    %   S0 is the starting sample index (1-based).
    %   S1 is the ending sample index (1-based).
    %
    %   DATA is a vector containing the requested data samples.
    %
    %   Example:
    %       data = read_IntanRHD2000_one_file_per_channel_type('data', 2, 1, 32, 100, 200);
    %       % Reads samples 100 to 200 from the first amplifier channel from 32 channels.
    %
    %   See also: fixdatfilename
    arguments
        directory_name (1, :) char {mustBeFolder(directory_name)}
        channel_type (1, 1) double {mustBeMember(channel_type, 1:8)}
        channel_index (1, 1) double {mustBeInteger, mustBePositive}
        num_channels (1, 1) double {mustBeInteger, mustBePositive}
        s0 (1, 1) double {mustBeInteger, mustBePositive}
        s1 (1, 1) double {mustBeInteger, mustBePositive, mustBeGreaterThanOrEqual(s1, s0)}
    end


sample_size_bytes = [ 4 2 2 2 2 2 2];
sample_precision = { 'int32', 'int16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16' };

switch(channel_type)
    case 1
        filename_post = 'time.dat';
    case 2
        filename_post = 'amplifier.dat';
    case 3
        filename_post = 'auxin.dat'; % guess
    case 4
        filename_post = 'supply.dat'; % guess
    case 5
        filename_post = 'temp.dat'; % guess
    case 6
        filename_post = 'analogin.dat'; 
    case 7
        filename_post = 'digitalin.dat';
    case 8
        filename_post = 'digitalout.dat'; % guess
    otherwise
        error(['Unknown channel_type ' int2str(channel_type)]);
end % switch

fn = fixdatfilename([directory_name filesep filename_post]);

fid = fopen(fn,'r','ieee-le');
if fid<0
    error(['Could not open ' fn ' for reading.']);
end

% move num_channels * size * (s0-1) samples in, and then channel_index - 1 further
fseek(fid,sample_size_bytes(channel_type)*(num_channels*(s0-1) + channel_index-1),'bof');

% now read the data, skipping numchannels-1 samples each time
data = fread(fid,s1-s0+1,sample_precision{channel_type},sample_size_bytes(channel_type)*(num_channels-1));

fclose(fid);

end

function fn = fixdatfilename(filename)
% FIXDATFILENAME - if the filename has a prefix, find it
%
% FN = FIXDATFILENAME(FILENAME)
%
% Checks to make sure filename exists. If not, it looks for a file with
% a prefix (e.g., XXXfilename).
%
if isfile(filename)
    fn = filename;
    return;
end;

[parentdir,fname,ext] = fileparts(filename);

d = dir([parentdir filesep '*' fname ext]);

if ~isempty(d)
    fn = [parentdir filesep d(1).name];
    return;
end;

end