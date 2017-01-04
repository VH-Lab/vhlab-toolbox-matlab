function [data,total_samples,total_time,blockinfo] = read_Intan_RHD2000_datafile(filename,header,channel_type,channel_numbers,t0,t1, varargin)
% READ_INTAN_RHD2000_DATAFILE - Read samples from an Intan data file
%
%  [DATA,TOTAL_SAMPLES,TOTAL_TIME,BLOCKINFO] = READ_INTAN_RHD2000_DATAFILE(FILENAME,
%     HEADER, CHANNEL_TYPE, CHANNEL_NUMBERS, T0, T1);
%
%  Inputs:
%  Reads data from the Intan Technologies .rhd 2000 file FILENAME.
%  The file HEADER information can be provided in HEADER.  If HEADER
%  is empty, then it will be read from the file. CHANNEL_TYPE is the
%  type of channel to be read (use table below). CHANNEL_NUMBERS are the
%  the channel numbers for which to return data (randing from 1 to the number
%  of channels of that type sampled). T0 is the time to start reading (the beginning of
%  the recording is 0) and T1 is the time to stop reading. If T0 is negative, we will
%  start with time 0. If T1 is INF, we will use the end time of the whole file.
%
%  CHANNEL_TYPE values:
%  Value:                      | Meaning:
%  --------------------------------------------------------------------------
%  'time', 'timestamps', or 1  | read timestamps of samples
%  'amp', 'amplifier' or 2     | read amplifier channels
%  'aux', 'aux_in', or 3       | read auxiliary input channels
%  'supply', or 4              | read supply voltages
%  'temp', or 5                | read temperature sensor
%  'adc', or 6                 | read analog to digital converter signals
%  'din', 'digital_in', or 7   | read digital input (a single channel of 16 bit values)
%  'dout', 'digital_out', or 8 | read digital output signal (a single channel)
% 
%  Outputs:
%    DATA - each column contains samples from an individual channel; if more than
%       one channel has been requested, DATA will have more than one column.
%    TOTAL_SAMPLES - The total number of (amplifier or digital) samples estimated to be
%       in the file.
%    TOTAL_TIME - An estimate of the total duration of the time series data in the
%       recorded file, in seconds.
%
%  Notes: (1) The Intan RHD2000 board has its own clock. Asking this function
%  to read at time T0=0 will read the first sample in the file. This time
%  might correspond to some other time on the Intan board.  Reading the
%  'time' channel will indicate the time of the sample on the board's clock.
%  (2) This function performs no filtering. Even if the user had checked
%  for the RHD2000 software to use a 60Hz notch or a high-pass filter,
%  this function returns the raw data. 
%
%  See also: READ_INTAN_RHD2000_HEADER
%
%  2014-12-08 SDV - wrote it and tested it
%

force_single_channel_read = 0;
assign(varargin{:});

if isempty(header),
	header = read_Intan_RHD2000_header(filename);
end;

  % get set up to read 
% how many channels do we have?
num_amplifier_channels = length(header.amplifier_channels);
num_aux_input_channels = length(header.aux_input_channels);
num_supply_voltage_channels = length(header.supply_voltage_channels);
num_board_adc_channels = length(header.board_adc_channels);
num_board_dig_in_channels = length(header.board_dig_in_channels);
num_board_dig_out_channels = length(header.board_dig_out_channels);
num_temp_sensor_channels = header.num_temp_sensor_channels;

% Determine how many samples the data file contains.

% BLOCK PARAMETERS - these change depending upon which channels were recorded
   % initially set all block_offsets to 0, then calculate them again later

block_piece    = struct('type','timestamp','block_offset',0,'bytes',60*4,'bytes_per_sample',4,'samples_per_block',60,'numchannels',1,...
	'interleaved',0,'precision',['60*uint32=>uint32'],'scale',1.0/header.frequency_parameters.amplifier_sample_rate,'shift',0);
if ((header.fileinfo.data_file_main_version_number == 1 && header.fileinfo.data_file_secondary_version_number >= 2) ...
	|| (header.fileinfo.data_file_main_version_number > 1))
	block_piece(1).precision = ['60*int32=>int32'];
end;
block_piece(2) = struct('type','amp','block_offset',0,'bytes',60*2*num_amplifier_channels,'bytes_per_sample',2,'samples_per_block',60,'numchannels',num_amplifier_channels,...
	'interleaved',1,'precision','*uint16=>uint16','scale',0.195,'shift',32768);
block_piece(3) = struct('type','aux','block_offset',0,'bytes',15*2*num_aux_input_channels,'bytes_per_sample',2,'samples_per_block',15,'numchannels',num_aux_input_channels,...
	'interleaved',1,'precision','*uint16=>uint16','scale',37.4e-6,'shift',0);
