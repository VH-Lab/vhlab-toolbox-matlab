function newstr = trimsymbol(str, symbol)
% TRIMSYMBOL - Trim a symbol (or symbols) from a string
%
%  NEWSTR = TRIMSYMBOL(STR, SYMBOL)
%
%  Removes the character symbols in the array SYMBOL from the
%  character string STR, and return the result in NEWSTR.
%
%  If STR is a cell array of strings, then each string in the
%  cell array will be processed separately.
%
%  Example:  
%     mystr = '*myhighlightedname#'
%     newstr = trimsymbol(mystr,'*#')
%     % newstr = 'myhighlightedname'
%     

newstr = str;

if iscell(str),
	for i=1:length(str),
		newstr{i} = trimsymbol(str{i},symbol);
	end;
else,
	for i=1:length(symbol),
		newstr = newstr(find(newstr~=symbol(i)));
	end;
end;




