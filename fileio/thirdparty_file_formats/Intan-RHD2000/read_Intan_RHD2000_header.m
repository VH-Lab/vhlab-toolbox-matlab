function [header] = read_Intan_RHD2000_header(filename);
% READ_INTAN_RHD2000_HEADER - Read header information from an Intan data file
%
%   HEADER = READ_INTAN_RHD2000_HEADER(FILENAME)
%
% Returns a structure HEADER with all of the information fields that
% are stored in the Intan RHD2000 file FILENAME.
%
% HEADER contains several substructures:
% --------------------------------------------------------------------
% fileinfo                |  Information about the file and its version
% frequency_parameters    |  Information about sampling frequency 
% spike_triggers          |  Information about spike triggers for each amplifier channel
% amplifier_channels      |  Information about amplifier channels
% aux_input_channels      |  Information about auxillary input channels
% supply_voltage_channels |  Information about supply voltage channels
% board_adc_channels      |  Information about the board analog to digital converter channels
% board_dig_in_channels   |  Digital input channels
% board_dig_out_channels  |  Digital output channels
% num_temp_sensor_channels|  Number of temperature sensor channels
%
% See also: READ_INTAN_RDH2000_DATAFILE
%

fid = fopen(filename, 'r');
[dirname,fname]=fileparts(filename);
s = dir(filename);
if isempty(s),
    error(['Could not find a file ' filename '; check spelling, permissions, extension']);
end;
filesize = s.bytes;
% Check 'magic number' at beginning of file to make sure this is an Intan
% Technologies RHD2000 data file.
magic_number = fread(fid, 1, 'uint32');
if magic_number ~= hex2dec('c6912702');
	error('Unrecognized file type.');
end

% Read version number.
data_file_main_version_number = fread(fid, 1, 'int16');
data_file_secondary_version_number = fread(fid, 1, 'int16');

% Read information of sampling rate and amplifier frequency settings.
sample_rate = fread(fid, 1, 'single');
dsp_enabled = fread(fid, 1, 'int16');
actual_dsp_cutoff_frequency = fread(fid, 1, 'single');
actual_lower_bandwidth = fread(fid, 1, 'single');
actual_upper_bandwidth = fread(fid, 1, 'single');

desired_dsp_cutoff_frequency = fread(fid, 1, 'single');
desired_lower_bandwidth = fread(fid, 1, 'single');
desired_upper_bandwidth = fread(fid, 1, 'single');

% This tells us if a software 50/60 Hz notch filter was enabled during the data acquisition.
notch_filter_mode = fread(fid, 1, 'int16');
notch_filter_frequency = 0;
if (notch_filter_mode == 1)
	notch_filter_frequency = 50;
elseif (notch_filter_mode == 2)
	notch_filter_frequency = 60;
end

desired_impedance_test_frequency = fread(fid, 1, 'single');
actual_impedance_test_frequency = fread(fid, 1, 'single');

% Place notes in data strucure
notes = struct( ...
    'note1', fread_QString(fid), ...
    'note2', fread_QString(fid), ...
    'note3', fread_QString(fid) );
    
% If data file is from GUI v1.1 or later, see if temperature sensor data
% was saved.
num_temp_sensor_channels = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 1) ...
	|| (data_file_main_version_number > 1))
	num_temp_sensor_channels = fread(fid, 1, 'int16');
end

% If data file is from GUI v1.3 or later, load eval board mode.
eval_board_mode = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 3) ...
	|| (data_file_main_version_number > 1))
		eval_board_mode = fread(fid, 1, 'int16');
end

header.fileinfo = struct(...
	'dirname',dirname,...
	'filename',fname,...
	'filesize',filesize,...
	'magic_number', magic_number,...
	'data_file_main_version_number',data_file_main_version_number,...
	'data_file_secondary_version_number',data_file_secondary_version_number,...
	'eval_board_mode',eval_board_mode,...
	'notes',notes);

% Place frequency-related information in data structure.
header.frequency_parameters = struct( ...
	'amplifier_sample_rate', sample_rate, ...
	'aux_input_sample_rate', sample_rate / 4, ...
	'supply_voltage_sample_rate', sample_rate / 60, ...
	'board_adc_sample_rate', sample_rate, ...
	'board_dig_in_sample_rate', sample_rate, ...
	'desired_dsp_cutoff_frequency', desired_dsp_cutoff_frequency, ...
	'actual_dsp_cutoff_frequency', actual_dsp_cutoff_frequency, ...
	'dsp_enabled', dsp_enabled, ...
	'desired_lower_bandwidth', desired_lower_bandwidth, ...
	'actual_lower_bandwidth', actual_lower_bandwidth, ...
	'desired_upper_bandwidth', desired_upper_bandwidth, ...
	'actual_upper_bandwidth', actual_upper_bandwidth, ...
	'notch_filter_frequency', notch_filter_frequency, ...
	'desired_impedance_test_frequency', desired_impedance_test_frequency, ...
	'actual_impedance_test_frequency', actual_impedance_test_frequency );

