function [data, total_samples, total_time] = read_Willow_datafile(filename, header, channel_type, channel_numbers, t0, t1);
% READ_WILLOW_DATAFILE - Reads Willow data files from LeafLabs hardware
% 
%  [DATA, TOTAL_SAMPLES, TOTAL_TIME] = READ_WILLOW_DATAFILE(FILENAME, HEADER, ...
%     CHANNEL_TYPE, CHANNEL_NUMBERS, T0, T1);
% 
% this is for data produced with the new 30 kHz gpio firmware
% FILENAME is a string, the relative path to the H5 Willow file
% CHANNEL_TYPE = 'time', 'amp', 'aux', 'supply', 'temp', 'din'
% CHANNEL_NUMBERS is an array of channel numbers, e.g. 1:64
% T0,T1 is an inclusive time range in seconds, relative to the beginning of the file
% everything is 1-indexed because matlab
% channel_type = "adc" is not supported (returns error), because there are no adc converters
% channel_type = "dout" is not supported (returns error), as any output pins are rolled into GPIO (din)
%
% example usage:
%  data = read_Willow_datafile('snapshot_30kgpio.h5', [], 'time', 1, 0, 0.1);
%  data = read_Willow_datafile('snapshot_30kgpio.h5', [], 'amp', 129:256, 0, 0.1);
%  data = read_Willow_datafile('snapshot_30kgpio.h5', [], 'aux', 1:12, 0, 0.1); % 2khz
%  data = read_Willow_datafile('snapshot_30kgpio.h5', [], 'supply', 1:4, 0, 0.1); % 2khz
%  data = read_Willow_datafile('snapshot_30kgpio.h5', [], 'temp', 1:4, 0, 0.1); % 2khz
%  data = read_Willow_datafile('snapshot_30kgpio.h5', [], 'din', [1,3,7], 0, 0.1);
%
% CKC 20160209
% SDV 20160211 - minor modifications, added header information

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

if isempty(header),
	header = read_Willow_headerfile(filename);
end;

if ~strcmp(upper(header.fileinfo.version),upper('30kgpio')),
	error(['Do not know how to process file version ' header.fileinfo.version '.']);
end;

sample_index = h5read(filename, '/sample_index');
total_samples = length(sample_index);
time_file = ((1:total_samples) - 1)./header.frequency_parameters.amplifier_sample_rate;
total_time = time_file(end);
time_indices = find( (t0 <= time_file) & (time_file <= t1) ); % inclusive on both ends
nsamples = length(time_indices);

nchannels = length(channel_numbers);
    
if channel_type ==  1, % time data, 30 khz
    % channel_numbers should equal 1 here
    data = double(sample_index(time_indices))./header.frequency_parameters.amplifier_sample_rate;
end

if channel_type == 2, % amplifier data, 30 khz
    % channel_numbers should range from 1 to 1024 here

    s0 = 1+(time_indices(1)-1)*1024;
    s1 = 1+(time_indices(end)-1)*1024;
    if s0<1, s0 = 1; end; % bounds checking
    if s1>total_samples*1024, s1 = total_samples*1024; end;

    sample_count = s1 - s0 + 1024;
    datapoint_count = (sample_count)/1024;

    channel_data = h5read(filename, '/channel_data', s0, sample_count);

    data_all = reshape(channel_data, 1024, datapoint_count);
    data = data_all(channel_numbers, :);
    data = (double(data)' - 2^15) * 0.195 * 1e-6; % volts
end

if channel_type ==  3, % aux data, 2 khz
    % channel_numbers should range from 1 to 96 here
    % todo: need to correct for files not starting on sample_index % 15 == 0
    aux_data = h5read(filename, '/aux_data');
    aux_all = reshape(aux_data, 96, total_samples);
    modulo_ind = find( (mod(sample_index, 15) >= 2) & mod(sample_index, 15) <= 4);
    time_indices_2khz = intersect(modulo_ind, time_indices);
    slot2_ind = 3:3:96;
    analog_aux = aux_all(slot2_ind, time_indices_2khz);
    analog_aux = reshape(analog_aux, 96, idivide(length(time_indices_2khz),int32(3)));
    data = analog_aux(channel_numbers, :);
end

if channel_type ==  4, % supply data, 2 khz
    % channel_numbers should range from 1 to 32 here
    aux_data = h5read(filename, '/aux_data');
    aux_all = reshape(aux_data, 96, total_samples);
    time_indices_2khz = intersect( find(mod(sample_index, 15) == 5), time_indices);
    supply_data = aux_all(3:3:96, time_indices_2khz);
    data = supply_data(channel_numbers,:);
end

if channel_type ==  5, % temp data, 2 khz
    % channel_numbers should range from 1 to 32 here
    aux_data = h5read(filename, '/aux_data');
    aux_all = reshape(aux_data, 96, total_samples);
    time_indices_2khz = intersect( find(mod(sample_index, 15) == 6), time_indices);
    temp_data = aux_all(3:3:96, time_indices_2khz);
    data = temp_data(channel_numbers,:);
end

if channel_type ==  6, % adc data
    error(['No adc data']);
    data = 0; %  todo: what is this?
end

if channel_type ==  7, % GPIO data, 30 khz
    % channel_numbers should range from 1 to 16 here
    aux_data = h5read(filename, '/aux_data');
    aux_all = reshape(aux_data, 96, total_samples);
    gpio_bitfield = aux_all(2,time_indices);
    gpio = zeros(nchannels, nsamples);
    for i = 1:nchannels
        gpio(i,:) = bitand( bitshift(gpio_bitfield, 1-channel_numbers(i)), 1);
    data = gpio;
end

if channel_type ==  8, % dout
    error(['No dout data']);
    data = 0; % dout is wrapped into GPIO, which we are calling din
end

end
