function h = vhsb_readheader(fo)
% VHSB_READHEADER - read a VH Lab Series Binary file header
%
% H = vlt.file.custom_file_formats.vhsb_writeheader(FILE_OBJ_OR_FNAME, ...)
%
% Reads the header portion of the vlt.file.fileobj or filename FILE_OBJ_OR_FNAME.
% At the conclusion of reading, the FILEOBJ or file is closed.
%
% This function returns a structure with the following fields (default in parentheses):
%
% -----------------------------------------------------------------------------------------
% version (1)                       | 32-bit integer describing version. Only 1 is allowed.
% machine_format ('little-endian')  | The machine format. The only value allowed is
%                                   |    'little_endian'.
% X_data_size (64)                  | 32-bit integer describing the size (in bytes) of each 
%                                   |    data point in the X series.
% X_data_type (4)                   | 8-bit unsigned integer describing whether X type is char (1), uint (2), int (3), or float (4)
% Y_dim ([1 1])                     | 64-bit unsigned integer describing the rows, columns, etc of each Y datum
% Y_data_size (64)                  | 32-bit integer describing the size (in bytes) of each 
%                                   |    sample in the Y series.
% Y_data_type (4)                   | 8-bit unsigned integer describing whether Y type is char (1), uint (2), int (3), or float (4)
% X_stored (1)                      | Character 0 or 1 describing whether the X value of the series
%                                   |    is stored in the file or just inferred from start and increment.
% X_constantinterval (0)            | Character 0 or 1 describing whether the X value of the series consists
%                                   |    of a value that is incremented by a constant interval for each sample
% X_start (0)                       | The value of the first X data sample (same size/type as X_data)
% X_increment (0)                   | The value of the increment (same size/type as X_data)
%                                   |
% X_units ('')                      | A 256 character string with the units of X (after any scaling)
% Y_units ('')                      | A 256 character string with the units of Y (after any scaling)
% 
% X_usescale (0)                    | Character 0/1 should we scale what is read in X using parameters below?
% Y_usescale (0)                    | Character 0/1 should we scale what is read in Y using parameters below?
% X_scale (1)                       | 64-bit float scale factor
% X_offset (0)                      | 64-bit float offset factor common to all X info
% Y_scale (1)                       | 64-bit float scale factor
% Y_offset (0)                      | 64-bit float offset factor common to all Y info
%                                   | 
% headersize (1836)                 | The full header size in bytes
% num_samples (variable)            | The calculated number of samples in the file.
% X_skip_bytes (variable)           | Number of bytes to skip over when reading X samples
% Y_skip_bytes (variable)           | Number of bytes to skip over when reading Y samples
% sample_size (variable)            | The size of each (x,y) pair of samples in bytes
% filesize (variable)               | The size of the file in bytes

% skip 200 bytes for future

skip = 200; 
d = dir(vlt.file.filename_value(fo));

if isempty(d),
	error(['Could not find file ' vlt.file.filename_value(fo) '.']);
end;

fo = fopen(fo,'r','ieee-le');

headersize = 1836;

try,
	fseek(fo, skip,'bof');

	version = fread(fo, 1, 'uint32');

	machine_format = char(fread(fo, 256, 'char'));

	X_data_size = fread(fo, 1, 'uint32');
	X_data_type = fread(fo, 1, 'uint16');

	Y_dim = fread(fo, 100, 'uint64')';
	Y_dim = Y_dim(Y_dim>0);

	Y_data_size = fread(fo, 1, 'uint32');
	Y_data_type = fread(fo, 1, 'uint16');

	X_stored = fread(fo, 1, 'uint8');
	X_constantinterval = fread(fo, 1, 'uint8');

	X_start =     fread(fo, 1, vlt.file.custom_file_formats.vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size));
	X_increment = fread(fo, 1, vlt.file.custom_file_formats.vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size));

	X_units = char(fread(fo, 256, 'char'));
	Y_units = char(fread(fo, 256, 'char'));

	X_usescale = fread(fo, 1, 'uint8');
	Y_usescale = fread(fo, 1, 'uint8');

	X_scale  = fread(fo, 1, 'float64');
	X_offset = fread(fo, 1, 'float64');

	Y_scale = fread(fo, 1, 'float64');
	Y_offset = fread(fo, 1, 'float64');

catch,
	fclose(fo);
	error(['Error reading file ' vlt.file.filename_value(fo) ': ' ferror(fo) '.']);
end;

fclose(fo);

machine_format = vlt.string.line_n(machine_format(:)',1);
X_units = vlt.string.line_n(X_units(:)',1);
Y_units = vlt.string.line_n(Y_units(:)',1);

X_skip_bytes = prod(Y_dim(2:end)) * Y_data_size/8; % 8 bits per byte
Y_skip_bytes = X_data_size/8 * (X_stored==1);      % 8 bits per byte
sample_size = X_skip_bytes + Y_skip_bytes;

filesize = d.bytes;
num_samples = (filesize-headersize) / sample_size;

h = vlt.data.workspace2struct;

h = rmfield(h,{'fo','d'});

