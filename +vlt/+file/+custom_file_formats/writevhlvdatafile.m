function writevhlvdatafile(filename, header, data, varargin)
% WRITEVLHVDATAFILE - Write data to a VHLVDATAFILE 
%  
% vlt.file.custom_file_formats.writevhlvdatafile(FILENAME, HEADER, DATA)
%
% Write a VHLVDATAFILE file to filename FILENAME, in Multiplex format.
%
% This is the format used by the Van Hooser lab at Brandeis University
% for files acquired via a LabView program (hence the abbreviation VHLV). 
%
% DATA should be channel data; each column should contain data from a single channel.
%
% If the header file in .vlh format does not exist, then it is written
% using the information in HEADER and FILENAME. The header field
% 'Multiplexed' is updated to be 1.
%
% One can provide optional name/value pairs:
% PARAMETER (default value)        | Description
% --------------------------------------------------------------------------
% append (1)                       | Should we append to the end of the file?
%                                  |  0 - no, create a new file
%                                  |  1 - yes, add to the end of the file
%
% See also: vlt.file.custom_file_formats.readvhlvdatafile
%
 
append = 0;

vlt.data.assign(varargin{:});

[mypath,myname,myext] = fileparts(filename);
myoutputfile = fullfile(mypath,[myname '.vld']);

header.Multiplexed = 1;

if ~exist(fullfile(mypath,[myname '.vlh']),'file'),
	vlt.file.custom_file_formats.writevhlvheaderfile(header,fullfile(mypath,[myname '.vlh']));
end;

write_string = 'w';
if append,
	write_string = 'a';
end;

fid_out = fopen(myoutputfile,write_string,'ieee-be');

if fid_out<1,
	error(['Could not open file ' myoutputfile ' for writing.']);
end;

switch header.precision,
	case 'double',
		unit_size = 8;
		maxint = 1;
	case 'single',
		unit_size = 4;
		maxint = 1;
	case 'int32',
		unit_size = 4;
		maxint = 2^31-1;
	case 'int16',
		unit_size = 2;
		maxint = 2^15 - 1;
end;

data = double(data')*maxint/header.Scale;  % see the transpose

eval(['data=' header.precision '(data);']);

fwrite(fid_out,data,header.precision,0,'ieee-be');

fclose(fid_out);