block_piece(4) = struct('type','supply','block_offset',0,'bytes',1*2*num_supply_voltage_channels,'bytes_per_sample',2,'samples_per_block',1,'numchannels',num_supply_voltage_channels,...
	'interleaved',1,'precision','*uint16=>uint16','scale',74.8e-6,'shift',0);
block_piece(5) = struct('type','temp','block_offset',0,'bytes',1*2*(num_temp_sensor_channels>0),'bytes_per_sample',2,'samples_per_block',1,'numchannels',num_temp_sensor_channels,...
	'interleaved',1,'precision','*int16=>int16','scale',1/100,'shift',0);
block_piece(6) = struct('type','board_adc','block_offset',0,'bytes',60*2*num_board_adc_channels,'bytes_per_sample',2,'samples_per_block',60,'numchannels',num_board_adc_channels,...
	'interleaved',1,'precision','*uint16=>uint16','scale',152.59e-6,'shift',32768);
if header.fileinfo.eval_board_mode~=1,
	block_piece(6).scale=50.354e-6;
	block_piece(6).shift = 0;
end;
block_piece(7) = struct('type','din','block_offset',0,'bytes',60*2*(num_board_dig_in_channels>0),'bytes_per_sample',2,'samples_per_block',60,'numchannels',uint16(num_board_dig_in_channels>0),...
	'interleaved',0,'precision',['60*uint16=>uint16'],'scale',1,'shift',0);
block_piece(8) = struct('type','dout','block_offset',0,'bytes',60*2*(num_board_dig_out_channels>0),'bytes_per_sample',2,'samples_per_block',60,'numchannels',uint16(num_board_dig_out_channels>0),...
	'interleaved',0,'precision',['60*uint16=>uint16'],'scale',1,'shift',0);

block_offset = 0;
for i=1:length(block_piece), 
	block_piece(i).block_offset = block_offset;
	block_offset = block_offset + block_piece(i).bytes;
end;
bytes_per_block = block_offset;

blockinfo = block_piece;

% How many data blocks are in this file?
bytes_present = header.fileinfo.filesize - header.fileinfo.headersize;
num_data_blocks = bytes_present / bytes_per_block;

% END of BLOCK PARAMETERS

total_samples = 60 * num_data_blocks;
total_time = total_samples / header.frequency_parameters.amplifier_sample_rate; % in seconds

% NOW, WHICH DATA DID THE USER REQUEST US TO READ?

 % fix t0, t1 to be in range
if t0<1, t0 = 0; end;
if t1>(total_time-1/header.frequency_parameters.amplifier_sample_rate),
	t1 = total_time-1/header.frequency_parameters.amplifier_sample_rate;
end;

 % now compute starting and ending samples to read
s0 = 1+fix(t0 * header.frequency_parameters.amplifier_sample_rate);
s1 = 1+fix(t1 * header.frequency_parameters.amplifier_sample_rate);

 % where do these samples live? in which blocks?
block0 = ceil(s0/60);
block0_s = mod(s0,60) + (mod(s0,60)==0)*60; % s0 is the block0_s sample in block0
block1 = ceil(s1/60);
block1_s = mod(s1,60) + (mod(s1,60)==0)*60; % s1 is the block1_s sample in block1

 % determine which channels are going to be read into memory
ch = zeros(1,8);
if ischar(channel_type),
	switch(channel_type),
		case {'time','timestamp'}, channel_type = 1;
		case {'amp','amplifier'}, channel_type = 2;
		case {'aux','aux_in'}, channel_type = 3;
		case {'suppy'}, channel_type = 4;
		case {'temp'}, channel_type = 5;
		case {'adc'}, channel_type = 6;
		case {'din','digital_in'}, channel_type = 7;
		case {'dout','digital_out'}, channel_type = 8;
		otherwise, error(['Unknown channel_type ' channel_type '.']); 
	end;
end;
ch(channel_type) = 1;
c = find(ch);


% NOW, WE KNOW WHAT TO READ, LET'S READ IT

fid = fopen(filename,'r');
if fid<0,
	error(['Could not open filename ' filename ' for reading (check path, spelling, permissions).']);
end;

 % now read the data 

data = [];

