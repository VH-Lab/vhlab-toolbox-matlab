function b = isunix_sv

% VLT.DATA.ISUNIX_SV - Check if the operating system is Unix-based
%
%   B = vlt.data.isunix_sv
%
%   Returns 1 if the current operating system is Unix-based, and 0 otherwise.
%   This function provides a wrapper around Matlab's ISUNIX function for
%   backward compatibility with older Matlab versions.
%
%   Example:
%       is_unix = vlt.data.isunix_sv();
%
%   See also: ISUNIX, ISPC, ISMAC, COMPUTER
%

if version>=13,
	b = isunix;
else,
	b = 1;
	if strcmp(computer,'MAC2'), b = 0; end;
	if strcmp(computer,'PC'), b = 0; end;
end;

