function str = trimws(mystring)
% TRIMWS - Trim leading whitespace from a string
%
%   NEWSTR = TRIMWS(STR)
%
%   Trims leading spaces from a string.
%  
%   There is probably no reason for this function to exist, as the Matlab function
%   STRTRIM seems to perform its function.  This function is provided for backward
%   compatibility.  I recommend simply using STRTRIM rather than this function, as it
%   will probably be removed in a future release.
%
%   The only difference between STRTRIM and TRIMWS is that TRIMWS only operates on
%   leading spaces, whereas STRTRIM removes trailing whitespace and also operates on
%   any whitespace character as defined by the function ISSPACE.
%
%   Example:
%       m = trimws('   this string has leading whitespace')
%
%   See also:  STRTRIM, ISSPACE
%   

str = mystring;
inds = find(mystring~=' ');
if length(inds)>0,
	str = mystring(inds(1):end);
end;

