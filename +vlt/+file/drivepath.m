function p = drivepath(varargin)
% DRIVEPATH - What is the default name of the directory that contains drives / media / volumes ?
% 
%  P = vlt.file.drivepath
%
%  Returns the name of the default name of the directory that contains drives or media or volumes
%  on this operating system.
%
%  If the platform (returned in COMPUTER), then P is 
%  Platform string             | P
%  ----------------------------------------------------------
%  'GLNXA64'                   | '/media'
%  'MACI64'                    | '/Volumes'
%  'PCWIN64'                   | ''
%
%  See also: COMPUTER

p = '';

switch computer,
	case 'GLNXA64',
		p  = '/media';
	case 'MACI64',
		p = '/Volumes';
end

