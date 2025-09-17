function n=str2nume(str)

% VLT.DATA.STR2NUME - Convert a string to a number, with empty handling
%
%   N = vlt.data.str2nume(STR)
%
%   Converts a string STR to a numeric value N. If the input string is empty,
%   it returns an empty matrix []. Otherwise, it functions like the built-in
%   str2num.
%
%   Example:
%       vlt.data.str2nume('123')   % returns 123
%       vlt.data.str2nume('')      % returns []
%
%   See also: STR2NUM, STR2DOUBLE
%

if isempty(str),
	n = [];
else,
	n=str2num(str);
end;
