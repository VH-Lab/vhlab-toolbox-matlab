function display(ds)
% DISPLAY print info from a DIRSTRUCT object
%
%   DISPLAY(DS)
%
%   Displays information about the DIRSTRUCT object DS
%
%   See also: DS

if isempty(inputname(1)),
	disp([inputname(1) '; manages directory ' getpathname(ds) ]);
else,
	disp([inputname(1) '; manages directory ' getpathname(ds) ]);
end;
