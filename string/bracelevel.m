function level = bracelevel(str, braceleft, braceright)
% BRACELEVEL - Determine the enclosure depth level for text within braces
%
%  LEVEL = BRACELEVEL(STR)
%
%  For the string STR, returns an equally long array of numbers
%  LEVEL that indicates the enclosure depth. The enclosure depth
%  answers how many levels deep each character is within parentheses.
%
%  One can also call:
%  
%  LEVEL = BRACELEVEL(STR, BRACELEFT, BRACERIGHT)
%
%  And specify the LEFTBRACE and RIGHTBRACE characters.
%
%  Examples:
%     str = 'this is (a test of (depth))';
%     level=bracelevel(str)
%
%     str2 = 'this is [a test of [depth]]';
%     level=bracelevel(str,'[',']')

if nargin<3,
	braceright = ')';
end;

if nargin<2,
	braceleft = '(';
end;

level = zeros(size(str));

 % the character after a left brace goes up one level; a right brace goes down one level.
 % add rather than assign so an empty pair '()' cancels out, and ignore a left brace at the end
up = 1+find(str==braceleft);
up = up(up<=numel(str));
down = find(str==braceright);

level(up) = level(up) + 1;
level(down) = level(down) - 1;

level = cumsum(level);

