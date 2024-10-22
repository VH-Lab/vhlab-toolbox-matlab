function [data,total_samples,total_time] = read_Intan_RHD2000_directory(directoryname,header,channel_type,channel_numbers,t0,t1, varargin)
% READ_INTAN_RHD2000_DIRECTORY - Read samples from an Intan data directory (1 file per channel format)
%
%  [DATA,TOTAL_SAMPLES,TOTAL_TIME,BLOCKINFO] = READ_INTAN_RHD2000_DIRECTORY(DIRECTORYNAME,
%     HEADER, CHANNEL_TYPE, CHANNEL_NUMBERS, T0, T1);
%
%  Inputs:
%  Reads data from the Intan Technologies .rhd 2000 directory DIRECTORYNAME.
%  The file HEADER information can be provided in HEADER.  If HEADER
%  is empty, then it will be read from the file. CHANNEL_TYPE is the
%  type of channel to be read (use table below). CHANNEL_NUMBERS are the
%  the channel numbers for which to return data (randing from 1 to the number
%  of channels of that type sampled). CHANNEL_NUMBERS are from 1...N where 
%  N is the number of channels ENABLED in the recording. 1 is the first channel 
%  enabled, 2 is the 2nd channel enabled, etc. One can examine the header file to 
%  see its correspondance with Intan bank and channel indexes (e.g., the first channel may be
%  'amp-A-000'). T0 is the time to start reading (the beginning of
%  the recording is 0) and T1 is the time to stop reading. If T0 is negative, we will
%  start with time 0. If T1 is INF, we will use the end time of the whole file.
%
%  NOTE: It is assumed that the DIRECTORY is a directory/folder with files written in the
%  Intan "1 file per channel" format.
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
%  2020-06-11 SDV - wrote it, checked time, amp, aux, supply, din
%                   could use more testing with different channel configurations and ADC and DOUT
%                   note: dout seems to write to disk even if it is not in the header file but
%                   this function will only examine channels that are listed in the header file
%

force_single_channel_read = 0;
assign(varargin{:});

if isempty(header),
	header = read_Intan_RHD2000_header([directoryname filesep 'info.rhd'] );
end;

[blockinfo, bytes_per_block, bytes_present, num_data_blocks] = Intan_RHD2000_blockinfo('', header);

 % we need to look at files to see what the total time is
 % usually time should always be present

fileinfo = dir([directoryname filesep 'time.dat']);

if isempty(fileinfo),
	error(['No file ' directoryname filesep 'time.dat, required file.']);
end;

total_samples = fileinfo.bytes / 4;
total_time = total_samples / header.frequency_parameters.amplifier_sample_rate; % in seconds

% NOW, WHICH DATA DID THE USER REQUEST US TO READ?

 % fix t0, t1 to be in range
if t0<0, t0 = 0; end;
if t1>(total_time-1/header.frequency_parameters.amplifier_sample_rate),
	t1 = total_time-1/header.frequency_parameters.amplifier_sample_rate;
end;

 % now compute starting and ending samples to read
s0 = 1+round(t0 * header.frequency_parameters.amplifier_sample_rate);
s1 = 1+round(t1 * header.frequency_parameters.amplifier_sample_rate);

 % determine which channels are going to be read into memory
ch = zeros(1,8);
if ischar(channel_type),
	switch(channel_type),
		case {'time','timestamp'}, channel_type = 1;
		case {'amp','amplifier'}, channel_type = 2;
		case {'aux','aux_in'}, channel_type = 3;
		case {'supply'}, channel_type = 4;
		case {'temp'}, channel_type = 5;
		case {'adc'}, channel_type = 6;
		case {'din','digital_in'}, channel_type = 7;
		case {'dout','digital_out'}, channel_type = 8;
		otherwise, error(['Unknown channel_type ' channel_type '.']); 
	end;
end;

data = []; % start out with blank data initially

% channel_type will be a single number

relevant_headers = { [], 'amplifier_channels', 'aux_input_channels', 'supply_voltage_channels', 'temp', 'board_adc_channels', ...
	'board_dig_in_channels','board_dig_out_channels'};

fileprefix = { [], 'amp-', 'aux-', 'vdd-', 'temp', 'board-', 'board-', 'board-'};
sample_size_bytes = [ 4 2 2 2 2 2 2];
sample_precision = { 'int32', 'int16', 'uint16', 'uint16', 'uint16', 'uint16', 'uint16' };
conversion_scale = [ 0 0.195 0.0000374 0.0000748 0 0.000050354 1 1];
conversion_shift = [ 0 0 0 0 0 0 0 ];
if header.fileinfo.eval_board_mode ~=0,
	conversion_shift(6) = -32768;
	conversion_scale(6) = 0.0003125;
end;

switch channel_type,
	case 1, % time
		if numel(channel_numbers)~=1,
			error(['Only 1 time channel, ' int2str(channel_numbers) ' requested.']);
		end;
		fid = fopen([directoryname filesep 'time.dat'],'r','l');
		if fid<0,
			error(['Could not open file ' directoryname filesep 'time.dat for reading.']);
		end;
		% time samples are int32, 4 bytes
		fseek(fid,4*(s0-1),'bof');
		data = fread(fid,s1-s0+1,'int32');
		data = data(:) / header.frequency_parameters.amplifier_sample_rate; % make sure it is column vector using (:)
		fclose(fid); % close the filename
	case {2,3,4,6,7,8},
		hinfo = getfield(header, relevant_headers{channel_type});
		for i=1:numel(channel_numbers),
			if channel_numbers(i) > numel(hinfo) | channel_numbers(i)<1,
				error(['Channel ' int2str(channel_numbers(i)) ' not in range 1 ... ' int2str(numel(hinfo)) ' listed in header.']);
			end;
			fname = [fileprefix{channel_type} hinfo(channel_numbers(i)).custom_channel_name '.dat'];
			fid = fopen([directoryname filesep fname],'r','l');
			fseek(fid,sample_size_bytes(channel_type)*(s0-1),'bof'); % move to point in file where our samples are saved
			data_here = double(fread(fid,s1-s0+1,sample_precision{channel_type}));
			fclose(fid);
			if conversion_shift(channel_type) ~=0,
				data_here = data_here - conversion_shift(channel_type);
			end;
			data(:,end+1) = data_here(:) * conversion_scale(channel_type); 
		end;	
	case 5,
		error(['Do not know how to read temperature in this mode yet.']);
end;

