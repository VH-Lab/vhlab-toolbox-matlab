function [pos_match, bravedepth] = bracematch(str,pos,varargin)
% BRACEMATCH - Match parenthesis in a text string
%
%  [POS_MATCH,BRACEDEPTH] = BRACEMATCH(STR, POS)
%
%  Finds the right parenthesis ')' that matches the left paranthesis
%  '(' in string STR at position POS.
%
%  One can modify the behavior of this function by passing name/value pairs:
%  Name (default):               | Description
%  ---------------------------------------------------------------------
%  braceleft ('(')               | The character to be the left parenthesis
%                                |   (other examples, '[', '{', '<')
%  braceright (')')              | The character to be the right parenthesis
%                                |   (other examples, ']', '}', '>')
%  bracedepth ([])               | To save time, if one has computed the
%                                |   brace level using the function BRACELEVEL,
%                                |   one can pass it here. If empty, the
%                                |   brace level will be recalculated.
%  Examples:
%     str = 'this is (a test of (depth))';
%     match1=vlt.string.bracematch(str, 9)
%     match2=vlt.string.bracematch(str,20)
%
%  See also:  BRACELEVEL
%

bracedepth = [];
braceleft  = '(';
braceright = ')';

vlt.data.assign(varargin{:});

if isempty(bracedepth),
	bracedepth = vlt.string.bracelevel(str,braceleft,braceright);
end;

leveltarget = bracedepth(pos);
pos_match = pos + find( bracedepth(pos+1:end) == leveltarget, 1, 'first');
