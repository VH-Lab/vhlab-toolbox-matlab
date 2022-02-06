function h=hashmatlabvariable(d, varargin)
% HASHMATLABVARIABLE - create a hashed version of a Matlab variable in memory
%
% H = vlt.data.hashmatlabvariable(D)
%
% Creates a hashed value based on the binary data in the variable D.
% Depending upon the algorithm, the output H may vary (see below).
% 
% This function can be modified by name/value pairs:
% Parameter (default)        | Description
% -------------------------------------------------------------
% algorithm ('DataHash/MD5') | Algorithm to be used, a string:
%                            | 'DataHash/MD5':
%                            |   Uses the third party tool DataHash,
%                            |   to obtain the MD5 checksum of 
%                            |   getByteStreamFromArray(D).
%                            |   Returns a hexidecimal string.
%			     | 'pm_hash/crc':
%                            |   Uses the Matlab function PM_HASH.
%                            |   Returns a 32 bit integer (uint32).
%                            |   Requires Simulink and SimScape toolboxes.
%
% Warning: For many years, PM_HASH produced the same numbers across
% platforms and across versions. New versions (Matlab 2019a for instance) 
% now seems to produce PM_HASH numbers that differ from earlier versions.
%
% See https://undocumentedmatlab.com/articles/serializing-deserializing-matlab-data
% for information about the undocumented function getByteStreamFromArray
% function, upon which the default algorithm relies.
%
% See also: DataHash
%
% Example:
%     A = randn(5,3,2); % a random number
%     h = vlt.data.hashmatlabvariable(A) % generate a hash, a hexidecimal string
%     h2 = vlt.data.hashmatlabvariable(A,'algorithm','pm_hash/crc') % require Simulink/SimScape; returns uint32
% 

algorithm = 'DataHash/MD5';
 % algorithm = 'pm_hash/crc'; no longer default

assign(varargin{:});

h = 0;

switch lower(algorithm),
	case 'datahash/md5',
		h = DataHash(uint8(getByteStreamFromArray(d)),'bin','MD5','hex');
	case 'pm_hash/crc',
		h = pm_hash('crc',d);
	otherwise,
		error(['Unknown algorithm ' algorithm '.']);
end;

