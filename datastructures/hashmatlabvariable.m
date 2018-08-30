function h=hashmatlabvariable(d, varargin)
% HASHDATA - create a hashed version of a Matlab variable in memory
%
% H = HASHMATLABVARIABLE(D)
%
% Creates a 32-bit hashed value based on the binary data in the variable D.
% 
% This function can be modified by name/value pairs:
% Parameter (default)        | Description
% -------------------------------------------------
% algorithm ('pm_hash/crc')  | Algorithm to be used.
%                            |  At present, the only choice is 
%                            |  pm_hash/crc, which uses the Matlab
%                            |  function PM_HASH.
%
%

algorithm = 'pm_hash/crc';

assign(varargin{:});

h = 0;

switch algorithm,
	case 'pm_hash/crc',
		h = pm_hash('crc',d);
	otherwise,
		error(['Unknown algorithm ' algorithm '.']);
end;
