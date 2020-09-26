function b = isunix_sv

% vlt.data.isunix_sv - Returns true if we are running a Unix system
%
%  If Matlab version is greater than 5, returns ISUNIX.  Else,
%  returns ISUNIX is computer is not a PC or Mac2.
%
%

if version>=13,
	b = isunix;
else,
	b = 1;
	if strcmp(computer,'MAC2'), b = 0; end;
	if strcmp(computer,'PC'), b = 0; end;
end;

