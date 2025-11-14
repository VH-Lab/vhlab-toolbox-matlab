function vars = read_Intan_RHD2000_file_var(filename)
% read_Intan_RHD2000_file_var
%
% A modification of the manufacturer's code to accept a filename and
% return the variables in a struct.
vars = [];
fid = fopen(filename, 'r');
s = dir(filename);
filesize = s.bytes;
% Check 'magic number' at beginning of file to make sure this is an Intan
% Technologies RHD2000 data file.
magic_number = fread(fid, 1, 'uint32');
if magic_number ~= hex2dec('c6912702')
    error('Unrecognized file type.');
end
% Read version number.
data_file_main_version_number = fread(fid, 1, 'int16');
data_file_secondary_version_number = fread(fid, 1, 'int16');
if (data_file_main_version_number == 1)
    num_samples_per_data_block = 60;
else
    num_samples_per_data_block = 128;
end
% Read information of sampling rate and amplifier frequency settings.
sample_rate = fread(fid, 1, 'single');
dsp_enabled = fread(fid, 1, 'int16');
actual_dsp_cutoff_frequency = fread(fid, 1, 'single');
actual_lower_bandwidth = fread(fid, 1, 'single');
actual_upper_bandwidth = fread(fid, 1, 'single');
desired_dsp_cutoff_frequency = fread(fid, 1, 'single');
desired_lower_bandwidth = fread(fid, 1, 'single');
desired_upper_bandwidth = fread(fid, 1, 'single');
% This tells us if a software 50/60 Hz notch filter was enabled during
% the data acquisition.
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
% If data file is from GUI v1.3 or later, load board mode.
board_mode = 0;
if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 3) ...
        || (data_file_main_version_number > 1))
    board_mode = fread(fid, 1, 'int16');
end
% If data file is from v2.0 or later (Intan Recording Controller),
% load name of digital reference channel.
if (data_file_main_version_number > 1)
    reference_channel = fread_QString(fid);
