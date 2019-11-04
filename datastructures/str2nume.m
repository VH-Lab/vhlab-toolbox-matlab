function n=str2nume(str)

%STR2NUME - Str2num that returns empty given an empty input
%
%    N = STR2NUME(STR)
%  Returns [] if STR is empty, otherwise returns STR2NUM(STR).

if isempty(str), n = []; else, n=str2num(str); end;
