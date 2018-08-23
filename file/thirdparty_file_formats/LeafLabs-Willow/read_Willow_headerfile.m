function header = read_Willow_headerfile(filename)
% READ_WILLOW_HEADERFILE - Read file information from a Willow file
%
%  HEADER = READ_WILLOW_HEADERFILE(FILENAME)
%
% Returns a structure HEADER with all of the information fields that
% are stored in the Willow .h5 file FILENAME.
%
% HEADER contains several substructures:
% ------------------------------------------------------------------
% fileinfo              | Information about the file and its version
% frequency_parameters  | Information about sampling frequency
% amplifier_channels    | Information about amplifier channels
% board_dig_in_channels | Digital input channels
%


s = dir(filename);

if isempty(s),
	error(['Could not find a file ' filename '; check spelling, permissions, path, extension']);
end;

filesize = s.bytes;

version = '30kgpio';

  % file info

header.fileinfo = struct(...
	'filename',filename, ...
	'version', version);

header.frequency_parameters = struct( ...
	'amplifier_sample_rate', 30000, ...
	'aux_input_sample_rate', 2000, ...
	'supply_voltage_sample_rate', 2000, ...
	'temp_sample_rate', 2000, ...
	'board_dig_in_sample_rate', 2000 );


