function h = vhsb_writeheader(fo, varargin)
% VHSB_WRITEHEADER - write a VH Lab Series Binary file header
%
% H = VHSB_WRITEHEADER(FILE_OBJ_OR_FNAME, 'PARAM1, VALUE1, ...)
%
% Writes or re-writes the header portion of the FILE_OBJ or filename
% FILE_OBJ_OR_FNAME according to the parameters provided.
%
% The file or file object is closed at the conclusion of writing the header.
%
% This function takes name/value pairs that override the default functionality:
% Parameter (default)               | Description 
% -----------------------------------------------------------------------------------------
% version (1)                       | 32-bit integer describing version. Only 1 is allowed.
% machine_format ('little-endian')  | The machine format. The only value allowed is
%                                   |    'little_endian'.
% X_data_size (64)                  | 32-bit integer describing the size (in bits) of each 
%                                   |    data point in the X series.
% X_data_type (4)                   | 8-bit unsigned integer describing whether X type is char (1), uint (2), int (3), or float (4)
% Y_dim ([1 1])                     | 64-bit unsigned integer describing the rows, columns, etc of each Y datum; can be up to 1x100
% Y_data_size (64)                  | 32-bit integer describing the size (in bits) of each 
%                                   |    sample in the Y series.
% Y_data_type (4)                   | 8-bit unsigned integer describing whether Y type is char (1), uint (2), int (3), or float (4)
% X_stored (1)                      | Character 0 or 1 describing whether the X value of the series
%                                   |    is stored in the file or just inferred from start and increment.
% X_constantinterval (1)            | Character 0 or 1 describing whether the X value of the series consists
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

% skip 200 bytes for future

skip = 200; 

version = 1;             % uint32 version number

machine_format = 'little-endian';  %

X_data_size = 64;        % X_data_size
X_data_type = [4];   % char, uint, int, float

Y_dim = [1 1];

Y_data_size = 64;        % Y_data_size
Y_data_type = [4];   % char, uint, int, float

X_stored = 1;            % 0/1 are the stamps for the X data stored?
X_constantinterval = 1;  % 0/1 are the X values regularly sampled?
X_start = 0;             % the value of the first X data
X_increment = 0;         % the increment value 

X_units = '';            % 256 character string, units after any scaling
Y_units = '';            % 256 character string, units after any scaling

X_usescale = 0;          % perform an input/output scale for X? Output will be 64-bit float if so
Y_usescale = 0;          % perform an input/output scale for Y? Output will be 64-bit float if so

X_scale = 1;             % 64-bit float scale factor
X_offset = 0;            % 64-bit float offset factor common to all X info
Y_scale = 1;             % 64-bit float scale factor
Y_offset = 0;            % 64-bit float offset factor common to all Y info

headersize = 1836;

assign(varargin{:});

h = workspace2struct;
h = rmfield(h,{'fo','varargin'});
if isfield(h,'ans'),
	h = rmfield(h,'ans');
end;

 % open file for writing, set machine-type to little-endian

fo = fopen(fo,'w','l');

fseek(fo, 0, 'bof');

id = ['This is a VHSB file, http://github.com/VH-Lab' sprintf('\n')];

fwrite(fo, [id(:); repmat(sprintf('\0'),skip-numel(id),1)], 'char');

fseek(fo, skip, 'bof');

fwrite(fo, version, 'uint32');

fwrite(fo, [machine_format(:)' sprintf('\n') repmat(sprintf('\0'), 1, 256-(numel(machine_format)+1))], 'char');

fwrite(fo, X_data_size, 'uint32');
fwrite(fo, X_data_type, 'uint16');

Y_dim = [Y_dim(:) ; repmat(0, 100-numel(Y_dim), 1) ];

fwrite(fo, Y_dim(:), 'uint64');

fwrite(fo, Y_data_size, 'uint32');
fwrite(fo, Y_data_type, 'uint16');

fwrite(fo, X_stored, 'uint8');
fwrite(fo, X_constantinterval, 'uint8');

fwrite(fo, X_start,     vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size));
fwrite(fo, X_increment, vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size));

fwrite(fo, [X_units(:)' sprintf('\n') repmat(sprintf('\0'), 1, 256-(numel(X_units)+1)) ], 'char');
fwrite(fo, [Y_units(:)' sprintf('\n') repmat(sprintf('\0'), 1, 256-(numel(Y_units)+1)) ], 'char');

fwrite(fo, X_usescale, 'uint8');
fwrite(fo, Y_usescale, 'uint8');

fwrite(fo, X_scale, 'float64');
fwrite(fo, X_offset, 'float64');

fwrite(fo, Y_scale, 'float64');
fwrite(fo, Y_offset, 'float64');

fclose(fo);
