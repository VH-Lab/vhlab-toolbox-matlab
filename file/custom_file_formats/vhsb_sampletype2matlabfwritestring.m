function s = vhsb_sampletype2matlabfwritestring(data_type, data_size)
% VHSH_SAMPLETYPE2MATLABFWRITESTRING - return fwrite/fread string for sample type
%
% S = VHSB_SAMPLETypE2MATLABFWRITESTRING(DATA_TYPE, DATASIZE)
%
% Given the DATA_TYPE (char (1), uint (2), int (3), or float (4)) and
% the DATA_SIZE in bytes, this function returns a format string
% appropriate for passing to FREAD or FWRITE.
%
% Example:
%   s = vhsb_sampletype2matlabfwritestring(4, 64)
%     % s = 'float64'
% 

s = [];

switch (data_type),
	case 1,
		s = 'char';
	case 2,
		s = 'uint';
	case 3,
		s = 'int';
	case 4,
		s = 'float';
	otherwise,
		error(['Unknown DATA_TYPE ' int2str(data_type) '.']);
end;

s = [s int2str(data_size)];