% Define data structure for spike trigger settings.
spike_trigger_struct = struct( ...
	'voltage_trigger_mode', {}, ...
	'voltage_threshold', {}, ...
	'digital_trigger_channel', {}, ...
	'digital_edge_polarity', {} );

new_trigger_channel = struct(spike_trigger_struct);

% Define data structure for data channels.
channel_struct = struct( ...
	'native_channel_name', {}, ...
	'custom_channel_name', {}, ...
	'native_order', {}, ...
	'custom_order', {}, ...
	'board_stream', {}, ...
	'chip_channel', {}, ...
	'port_name', {}, ...
	'port_prefix', {}, ...
	'port_number', {}, ...
	'electrode_impedance_magnitude', {}, ...
	'electrode_impedance_phase', {} );

new_channel = struct(channel_struct); % an empty structure to use to build a record for each channel

% Create structure arrays for each type of data channel.
header.spike_triggers = struct(spike_trigger_struct);
header.amplifier_channels = struct(channel_struct);
header.aux_input_channels = struct(channel_struct);
header.supply_voltage_channels = struct(channel_struct);
header.board_adc_channels = struct(channel_struct);
header.board_dig_in_channels = struct(channel_struct);
header.board_dig_out_channels = struct(channel_struct);
header.num_temp_sensor_channels = num_temp_sensor_channels;

amplifier_index = 1;
aux_input_index = 1;
supply_voltage_index = 1;
board_adc_index = 1;
board_dig_in_index = 1;
board_dig_out_index = 1;

%Read signal summary from data file header.

number_of_signal_groups = fread(fid, 1, 'int16');

for signal_group = 1:number_of_signal_groups
	signal_group_name = fread_QString(fid);
	signal_group_prefix = fread_QString(fid);
	signal_group_enabled = fread(fid, 1, 'int16');
	signal_group_num_channels = fread(fid, 1, 'int16');
	signal_group_num_amp_channels = fread(fid, 1, 'int16');

	if (signal_group_num_channels > 0 && signal_group_enabled > 0),
		new_channel(1).port_name = signal_group_name;
		new_channel(1).port_prefix = signal_group_prefix;
		new_channel(1).port_number = signal_group;
		for signal_channel = 1:signal_group_num_channels,
			new_channel(1).native_channel_name = fread_QString(fid);
			new_channel(1).custom_channel_name = fread_QString(fid);
			new_channel(1).native_order = fread(fid, 1, 'int16');
			new_channel(1).custom_order = fread(fid, 1, 'int16');
			signal_type = fread(fid, 1, 'int16');
			channel_enabled = fread(fid, 1, 'int16');
			new_channel(1).chip_channel = fread(fid, 1, 'int16');
			new_channel(1).board_stream = fread(fid, 1, 'int16');
			new_trigger_channel(1).voltage_trigger_mode = fread(fid, 1, 'int16');
			new_trigger_channel(1).voltage_threshold = fread(fid, 1, 'int16');
			new_trigger_channel(1).digital_trigger_channel = fread(fid, 1, 'int16');
			new_trigger_channel(1).digital_edge_polarity = fread(fid, 1, 'int16');
			new_channel(1).electrode_impedance_magnitude = fread(fid, 1, 'single');
			new_channel(1).electrode_impedance_phase = fread(fid, 1, 'single');
            
			if (channel_enabled)
				switch (signal_type)
					case 0 % amplifier channel
						header.amplifier_channels(amplifier_index) = new_channel;
						header.spike_triggers(amplifier_index) = new_trigger_channel;
						amplifier_index = amplifier_index + 1;
					case 1 % aux input channel
						header.aux_input_channels(aux_input_index) = new_channel;
						aux_input_index = aux_input_index + 1;
					case 2, % supply voltage channels
						header.supply_voltage_channels(supply_voltage_index) = new_channel;
						supply_voltage_index = supply_voltage_index + 1;
					case 3, % adc channel
						header.board_adc_channels(board_adc_index) = new_channel;
						board_adc_index = board_adc_index + 1;
					case 4 % digital in
						header.board_dig_in_channels(board_dig_in_index) = new_channel;
						board_dig_in_index = board_dig_in_index + 1;
					case 5 % digital out
						header.board_dig_out_channels(board_dig_out_index) = new_channel;
						board_dig_out_index = board_dig_out_index + 1;
					otherwise % error
						error('Unknown channel type');
				end
			end
		end
	end
end

header.fileinfo.headersize = ftell(fid); % get the location of the next byte to be read

fclose(fid);
