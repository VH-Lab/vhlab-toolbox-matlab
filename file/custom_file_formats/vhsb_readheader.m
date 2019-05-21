function h = vhsb_readheader(fo)
% VHSB_READHEADER - read a VH Lab Series Binary file header
%
% H = VHSB_WRITEHEADER(FILE_OBJ_OR_FNAME, ...)
%
% Reads the header portion of the FILEOBJ or filename FILE_OBJ_OR_FNAME.
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
% headersize (1636)                 | The full header size in bytes
% num_samples (variable)            | The calculated number of samples in the file.

% skip 200 bytes for future

skip = 200; 

d = dir(filename_value(fo));

if isempty(d),
	error(['Could not find file ' filename_value(fo) '.']);
end;

fo = fopen(fo,'r','ieee-le');

headersize = 1636;

fseek(fo, skip,'bof');

version = fread(fo, 1, 'uint32'),

machine_format = char(fread(fo, 256, 'char'));
i = find(machine_format==sprintf('\n'));
if ~isempty(i),
	machine_format = machine_format(1:i-1);
else,
	error(['Machine format does not have end-of-line character (\n, 10).']);
end;
machine_format = machine_format(:)';

X_data_size = fread(fo, 1, 'uint32'),
X_data_type = fread(fo, 1, 'uint16'),

Y_dim = fread(fo, 100, 'uint64');
Y_dim = Y_dim(Y_dim>0);

Y_data_size = fread(fo, 1, 'uint32');
Y_data_type = fread(fo, 1, 'uint16');

X_stored = fread(fo, 1, 'uint8');
X_constantinterval = fread(fo, 1, 'uint8');

X_start = fread(fo, 1, vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size));
X_constantinterval = fread(fo, 1, vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size));

X_units = char(fread(fo, 256, 'char'));
double(X_units)
i = find(X_units==sprintf('\n'));
if ~isempty(i),
	X_units = X_units(1:i-1);
else,	
	fclose(fo);
	error(['Did not find end-of-line character (\n, 10) in X_units']);
end;
X_units = char(X_units(:)');

Y_units = char(fread(fo, 256, 'char'));
i = find(Y_units==sprintf('\n'));
if ~isempty(i),
	Y_units = Y_units(1:i-1);
else,	
	fclose(fo);
	error(['Did not find end-of-line character (\n, 10) in Y_units']);
end;
Y_units = char(Y_units(:)');
clear i;

X_usescale = fread(fo, 1, 'uint8');
Y_usescale = fread(fo, 1, 'uint8');

X_scale  = fread(fo, 1, 'float64');
X_offset = fread(fo, 1, 'float64');

Y_scale = fread(fo, 1, 'float64');
Y_offset = fread(fo, 1, 'float64');

X_skip_bytes = prod(Y_dim) * Y_data_size;
Y_skip_bytes = X_data_size * (h.X_stored==1);
sample_size = X_skip_bytes + Y_skip_bytes;

num_samples = d.bytes / sample_size;

h = workspace2struct;

h = rmfield(h,{'fo','d','X_skip_bytes','Y_skip_bytes','sample_size'});

fclose(fo);

