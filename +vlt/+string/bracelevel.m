function level = bracelevel(str, braceleft, braceright)
% BRACELEVEL - Determine the enclosure depth level for text within braces
%
%  LEVEL = vlt.string.bracelevel(STR)
%
%  For the string STR, returns an equally long array of numbers
%  LEVEL that indicates the enclosure depth. The enclosure depth
%  answers how many levels deep each character is within parentheses.
%
%  One can also call:
%  
%  LEVEL = vlt.string.bracelevel(STR, BRACELEFT, BRACERIGHT)
%
%  And specify the LEFTBRACE and RIGHTBRACE characters.
%
%  Examples:
%     str = 'this is (a test of (depth))';
%     level=vlt.string.bracelevel(str)
%
%     str2 = 'this is [a test of [depth]]';
%     level=vlt.string.bracelevel(str,'[',']')

if nargin<3,
	braceright = ')';
end;

if nargin<2,
	braceleft = '(';
end;

level = 0*str;

level(1+find(str==braceleft)) = 1;
level(find(str==braceright)) = -1;

level = cumsum(level);

