function fs = string2filestring(s)
% STRING2FILESTRING - edit a string so it its suitable for use as part of a filename (remove whitespace)
%
% FS = STRING2FILESTRING(S)
%
% Modifies the string S so that it is suitable for use as part of a filename.
% Removes any characters that are not letters ('A'-'Z', 'a'-'z') or digits ('0'-'9')
% and replaces them with '_'.
%
% Example:
%    mystr = 'This is a variable name: 1234.';
%    string2filestring(mystr)  % returns 'This_is_a_variable_name__1234_'
%

ranges = [double('a') double('z') ; double('A') double('Z'); double('0') double('9')];

goodindexes = [];

for i=1:size(ranges,1),
	goodindexes = union(goodindexes, find(s>=ranges(i,1) & s<=ranges(i,2)));
end

fs = repmat('_',1,numel(s));
fs(goodindexes) = s(goodindexes);


