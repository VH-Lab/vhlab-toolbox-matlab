function b = vhsb_write(fo, x, y, varargin)
% VHSB_WRITE - write a VHLab series binary file
%
% B = vlt.file.custom_file_formats.vhsb_write(FO, X, Y, ...)
%
% Write series data to a VH series binary file.
%
% Inputs:
%    FO is the file description to write to; it can be a 
%         filename or an object of type FILEOBJ
%    X is a NUMSAMPLESx1 dataset, usually the independent variable.
%         X can be empty if an X_start and X_increment are provided
%    Y is an NUM_SAMPLESxXxYxZx... dataset with the Y samples that
%         are associated with each value of X.
%         X(i) is the ith sample of X, and Y(i,:,:,...) is the ith sample of Y
%         
% Outputs: 
%    B is 1 if the file was written successfully, 0 otherwise
% 
% The function accepts parameters that modify the default functionality
% as name/value pairs.
%
% Parameter (default)                           | Description
% ------------------------------------------------------------------------------
% use_filelock (1)                              | Lock the file with vlt.file.checkout_lock_file
% X_start (X(1))                                | The value of X in the first sample
% X_increment (0)                               | The increment between subsequent values of X
%                                               |    (needs only be non-zero if X_constantinterval is 1)
% X_stored (1)                                  | Should values of X be stored (1), or computed from X_start
%                                               |    and X_increment (0)?
% X_constantinterval (0)                        | Is there a constant interval between X samples (1) or not (0) or
%                                               |    not necessarily (0)?
% X_units ('')                                  | The units of X (a character string, up to 255 characters)
% Y_units ('')                                  | The units of Y (a character string, up to 255 characters)
% X_data_size (64)                              | The resolution (in bits) for X
% X_data_type ('float')                         | The data type to be written for X ('char','uint','int','float')
% Y_data_size (64)                              | The resolution (in bits) for Y
% Y_data_type ('float')                         | The data type to be written for Y ('char','uint','int','float')
% X_usescale (0)                                | Scale the X data before writing to disk (and after reading)?
% Y_usescale (0)                                | Scale the Y data before writing to disk (and after reading)?
% X_scale (1)                                   | The X scale factor to use to write samples to disk
% X_offset (0)                                  | The X offset to use (Xdisk = X/X_scale + X_offset)
% Y_scale (1)                                   | The Y scale factor to use
% Y_offset (0)                                  | The Y offset to use (Ydisk = Y/Y_scale + X_offset)
%
% See also: vlt.data.namevaluepair 
%

if size(x,1)~=size(y,1),
	error(['X must have the same number of rows as Y (rows correspond to samples; X is NUM_SAMPLESx1, Y is NUM_SAMPLESxY1xY2... ).']);
end;

use_filelock = 1;

if numel(x)>1,
	X_start = x(1);
else,
	X_start = 0;
end;
if numel(x)>2,
	X_increment = median(diff(x));
else, 
	X_increment = 0;
end;
X_stored = 1;
if numel(x)>3,
	X_constantinterval = (max(diff(diff(x)))<1e-7);
else,
	X_constantinterval = 0;
end;
X_units = '';
Y_units = '';
X_data_size = 64;
X_data_type = 'float';
Y_data_size = 64;
Y_data_type = 'float';
X_usescale = 0;
Y_usescale = 0;
X_scale = 1;
X_offset = 0;
Y_scale = 1;
Y_offset = 0;
Y_dim = size(y);

vlt.data.assign(varargin{:});

if X_usescale,
	x = x/X_scale + X_offset;
end;
if Y_usescale,
	y = y/Y_scale + Y_offset;
end;

switch lower(X_data_type),
	case 'char',
		X_data_type = 1;
	case 'uint',
		X_data_type = 2;
	case 'int',
		X_data_type = 3;
	case 'float',
		X_data_type = 4;
	otherwise,
		error(['Unknown datatype ' X_data_type '.']);
end;

switch Y_data_type,
	case 'char',
		Y_data_type = 1;
	case 'uint',
		Y_data_type = 2;
	case 'int',
		Y_data_type = 3;
	case 'float',
		Y_data_type = 4;
	otherwise,
		error(['Unknown datatype ' Y_data_type '.']);
end;

parameters = vlt.data.workspace2struct;
parameters = rmfield(parameters,{'x','y','use_filelock','varargin','fo'});

if use_filelock,
	lock_fname = [vlt.file.filename_value(fo) '-lock'];
	fid = vlt.file.checkout_lock_file(lock_fname);
	if fid<0,
		error(['Could not get lock for file ' lock_fname '.']);
	end;
end;

h = vlt.file.custom_file_formats.vhsb_writeheader(fo,parameters);

 % vlt.file.custom_file_formats.vhsb_writeheader will close the file

fo = fopen(fo,'r+','ieee-le');

fseek(fo,h.headersize,'bof');

 % write X

X_skip_bytes = prod(Y_dim(2:end)) * Y_data_size/8; % divide by 8 bits per byte

fseek(fo,-X_skip_bytes,'cof');

if X_stored,
	fwrite(fo, x, vlt.file.custom_file_formats.vhsb_sampletype2matlabfwritestring(X_data_type, X_data_size), X_skip_bytes);
end;

fseek(fo,h.headersize,'bof');  % rewind back to the beginning of the data

Y_skip_bytes = X_data_size/8 * (X_stored==1); % divide by 8 bits per byte

y2 = permute(y,[2:numel(Y_dim) 1]);

if numel(y2)>0,

	fwrite(fo, y2(:), ...
		[int2str(prod(Y_dim(2:end))) '*' vlt.file.custom_file_formats.vhsb_sampletype2matlabfwritestring(Y_data_type, Y_data_size)], ...
		Y_skip_bytes);

end;

if use_filelock,
	fclose(fid);
	delete(lock_fname);
end;

fclose(fo);

b = 1;