if block_piece(c).interleaved==0,
    if ~all(ismember(channel_numbers,[1:block_piece(c).numchannels])),
        error(['Requested channel(s) ' mat2str(channel_numbers) ' for type ''' block_piece(c).type ''' out of available range ' mat2str([1:block_piece(c).numchannels]) '.']);
    end;
	% read it all in one fread call!
	fseek(fid,header.fileinfo.headersize+bytes_per_block*(block0-1)+block_piece(c).block_offset,'bof');
	data=fread(fid,block_piece(c).samples_per_block*(block1-block0+1),block_piece(c).precision,bytes_per_block-block_piece(c).bytes);
else,
    if ~all(ismember(channel_numbers,[1:block_piece(c).numchannels])),
        error(['Requested channel(s) ' mat2str(channel_numbers) ' for type ''' block_piece(c).type ''' out of available range ' mat2str([1:block_piece(c).numchannels]) '.']);
    end;

	if ~all((channel_numbers>0)&(channel_numbers<=block_piece(c).numchannels)),
		error(['Requested channel list includes an out-of-range channnel: suitable range is 1 to ' int2str(block_piece(c).numchannels) ', request was ' int2str(channel_numbers) '.']);
	end;

	[chan_sort,chan_sort_indexes] = sort(channel_numbers);
	% do we have consecutive channels requested? (so we can read it with a single fread function call)
	consecutive_channels_requested = length(channel_numbers)==1|eqlen(diff(chan_sort),ones(1,length(channel_numbers)-1));

	if ~force_single_channel_read & consecutive_channels_requested,
			% we want to read samples_per_block * number_channel_samples then skip the rest of the block
		channels_to_skip_before_reading = chan_sort(1)-1;
		channels_remaining_after_read = block_piece(c).numchannels - chan_sort(end);
			% skip to right point in file

		skip_point = header.fileinfo.headersize + ... % skip header file
				bytes_per_block*(block0-1) + ... % skip previous blocks
                                block_piece(c).block_offset + ... % skip previous elements in this block
				block_piece(c).bytes_per_sample*block_piece(c).samples_per_block*channels_to_skip_before_reading; % skip to our first channel of interest

		skip_after_each_read = bytes_per_block + ... % skip a whole block, except
				(-block_piece(c).bytes) + ... % don't skip the part of the block that has this type of channel data
				block_piece(c).bytes_per_sample*block_piece(c).samples_per_block*(channels_to_skip_before_reading) + ... % do skip channels before the ones we are reading
				block_piece(c).bytes_per_sample*block_piece(c).samples_per_block*(channels_remaining_after_read); % do skip channels after the ones we are reading

		fseek(fid,skip_point,'bof');
		data=fread(fid,length(channel_numbers)*block_piece(c).samples_per_block*(block1-block0+1),[int2str(block_piece(c).samples_per_block*length(channel_numbers)) block_piece(c).precision],...
			skip_after_each_read);

		% demix the read data
		data = reshape(data, block_piece(c).samples_per_block, length(channel_numbers), (block1-block0+1));
		data = permute(data,[2 1 3]);
		data = reshape(data,length(channel_numbers),numel(data)/length(channel_numbers))';

		if ~eqlen(chan_sort,channel_numbers),
			data = data(:,chan_sort_indexes); % resort to match user request
		end;
	else, % numbers not consecutive, read all individually (or user forced individual channel read)
		data = zeros(s1-s0+1,length(channel_numbers));
		for i=1:length(channel_numbers),
			channels_to_skip_before_reading = channel_numbers(i)-1;
			channels_remaining_after_read = block_piece(c).numchannels - channel_numbers(i);

			skip_point = header.fileinfo.headersize + ... % skip header file
				bytes_per_block*(block0-1) + ... % skip previous blocks
                                block_piece(c).block_offset + ... % skip previous elements in this block
				block_piece(c).bytes_per_sample*block_piece(c).samples_per_block*channels_to_skip_before_reading; % skip to our first channel of interest

			skip_after_each_read = bytes_per_block + ... % skip a whole block, except
				(-block_piece(c).bytes) + ... % don't skip the part of the block that has this type of channel data
				block_piece(c).bytes_per_sample*block_piece(c).samples_per_block*(channels_to_skip_before_reading) + ... % do skip channels before the ones we are reading
				block_piece(c).bytes_per_sample*block_piece(c).samples_per_block*(channels_remaining_after_read); % do skip channels after the ones we are reading

			fseek(fid,skip_point,'bof');
			data(:,i)=fread(fid,block_piece(c).samples_per_block*(block1-block0+1),[int2str(block_piece(c).samples_per_block) block_piece(c).precision],...
				skip_after_each_read)';
		end;
	end;
end;

fclose(fid);  % close the file

% trim to match user requested samples
if block0_s~=0 | block1_~=60,
	data = data(block0_s:end-(60-block1_s),:);
end;

if block_piece(c).shift ~=0, 
	data = double(data) - block_piece(c).shift;
end;

if block_piece(c).scale ~= 1, 
	data = double(data) * block_piece(c).scale;
end;
