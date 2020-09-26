function n=str2nume(str)

%vlt.data.str2nume - Str2num that returns empty given an empty input
%
%    N = vlt.data.str2nume(STR)
%  Returns [] if STR is empty, otherwise returns STR2NUM(STR).

if isempty(str),
	n = [];
else,
	n=str2num(str);
end;
