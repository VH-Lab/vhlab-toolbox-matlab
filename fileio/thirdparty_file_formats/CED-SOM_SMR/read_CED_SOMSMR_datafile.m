function [data,total_samples,total_time,blockinfo,time] = read_CED_SOMSMR_datafile(filename,header,channel_number,t0,t1, varargin)
% READ_CED_SOMSMR_DATAFILE - Reads samples from a CED SOM/SMR file 
%
%  [DATA,TOTAL_SAMPLES,TOTAL_TIME,BLOCKINFO,TIME] = READ_CED_SOMSMR_DATAFILE(FILENAME,
%     HEADER, CHANNEL_NUMBER, T0, T1);
%
%  Inputs:
%  Reads data from the Cambridge Electronic Design .SOM or .SMR file FILENAME.
%  The file HEADER information can be provided in HEADER.  If HEADER
%  is empty, then it will be read from the file.  CHANNEL_NUMBER is the
%  the channel number for which to return data (ranging from 1 to the number
%  of channels ). T0 is the time to start reading (the beginning of the recording is 0)
%  and T1 is the time to stop reading. If T0 is negative, we will start with time 0.
%  If T1 is INF, we will use the end time of the whole file.
%
%  Outputs:
%    DATA - each column contains samples from an individual channel; if more than
%       one channel has been requested, DATA will have more than one column.
%    TOTAL_SAMPLES - The total number of (amplifier or digital) samples estimated to be
%       in the file.
%    TOTAL_TIME - An estimate of the total duration of the time series data in the
%       recorded file, in seconds.
%    BLOCKINFO - the output of SONGETBLOCKHEADERS that describes the file blocks
%    TIME - a vector corresponding to the time of each sample read
%
%  See also: READ_CED_SOMSMR_HEADER, READ_CED_SOMSMR_SAMPLEINTERVAL
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
		total_time = chheader.sampleinterval*1e-6 * total_samples;

		s0 = point2samplelabel(t0,chheader.sampleinterval*1e-6);
		s1 = point2samplelabel(t1,chheader.sampleinterval*1e-6);

		block_start = 1 + floor(s0/block_length);
		start_sample_within_block = mod(s0,block_length);
		block_stop = 1 + floor(s1/block_length);
		stop_sample_within_block = mod(s1,block_length);
		samples_to_trim = blockinfo(5,block_stop) - stop_sample_within_block;

		data = SONGetADCChannel(fid,header.channelinfo(channel_index).number,...
			block_start,block_stop,'scale');
		data = data(start_sample_within_block:end-samples_to_trim);
		if any(size(data)==1), data = data(:); end; % ensure column for single vector
		time = chheader.start + ((s0:s1)-1)* chheader.sampleinterval*1e-6;

	case {2,3,4}, % event
		blockinfo = SONGetBlockHeaders(fid,header.channelinfo(channel_index).number);
		blocktimes = block_info(2:3,:)*header.fileinfo.usPerTime*header.fileinfo.dTimeBase;
		
		block_start = find(blocktimes(1,:)<=t0 & blocktimes(2,:)>=t0);
		block_end = find(blocktimes(2,:)<=t1,1,'first');
		[data]=SONGetEventChannel(fid,header.channelinfo(channel_index).number,...
			block_start,block_end);
		data = data(find(data>=t0 & data<=t1));

		fclose(fid);

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

