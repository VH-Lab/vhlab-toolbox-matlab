function b = validvarname(varname)

%  Part of the NewStim package
%
%  B = VALIDVARNAME(VARNAME)
%
%  Returns 1 if VARNAME is a valid variable name in Matlab, or returns 0
%  otherwise.
%
%  Note: There is now a Matlab function that does this: ISVARNAME
%
%  See also: ISVARNAME, MATLAB.LANG.MAKEVALIDNAME

b=1;
try, eval([varname '=5;']); catch, b=0; end;