end
% Place frequency-related information in data structure.
frequency_parameters = struct( ...
    'amplifier_sample_rate', sample_rate, ...
    'aux_input_sample_rate', sample_rate / 4, ...
    'supply_voltage_sample_rate', sample_rate / num_samples_per_data_block, ...
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
spike_triggers = struct(spike_trigger_struct);
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
new_channel = struct(channel_struct);
% Create structure arrays for each type of data channel.
amplifier_channels = struct(channel_struct);
aux_input_channels = struct(channel_struct);
supply_voltage_channels = struct(channel_struct);
board_adc_channels = struct(channel_struct);
board_dig_in_channels = struct(channel_struct);
board_dig_out_channels = struct(channel_struct);
amplifier_index = 1;
aux_input_index = 1;
supply_voltage_index = 1;
board_adc_index = 1;
board_dig_in_index = 1;
board_dig_out_index = 1;
% Read signal summary from data file header.
number_of_signal_groups = fread(fid, 1, 'int16');
for signal_group = 1:number_of_signal_groups
    signal_group_name = fread_QString(fid);
    signal_group_prefix = fread_QString(fid);
    signal_group_enabled = fread(fid, 1, 'int16');
    signal_group_num_channels = fread(fid, 1, 'int16');
    signal_group_num_amp_channels = fread(fid, 1, 'int16');
    if (signal_group_num_channels > 0 && signal_group_enabled > 0)
        new_channel(1).port_name = signal_group_name;
        new_channel(1).port_prefix = signal_group_prefix;
        new_channel(1).port_number = signal_group;
        for signal_channel = 1:signal_group_num_channels
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
                    case 0
                        amplifier_channels(amplifier_index) = new_channel;
                        spike_triggers(amplifier_index) = new_trigger_channel;
                        amplifier_index = amplifier_index + 1;
                    case 1
                        aux_input_channels(aux_input_index) = new_channel;
                        aux_input_index = aux_input_index + 1;
                    case 2
                        supply_voltage_channels(supply_voltage_index) = new_channel;
                        supply_voltage_index = supply_voltage_index + 1;
                    case 3
                        board_adc_channels(board_adc_index) = new_channel;
                        board_adc_index = board_adc_index + 1;
                    case 4
                        board_dig_in_channels(board_dig_in_index) = new_channel;
                        board_dig_in_index = board_dig_in_index + 1;
                    case 5
                        board_dig_out_channels(board_dig_out_index) = new_channel;
                        board_dig_out_index = board_dig_out_index + 1;
                    otherwise
                        error('Unknown channel type');
                end
            end
        end
    end
end
% Summarize contents of data file.
num_amplifier_channels = amplifier_index - 1;
num_aux_input_channels = aux_input_index - 1;
num_supply_voltage_channels = supply_voltage_index - 1;
num_board_adc_channels = board_adc_index - 1;
num_board_dig_in_channels = board_dig_in_index - 1;
num_board_dig_out_channels = board_dig_out_index - 1;
% Determine how many samples the data file contains.
% Each data block contains num_samples_per_data_block amplifier samples.
bytes_per_block = num_samples_per_data_block * 4; % timestamp data
bytes_per_block = bytes_per_block + num_samples_per_data_block * 2 * num_amplifier_channels;
% Auxiliary inputs are sampled 4x slower than amplifiers
bytes_per_block = bytes_per_block + (num_samples_per_data_block / 4) * 2 * num_aux_input_channels;
% Supply voltage is sampled once per data block
bytes_per_block = bytes_per_block + 1 * 2 * num_supply_voltage_channels;
% Board analog inputs are sampled at same rate as amplifiers
bytes_per_block = bytes_per_block + num_samples_per_data_block * 2 * num_board_adc_channels;
% Board digital inputs are sampled at same rate as amplifiers
if (num_board_dig_in_channels > 0)
    bytes_per_block = bytes_per_block + num_samples_per_data_block * 2;
end
% Board digital outputs are sampled at same rate as amplifiers
if (num_board_dig_out_channels > 0)
    bytes_per_block = bytes_per_block + num_samples_per_data_block * 2;
end
% Temp sensor is sampled once per data block
if (num_temp_sensor_channels > 0)
    bytes_per_block = bytes_per_block + 1 * 2 * num_temp_sensor_channels;
end
% How many data blocks remain in this file?
data_present = 0;
bytes_remaining = filesize - ftell(fid);
if (bytes_remaining > 0)
    data_present = 1;
end
num_data_blocks = floor(bytes_remaining / bytes_per_block);
num_amplifier_samples = num_samples_per_data_block * num_data_blocks;
num_aux_input_samples = (num_samples_per_data_block / 4) * num_data_blocks;
num_supply_voltage_samples = 1 * num_data_blocks;
num_board_adc_samples = num_samples_per_data_block * num_data_blocks;
num_board_dig_in_samples = num_samples_per_data_block * num_data_blocks;
num_board_dig_out_samples = num_samples_per_data_block * num_data_blocks;
if (data_present)
    % Pre-allocate memory for data.
    t_amplifier = zeros(1, num_amplifier_samples);
    amplifier_data = zeros(num_amplifier_channels, num_amplifier_samples);
    aux_input_data = zeros(num_aux_input_channels, num_aux_input_samples);
    supply_voltage_data = zeros(num_supply_voltage_channels, num_supply_voltage_samples);
    temp_sensor_data = zeros(num_temp_sensor_channels, num_supply_voltage_samples);
    board_adc_data = zeros(num_board_adc_channels, num_board_adc_samples);
    board_dig_in_data = zeros(num_board_dig_in_channels, num_board_dig_in_samples);
    board_dig_in_raw = zeros(1, num_board_dig_in_samples);
    board_dig_out_data = zeros(num_board_dig_out_channels, num_board_dig_out_samples);
    board_dig_out_raw = zeros(1, num_board_dig_out_samples);
    % Read sampled data from file.
    amplifier_index = 1;
    aux_input_index = 1;
    supply_voltage_index = 1;
    board_adc_index = 1;
    board_dig_in_index = 1;
    board_dig_out_index = 1;
    for i=1:num_data_blocks
        % In version 1.2, we moved from saving timestamps as unsigned
        % integeters to signed integers to accomidate negative (adjusted)
        % timestamps for pretrigger data.
        if ((data_file_main_version_number == 1 && data_file_secondary_version_number >= 2) ...
                || (data_file_main_version_number > 1))
            t_amplifier(amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'int32');
        else
            t_amplifier(amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint32');
        end
        if (num_amplifier_channels > 0)
            amplifier_data(:, amplifier_index:(amplifier_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_amplifier_channels], 'uint16')';
        end
        if (num_aux_input_channels > 0)
            aux_input_data(:, aux_input_index:(aux_input_index + (num_samples_per_data_block / 4) - 1)) = fread(fid, [(num_samples_per_data_block / 4), num_aux_input_channels], 'uint16')';
        end
        if (num_supply_voltage_channels > 0)
            supply_voltage_data(:, supply_voltage_index) = fread(fid, [1, num_supply_voltage_channels], 'uint16')';
        end
        if (num_temp_sensor_channels > 0)
            temp_sensor_data(:, supply_voltage_index) = fread(fid, [1, num_temp_sensor_channels], 'int16')';
        end
        if (num_board_adc_channels > 0)
            board_adc_data(:, board_adc_index:(board_adc_index + num_samples_per_data_block - 1)) = fread(fid, [num_samples_per_data_block, num_board_adc_channels], 'uint16')';
        end
        if (num_board_dig_in_channels > 0)
            board_dig_in_raw(board_dig_in_index:(board_dig_in_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint16');
        end
        if (num_board_dig_out_channels > 0)
            board_dig_out_raw(board_dig_out_index:(board_dig_out_index + num_samples_per_data_block - 1)) = fread(fid, num_samples_per_data_block, 'uint16');
        end
        amplifier_index = amplifier_index + num_samples_per_data_block;
        aux_input_index = aux_input_index + (num_samples_per_data_block / 4);
        supply_voltage_index = supply_voltage_index + 1;
        board_adc_index = board_adc_index + num_samples_per_data_block;
        board_dig_in_index = board_dig_in_index + num_samples_per_data_block;
        board_dig_out_index = board_dig_out_index + num_samples_per_data_block;
    end
end
% Close data file.
fclose(fid);
if (data_present)
    % Extract digital input channels to separate variables.
    for i=1:num_board_dig_in_channels
        mask = 2^(board_dig_in_channels(i).native_order) * ones(size(board_dig_in_raw));
        board_dig_in_data(i, :) = (bitand(board_dig_in_raw, mask) > 0);
    end
    for i=1:num_board_dig_out_channels
        mask = 2^(board_dig_out_channels(i).native_order) * ones(size(board_dig_out_raw));
        board_dig_out_data(i, :) = (bitand(board_dig_out_raw, mask) > 0);
    end
    % Scale voltage levels appropriately.
    amplifier_data = 0.195 * (amplifier_data - 32768); % units = microvolts
    aux_input_data = 37.4e-6 * aux_input_data; % units = volts
    supply_voltage_data = 74.8e-6 * supply_voltage_data; % units = volts
    if (board_mode == 1)
        board_adc_data = 152.59e-6 * (board_adc_data - 32768); % units = volts
    elseif (board_mode == 13) % Intan Recording Controller
        board_adc_data = 312.5e-6 * (board_adc_data - 32768); % units = volts
    else
        board_adc_data = 50.354e-6 * board_adc_data; % units = volts
    end
    temp_sensor_data = temp_sensor_data / 100; % units = deg C
    % Scale time steps (units = seconds).
    t_amplifier = t_amplifier / sample_rate;
    t_aux_input = t_amplifier(1:4:end);
    t_supply_voltage = t_amplifier(1:num_samples_per_data_block:end);
    t_board_adc = t_amplifier;
    t_dig = t_amplifier;
    t_temp_sensor = t_supply_voltage;
end
% Move variables to a struct.
vars.filename = filename;
vars.notes = notes;
vars.frequency_parameters = frequency_parameters;
if (data_file_main_version_number > 1)
    vars.reference_channel = reference_channel;
end
if (num_amplifier_channels > 0)
    vars.amplifier_channels = amplifier_channels;
    if (data_present)
        vars.amplifier_data = amplifier_data;
        vars.t_amplifier = t_amplifier;
    end
    vars.spike_triggers = spike_triggers;
end
if (num_aux_input_channels > 0)
    vars.aux_input_channels = aux_input_channels;
    if (data_present)
        vars.aux_input_data = aux_input_data;
        vars.t_aux_input = t_aux_input;
    end
end
if (num_supply_voltage_channels > 0)
    vars.supply_voltage_channels = supply_voltage_channels;
    if (data_present)
        vars.supply_voltage_data = supply_voltage_data;
        vars.t_supply_voltage = t_supply_voltage;
    end
end
if (num_board_adc_channels > 0)
    vars.board_adc_channels = board_adc_channels;
    if (data_present)
        vars.board_adc_data = board_adc_data;
        vars.t_board_adc = t_board_adc;
    end
end
if (num_board_dig_in_channels > 0)
    vars.board_dig_in_channels = board_dig_in_channels;
    if (data_present)
        vars.board_dig_in_data = board_dig_in_data;
        vars.t_dig = t_dig;
    end
end
if (num_board_dig_out_channels > 0)
    vars.board_dig_out_channels = board_dig_out_channels;
    if (data_present)
        vars.board_dig_out_data = board_dig_out_data;
        vars.t_dig = t_dig;
    end
end
if (num_temp_sensor_channels > 0)
    if (data_present)
        vars.temp_sensor_data = temp_sensor_data;
        vars.t_temp_sensor = t_temp_sensor;
    end
end
end
