function [sampleinterval,total_samples,total_time,blockinfo] = read_CED_SOMSMR_sampleinterval(filename,header,channel_number, varargin)
% READ_CED_SOMSMR_SAMPLEINTERVAL - Reads samples from a CED SOM/SMR file 
%
%  [DATA,TOTAL_SAMPLES,TOTAL_TIME,BLOCKINFO] = READ_CED_SOMSMR_DATAFILE(FILENAME,
%     HEADER, CHANNEL_NUMBER);
%
%  Inputs:
%  Reads the sampleinterval (in seconds) for a given channel from the
%  Cambridge Electronic Design .SOM or .SMR file FILENAME. The file HEADER
%  information can be provided in HEADER. If HEADER is empty, then it will
%  be read from the file.  CHANNEL_NUMBER is the the channel number for which
%  to return data; it corresponds to the channel number in the Spike2 .SMR file 
%  (that is, in the Sampling Configuration that was used on Spike2).
%
%  Outputs:
%    SAMPLE_INTERVAL - each column contains samples from an individual channel; if more than
%       one channel has been requested, DATA will have more than one column.
%    TOTAL_SAMPLES - The total number of (amplifier or digital) samples estimated to be
%       in the file.
%    TOTAL_TIME - An estimate of the total duration of the time series data in the
%       recorded file, in seconds.
%
%  See also: READ_CED_SOMSMR_DATAFILE, READ_CED_SOMSMR_HEADER
%

if isempty(header),
	header = read_CED_SOMSMR_header(filename);
end;

channel_index = find([[header.channelinfo.number]==channel_number]);

if isempty(channel_index),
	error(['Channel number ' int2str(channel_number) ' not recorded in file ' filename '.']);
end

[pathname filename2 extension] = fileparts(filename);
if strcmpi(extension,'.smr'), % little endian
        fid=fopen(filename,'r','l');
elseif strcmp(extension,'.son'), % big endian
        fid=fopen(filename,'r','b');
else,
        error(['Unknown extension for SOM/SMR file: .' extension '.']);
end;

switch (header.channelinfo(channel_index).kind),

	case {1,9}, % ADC
		blockinfo = SONGetBlockHeaders(fid,header.channelinfo(channel_index).number);
		block_length = blockinfo(5,1); % assume all blocks except last have same length
				% assume last block has possibly fewer samples but not greater

		total_samples = sum(blockinfo(5,:));

		[dummy,chheader] = SONGetADCChannel(fid,header.channelinfo(channel_index).number,1,1);

		sampleinterval = chheader.sampleinterval * 1e-6;

	case {2,3,4}, % event
		fclose(fid);
		error(['need to implement this channel type.']);

	case {5,7,8}, % marker
		fclose(fid);
		error(['need to implement this channel type.']);

	case 6, % wavemark
		fclose(fid);
		error(['need to implement this channel type.']);

	otherwise,
		fclose(fid);
		error(['Unknown channel kind: ' int2str(header.channelinfo(channel_index).kind)  '.']);
end

fclose(fid);

