function str = cell2mlstr(thecell, varargin)
% CELL2MLSTR - Create a text string to fully characterize a cellure
%
%  STR = CELL2MLSTR(THECELL)
%
%  Produces a string representation of a cellure that can be passed to
%  an external program to fully encapsulate the cellure.  Character strings
%  are written directly, integers are written using MAT2STR, 
%  numbers are written using MAT2STR, cells are written using CELL2MLSTR.
%  Any other objects are written using the function DISP.
%
%  The cellure is written in the following way:
%  <CELL size=[X Y Z ...] data=
%       <value1>
%       <value2>
%  /CELL>
%
%  where X,Y,Z are the dimension of the cellure array, and
%  data contains the data for each cell entry, inside < and >.  Within each data,
%  values for each field separated with < and > characters.
%  /CELL ends the cellure.
%
%  Newline characters are produced after 'data=' and after each variable entry
%  ('\n').
%
%  The default parameters may be overridden by passing NAME/VALUE
%  pairs as additional arguments, as in:
%
%   STR = CELL2STR(THECELL, 'NAME1', VALUE1,...)
%
%
%  Parameters:             | Description
%  ---------------------------------------------------------------
%  precision               | Precision we should use for mat2str (default 15)
%                          |    (this is the number of digits we should use)
%  varname                 | Variable name, entered before data= line as name=
%  indent                  | Indentation (default 0)
%  indentshift             | How much to indent sub-cellures (default 5)
%                      
%  Example:
%      A = {'test', 5, [3 4 5]}
%      cell2mlstr(A)
% 

precision = 15;
indent = 0;
indentshift = 5;
varname = '';

assign(varargin{:});

sizestr = mat2str(size(thecell));
if sizestr(1)~='[',
	sizestr = [ '[' sizestr ']' ];
end;

varstr = ' ';
if ~ischar(varname),
	error(['Variable name varname must be a character array (that is, a string).']);
end;
if ~isempty(varname),
	varstr = [' name=' 39 varname 39 ' '];
end;

str = ['<CELL size=' sizestr varstr 'data=' sprintf('\n')];

for i=1:numel(thecell),
	str = cat(2,str,repmat(' ',1,indent+indentshift),'<');
	value = thecell{i};
	if ischar(value),
		valuestr = char([39 value 39]);
	elseif isint(value),
		valuestr = ['[' mat2str(value) ']'];
	elseif isnumeric(value),
		valuestr = [ '[' mat2str(value,precision) ']'];
	elseif isstruct(value)
		valuestr = struct2mlstr(value,'indent',indent+indentshift);
	elseif iscell(value),
		valuestr = cell2mlstr(value,'indent',indent+indentshift);
	else,
		valuestr = disp(value);
	end;
	str = cat(2,str,valuestr);
	str = cat(2,str,'>',sprintf('\n'));
end;

str = [ str repmat(' ',1, indent) '/CELL>'];

